function MakeTurbine()
end

"""
#### CreateAD14(Foils, Nodes; StallMod="STEADY", UseCm="NO_CM", InfModel="EQUIL",
IndModel="SWIRL", AToler=0.005, TLModel="PRANDtl", HLModel="PRANDtl",
TwrShad=0.3, ShadHWid=0.2, T_Shad_Refpt=1.341, AirDens=0.9526, KinVisc=1.4639E-05,
DTAero=0.005, notes="This is an Aerodyn input file.")

### Inputs
- Foils - An array of strings containing the names of the airfoil files used in the blade. Note that order does matter. The order must match the order listed in the ADblade file. 

### Outputs

### Notes
"""
function CreateAD14(Foils, Nodes; StallMod="STEADY", UseCm="NO_CM", InfModel="EQUIL",
    IndModel="SWIRL", AToler=0.005, TLModel="PRANDtl", HLModel="PRANDtl",
    TwrShad=0.3, ShadHWid=0.2, T_Shad_Refpt=1.341, AirDens=0.9526, KinVisc=1.4639E-05,
    DTAero=0.005, notes="This is an Aerodyn input file.")

    NumFoil = length(Foils)
    if NumFoil == 0
        error("Too few airfoil files")
    end
    BldNodes,temp = size(Nodes)
    if BldNodes == 0
        error("Too few Blade Nodes")
    end
    directory = [
    "title"; "notes"; "StallMod"; "UseCm"; "InfModel"; "IndModel"; "AToler";
    "TLModel"; "HLModel"; "TwrShad"; "ShadHWid"; "T_Shad_Refpt"; "AirDens";
    "KinVisc"; "DTAero"; "NumFoil"]
    i = 1
    for i = 1:NumFoil
        temp = "Foil $i"
        push!(directory,temp)
    end
    append!(directory,["BldNodes"; "nodetitle"])
    i=1
    for i = 1:BldNodes
        temp = "BldNode $i"
        push!(directory,temp)
    end

    file = AD14file(directory, notes, StallMod, UseCm, InfModel, IndModel, AToler, TLModel,
        HLModel, TwrShad, ShadHWid, T_Shad_Refpt, AirDens, KinVisc, DTAero, NumFoil, Foils,
        BldNodes, Nodes)

    return file
end




function CreateAD15(Blades, Foils; Notes = "Notes on what this Aerodyn File is.", Echo="False",
    DTAero="\"default\"", WakeMod=1,
    AFAeroMod=2, TwrPotent=1, TwrShadow="False", TwrAero="True", FrozenWake="False",
    CavitCheck="False", AirDens=1.225, KinVisc=1.464e-5, SpdSound = 335.0, Patm=103500,
    Pvap=1700, FluidDepth=0.5, SkewMod=2, SkewModFactor="\"default\"", TipLoss="True",
    HubLoss="True", TanInd="True", AIDrag="False", TIDrag="False", IndToler="\"default\"",
    MaxIter=100, DBEMT_Mod=2, tau1_const=4, UAMod=3, FLookup="True", AFTabMod=1,
    InCol_Alfa=1, InCol_Cl=2, InCol_Cd=3, InCol_Cm=4, InCol_Cpmin=0, UseBlCm="True",
    TwrNds=zeros(1,3), SumPrint="False", NBlOuts=0, BlOutNd=[0], NTwOuts=0, TwOutNd=[0],
    Outlist=String[])

directory = [
"title"; "notes"; "GeneralOptions"; "Echo"; "DTAero"; "WakeMod"; "AFAeroMod";
"TwrPotent"; "TwrShadow"; "TwrAero"; "FrozenWake"; "CavitCheck"; "EnvironmetalConditions";
"AirDens"; "KinVisc"; "SpdSound"; "Patm"; "Pvap"; "FluidDepth"; "BEMoptions";
"SkewMod"; "SkewModFactor"; "TipLoss"; "HubLoss"; "TanInd"; "AIDrag"; "TIDrag";
"IndToler"; "MaxIter"; "DynamicBEMoptions"; "DBEMT_Mod"; "tau1_const"; "BLUAAoptions";
"UAMod"; "FLookup"; "AirfoilInfo"; "AFTabMod"; "InCol_Alfa"; "InCol_Cl";
"InCol_Cd"; "InCol_Cm"; "InCol_Cpmin"; "NumAFfiles"]



NumAFfiles=length(Foils)
if NumAFfiles==0
 error("Too few airfoils included in AD15 file. - CreateAD15")
