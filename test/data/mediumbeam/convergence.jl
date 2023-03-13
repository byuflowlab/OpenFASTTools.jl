#=
    Check the convergence rate of BeamDyn (with element order, and number of elements) and GXBeam on the simplified NREL 5MW Wind turbine. 


    Adam Cardoza 03/09/23

=#

using OpenFASTsr, Rotors, DynamicStallModels, DelimitedFiles, Plots, GXBeam, LaTeXStrings

of = OpenFASTsr

path = dirname(@__FILE__)
cd(path)

runfile() = run(`/Users/adamcardoza/repos/openfast/build/modules/beamdyn/beamdyn_driver mb_bddriver.inp`)

function prepfile(n::Int, rhub, nelem::Int)
    # nelem = 1
    order = 7
    rtip = 100.0
    
    ### Read in OpenFAST files
    ofpath = "../5MWturbine/" 
    bddriver = of.read_bddriver("NREL5MWref_bddriver.inp", ofpath)
    bdfile = of.read_bdfile("NREL5MWrefBD.dat", ofpath)
    bdblade = of.read_bdblade("NREL5MWrefBD_Blade.dat", ofpath)

    ### Simulation control

    E = 1.1e10 #6.83e10 #Young's Modulus
    nu = 0.3 #Poisson's Ratio
    m = 10.0 #2700.0 #kg/m^3 -> Decreasing the weight decreases the frequency of oscillation
    h = 0.25 # Thickness (meters)
    w = 0.25 # Width (meters)
    mu = 0.001 #Damping ratio

    A = w*h #Area

    Ix = w*(h^3)/12  #Area moment of inertia
    Iy = h*(w^3)/12
    J = Ix + Iy

    G=E/(2*(1+nu))

    K1 = of.stiffness_matrix(E, nu, A, Ix, Iy) #Stiffness matrix

    h2 = 2h
    w2 = 2w
    A2 = w2*h2
    Ix2 = w2*(h2^3)/12  #Area moment of inertia
    Iy2 = h2*(w2^3)/12

    K2 = of.stiffness_matrix(E, nu, A2, Ix2, Iy2)



    dm = m*w*h #Distributed mass of the section #TODO: Dr. Ning suggested setting this to zero to simplify terms.  
    Mix = dm*Ix #Mass moment of inertia
    Miy = dm*Iy
    M1 = of.mass_matrix(dm, Mix, Miy)

    dm2 = m*w2*h2 #Distributed mass of the section #TODO: Dr. Ning suggested setting this to zero to simplify terms.  
    Mix2 = dm2*Ix2 #Mass moment of inertia
    Miy2 = dm2*Iy2
    M2 = of.mass_matrix(dm2, Mix2, Miy2)

    ### Environmental variables
    gravity = 0.0 #9.81 #Gravity (m/s^2)

    rpm = 50 #angular velocity (rotations per minute)
    omega = rpm*2*pi/60 #angular velocity (radians/second)



    ### Turbine description

    # rhub = 1.0 #Hub radius
    # rtip = 100.0 #Tip radius

    rvec = collect(range(rhub, rtip, length=n))
    rfrac = (rvec .- rhub)/(rtip-rhub)

    twistvec = zeros(n)


    ### Set OpenFAST file values
    ### BD Primary #Todo: Add stuff to automatically update the BDDriver as well. 
    bdfile["QuasiStaticInit"] = false
    bdfile["NRMax"] = 5000
    
    bdfile["DTBeam"] = "DEFAULT"
    bdfile["stop_tol"] = 1e-6

    bdfile["quadrature"] = 1
    if order==1
        bdfile["quadrature"] = 2
    end

    bdfile["order_elem"] = order
    if isodd(nelem)&&nelem>1
        error("For our purposes nelem can't be even.")
    end
    bdfile["member_total"] = nelem
    np_elem = Int(n/nelem)
    members = zeros(nelem, 2)
    for i = 1:nelem
        members[i,1] = i
        if i==1
            members[i,2] = np_elem
        else
            members[i,2] = np_elem + 1
        end
    end
    bdfile["KeyPairs"] = members

    bdfile["kp_total"] = n
    bdfile["kp_xr"] = zeros(n)
    bdfile["kp_yr"] = zeros(n)
    bdfile["kp_zr"] = rvec .- rhub

    bdfile["initial_twist"] = twistvec

    bdfile["BldFile"] = ["mb_BDblade.dat"]
    bdfile["BldNd_BlOutNd"] = 99
    bdfile["OutNd"] = Int[1]
    bdfile["OutList"] = [" ", "TipTDxr", "TipTDyr", "TipTDzr"]
    bdfile["NodeOutList"] = ["TDxr", "TDyr", "TDzr"]
    # append!(bdfile["NodeOutList"], ["TDxr", "TDyr", "TDzr", "RVxr", "RVyr", "RVzr"])

    ### BD Blade file
    
    for i = 1:n
        if rfrac[i]<=.5
            bdblade["K$i"] = K1
            bdblade["M$i"] = M1
        else
            bdblade["K$i"] = K2
            bdblade["M$i"] = M2
        end
    end

    bdblade["station_total"] = n
    bdblade["rfrac"] = rfrac
    bdblade["mu"] .= mu

    ### Write OpenFAST files
    of.write_bdfile(bdfile, "mb_BDfile.dat"; outputpath="./")
    of.write_bdblade(bdblade, "mb_BDblade.dat"; outputpath="./")

