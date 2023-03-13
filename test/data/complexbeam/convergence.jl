#=
    Check the convergence rate of BeamDyn (with element order, and number of elements) and GXBeam on the simplified NREL 5MW Wind turbine. 


    Adam Cardoza 03/09/23

=#

using OpenFASTsr, Rotors, DynamicStallModels, DelimitedFiles, Plots, GXBeam

of = OpenFASTsr

path = dirname(@__FILE__)
cd(path)

rhub = 1.0 #Hub radius
rtip = 100.0 #Tip radius

runfile() = run(`/Users/adamcardoza/repos/openfast/build/modules/beamdyn/beamdyn_driver cb_bddriver.inp`)

function prepfile(n::Int, nelem::Int, order::Int)
    
    ### Read in OpenFAST files
    ofpath = "../5MWturbine/" 
    bddriver = of.read_bddriver("NREL5MWref_bddriver.inp", ofpath)
    bdfile = of.read_bdfile("NREL5MWrefBD.dat", ofpath)
    bdblade = of.read_bdblade("NREL5MWrefBD_Blade.dat", ofpath)

    ### Simulation control
    mu = 0.001 #Damping ratio



    ### Turbine description

    rvec = collect(range(rhub, rtip, length=n))
    rfrac = (rvec .- rhub)/(rtip-rhub)

    twistvec = zeros(n)


    ### Set OpenFAST file values
    ### BD Primary #Todo: Add stuff to automatically update the BDDriver as well. 
    bdfile["QuasiStaticInit"] = false
    bdfile["NRMax"] = 5000
    
    bdfile["DTBeam"] = "DEFAULT"
    bdfile["stop_tol"] = 1e-12

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

    bdfile["BldFile"] = ["cb_BDblade.dat"]
    bdfile["BldNd_BlOutNd"] = 99
    bdfile["OutNd"] = Int[1]
    bdfile["OutList"] = [" ", "TipTDxr", "TipTDyr", "TipTDzr"]
    bdfile["NodeOutList"] = ["TDxr", "TDyr", "TDzr"]
    # append!(bdfile["NodeOutList"], ["TDxr", "TDyr", "TDzr", "RVxr", "RVyr", "RVzr"])

    ### BD Blade file
    Kmat = zeros(6,6,Int(bdblade["station_total"]))
    Mmat = zeros(6,6,Int(bdblade["station_total"]))
    for i = 1:Int(bdblade["station_total"])
        Kmat[:,:,i] = bdblade["K$i"]
        Mmat[:,:,i] = bdblade["M$i"]
    end
    Kfit = Rotors.interpolate_matrix_symmetric(bdblade["rfrac"], rfrac, Kmat; fit=Linear)
    Mfit = Rotors.interpolate_matrix_symmetric(bdblade["rfrac"], rfrac, Mmat; fit=Linear)
    for i = 1:n
        bdblade["K$i"] = Kfit[:,:,i]
        bdblade["M$i"] = Mfit[:,:,i]
    end

    bdblade["station_total"] = n
    bdblade["rfrac"] = rfrac
    bdblade["mu"] .= mu


    bddriver["DynamicSolve"] = false
    bddriver["InputFile"] = "cb_BDfile.dat"
    bddriver["TipLoad(1)"] = 1000

    ### Write OpenFAST files
    of.write_bddriver(bddriver, "cb_bddriver.inp"; outputpath="./")
    of.write_bdfile(bdfile, "cb_BDfile.dat"; outputpath="./")
    of.write_bdblade(bdblade, "cb_BDblade.dat"; outputpath="./")

end #End the prep file function

