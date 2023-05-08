#=
Simplify the NREL 5MW to compare OpenFAST, GXBeam, and eventually Rotors.jl. 


Adam Cardoza 01/23/23

=#


using OpenFASTsr, Rotors, DynamicStallModels

of = OpenFASTsr

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




let
    ### Set OpenFAST file values
    


    ### BD Primary #Todo: Add stuff to automatically update the BDDriver as well. 
    bdfile["QuasiStaticInit"] = false
    bdfile["NRMax"] = 5000
    bdfile["quadrature"] = 1
    bdfile["DTBeam"] = "DEFAULT"
    bdfile["order_elem"] = 7
    bdfile["stop_tol"] = 1e-9

    bdfile["member_total"] = 4
    bdfile["KeyPairs"] = [1 50; 2 51; 3 51; 4 51]

    # bdfile["member_total"] = 1
    # bdfile["KeyPairs"] = [1 n]

    bdfile["kp_total"] = n
    bdfile["kp_xr"] = zeros(n)
    bdfile["kp_yr"] = zeros(n)
    bdfile["kp_zr"] = rvec .- rhub
    bdfile["initial_twist"] = twistvec

    

    bdfile["BldFile"] = ["mb_BDblade.dat"]
    bdfile["BldNd_BlOutNd"] = 99

    bdfile["OutNd"] = Int[1]
    bdfile["OutList"] = [" ", "TipTDxr", "TipTDyr", "TipTDzr", "TipTVxg", "TipTVyg", "TipTVzg" ]
    bdfile["NodeOutList"] = ["TDxr", "TDyr", "TDzr", "TVxg", "TVyg", "TVzg", "TVxl", "TVyl", "TVzl"]
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
end





nothing