end

for i=1:NumAFfiles
 temp = "Foil $i"
 push!(directory, temp)
end
#TODO: Add other things to the directory

if length(Blades)>3
 error("Too many blade files included in AD15 file. - CreateAD15")
elseif length(Blades)==0
 error("A blade file is required to create an AD15 file.")
end

m,n = size(TwrNds)
NumTwrNds = m
if n!=3
 error("AD15 TwrNds formatted incorrectly. There must be 3 columns.")
end

if NBlOuts>9
 error("Max number of NBlOuts is 9. CreateAD15")
end
if NTwOuts>9
 error("Max number of NBlOuts is 9. CreateAD15")
end

file = AD15file(directory, Notes, Echo, DTAero, WakeMod, AFAeroMod, TwrPotent, TwrShadow, TwrAero,
FrozenWake, CavitCheck, AirDens, KinVisc, SpdSound, Patm, Pvap, FluidDepth, SkewMod, SkewModFactor,
TipLoss, HubLoss, TanInd, AIDrag, TIDrag, IndToler, MaxIter, DBEMT_Mod, tau1_const, UAMod, FLookup,
AFTabMod, InCol_Alfa, InCol_Cl, InCol_Cd, InCol_Cm, InCol_Cpmin, NumAFfiles, Foils, UseBlCm, Blades,
NumTwrNds, TwrNds, SumPrint, NBlOuts, BlOutNd, NTwOuts, TwOutNd, Outlist)
return file
end

"""
#### CreateAD15Blade(rads, radschords, radstwists, radscones, radsconeangs, radssweeps, radsafid, tiprad, hubrad, cylinderrad, airfoilrad; importantrads=[], notes="This is a turbine.", verbose=true)

Takes the inputs and creats a adblade struct. Note that this is a file that mainly contains nodes that describe the turbine blade to AeroDyn. At each node the distance from the hub will be given; the chord length, twist, cone distance, cone angle, sweep, and airfoil will also be given. 

### Inputs
- rads - node distance from the center of rotation. (meters)
- radschords - node chord length (meters)
- radstwist - node twist angle (degrees)
- radscones - node cone distance? (meters) * Not actually sure what this is.
- radsconeangs - node cone angle (degrees) 
- radssweeps - node swept location (meters)
- radsafid - nodal airfoil id, this is a string name, function will convert to integer. Note that this function is not case sensitive. 
- tiprad - tip radius from center of rotation (meters)
- hubrad - hub radius from center of rotation (meters)
- cylinderrad - the radial distance (from the center of rotation) of the end of the cynlinder section. If no cylinder section is included, set this value to the hub radius. 
- airfoilrad - the radial distance (from the center of rotation) of the first airfoil 
- importantrads - radial distances that the user would like to insure a node is placed. (meters)
- notes - notes that the user would like placed at the top of the blade file.
- verbose - boolean that marks whether to make statements about creating the blade.

### Outputs
- adblade - an adblade struct
- importantnodes - the node numbers of the important radi that the user declared. 

### Notes
- Note that this function does not place nodes in the transition region between the cylinder and the airfoils. It also does not interpolate the airfoils between nodes, but uses an interger fit to populate the airfoil id in the blade file. 

### Definitions 
Below is a short list of the naming convention used in this function.
- radius (rads) - distance from the center of rotation
- fractions (fracs) - percentage of total blade radius
- blade radius (blrads) - distance from the hub (distance of blade length not   including the hub)
- blade fraction (blfrac) - percentage of blade radius
"""
function CreateAD15Blade(rads, radschords, radstwists, radscones, radsconeangs, radssweeps, radsafid, tiprad, hubrad, cylinderrad, airfoilrad; importantrads=[], notes="This is a turbine.", verbose=true)
    # Definitions
    # radius (rads) - distance from the center of rotation
    # fractions (fracs) - percentage of total blade radius
    # blade radius (blrads) - distance from the hub (distance of blade length not   including the hub)
    # blade fraction (blfrac) - percentage of blade radius
    
    # Fit the incoming data
    chordfit = Akima(rads, radschords)
    twistfit = Akima(rads, radstwists)
    conefit = Akima(rads, radscones)
    coneangfit = Akima(rads, radsconeangs)
    sweepfit = Akima(rads, radssweeps)
    radsafid = nametonumber(geoprops[:,8]).-1

    # Need to add important locations to fracs
    minus = 2
    bladelength = tiprad-hubrad
    tipblfrac = 1.0
    hubblfrac = 0.0
    if airfoilrad<hubrad || airfoilrad<cylinderrad
        error("Beginning of airfoil radius smaller than cylinder radius or hub  radius. ")
    end
    airfoilblfrac = (airfoilrad-hubrad)/bladelength
    cylinderblfrac = (cylinderrad-hubrad)/bladelength
    if cylinderrad<=hubrad
        if verbose
            println("No Cylinder portion on this blade.")
        end
        cylinderblfrac = 0
        minus -= 1
    end
    importantblfracs = (importantrads.-hubrad)./bladelength  
    blfracs = collect(range(airfoilblfrac,tipblfrac, length=numnodes-length(importantrads)-minus))
    append!(blfracs, importantblfracs)
    push!(blfracs, hubblfrac,  airfoilblfrac, tipblfrac)
    if cylinderblfrac>0
        push!(blfracs, cylinderblfrac)
    end
    unique!(blfracs)
    sort!(blfracs)

    # Convert from blfracs to radius positions and their radial locations
    blrads = blfracs.*(bladelength) #Note do not use this to get any property values    with the fits.
    locs = blrads.+0.508 #The rads location of the blrads nodes
    n = length(blrads)
    precone = conefit.(locs)
    sweep = sweepfit.(locs)
    preconeangle = coneangfit.(locs)
    twist = twistfit.(locs)
    twist = twist.+(-twist[end]+pitch) #Correct twist to OpenFAST input style,  including blade pitch
    chords = chordfit.(locs)
    afid = of.intergerfit(rads, radsafid, locs)
    adprops = hcat(blrads, precone, sweep, preconeangle, twist, chords, afid)
    directory = ["BlSpn" "BlCrvAC" "BlSwpAC" "BlCrvAng" "BlTwist" "BlChord" "BlAFID"]

    adblade = of.ADBlade(directory, notes, n, adprops, blrads, precone, sweep,  preconeangle, twist, chords, afid) #Maybe remove adprops from this struct

    # Find the nodes of the important idxs
    nodeidxs = []
    for i = 1:length(locs)
        if in(locs[i], PTrads)
            push!(nodeidxs, i)
        end
    end
    return adblade, nodeidxs