function prepfile_elements(nelem::Int, order::Int)
    
    ### Read in OpenFAST files
    ofpath = "../5MWturbine/" 
    bddriver = of.read_bddriver("NREL5MWref_bddriver.inp", ofpath)
    bdfile = of.read_bdfile("NREL5MWrefBD.dat", ofpath)
    bdblade = of.read_bdblade("NREL5MWrefBD_Blade.dat", ofpath)

    ### Simulation control
    bdfile["member_total"] = nelem
    if nelem < 3
        np_elem = 100
    elseif nelem < 5
        np_elem = 50
    else
        np_elem = 25
    end
    
    members = zeros(nelem, 2)
    for i = 1:nelem
        members[i,1] = i
        members[i,2] = np_elem
    end

    bdfile["KeyPairs"] = members

    n = Int(sum(members[:,2]) - nelem + 1)

    mu = 0.001 #Damping ratio




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
    bdfile["stop_tol"] = 1e-12

    bdfile["quadrature"] = 1
    if order==1
        bdfile["quadrature"] = 2
    end
    if nelem>1
        bdfile["quadrature"] = 1
    end

    bdfile["order_elem"] = order
    

    bdfile["kp_total"] = n
    bdfile["kp_xr"] = zeros(n)
    bdfile["kp_yr"] = zeros(n)
    bdfile["kp_zr"] = rvec .- rhub

    bdfile["initial_twist"] = twistvec

    bdfile["BldFile"] = ["cb_BDblade.dat"]
    bdfile["BldNd_BlOutNd"] = 99
    bdfile["OutNd"] = Int[1]
    bdfile["OutList"] = [" ", "TipTDxr", "TipTDyr", "TipTDzr"]
    bdfile["NodeOutList"] = ["TDxr", "TDyr", "TDzr"]
    # append!(bdfile["NodeOutList"], ["TDxr", "TDyr", "TDzr", "RVxr", "RVyr", "RVzr"])

    ### BD Blade file
    Kmat = zeros(6,6,Int(bdblade["station_total"]))
    Mmat = zeros(6,6,Int(bdblade["station_total"]))
    for i = 1:Int(bdblade["station_total"])
        Kmat[:,:,i] = bdblade["K$i"]
        Mmat[:,:,i] = bdblade["M$i"]
    end
    Kfit = Rotors.interpolate_matrix_symmetric(bdblade["rfrac"], rfrac, Kmat; fit=Linear)
    Mfit = Rotors.interpolate_matrix_symmetric(bdblade["rfrac"], rfrac, Mmat; fit=Linear)
    for i = 1:n
        bdblade["K$i"] = Kfit[:,:,i]
        bdblade["M$i"] = Mfit[:,:,i]
    end

    bdblade["station_total"] = n
    bdblade["rfrac"] = rfrac
    bdblade["mu"] .= mu

    bddriver["DynamicSolve"] = false
    bddriver["InputFile"] = "cb_BDfile.dat"
    bddriver["TipLoad(1)"] = 1000

    ### Write OpenFAST files
    of.write_bddriver(bddriver, "cb_bddriver.inp"; outputpath="./")
    of.write_bdfile(bdfile, "cb_BDfile.dat"; outputpath="./")
    of.write_bdblade(bdblade, "cb_BDblade.dat"; outputpath="./")

end #End the prep file function

function gettipdef()
    bdread = readdlm("./cb_bddriver.out", skipstart=6)
    bdnames = bdread[1,:]
    bddata = Float64.(bdread[3:end,:])

    bdouts = Dict(bdnames[i] => bddata[:,i] for i in eachindex(bdnames))

    return bdouts["TipTDxr"][end]
end


order = collect(1:2:30)
nelemvec = collect(1:1:50)
kpvec = collect(20:20:400)

tipdef_order = zeros(length(order))
tipdef_nelem = zeros(length(nelemvec))
tipdef_kp = zeros(length(kpvec))


for i in eachindex(order)
    prepfile(100, 1, order[i])
    runfile()
    tipdef_order[i] = gettipdef()
end

for i in eachindex(nelemvec)
    prepfile_elements(nelemvec[i], 2)
    runfile()
    tipdef_nelem[i] = gettipdef()
end

for i in eachindex(kpvec)
    prepfile(kpvec[i], 1, 10)
    runfile()
    tipdef_kp[i] = gettipdef()
end





function rungxbeam()
    ofpath = "./"
    bdfile = of.read_bdfile("cb_BDfile.dat", ofpath)
    bdblade = of.read_bdblade("cb_BDblade.dat", ofpath)
    # rhub = 1.0
    # rtip = 100.0
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

gxconvergence = collect(20:20:400)

tipdefs = zeros(length(gxconvergence))

for i in eachindex(tipdefs)
    prepfile(gxconvergence[i], 1, 7)
    tipdefs[i] = rungxbeam()
end

println("Converged values: ")
println("Order: ", tipdef_order[end])
println("Elements: ", tipdef_nelem[end])
println("Key Points: ", tipdef_kp[end])
println("Nodes: ", tipdefs[end])

oplt = plot(order, tipdef_order, xaxis="Order", yaxis="Tip Def (m)", leg=false, markershape=:x)
nplt = plot(nelemvec, tipdef_nelem, xaxis="# Elements", yaxis="Tip Def (m)", leg=false, markershape=:x)
kplt = plot(kpvec, tipdef_kp, xaxis="# Key Points", yaxis="Tip Def (m)", leg=false, markershape=:x)
gplt = plot(gxconvergence, tipdefs, xaxis="# Elements", yaxis="Tip Def (m)", leg=false, markershape=:o)

plt = plot(oplt, nplt, kplt, gplt, layout=(4,1))
# savefig(plt, "gxbeam_convergence.png")