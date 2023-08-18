#=
Simplify the NREL 5MW to compare OpenFAST, GXBeam, and eventually Rotors.jl. 


Adam Cardoza 01/23/23

=#


using OpenFASTTools, Rotors, DynamicStallModels

of = OpenFASTTools

path = dirname(@__FILE__)
cd(path)

### Read in OpenFAST files
ofpath = "../5MWturbine/" 
bddriver = of.read_bddriver("NREL5MWref_bddriver.inp", ofpath)
bdfile = of.read_bdfile("NREL5MWrefBD.dat", ofpath)
bdblade = of.read_bdblade("NREL5MWrefBD_Blade.dat", ofpath)

### Simulation control
tmax = 20.0
dt = 0.001
dt_out = 0.001 # "\"default\""
n = 200

### Environmental variables
gravity = 0.0 #9.81 #Gravity (m/s^2)

rpm = 50 #angular velocity (rotations per minute)
omega = rpm*2*pi/60 #angular velocity (radians/second)



### Turbine description

rhub = 0.0 #Hub radius
rtip = 100.0 #Tip radius

rvec = collect(range(rhub, rtip, length=n))
rfrac = (rvec .- rhub)/(rtip-rhub)


chordvec = ones(n)
twistvec = zeros(n)
# twistvec = -ones(n).*3.0  

E = 1.1e10 #6.83e10 #Young's Modulus
nu = 0.3 #Poisson's Ratio
m = 10.0 #2700.0 #kg/m^3 -> Decreasing the weight decreases the frequency of oscillation
h = 0.25 # Thickness (meters)
w = 0.25 # Width (meters)
# mu = 0.001 #Damping ratio
mu = 2.0

A = w*h #Area

Ix = w*(h^3)/12  #Area moment of inertia
Iy = h*(w^3)/12
J = Ix + Iy

G=E/(2*(1+nu))

# K = of.stiffness_matrix(E, nu, h*w, Ix, Iy) #Stiffness matrix

#[3, 1, 2, 6, 4, 5] #BD to GX indexing
# gxtobdidx = [2, 3, 1, 5, 6, 4] #GX to BD indexing
# K1 = [(E*A) 0 0 0 0 0
#     0 (G*A) 0 0 0 0
#     0 0 (G*A) 0 0 0
#     0 0 0 (G*J) 0 0
#     0 0 0 0 (E*Iy) 0
#     0 0 0 0 0 (E*Ix)] #GXBeam stiffness matrix
# K = K[gxtobdidx, gxtobdidx] #Convert to BD stiffness matrix
#Note: both K and K1 produce the same matrix. :| Which means that I did it right the first go aroound. Which means that BeamDyn just can't solve my stiffness matrix. 

# l = rvec[2]-rvec[1] # Element length

# dm = m*w*h #Distributed mass of the section #TODO: Dr. Ning suggested setting this to zero to simplify terms.  
# Mix = dm*Ix #Mass moment of inertia
# Miy = dm*Iy
# M = of.mass_matrix(dm, Mix, Miy)





let
    ### Set OpenFAST file values
    


    ### BD Primary #Todo: Add stuff to automatically update the BDDriver as well. 
    bdfile["QuasiStaticInit"] = false
    bdfile["NRMax"] = 5000
    bdfile["quadrature"] = 1
    bdfile["DTBeam"] = "DEFAULT"
    bdfile["order_elem"] = 10
    bdfile["stop_tol"] = 1e-9
    bdfile["RotStates"] = false

    # bdfile["member_total"] = 1
    # bdfile["KeyPairs"] = [1 n]
    bdfile["member_total"] = 4
    # bdfile["KeyPairs"] = [1 100; 2 101; 3 101; 4 101]
    bdfile["KeyPairs"] = [1 50; 2 51; 3 51; 4 51]

    bdfile["kp_total"] = n
    bdfile["kp_xr"] = zeros(n)
    bdfile["kp_yr"] = zeros(n)
    bdfile["kp_zr"] = rvec .- rhub
    bdfile["initial_twist"] = twistvec

    

    bdfile["BldFile"] = ["cb_BDblade.dat"]
    bdfile["BldNd_BlOutNd"] = 99

    bdfile["OutNd"] = Int[1]
    bdfile["OutList"] = [" ", "TipTDxr", "TipTDyr", "TipTDzr", "TipTVxg", "TipTVyg", "TipTVzg" ]
    bdfile["NodeOutList"] = ["TDxr", "TDyr", "TDzr", "TVxg", "TVyg", "TVzg", "TVxl", "TVyl", "TVzl"]
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
        # bdblade["K$i"] = K
        # bdblade["M$i"] = M
    end

    
    bdblade["station_total"] = n
    bdblade["rfrac"] = rfrac
    bdblade["mu"] .= mu


    bddriver["InputFile"] = "cb_BDfile.dat"
    bddriver["DynamicSolve"] = false
    # bddriver["TipLoad(1)"] = 1000
    bddriver["DistrLoad(1)"] = 5



    ### Write OpenFAST files
    of.write_bddriver(bddriver, "cb_bddriver.inp"; outputpath="./")
    of.write_bdfile(bdfile, "cb_BDfile.dat"; outputpath="./")
    of.write_bdblade(bdblade, "cb_BDblade.dat"; outputpath="./")
end





nothing