end

"""
#### CreateAD15Blade(rads, radschords, radstwists, radscones, radsconeangs, radssweeps, radsafid, tiprad, hubrad, cylinderrad, airfoilrad; importantrads=[], notes="This is a turbine.", verbose=true)

Takes the inputs and creats a adblade struct. Note that this is a file that mainly contains nodes that describe the turbine blade to AeroDyn. At each node the distance from the hub will be given; the chord length, twist, cone distance, cone angle, sweep, and airfoil will also be given. 

    ### Inputs
    - props - a n x 7 array holding the nodal values in order (radius, chord length, twist, cone, cone angle, sweep, airfoil name)
    - tiprad - tip radius from center of rotation (meters)
    - hubrad - hub radius from center of rotation (meters)
    - cylinderrad - the radial distance (from the center of rotation) of the end of the cynlinder section. If no cylinder section is included, set this value to the hub radius. 
    - airfoilrad - the radial distance (from the center of rotation) of the first airfoil 
    - importantrads - radial distances that the user would like to insure a node is placed. (meters)
    - notes - notes that the user would like placed at the top of the blade file.
    - verbose - boolean that marks whether to make statements about creating the blade.
    
    ### Outputs
    - adblade - an adblade struct
    - importantnodes - the node numbers of the important radi that the user declared. 
    
    ### Notes
    - Note that this function does not place nodes in the transition region between the cylinder and the airfoils. It also does not interpolate the airfoils between nodes, but uses an interger fit to populate the airfoil id in the blade file. 
    
    ### Definitions 
    Below is a short list of the naming convention used in this function.
    - radius (rads) - distance from the center of rotation
    - fractions (fracs) - percentage of total blade radius
    - blade radius (blrads) - distance from the hub (distance of blade length not   including the hub)
    - blade fraction (blfrac) - percentage of blade radius
"""
function CreateAD15Blade(props, tiprad, hubrad, cylinderrad, airfoilrad; importantrads = [], notes = "This is a turbine.", verbose=true)

    return CreateAD15Blade(props[:,1], props[:,2], props[:,3], props[:,4], props[:,5], props[:,6], props[:,7], tiprad, hubrad, cylinderrad, airfoilrad; importantrads = [], notes = "This is a turbine.", verbose=true)
end