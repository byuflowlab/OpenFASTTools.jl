# Quick Start
Once you've successfully installed OpenFAST, a quick run through these examples may be beneficial in learning how to use OpenFASTsr and OpenFAST. 


## AeroDyn Only

Let's start off with just running AeroDyn by itself. There are at least four files required to run AeroDyn, a driver file, an input file, a blade file, and an airfoil input file. We'll use the Unsteady Aerodynamics Experiment (UAE) 20 kW wind turbine as an example. 

### ADDriver
First, the driver file. The driver file provides the basic turbine description, operating conditions, and points the driver at the input file. So naturally we need to declare those things. 

```julia
### Turbine Description
NumBlades = 2
HubRad = 0.508 # meters
HubHt = 12.192 # meters
Overhang = -1.401 # meters
Precone = 0.0 # degrees
ShftTilt = 0.0 # degrees turbine tilt
```

I have provided several different constructors to allow for quick creation of driver files that have one operating condition (as shown here), or for conditions where everything but the wind speed changes, or for any combination of wind speed, rpm, pitch, yaw, shear exponent, simulation time, and time step. 

```julia
### Operating Conditions
windspeed = 5.0 # m/s - average windspeed at hub height
RPM = 72.1 # rotations/minute 
Pitch = 2.98 # degrees
Yaw = 0.0 # degrees
ShearExp = 0.0 # dimensionless - Usually a shear exponent is included, but for such a small wind turbine, it shouldn't make much of a difference. 
Tmax = 5.0 # seconds - simulation time
dT = 0.1 # seconds - time step length
NumCases = length(windspeed)
```

```julia
### AeroDyn Inputs
Notes = "UAE 20kW Turbine 5/10/21 Adam Cardoza" # These notes will appear under the header of the driver file. Typically a short description is provided as well as the author and date.
AD_InputFile = "20kWAD15.dat" # The exact name of the AeroDyn input file must be given.
OutFileRoot = "20kWturbine" # The name of the output file is given. 
OutFmt = "ES20.3E2" # I honestly don't know how this changes things, I don't know what the valid inputs are, but everything I've done uses this OutFmt (I don't know if changing this value will break by output reading functions). 

Echo = false #Whether or not OpenFAST will generate a file that returns the inputs you used for a given run. 
TabDel = true #Wheter the output file will be delimited with a tab or not. 
Beep = false #Wheter OpenFAST will beep upon completion. 
```

Then we can simply stick them into the ADDriver object for later use. 


```julia
addriver = OpenFASTsr.ADDriver(Notes, Echo, AD_InputFile, NumBlades, HubRad, HubHt, Overhang, ShftTilt, Precone , OutFileRoot, TabDel, OutFmt, Beep, NumCases, windspeed, ShearExp, RPM, Pitch, Yaw, dT, Tmax)
```

### ADFile

### ADBlade

```julia
geoprops = readdlm("./data/20kw corrected blade properties.txt")
rads = Float64.(geoprops[:,1])
radschords = Float64.(geoprops[:,4])
radstwists = Float64.(geoprops[:,5])
radscones = zeros(length(rads))
radsconeangs = zeros(length(rads))
radssweeps = zeros(length(rads))
afiddistro = hcat(geoprops[:,1], geoprops[:,8])
```

```julia
for i = 1:length(afiddistro[:,1]) #Need to skip over the transition foils to make the AFID numbers nice. 
    if lowercase(afiddistro[i,2])=="transition"
        afiddistro[i,2] = "s809"
    end
end

radsafid = OpenFASTsr.namefit(afiddistro[:,1], afiddistro[:,2], rads)
```

```julia

adblade, irads = OpenFASTsr.CreateAD15Blade(rads, radschords, radstwists, radscones, radsconeangs, radssweeps, radsafid, tiprad, hubrad, cylinderrad, airfoilrad, pitch; numnodes=50, notes = "20kW UAE Turbine", verbose=false)

```

### AirfoilInput Files


!!! Tip
    Correcting the airfoil polars is essential to obtaining accurate results from the BEM. I use [CCBlade's functions](https://flow.byu.edu/CCBlade.jl/stable/howto/#Airfoil-Data) to correct, extrapolate, and smooth airfoil data before creating my AirfoilInput files. 



### Writing to File
At this point, we can do what we want with the files now. Likely you'll want to use them in a simulation, so first we'll write the objects to file. 


### Running AeroDyn


### Reading the Output File(s)


### Reading AeroDyn Files


## Running OpenFAST
Because you have to use a minimum of three modules (InflowWind, AeroDyn, and ElastoDyn), this is a little more involved. Luckily, it follows about the same procedure from before. A file for the glue code is also required. 

!!! tip
    While reading and writing your files using OpenFASTsr can be useful, sometimes I just take an old input file and change it manually (especially if I don't plan on making lots of changes). 

### OpenFAST Glue Code


### InflowWind


### AeroDyn
Now, because we are using the OpenFAST glue code to drive AeroDyn, we don't need the ADDriver file, but we will still need the ADInput, ADBlade, and AirfoilInput files. We can just use the same files from before. 

### ElastoDyn