end #End the prep file function

function gettipdef()
    bdread = readdlm("./mb_bddriver.out", skipstart=6)
    bdnames = bdread[1,:]
    bddata = Float64.(bdread[3:end,:])

    bdouts = Dict(bdnames[i] => bddata[:,i] for i in eachindex(bdnames))

    return bdouts["TipTDxr"][end]
end

function rungxbeam(rhub)
    ofpath = "./"
    bdfile = of.read_bdfile("mb_BDfile.dat", ofpath)
    bdblade = of.read_bdblade("mb_BDblade.dat", ofpath)
    # rhub = 1.0
    rtip = 100.0
    rstructural = bdfile["kp_zr"]
    twist = bdfile["initial_twist"].*(pi/180)
    assembly = of.make_assembly(rhub, rtip, rstructural, twist, bdblade; fit=Linear)
    nelem = length(assembly.elements)

    Fx = 1000.0

    prescribed_conditions = Dict(1 => GXBeam.PrescribedConditions(ux=0, uy=0, uz=0, theta_x=0, theta_y=0, theta_z=0), nelem+1 => GXBeam.PrescribedConditions(Fz = -Fx)) # root section is fixed, Note that the BeamDyn and GXBeam beams extend in different directions (I could probably fix that. )
        
    ### GXBeam  solution  
    system, _ = GXBeam.steady_state_analysis(assembly; prescribed_conditions = prescribed_conditions) 

    gxstate = AssemblyState(system, assembly; prescribed_conditions)

    # def_x = [-gxstate.points[i].u[3] for i in eachindex(gxstate.points)]

    return -gxstate.points[end].u[3]
end

nelems = [1, 2, 4]
rhubvals = [0.0, 0.5, 1.0, 1.5, 5.0]
kpvec = collect(50:50:600)

tipdef_rhub = zeros(length(rhubvals))
tipdef_rhub_gx = zeros(length(rhubvals))
tipdef_kp = zeros(length(kpvec))
tipdef_kp_gx = zeros(length(kpvec))
tipdef_ne = zeros(length(nelems))



for i in eachindex(rhubvals)
    prepfile(200, rhubvals[i], 1)
    runfile()
    tipdef_rhub_gx[i] = gettipdef()
    tipdef_rhub[i] = rungxbeam(rhubvals[i])
end

for i in eachindex(kpvec)
    prepfile(kpvec[i], 0.0, 1)
    runfile()
    tipdef_kp[i] = gettipdef()
    tipdef_kp_gx[i] = rungxbeam(0.5)
end

for i in eachindex(nelems)
    prepfile(200, 0.5, nelems[i])
    runfile()
    tipdef_ne[i] = gettipdef()
end



rplt = plot(rhubvals, tipdef_rhub, xaxis=L"$R_{hub}$ (m)", yaxis="Tip Def (m)", lab="OF", marker=:x)
plot!(rhubvals, tipdef_rhub_gx, lab="GX", marker=:o)
kplt = plot(kpvec, tipdef_kp, xaxis="# Key Points", yaxis="Tip Def (m)", marker=:x, lab="OF")
plot!(kpvec, tipdef_kp_gx, lab="GX", marker=:o)
nplt = plot(nelems, tipdef_ne, xaxis="# Elements", yaxis="Tip Def (m)", lab="OF", marker=:x)
hline!([tipdef_kp_gx[end]], lab="GX")

plt = plot(rplt, kplt, nplt, layout=(3,1))
display(plt)
# savefig(plt, "mediumbeam_convergence.png")



