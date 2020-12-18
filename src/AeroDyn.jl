
##############################################################
##################     STRUCTURES     ########################
##############################################################

struct AD14file
    Directory
    Notes
    StallMod
    UseCm
    InfModel
    IndModel
    AToler
    TLModel
    HLModel
    TwrShad
    ShadHWid
    T_Shad_Refpt
    AirDens
    KinVisc
    DTAero
    NumFoil
    Foils
    BldNodes
    Nodes
end

mutable struct AD15file
    #I'm storing the booleans as strings. :|
    Directory::Array{String}
    Notes::String
    Echo::String
    DTAero::String
    WakeMod::Int
    AFAeroMod::Int
    TwrPotent::Int
    TwrShadow::String
    TwrAero::String
    FrozenWake::String
    CavitCheck::String
    CompAA::String
    AA_InputFile::String
    AirDens::Float64
    KinVisc::Float64
    SpdSound::Float64
    Patm::Float64
    Pvap::Float64
    FluidDepth::Float64
    SkewMod::Int
    SkewModFactor::String
    TipLoss::String
    HubLoss::String
    TanInd::String
    AIDrag::String
    TIDrag::String
    IndToler::String
    MaxIter::Int
    DBEMT_Mod::Int
    tau1_const::Int
    OLAFInputFileName::String
    UAMod::Int
    FLookup::String
    AFTabMod::Int
    InCol_Alfa::Int
    InCol_Cl::Int
    InCol_Cd::Int
    InCol_Cm::Int
    InCol_Cpmin::Int
    NumAFfiles::Int
    Foils::Array{String}
    UseBlCm::String
    Blades::Array{String}
    NumTwrNds::Int
    TwrNds::Array
    SumPrint::String
    NBlOuts::Int
    BlOutNd::Array
    NTwOuts::Int
    TwOutNd::Array
    Outlist::Array{String}
    BldNd_BladesOut::Int
    BldNd_BlOutNd::Array{Int}
    NodeOutlist::Array{String}
end

mutable struct ADBlade
    Directory
    Notes
    NumBlNds
    BldProps
    BlSpn
    BlCrvAC
    BlSwpAC
    BlCrvAng
    BlTwist
    BlChord
    BlAFID
end

#Aerodata structure, not to be confused with the airfoils input structure
struct Aerodata
    Notes1
    Notes2
    NumAirfoils
    TableID
    Aoa_stall
    z1
    z2
    z3
    Aoa_0Cn
    dCn_0L
    Cn_stall_positive
    Cn_stall_negative
    Aoa_minCd
    Cd_min
    Polar
end

struct AirfoilInput
    InterpOrd
    NonDimArea::AbstractFloat
    NumCoords
    BL_file::String
    NumTabs::Int
    Re::AbstractFloat
    UserProp::Int
    InclUAdata::String
    alpha0::AbstractFloat
    alpha1::AbstractFloat
    alpha2::AbstractFloat
    eta_e::AbstractFloat
    C_nalpha::AbstractFloat
    T_f0::AbstractFloat
    T_V0::AbstractFloat
    T_p::AbstractFloat
    T_VL::AbstractFloat
    b1::AbstractFloat
    b2::AbstractFloat
    b5::AbstractFloat
    A1::AbstractFloat
    A2::AbstractFloat
    A5::AbstractFloat
    S1::AbstractFloat
    S2::AbstractFloat
    S3::AbstractFloat
    S4::AbstractFloat
    Cn1::AbstractFloat
    Cn2::AbstractFloat
    St_sh::AbstractFloat
    Cd0::AbstractFloat
    Cm0::AbstractFloat
    k0::AbstractFloat
    k1::AbstractFloat
    k2::AbstractFloat
    k3::AbstractFloat
    k1_hat::AbstractFloat
    x_cp_bar::AbstractFloat
    UACutout
    filtCutOff
    NumAlf::Int
    Polar::Array{AbstractFloat}
end

struct AirfoilCoords
    NumCoords::Int
    AirfoilReference::Array{Float64,2}
    Coordinates::Array{Float64, 2}
end
 
mutable struct ADDriver
    Notes::String
    Echo::String
    AD_InputFile::String
    NumBlades::Int
    HubRad::Float64
    HubHt::Float64
    Overhang::Float64
    ShftTilt::Float64
    Precone ::Float64
    OutFileRoot::String
    TabDel::String
    OutFmt::String
    Beep::String
    NumCases::Int
    WindData::Array{Float64, 2}
    end


##############################################################
################## READING FUNCTIONS #########################
##############################################################
"""
ReadAD14File(filename, filepath)

Read an AeroDyn v14 inputfile and creates a mutable struct of all the input data.

"""
function ReadAD14File(filename, filepath)
    cd(filepath)
    fi = open(filename, "r")
    lines = readlines(fi)
    close(fi)

    # Lines 1-16 are constant
    directory = [
    "title"; "notes"; "StallMod"; "UseCm"; "InfModel"; "IndModel"; "AToler";
    "TLModel"; "HLModel"; "TwrShad"; "ShadHWid"; "T_Shad_Refpt"; "AirDens";
    "KinVisc"; "DTAero"; "NumFoil"]

    # Read lines 1-16
    notes = lines[2]
    StallMod = fetchword(lines[3])
    UseCm = fetchword(lines[4])
    InfModel = fetchword(lines[5])
    IndModel = fetchword(lines[6])
    AToler = parse(Float64,lines[7][1:11])
    TLModel = fetchword(lines[8])
    HLModel = fetchword(lines[9])
    TwrShad = parse(Float64,lines[10][1:11])
    ShadHWid = parse(Float64,lines[11][1:11])
    T_Shad_Refpt = parse(Float64,lines[12][1:11])
    AirDens = parse(Float64,lines[13][1:11])
    KinVisc = parse(Float64,lines[14][1:11])
    DTAero = parse(Float64,lines[15][1:11])
    NumFoil = parse(Int,lines[16][1:11])

    foils = String[]
    i = 1
    for i = 1:NumFoil
        temp = "Foil $i"
        push!(directory,temp)
        foilname = fetchword(lines[16+i];lengthofword=length(lines[16+i]))
        push!(foils,foilname)
    end
    append!(directory,["BldNodes"; "nodetitle"])



    #Read BldNodes
    BldNodes = parse(Int,lines[17+NumFoil][1:11])
    i=1
    for i = 1:BldNodes
        temp = "BldNode $i"
        push!(directory,temp)
    end

    nodes = fetchmatrix(lines[19+NumFoil:18+NumFoil+BldNodes], 75, 5)



    file = AD14file(directory, notes, StallMod, UseCm, InfModel, IndModel, AToler, TLModel,
        HLModel, TwrShad, ShadHWid, T_Shad_Refpt, AirDens, KinVisc, DTAero, NumFoil, foils,
        BldNodes, nodes)

    return file

end

"""
ReadAD15File(filename, filepath)

Reads in AeroDyn v15 input file and stores the options as a mutable struct.

"""
function ReadAD15File(filename, filepath)
cd(filepath)
fi = open(filename, "r")
lines = readlines(fi)
close(fi)

   # Lines 1-44 are constant
directory = [
   "title"; "notes"; "GeneralOptions"; "Echo"; "DTAero"; "WakeMod"; "AFAeroMod";
   "TwrPotent"; "TwrShadow"; "TwrAero"; "FrozenWake"; "CavitCheck"; "EnvironmetalConditions";
   "AirDens"; "KinVisc"; "SpdSound"; "Patm"; "Pvap"; "FluidDepth"; "BEMoptions";
   "SkewMod"; "SkewModFactor"; "TipLoss"; "HubLoss"; "TanInd"; "AIDrag"; "TIDrag";
   "IndToler"; "MaxIter"; "DynamicBEMoptions"; "DBEMT_Mod"; "tau1_const"; "BLUAAoptions";
   "UAMod"; "FLookup"; "AirfoilInfo"; "AFTabMod"; "InCol_Alfa"; "InCol_Cl";
   "InCol_Cd"; "InCol_Cm"; "InCol_Cpmin"; "NumAFfiles"]

   # Read lines 1-44
# Title = lines[1]
Notes = lines[2]
#Line 3 is a general title
Echo = fetchword15(lines[4])
DTAero = fetchword15(lines[5])
WakeMod = parse(Int, lines[6][1:14])
AFAeroMod = parse(Int, lines[7][1:14])
TwrPotent = parse(Int, lines[8][1:14])
TwrShadow = fetchword15(lines[9])
TwrAero = fetchword15(lines[10])
FrozenWake = fetchword15(lines[11])
CavitCheck = fetchword15(lines[12])
CompAA = fetchword15(lines[13])
AA_InputFile = fetchword(lines[14];lengthofword=length(lines[14]))
#Line 15 is a general title
AirDens = parse(Float64, lines[16][1:14])
KinVisc = parse(Float64, lines[17][1:14])
SpdSound = parse(Float64, lines[18][1:14])
Patm = parse(Float64, lines[19][1:14])
Pvap = parse(Float64, lines[20][1:14])
FluidDepth = parse(Float64, lines[21][1:14])
#Line 22 is a general title
SkewMod = parse(Int, lines[23][1:14])
SkewModFactor = fetchword(lines[24], lengthofword=14)
TipLoss = fetchword15(lines[25])
HubLoss = fetchword15(lines[26])
TanInd = fetchword15(lines[27])
AIDrag = fetchword15(lines[28])
TIDrag = fetchword15(lines[29])
IndToler = fetchword(lines[30], lengthofword=14)
MaxIter = parse(Int, lines[31][1:14])
#Line 32 is a general title
DBEMT_Mod = parse(Int, lines[33][1:14])
tau1_const = parse(Int, lines[34][1:14])
#Line 35 is a general title
OLAFInputFileName = fetchword(lines[36];lengthofword=length(lines[14]))
#Line 37 is a general title
UAMod = parse(Int, lines[38][1:14])
FLookup = fetchword15(lines[39])
#Line 40 is a general title
AFTabMod = parse(Int, lines[41][1:14])
InCol_Alfa = parse(Int, lines[42][1:14])
InCol_Cl = parse(Int, lines[43][1:14])
InCol_Cd = parse(Int, lines[44][1:14])
InCol_Cm = parse(Int, lines[45][1:14])
InCol_Cpmin = parse(Int, lines[46][1:14])
NumAFfiles = parse(Int, lines[47][1:14])

Foils = String[]
i = 1
for i = 1:NumAFfiles
    temp = "Foil $i"
    push!(directory, temp)
    foilname = fetchword(lines[47 + i];lengthofword=length(lines[47 + i]))
    push!(Foils, foilname)
end
#Line 48+NumAFfiles is a general title
UseBlCm = fetchword15(lines[49+NumAFfiles])
push!(directory, "UseBlCm")

Blades = String[]
idx = 49+NumAFfiles
i = 1
for i = 1:3
   temp = "Blade $i"
   push!(directory, temp)
   bladename = fetchword(lines[idx + i];lengthofword=length(lines[idx + i]))
   push!(Blades, bladename)
end

#Line 53+NumAFfiles is a general title
#TODO: I need to put everything after this point into the directory.
NumTwrNds = parse(Int, lines[54 + NumAFfiles][1:14])
#Line 55+NumAFfiles is a matrix title
#Line 56+NumAFfiles is a matrix title

##Read Twr Nodes matrix
TwrNds = fetchmatrix(lines[57+NumAFfiles:56+NumAFfiles+NumTwrNds], 43, 3)
idx = NumAFfiles+NumTwrNds

#Line 57 + idx is a general title
SumPrint = fetchword15(lines[58+idx])
NBlOuts = parse(Int, lines[59+idx][1:14])
BlOutNd = readvector(lines[60+idx],NBlOuts)
NTwOuts = parse(Int, lines[61+idx][1:14])
TwOutNd = readvector(lines[62+idx])
#Line 63+idx is a general title
Outlist = readoutlist(lines[64+idx:end])
# Node Outputs (Can't tell where the end, no way to hint how many outputs we're looking at) 
nodeoutputstitleidx = 0 
for i = 1:length(lines)
    if lowercase(lines[i][1:3]) == "end"
        nodeoutputstitleidx = i+1 #This is the title index
        break
    end
end
BldNd_BladesOut = parse(Int, lines[nodeoutputstitleidx+1][1:14])
BldNd_BlOutNd = readvector(lines[nodeoutputstitleidx+2], BldNd_BladesOut) 
# nodeoutputstitleidx+3 is a general title
NodeOutlist = readoutlist(lines[nodeoutputstitleidx+4:end])


file = AD15file(directory, Notes, Echo, DTAero, WakeMod, AFAeroMod, TwrPotent,
        TwrShadow, TwrAero, FrozenWake, CavitCheck, CompAA, AA_InputFile, AirDens, KinVisc, SpdSound, Patm, Pvap, FluidDepth, SkewMod, SkewModFactor, TipLoss, HubLoss, TanInd, AIDrag, TIDrag, IndToler, MaxIter, DBEMT_Mod, tau1_const, OLAFInputFileName, UAMod, FLookup, AFTabMod, InCol_Alfa, InCol_Cl, InCol_Cd, InCol_Cm, InCol_Cpmin, NumAFfiles, Foils, UseBlCm, Blades, NumTwrNds, TwrNds, SumPrint, NBlOuts, BlOutNd, NTwOuts, TwOutNd, Outlist, BldNd_BladesOut, BldNd_BlOutNd, NodeOutlist)
return file
end

"""
ReadADBlade(filename, filepath)

This function navigates to the location of the file given, and reads in the named 
    AD blade file.

    Inputs:
    filename - A string of the name of the file, including the extension
    filepath - A string of the path to the file

    Outputs: 
    adblade - an immutable struct of the AD blade file

"""
function ReadADBlade(filename, filepath)
    # TODO: Finish the directory. 
    cd(filepath)
    fi = open(filename, "r")
    lines = readlines(fi)
    close(fi)

    Directory = ["Title", "Notes"]

    Notes = lines[2]
    #Line 3 is a general title
    NumBlNds = parse(Int, lines[4][1:14])
    #Lines 5-6 are general titles
    BldProps = readmatrix(lines[7:6+NumBlNds], 7) #This is not an error, I overloaded the function readmatrix. 
    BlSpn = BldProps[:,1]
    BlCrvAC = BldProps[:,2]
    BlSwpAC = BldProps[:,3]
    BlCrvAng = BldProps[:,4]
    BlTwist = BldProps[:,5]
    BlChord = BldProps[:,6]
    BlAFID = Int.(BldProps[:,7])

    adblade = ADBlade(Directory, Notes, NumBlNds, BldProps, BlSpn, BlCrvAC, BlSwpAC,
                BlCrvAng, BlTwist, BlChord, BlAFID)
    return adblade
end

"""
ReadAerodata(filename, filepath)
    This function reads in the information from an aerodata file, including the polars
from the Aerodata folder. Note that currently you have to point it at the correct
file.
"""
function ReadAerodata(filename, filepath)
    cd(filepath)
    fi = open(filename, "r")
    lines = readlines(fi)
    close(fi)

    Notes1 = lines[1]
    Notes2 = lines[2]
    NumAirfoils = parse(Int,lines[3][1:firstletter(lines[3])-1])
    TableID = parse(Float64,lines[4][1:firstletter(lines[4])-1])
    Aoa_stall = parse(Float64,lines[5][1:firstletter(lines[5])-1])
    z1 = parse(Float64,lines[6][1:firstletter(lines[6])-1])
    z2 = parse(Float64,lines[7][1:firstletter(lines[7])-1])
    z3 = parse(Float64,lines[8][1:firstletter(lines[8])-1])
    Aoa_0Cn = parse(Float64,lines[9][1:firstletter(lines[9])-1])
    dCn_0L = parse(Float64,lines[10][1:firstletter(lines[10])-1])
    Cn_stall_positive = parse(Float64,lines[11][1:firstletter(lines[11])-1])
    Cn_stall_negative = parse(Float64,lines[12][1:firstletter(lines[12])-1])
    Aoa_minCd = parse(Float64,lines[13][1:firstletter(lines[13])-1])
    # println(Aoa_minCd)
    Cd_min = parse(Float64,lines[14][1:firstletter(lines[14])-1])

    stop = 15
    for i = 15:length(lines)
        lines[i] = rmspaces(lines[i])
        
        if lines[i]=="" #Chop the blank lines following. 
            stop = i-1
            break
        else
            stop = i
        end
        # println("\"", lines[i])

    end
    Polars = cat(readdlm.(IOBuffer.(lines[15:stop]))...,dims=1) #readmatrix(lines[15:end], 4)
    # println("polars: ", Polars, "   type: ", typeof(Polars))

    aerodata = Aerodata(Notes1, Notes2, NumAirfoils, TableID, Aoa_stall, z1, z2, z3,
            Aoa_0Cn, dCn_0L, Cn_stall_positive, Cn_stall_negative, Aoa_minCd, Cd_min, Polars)
    return aerodata
end

"""
ReadAirfoilInput(filename, filepath)
This function reads in the airfoil input file, which is similar to the aerodata file
    but points to the coordinates and has some different information.
    Using the fact that commented lines begin with "!".

"""
function ReadAirfoilInput(filename, filepath)

    cd(filepath)
    fi = open(filename, "r")
    lined = readlines(fi)
    close(fi)

    # Eliminate the comments from the file so we don't have to deal with multi-line comments
    lines = String[]
    for i=1:length(lined)
        # println(lined[i])
        if lined[i][1]!='!'
            line = lined[i]
            push!(lines,line)
        end
    end

    InterpOrd = fetchword(lines[1])
    NonDimArea = parse(Float64,lines[2][1:14])
    NumCoords = fetchword15(lines[3], lengthofword=length(lines[3])-115)
    BL_file = fetchword15(lines[4], lengthofword=length(lines[4])-145)
    NumTabs = parse(Int,lines[5][1:14])
    Re = parse(Float64,lines[6][1:14])
    UserProp = parse(Int,lines[7][1:14])
    InclUAdata = fetchword15(lines[8])
    alpha0 = parse(Float64,lines[9][1:14])
    alpha1 = parse(Float64,lines[10][1:14])
    alpha2 = parse(Float64,lines[11][1:14])
    eta_e = parse(Float64,lines[12][1:14])
    C_nalpha = parse(Float64,lines[13][1:14])
    T_f0 = parse(Float64,lines[14][1:14])
    T_V0 = parse(Float64,lines[15][1:14])
    T_p = parse(Float64,lines[16][1:14])
    T_VL = parse(Float64,lines[17][1:14])
    b1 = parse(Float64,lines[18][1:14])
    b2 = parse(Float64,lines[19][1:14])
    b5 = parse(Float64,lines[20][1:14])
    A1 = parse(Float64,lines[21][1:14])
    A2 = parse(Float64,lines[22][1:14])
    A5 = parse(Float64,lines[23][1:14])
    S1 = parse(Float64,lines[24][1:14])
    S2 = parse(Float64,lines[25][1:14])
    S3 = parse(Float64,lines[26][1:14])
    S4 = parse(Float64,lines[27][1:14])
    Cn1 = parse(Float64,lines[28][1:14])
    Cn2 = parse(Float64,lines[29][1:14])
    St_sh = parse(Float64,lines[30][1:14])
    Cd0 = parse(Float64,lines[31][1:14])
    Cm0 = parse(Float64,lines[32][1:14])
    k0 = parse(Float64,lines[33][1:14])
    k1 = parse(Float64,lines[34][1:14])
    k2 = parse(Float64,lines[35][1:14])
    k3 = parse(Float64,lines[36][1:14])
    k1_hat = parse(Float64,lines[37][1:14])
    x_cp_bar = parse(Float64,lines[38][1:14])
    UACutout = fetchword15(lines[39])
    filtCutOff = fetchword15(lines[40])
    # println(lines[41])
    NumAlf = parse(Int,lines[41][1:14])

    for i = 42:length(lines)
        lines[i] = rmspaces(lines[i])
    end
    Polar = readmatrix(lines[42:end],4) #TODO: This is having troubles reading the lines that have a different number of characters per entry. say 180.0 and 80.0/ There is the idea of using readdlm and iobuffer. 

    airfoilinput = AirfoilInput(InterpOrd, NonDimArea, NumCoords, BL_file, NumTabs, Re, UserProp, InclUAdata, alpha0, alpha1, alpha2, eta_e, C_nalpha, T_f0, T_V0, T_p, T_VL, b1, b2, b5, A1, A2, A5, S1, S2, S3, S4, Cn1, Cn2, St_sh, Cd0, Cm0, k0, k1, k2, k3, k1_hat, x_cp_bar, UACutout, filtCutOff, NumAlf, Polar)
    return airfoilinput
end

"""
ReadAirfoilCoordinates(filename, filepath)

Reads in the text file that has the airfoil coordinates, as per the format from OpenFAST

TODO: fix the reader so that if the numbers aren't a given length, it can still parse. 

"""
function ReadAirfoilCoordinates(filename, filepath)
    cd(filepath)
    fi = open(filename, "r")
    lined = readlines(fi)
    close(fi)

    # Eliminate the comments from the file so we don't have to deal with multi-line comments
    lines = String[]
    for i=1:length(lined)
        if lined[i][1]!='!'
            line = lined[i]
            push!(lines,line)
        end
    end

    NumCoords = parse(Int,lines[1][1:14])
    AirfoilReference = readcoordinates([rmspaces(lines[2])])

    for i = 3:length(lines)
        lines[i] = rmspaces(lines[i])
    end
    Coordinates = readcoordinates(lines[3:end])

    airfoilcoords = AirfoilCoords(NumCoords, AirfoilReference, Coordinates)
    return airfoilcoords
end

"""
    ReadADDriver(filename, filepath)

Returns an ADDriver object by reading a ADDriver input file. Note that the driver file is different from the primary input file. 

### Inputs 
- filename::String - The name of the file in the directory to be read. 
- filepath::String - The path to the file to be read, not including the filename in the path

### Outputs
- addriver - the read AD driver file object

### Notes
- Note that the reading function moves you to the directory of the file to be read. 
"""
function ReadADDriver(filename, filepath)
    cd(filepath)
    fi = open(filename, "r")
    lines = readlines(fi)
    close(fi)

    #Line 1 is the main title
    Notes = lines[2]
    #Line 3 is the input configuration title
    Echo = fetchword15(lines[4])
    AD_InputFile = fetchname(lines[5])
    #Line 6 is the Turbine Data title
    NumBlades = parse(Int, lines[7][1:14])
    HubRad = parse(Float64, lines[8][1:14])
    HubHt = parse(Float64, lines[9][1:14])
    Overhang = parse(Float64, lines[10][1:14])
    ShftTilt = parse(Float64, lines[11][1:14])
    Precone = parse(Float64, lines[12][1:14])
    #Line 13 is the I/O Settings title
    OutFileRoot = fetchname(lines[14])
    TabDel = fetchword15(lines[15])
    OutFmt = fetchname(lines[16])
    Beep = fetchword15(lines[17])
    #Line 18 is the combined-case Analysis title
    NumCases = parse(Int, lines[19][1:14])
    #Line 20 is the wind data header
    #Line 21 is the wind data units
    WindData = readmatrix(lines[22:21+NumCases], 7)
    #TODO: Maybe put something in here (or the writer) that makes NumCases match the    winddata matrix. I don't know if you can have unsteady data or not in this. 

    return ADDriver(Notes, Echo, AD_InputFile, NumBlades, HubRad, HubHt, Overhang, ShftTilt, Precone , OutFileRoot, TabDel, OutFmt, Beep, NumCases, WindData)
end




##############################################################
############# WRITING FUNCTIONS ##############################
##############################################################

function WriteAD14File(adfile, outputfile)
    #Create lines from adfile

    lines = String[]
    line = string("-"^9, " AeroDyn v14.04.* INPUT FILE ", "-"^73)
    push!(lines,line)                   # 1 - Title
    push!(lines,adfile.Notes)           # 2 - File Notes
    line = string(formatword(adfile.StallMod),"   StallMod     - Dynamic stall included [BEDDOES or STEADY] (unquoted string)")
    push!(lines,line)                   # 3 - StallMod
    line = string(formatword(adfile.UseCm), "   UseCm        - Use aerodynamic pitching moment model? [USE_CM or NO_CM] (unquoted string)")
    push!(lines, line)                  # 4 - UseCm
    line = string(formatword(adfile.InfModel), "   InfModel     - Inflow model [DYNIN or EQUIL] (unquoted string)")
    push!(lines, line)                  # 5 - InfModel
    line = string(formatword(adfile.IndModel), "   IndModel     - Induction-factor model [NONE or WAKE or SWIRL] (unquoted string)")
    push!(lines, line)                  # 6 - IndModel
    line = string(formatword(string(adfile.AToler);location="back", quotes=false), "   AToler       - Induction-factor tolerance (convergence criteria) (-)")
    push!(lines, line)                  # 7 - AToler
    line = string(formatword(adfile.TLModel), "   TLModel      - Tip-loss model (EQUIL only) [PRANDtl, GTECH, or NONE] (unquoted string)")
    push!(lines, line)                  # 8 - TLModel
    line = string(formatword(adfile.HLModel), "   HLModel      - Hub-loss model (EQUIL only) [PRANdtl or NONE] (unquoted string)")
    push!(lines, line)                  # 9 - HLModel
    line = string(formatword(string(adfile.TwrShad); location="back", quotes=false), "   TwrShad      - Tower-shadow velocity deficit (-)")
    push!(lines, line)                  # 10 - TwrShad
    line = string(formatword(string(adfile.ShadHWid); location="back", quotes=false), "   ShadHWid     - Tower-shadow half width (m)")
    push!(lines, line)                  # 11 - ShadHWid
    line = string(formatword(string(adfile.T_Shad_Refpt); location="back", quotes=false), "   T_Shad_Refpt - Tower-shadow reference point (m)")
    push!(lines, line)                  # 12 - T_Shad_Refpt
    line = string(formatword(string(adfile.AirDens); location="back", quotes=false), "   AirDens      - Air density (kg/m^3)")
    push!(lines, line)                  # 13 - AirDens
    line = string(formatword(@sprintf "%.4E" adfile.KinVisc; location="back", quotes = false), "   KinVisc      - Kinematic air viscosity [CURRENTLY IGNORED] (m^2/sec)")
    push!(lines, line)                  # 14 - KinVisc
    line = string(formatword(string(adfile.DTAero); location="back", quotes=false), "   DTAero       - Time interval for aerodynamic calculations (sec)")
    push!(lines, line)                  # 15 - DTAero
    line = string(formatword(string(adfile.NumFoil); location="back", quotes=false), "   NumFoil      - Number of airfoil files (-)")
    push!(lines, line)                  # 16 - NumFoil
    line = string(formatword(adfile.Foils[1]; desiredlength=32), "FoilNm      - Names of the airfoil files [NumFoil lines] (quoted strings)")
    push!(lines, line)                  # 17 Foil name

    for i = 2:adfile.NumFoil
        line = string(formatword(adfile.Foils[i]; desiredlength=32))
        push!(lines,line)               # Adding all foils (lines 16+NumFoil)
    end

    line = string(formatword(string(adfile.BldNodes); location="back", quotes=false), "   BldNodes    - Number of blade nodes used for analysis (-)")
    push!(lines, line)                  # BldNodes (line 17+NumFoil)
    line = "RNodes         AeroTwst       DRNodes        Chord          NFoil          PrnElm"
    push!(lines, line)                  # Nodes title (line 18+NumFoil)

    #Create Nodes Matrix
    smat = formatmatrix(adfile.Nodes[:,1:4])
    column = Int.(adfile.Nodes[:,5])
    column = formatword.(string.(column); location="back", quotes=false, desiredlength=9)
    smat = formatmatrix_appendcolumn(smat, column)
    column = String[]
    for i=1:length(adfile.Nodes[:,5])
        push!(column,"      NOPRINT")
    end
    smat = formatmatrix_appendcolumn(smat, column)
    append!(lines, smat)

    #Check that filename is appropriate
    # if outputfile[end-2]!="ipt"
    #     error("Output file name ending of AD writer incorrect.")
    # end

    #Write lines to file
    fi = open(outputfile,"w+")
    i = 1
    for i = 1:length(lines)-1
        write(fi,lines[i])
        write(fi,"\n")
        # println(lines[i])
    end
    write(fi,lines[end])
    close(fi)
end

function WriteAD15File(adfile, outputfile; outputpath=pwd())
    lines = String[]
    line = string("-"^7, " AERODYN v15 for OpenFAST INPUT FILE ", "-"^47)
    push!(lines,line)
    push!(lines, adfile.Notes)
    line = string("="^6, "  General Options  ", "="^76)
    push!(lines, line)
    line = string(formatword(adfile.Echo;quotes=false),"   Echo               - Echo the input to \"<rootname>.AD.ech\"?  (flag)")
    push!(lines, line)
    line = string(formatword(adfile.DTAero;quotes=false),"   DTAero             - Time interval for aerodynamic calculations {or \"default\"} (s)")
    push!(lines, line)
    line = string(formatword(string(adfile.WakeMod);location="back",quotes=false), "   WakeMod            - Type of wake/induction model (switch) {0=none, 1=BEMT, 2=DBEMT} [WakeMod cannot be 2 when linearizing]")
    push!(lines, line)
    line = string(formatword(string(adfile.AFAeroMod);location="back",quotes=false),"   AFAeroMod          - Type of blade airfoil aerodynamics model (switch) {1=steady model, 2=Beddoes-Leishman unsteady model} [AFAeroMod must be 1 when linearizing]")
    push!(lines, line)
    line = string(formatword(string(adfile.TwrPotent);location="back",quotes=false),"   TwrPotent          - Type tower influence on wind based on potential flow around the tower (switch) {0=none, 1=baseline potential flow, 2=potential flow with Bak correction}")
    push!(lines, line)
    line = string(formatword(adfile.TwrShadow;quotes=false), "   TwrShadow          - Calculate tower influence on wind based on downstream tower shadow? (flag)")
    push!(lines,line)
    line = string(formatword(adfile.TwrAero;quotes=false), "   TwrAero            - Calculate tower aerodynamic loads? (flag)")
    push!(lines, line)
    line = string(formatword(adfile.FrozenWake;quotes=false), "   FrozenWake         - Assume frozen wake during linearization? (flag) [used only when WakeMod=1 and when linearizing]")
    push!(lines, line)
    line = string(formatword(adfile.CavitCheck;quotes=false), "   CavitCheck         - Perform cavitation check? (flag) [AFAeroMod must be 1 when CavitCheck=true]")
    push!(lines, line)
    line = string(formatword(adfile.CompAA;quotes=false), "   CompAA             - Flag to compute AeroAcoustics calculation [only used when WakeMod=1 or 2]")
    push!(lines, line)
    line = string(formatword(adfile.AA_InputFile), "   - Aeroacoustics input file")
    push!(lines, line)
    line = string("="^6, "  Environmental Conditions  ", "="^67)
    push!(lines, line)
    line = string(formatword(string(adfile.AirDens);location="back", quotes=false), "   AirDens            - Air density (kg/m^3)")
    push!(lines, line)
    line = string(formatword(string(adfile.KinVisc);location="back", quotes=false), "   KinVisc            - Kinematic air viscosity (m^2/s)")
    push!(lines, line)
    line = string(formatword(string(adfile.SpdSound);location="back", quotes=false), "   SpdSound           - Speed of sound (m/s)")
    push!(lines, line)
    line = string(formatword(string(adfile.Patm);location="back", quotes=false), "   Patm               - Atmospheric pressure (Pa) [used only when CavitCheck=True]")
    push!(lines, line)
    line = string(formatword(string(adfile.Pvap);location="back", quotes=false), "   Pvap               - Vapour pressure of fluid (Pa) [used only when CavitCheck=True]")
    push!(lines, line)
    line = string(formatword(string(adfile.FluidDepth);location="back", quotes=false), "   FluidDepth         - Water depth above mid-hub height (m) [used only when CavitCheck=True]")
    push!(lines, line)
    line = string("="^6, "  Blade-Element/Momentum Theory Options  ", "="^54)
    push!(lines, line)
    line = string(formatword(string(adfile.SkewMod);location="back", quotes=false), "   SkewMod            - Type of skewed-wake correction model (switch) {1=uncoupled, 2=Pitt/Peters, 3=coupled} [unused when WakeMod=0]")
    push!(lines, line)
    line = string(formatword(adfile.SkewModFactor), "   SkewModFactor      - Constant used in Pitt/Peters skewed wake model {or \"default\" is 15/32*pi} (-) [used only when SkewMod=2; unused when WakeMod=0]")
    push!(lines, line)
    line = string(formatword(adfile.TipLoss;quotes=false), "   TipLoss            - Use the Prandtl tip-loss model? (flag) [unused when WakeMod=0]")
    push!(lines, line)
    line = string(formatword(adfile.HubLoss;quotes=false), "   HubLoss            - Use the Prandtl hub-loss model? (flag) [unused when WakeMod=0]")
    push!(lines, line)
    line = string(formatword(adfile.TanInd;quotes=false), "   TanInd             - Include tangential induction in BEMT calculations? (flag) [unused when WakeMod=0]")
    push!(lines, line)
    line = string(formatword(adfile.AIDrag;quotes=false), "   AIDrag             - Include the drag term in the axial-induction calculation? (flag) [unused when WakeMod=0]")
    push!(lines, line)
    line = string(formatword(adfile.TIDrag;quotes=false), "   TIDrag             - Include the drag term in the tangential-induction calculation? (flag) [unused when WakeMod=0 or TanInd=FALSE]")
    push!(lines, line)
    line = string(formatword(adfile.IndToler), "   IndToler           - Convergence tolerance for BEMT nonlinear solve residual equation {or \"default\"} (-) [unused when WakeMod=0]")
    push!(lines, line)
    line = string(formatword(string(adfile.MaxIter);location="back", quotes=false), "   MaxIter            - Maximum number of iteration steps (-) [unused when WakeMod=0]")
    push!(lines, line)
    line = string("="^6, "  Dynamic Blade-Element/Momentum Theory Options  ", "="^46)
    push!(lines, line)
    line = string(formatword(string(adfile.DBEMT_Mod);location="back", quotes=false), "   DBEMT_Mod          - Type of dynamic BEMT (DBEMT) model {1=constant tau1, 2=time-dependent tau1} (-) [used only when WakeMod=2]")
    push!(lines, line)
    line = string(formatword(string(adfile.tau1_const);location="back", quotes=false), "   tau1_const         - Time constant for DBEMT (s) [used only when WakeMod=2 and DBEMT_Mod=1]")
    push!(lines, line)
    line = string("="^6, "   OLAF -- cOnvecting LAgrangian Filaments (Free Vortex Wake) Theory Options", "="^46)
    push!(lines, line)
    line = string(formatword(adfile.OLAFInputFileName), "   - Aeroacoustics input file")
    push!(lines, line)
    line = string("="^6, "  Beddoes-Leishman Unsteady Airfoil Aerodynamics Options  ", "="^37)
    push!(lines, line)
    line = string(formatword(string(adfile.UAMod);location="back", quotes=false), "   UAMod              - Unsteady Aero Model Switch (switch) {1=Baseline model (Original), 2=Gonzalez's variant (changes in Cn,Cc,Cm), 3=Minemma/Pierce variant (changes in Cc and Cm)} [used only when AFAeroMod=2]")
    push!(lines, line)
    line = string(formatword(adfile.FLookup;quotes=false), "   FLookup            - Flag to indicate whether a lookup for f\' will be calculated (TRUE) or whether best-fit exponential equations will be used (FALSE); if FALSE S1-S4 must be provided in airfoil input files (flag) [used only when AFAeroMod=2]")
    push!(lines, line)
    line = string("="^6, "  Airfoil Information ", "="^73)
    push!(lines, line)
    line = string(formatword(string(adfile.AFTabMod);location="back", quotes=false), "   AFTabMod           - Interpolation method for multiple airfoil tables {1=1D interpolation on AoA (first table only); 2=2D interpolation on AoA and Re; 3=2D interpolation on AoA and UserProp} (-)")
    push!(lines, line)
    line = string(formatword(string(adfile.InCol_Alfa);location="back", quotes=false), "   InCol_Alfa         - The column in the airfoil tables that contains the angle of attack (-)")
    push!(lines, line)
    line = string(formatword(string(adfile.InCol_Cl);location="back", quotes=false), "   InCol_Cl           - The column in the airfoil tables that contains the lift coefficient (-)")
    push!(lines, line)
    line = string(formatword(string(adfile.InCol_Cd);location="back", quotes=false), "   InCol_Cd           - The column in the airfoil tables that contains the drag coefficient (-)")
    push!(lines, line)
    line = string(formatword(string(adfile.InCol_Cm);location="back", quotes=false), "   InCol_Cm           - The column in the airfoil tables that contains the pitching-moment coefficient; use zero if there is no Cm column (-)")
    push!(lines, line)
    line = string(formatword(string(adfile.InCol_Cpmin);location="back", quotes=false), "   InCol_Cpmin        - The column in the airfoil tables that contains the Cpmin coefficient; use zero if there is no Cpmin column (-)")
    push!(lines, line)
    line = string(formatword(string(adfile.NumAFfiles);location="back", quotes=false), "   NumAFfiles         - Number of airfoil files used (-)")
    push!(lines, line)

    line = string(formatword(adfile.Foils[1];desiredlength=length(adfile.Foils[2])+5), "AFNames            - Airfoil file names (NumAFfiles lines) (quoted strings)")
    push!(lines, line)

    for i=2:length(adfile.Foils)
       line = string("\"",adfile.Foils[i],"\"")
       push!(lines,line)
    end

    line = string("="^6, "  Rotor/Blade Properties  ", "="^69)
    push!(lines,line)
    line = string(formatword(adfile.UseBlCm;quotes=false), "   UseBlCm            - Include aerodynamic pitching moment in calculations?  (flag)")
    push!(lines,line)

    while length(adfile.Blades)<3 #If only one blade file is given, this repeats it 3 times so that the file is the correct length. I suppose I could always add "unused" instead, but the same name works just fine. 
       push!(adfile.Blades,adfile.Blades[1])
    end

    for i=1:length(adfile.Blades)
       line = string(formatword(adfile.Blades[i];desiredlength=length(adfile.Blades[i])+2),"   ADBlFile($i)        - Name of file containing distributed aerodynamic properties for Blade #$i (-)")
       push!(lines, line)
    end

    line = string("="^6, "  Tower Influence and Aerodynamics ", "="^61)
    push!(lines, line)
    line = string(formatword(string(adfile.NumTwrNds);location="back",quotes=false), "   NumTwrNds         - Number of tower nodes used in the analysis  (-) [used only when TwrPotent/=0, TwrShadow=True, or TwrAero=True]")
    push!(lines, line)
    line = "TwrElev        TwrDiam        TwrCd"
    push!(lines, line)
    line = "(m)              (m)           (-)"
    push!(lines, line)
    line = formatmatrix(adfile.TwrNds)
    append!(lines,line)
    line = string("="^6, "  Outputs  ", "="^84)
    push!(lines, line)
    line = string(formatword(adfile.SumPrint;quotes=false), "   SumPrint            - Generate a summary file listing input options and interpolated properties to \"<rootname>.AD.sum\"?  (flag)")
    push!(lines, line)
    line = string(formatword(string(adfile.NBlOuts);location="back",quotes=false), "   NBlOuts             - Number of blade node outputs [0 - 9] (-)")
    push!(lines, line)
    if adfile.NBlOuts>0
       line = formatvector(adfile.BlOutNd)
    else
       line = " "^11
    end
    line = string(line, "   BlOutNd             - Blade nodes whose values will be output  (-)")
    push!(lines, line)
    line = string(formatword(string(adfile.NTwOuts);location="back",quotes=false), "   NTwOuts             - Number of tower node outputs [0 - 9]  (-)")
    push!(lines, line)
    line = formatvector(adfile.TwOutNd)
    line = string(line, "   TwOutNd             - Tower nodes whose values will be output  (-)")
    push!(lines, line)
    line = "                   OutList             - The next line(s) contains a list of output parameters.  See s for a listing of available output channels, (-)"
    push!(lines, line)
    for i=1:length(adfile.Outlist)
       line = string("\"", adfile.Outlist[i], "\"")
       push!(lines,line)
    end
    line = "END of input file (the word \"END\" must appear in the first 3 columns of this last OutList line)"
    push!(lines,line)
    line = "---------------------- NODE OUTPUTS --------------------------------------------"
    push!(lines, line)
    line = string(formatword(string(adfile.BldNd_BladesOut);location="back",quotes=false), "   BldNd_BladesOut  - Blades to output")
    push!(lines, line)

    if adfile.BldNd_BladesOut>0
        line = formatvector(adfile.BldNd_BlOutNd)
    else
        line = " "^11
    end
     line = string(line, "   - Blade nodes on each blade (currently unused)")
     push!(lines, line)

     line = "                   OutList             - The next line(s) contains a list of output parameters.  See s for a listing of available output channels, (-)"

     push!(lines, line)
     for i=1:length(adfile.NodeOutlist)
        line = string("\"", adfile.NodeOutlist[i], "\"")
        push!(lines,line)
     end
     line = "END of input file (the word \"END\" must appear in the first 3 columns of this last OutList line)"
     push!(lines,line)

    #Write lines to file
    cd(outputpath)
    fi = open(outputfile,"w+")
    i = 1
    for i = 1:length(lines)-1
         write(fi,lines[i])
         write(fi,"\n")
    end
    write(fi,lines[end])
    close(fi)
end


function WriteADBlade(adblade, outputfile; outputpath=pwd())
    lines = String[]
    line = string("-"^7, " AERODYN v15.00.* BLADE DEFINITION INPUT FILE ", "-"^37)
    push!(lines, line)
    line = adblade.Notes
    push!(lines, line)
    line = string("="^6, "  Blade Properties ", "="^65)
    push!(lines, line)
    line = string(formatword(string(adblade.NumBlNds);location="back", quotes=false),"   NumBlNds           - Number of blade nodes used in the analysis (-)")
    push!(lines, line)
    line = "  BlSpn        BlCrvAC        BlSwpAC        BlCrvAng       BlTwist        BlChord          BlAFID"
    push!(lines, line)
    line = "   (m)           (m)            (m)            (deg)         (deg)           (m)              (-)"
    push!(lines, line)
    line = formatmatrix(adblade.BldProps[:,1:end-1])
    newcolumn = formatwidecolumn(Int.(adblade.BldProps[:,end]))
    line = formatmatrix_appendcolumn(line, newcolumn)
    append!(lines, line)

    #Write lines to file
    cd(outputpath)
    fi = open(outputfile,"w+")
    i = 1
    for i = 1:length(lines)-1
         write(fi,lines[i])
         write(fi,"\n")
    end
    write(fi,lines[end])
    close(fi)
end

"""
WriteAirfoilCoordinates(airfoilcoords, outputfile)

    Writes a file for the OpenFAST airfoil coordinates file.
"""
function WriteAirfoilCoordinates(airfoilcoords, outputfile; outputpath=pwd())
    lines = String[]
    line = string(formatword(string(airfoilcoords.NumCoords);location="back", quotes=false),"   NumCoords         ! The number of coordinates in the airfoil shape file (including an extra coordinate for airfoil reference).  Set to zero if coordinates not included." )
    push!(lines, line)
    line = "! ......... x-y coordinates are next if NumCoords > 0 ............."
    push!(lines, line)
    line = "! x-y coordinate of airfoil reference"
    push!(lines, line)
    line = "!  x/c        y/c"
    push!(lines, line)
    line = formatcoordinates(airfoilcoords.AirfoilReference)
    append!(lines, line)
    line = "! Airfoil Coordinates"
    push!(lines, line)
    line = "! x/c     y/c"
    push!(lines, line)
    line = formatcoordinates(airfoilcoords.Coordinates)
    append!(lines, line)


    ### Write lines to file
    cd(outputpath)
    fi = open(outputfile,"w+")
    i = 1
    for i = 1:length(lines)-1
         write(fi,lines[i])
         write(fi,"\n")
    end
    write(fi,lines[end])
    close(fi)
end

"""
WriteAirfoilInput(airfoilinput, outputfile)
"""
function WriteAirfoilInput(airfoilinput, outputfile; outputpath=pwd())
    lines = String[]
    line = "! ------------ AirfoilInfo v1.01.x Input File ----------------------------------"
    push!(lines, line)
    line = string(formatword(string(airfoilinput.InterpOrd);location="front", quotes=true),"   InterpOrd         ! Interpolation order to use for quasi-steady table lookup {1=linear; 3=cubic spline; \"default\"} [default=1]" )
    push!(lines, line)
    line = string(formatword(string(airfoilinput.NonDimArea);location="back", quotes=false),"   NonDimArea        ! The non-dimensional area of the airfoil (area/chord^2) (set to 1.0 if unsure or unneeded)")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.NumCoords);location="front", quotes=false, desiredlength=27),"   NumCoords         ! The number of coordinates in the airfoil shape file.  Set to zero if coordinates not included.")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.BL_file);location="front", quotes=false, desiredlength=length(airfoilinput.BL_file)+0), "   BL_file           ! The file name including the boundary layer characteristics of the profile. Ignored if the aeroacoustic module is not called.")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.NumTabs);location="back", quotes=false),"   NumTabs           ! Number of airfoil tables in this file.")
    push!(lines, line)
    line = "! ------------------------------------------------------------------------------"
    push!(lines, line)
    line = "! data for table 1"
    push!(lines, line)
    line = "! ------------------------------------------------------------------------------"
    push!(lines, line)
    line = string(formatword(string(airfoilinput.Re);location="back", quotes=false),"   Re                ! Reynolds number in millions")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.UserProp);location="back", quotes=false),"   UserProp          ! User property (control) setting")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.InclUAdata);location="front", quotes=false),"   InclUAdata        ! Is unsteady aerodynamics data included in this table? If TRUE, then include 30 UA coefficients below this line")
    push!(lines, line)
    if parse(Bool, airfoilinput.InclUAdata)
        line = "!........................................"
        push!(lines, line)
        line = string(formatword(string(airfoilinput.alpha0);location="back",   quotes=false),"   alpha0            ! 0-lift angle of attack, depends on  airfoil.")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.alpha1);location="back",   quotes=false),"   alpha1            ! Angle of attack at f=0.7,   (approximately the stall angle) for AOA>alpha0. (deg)")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.alpha2);location="back",   quotes=false),"   alpha2            ! Angle of attack at f=0.7,   (approximately the stall angle) for AOA<alpha0. (deg)")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.eta_e);location="back",    quotes=false),"   eta_e             ! Recovery factor in the range [0.85 - 0.  95] used only for UAMOD=1, it is set to 1 in the code when flookup=True. (-)  ")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.C_nalpha);location="back",     quotes=false),"   C_nalpha          ! Slope of the 2D normal force  coefficient curve. (1/rad)")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.T_f0);location="back",     quotes=false),"   T_f0              ! Initial value of the time constant    associated with Df in the expression of Df and f''. [default = 3]")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.T_V0);location="back",     quotes=false),"   T_V0              ! Initial value of the time constant    associated with the vortex lift decay process; it is used in the expression    of Cvn. It depends on Re,M, and airfoil class. [default = 6]")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.T_p);location="back",  quotes=false),"   T_p               ! Boundary-layer,leading edge pressure   gradient time constant in the expression of Dp. It should be tuned based on   airfoil experimental data. [default = 1.7]")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.T_VL);location="back",     quotes=false),"   T_VL              ! Initial value of the time constant    associated with the vortex advection process; it represents the    non-dimensional time in semi-chords, needed for a vortex to travel from LE     to trailing edge (TE); it is used in the expression of Cvn. It depends on   Re, M (weakly), and airfoil. [valid range = 6 - 13, default = 11]")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.b1);location="back",   quotes=false),"   b1                ! Constant in the expression of   phi_alpha^c and phi_q^c.  This value is relatively insensitive for thin   airfoils, but may be different for turbine airfoils. [from experimental   results, defaults to 0.14]")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.b2);location="back",   quotes=false),"   b2                ! Constant in the expression of   phi_alpha^c and phi_q^c.  This value is relatively insensitive for thin   airfoils, but may be different for turbine airfoils. [from experimental   results, defaults to 0.53]")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.b5);location="back",   quotes=false),"   b5                ! Constant in the expression of K'''_q,   Cm_q^nc, and k_m,q.  [from  experimental results, defaults to 5]")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.A1);location="back",   quotes=false),"   A1                ! Constant in the expression of   phi_alpha^c and phi_q^c.  This value is relatively insensitive for thin   airfoils, but may be different for turbine airfoils. [from experimental   results, defaults to 0.3]")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.A2);location="back",   quotes=false),"   A2                ! Constant in the expression of   phi_alpha^c and phi_q^c.  This value is relatively insensitive for thin   airfoils, but may be different for turbine airfoils. [from experimental   results, defaults to 0.7]")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.A5);location="back",   quotes=false),"   A5                ! Constant in the expression of K'''_q,   Cm_q^nc, and k_m,q. [from experimental results, defaults to 1]")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.S1);location="back",   quotes=false),"   S1                ! Constant in the f curve best-fit for    alpha0<=AOA<=alpha1; by definition it depends on the airfoil. [ignored if  UAMod<>1]")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.S2);location="back",   quotes=false),"   S2                ! Constant in the f curve best-fit    for         AOA> alpha1; by definition it depends on the airfoil. [ignored     if UAMod<>1]")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.S3);location="back",   quotes=false),"   S3                ! Constant in the f curve best-fit for    alpha2<=AOA< alpha0; by definition it depends on the airfoil. [ignored if  UAMod<>1]")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.S4);location="back",   quotes=false),"   S4                ! Constant in the f curve best-fit    for         AOA< alpha2; by definition it depends on the airfoil. [ignored     if UAMod<>1]")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.Cn1);location="back",  quotes=false),"   Cn1               ! Critical value of C0n at leading edge  separation. It should be extracted from airfoil data at a given Mach and     Reynolds number. It can be calculated from the static value of Cn at either     the break in the pitching moment or the loss of chord force at the onset of     stall. It is close to the condition of maximum lift of the airfoil at low   Mach numbers.")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.Cn2);location="back",  quotes=false),"   Cn2               ! As Cn1 for negative AOAs.")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.St_sh);location="back",    quotes=false),"   St_sh             ! Strouhal's shedding frequency    constant.  [default = 0.19]")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.Cd0);location="back",  quotes=false),"   Cd0               ! 2D drag coefficient value at 0-lift.")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.Cm0);location="back",  quotes=false),"   Cm0               ! 2D pitching moment coefficient about 1/    4-chord location, at 0-lift, positive if nose up. [If the aerodynamics  coefficients table does not include a column for Cm, this needs to be set to     0.0]")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.k0);location="back",   quotes=false),"   k0                ! Constant in the hat(x)_cp curve     best-fit; = (hat(x)_AC-0.25).  [ignored if UAMod<>1]")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.k1);location="back",   quotes=false),"   k1                ! Constant in the hat(x)_cp curve     best-fit.  [ignored if UAMod<>1]")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.k2);location="back",   quotes=false),"   k2                ! Constant in the hat(x)_cp curve     best-fit.  [ignored if UAMod<>1]")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.k3);location="back",   quotes=false),"   k3                ! Constant in the hat(x)_cp curve     best-fit.  [ignored if UAMod<>1]")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.k1_hat);location="back",   quotes=false),"   k1_hat            ! Constant in the expression of Cc due    to leading edge vortex effects.  [ignored if UAMod<>1]")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.x_cp_bar);location="back",     quotes=false),"   x_cp_bar          ! Constant in the expression of hat(x)  _cp^v. [ignored if UAMod<>1, default = 0.2]")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.UACutout);location="front",    quotes=false),"   UACutout          ! Angle of attack above which unsteady     aerodynamics are disabled (deg). [Specifying the string \"Default\" sets    UACutout to 45 degrees]")
        push!(lines, line)
        line = string(formatword(string(airfoilinput.filtCutOff);location="front", quotes=false),"   filtCutOff        ! Cut-off frequency (-3 dB corner frequency) for low-pass filtering the AoA input to UA, as well as the 1st and 2nd derivatives (Hz) [default = 20]")
        push!(lines, line)
    end
    line = "!........................................"
    push!(lines, line)
    line = "! Table of aerodynamics coefficients"
    push!(lines, line)
    line = string(formatword(string(airfoilinput.NumAlf);location="back", quotes=false),"   NumAlf            ! Number of data lines in the following table")
    push!(lines, line)
    line = "!    Alpha      Cl      Cd        Cm"
    push!(lines, line)
    line = "!    (deg)      (-)     (-)       (-)"
    push!(lines, line)
    line = formatcoordinates(airfoilinput.Polar)
    append!(lines, line)

    ### Write lines to file
    cd(outputpath)
    fi = open(outputfile,"w+")
    i = 1
    for i = 1:length(lines)-1
         write(fi,lines[i])
         write(fi,"\n")
    end
    write(fi,lines[end])
    close(fi)
end

"""
WriteAerodata(aerodata, outputfile)
This function takes an aerodata structure and writes an output file for it.
"""
function WriteAerodata(aerodata, outputfile; outputpath=pwd())
    lines = String[]
    line = aerodata.Notes1
    push!(lines, line)
    line = aerodata.Notes2
    push!(lines, line)
    line = string(formatword(string(aerodata.NumAirfoils);location="back", quotes=false),"   Number of airfoil tables in this file")
    push!(lines, line)
    line = string(formatword(string(aerodata.TableID);location="back", quotes=false),"   Table ID parameter")
    push!(lines, line)
    line = string(formatword(string(aerodata.Aoa_stall);location="back", quotes=false),"   Stall angle (deg)")
    push!(lines, line)
    line = string(formatword(string(aerodata.z1);location="back", quotes=false),"   No longer used, enter zero")
    push!(lines, line)
    line = string(formatword(string(aerodata.z2);location="back", quotes=false),"   No longer used, enter zero")
    push!(lines, line)
    line = string(formatword(string(aerodata.z3);location="back", quotes=false),"   No longer used, enter zero")
    push!(lines, line)
    line = string(formatword(string(aerodata.Aoa_0Cn);location="back", quotes=false),"   Zero Cn angle of attack (deg)")
    push!(lines, line)
    line = string(formatword(string(aerodata.dCn_0L);location="back", quotes=false),"   Cn slope for zero lift (dimensionless)")
    push!(lines, line)
    line = string(formatword(string(aerodata.Cn_stall_positive);location="back", quotes=false),"   Cn extrapolated to value at positive stall angle of attack")
    push!(lines, line)
    line = string(formatword(string(aerodata.Cn_stall_negative);location="back", quotes=false),"   Cn at stall value for negative angle of attack")
    push!(lines, line)
    line = string(formatword(string(aerodata.Aoa_minCd);location="back", quotes=false),"   Angle of attack for minimum CD (deg)")
    push!(lines, line)
    line = string(formatword(string(aerodata.Cd_min);location="back", quotes=false),"   Minimum CD value")
    push!(lines, line)
    line = formatcoordinates(aerodata.Polar)
    # println(line)
    # println(aerodata.Polar)
    append!(lines, line)

    ### Write lines to file
    cd(outputpath)
    fi = open(outputfile,"w+")
    i = 1
    for i = 1:length(lines)-1
         write(fi,lines[i])
         write(fi,"\n")
    end
    write(fi,lines[end])
    close(fi)
end

"""
    WriteADDriver(addriver, outputfile;outputpath=pwd())

Writes the desired AD driver file at the stated location. 

### Inputs 
- addriver - the AD driver file
- outputfile::String - The name of the file, containing the file ending.
- outputpath::String - the location to write the file

### No Outputs, but a file will be written
"""
function WriteADDriver(addriver, outputfile; outputpath=pwd())
    lines = []
    line = string("-"^7, " AeroDyn Driver v1.00.x Input File ", "-"^37)
    push!(lines, line)
    line = addriver.Notes
    push!(lines, line)
    line = string("="^7, "  General Options  ", "="^30)
    push!(lines, line)
    line = string(formatword(addriver.Echo;quotes=false),"   Echo               -   Echo the input to \"<rootname>.ech\"?  (flag)")
    push!(lines, line)
    line = string(formatword(addriver.AD_InputFile;quotes=false,desiredlength=length(addriver.AD_InputFile)+1),"   AD_InputFile    -  Name of the primary AeroDyn input file")
    push!(lines, line)
    line = string("-"^7, " Turbine Data ", "-"^30)
    push!(lines, line)
    line = string(formatword(string(addriver.NumBlades);location="back", quotes=false)  , "   NumBlades       - Number of blades (-)")
    push!(lines, line)
    line = string(formatword(string(addriver.HubRad);location="back", quotes=false),    "   HubRad          - Hub radius (m)")
    push!(lines, line)
    line = string(formatword(string(addriver.HubHt);location="back", quotes=false),     "   HubHt           - Hub height (m)")
    push!(lines, line)
    line = string(formatword(string(addriver.Overhang);location="back", quotes=false)   , "   Overhang        - Overhang (m)")
    push!(lines, line)
    line = string(formatword(string(addriver.ShftTilt);location="back", quotes=false)   , "   ShftTilt        - Shaft tilt (deg)")
    push!(lines, line)
    line = string(formatword(string(addriver.Precone);location="back", quotes=false),   "   Precone         - Blade precone (deg)")
    push!(lines, line)
    line = string("-"^7, " I/O Settings ", "-"^30)
    push!(lines, line)
    line = string(formatword(addriver.OutFileRoot;quotes=false, desiredlength=length(addriver.OutFileRoot)+1),"   OutFileRoot     -   Root name for any output files (use \"\" for .dvr rootname) (-)")
    push!(lines, line)
    line = string(formatword(addriver.TabDel;quotes=false),"   TabDel          - When   generating formatted output (OutForm=True), make output tab-delimited     (fixed-width otherwise) (flag)")
    push!(lines, line)
    line = string(formatword(addriver.OutFmt;quotes=false),"   OutFmt          -    Format used for text tabular output, excluding the time channel.  Resulting field  should be 10 characters. (quoted string)")
    push!(lines, line)
    line = string(formatword(addriver.Beep;quotes=false),"   Beep            - Beep     on exit (flag)")
    push!(lines, line)
    line = string("-"^7, "  Combined-Case Analysis  ", "-"^30)
    push!(lines, line)
    line = string(formatword(string(addriver.NumCases);location="back", quotes=false)   , "   NumCases        - Number of cases to run")
    push!(lines, line)
    line = "WndSpeed       ShearExp       RotSpd        Pitch               Yaw           dT             Tmax"
    push!(lines, line)
    line = "(m/s)            (-)          (rpm)         (deg)               (deg)          (s)            (s)"
    push!(lines, line)
    line = formatmatrix(addriver.WindData)
    append!(lines, line)



    #Write lines to file
    cd(outputpath)
    fi = open(outputfile,"w+")
    i = 1
    for i = 1:length(lines)-1
         write(fi,lines[i])
         write(fi,"\n")
    end
    write(fi,lines[end])
    close(fi)
end



##############################################################
############### CREATING FUNCTIONS ###########################
##############################################################

"""
    CreateAD14(Foils, Nodes; StallMod="STEADY", UseCm="NO_CM", InfModel="EQUIL",
IndModel="SWIRL", AToler=0.005, TLModel="PRANDtl", HLModel="PRANDtl",
TwrShad=0.3, ShadHWid=0.2, T_Shad_Refpt=1.341, AirDens=0.9526, KinVisc=1.4639E-05,
DTAero=0.005, notes="This is an Aerodyn input file.")

### Inputs
- Foils - An array of strings containing the names of the airfoil files used in the blade. Note that order does matter. The order must match the order listed in the ADblade file. 

### Outputs


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
    CavitCheck="False", CompAA="False", AA_InputFile="unused", AirDens=1.225, KinVisc=1.464e-5, SpdSound = 335.0, Patm=103500,
    Pvap=1700, FluidDepth=0.5, SkewMod=2, SkewModFactor="\"default\"", TipLoss="True",
    HubLoss="True", TanInd="True", AIDrag="False", TIDrag="False", IndToler="\"default\"",
    MaxIter=100, DBEMT_Mod=2, tau1_const=4, OLAFInputFileName="unused", UAMod=3, FLookup="True", AFTabMod=1,
    InCol_Alfa=1, InCol_Cl=2, InCol_Cd=3, InCol_Cm=4, InCol_Cpmin=0, UseBlCm="True",
    TwrNds=zeros(1,3), SumPrint="False", NBlOuts=0, BlOutNd=[0], NTwOuts=0, TwOutNd=[0],
    Outlist=String[], BldNd_BladesOut=0, BldNd_BlOutNd=[], NodeOutlist=String[]) 

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

    file = AD15file(directory, Notes, Echo, DTAero, WakeMod, AFAeroMod, TwrPotent, TwrShadow, TwrAero, FrozenWake, CavitCheck, CompAA, AA_InputFile, AirDens, KinVisc, SpdSound, Patm, Pvap, FluidDepth, SkewMod, SkewModFactor, TipLoss, HubLoss, TanInd, AIDrag, TIDrag, IndToler, MaxIter, DBEMT_Mod, tau1_const, OLAFInputFileName, UAMod, FLookup, AFTabMod, InCol_Alfa, InCol_Cl, InCol_Cd, InCol_Cm, InCol_Cpmin, NumAFfiles, Foils, UseBlCm, Blades, NumTwrNds, TwrNds, SumPrint, NBlOuts, BlOutNd, NTwOuts, TwOutNd, Outlist, BldNd_BladesOut, BldNd_BlOutNd, NodeOutlist)
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
- pitch - The value that the tip of the blade is pitched (assuming pitch is constant throughout the analysis) (degrees)
- importantrads - radial distances that the user would like to insure a node is placed. (meters)
- notes - notes that the user would like placed at the top of the blade file.
- verbose - boolean that marks whether to make statements about creating the blade.

### Outputs
- adblade - an adblade struct
- importantnodes - the node numbers of the important radi that the user declared. 

### Notes
- Note that this function does not place nodes in the transition region between the cylinder and the airfoils. It also does not interpolate the airfoils between nodes, but uses an integer fit to populate the airfoil id in the blade file. 

### Definitions 
Below is a short list of the naming convention used in this function.
- radius (rads) - distance from the center of rotation
- fractions (fracs) - percentage of total blade radius
- blade radius (blrads) - distance from the hub (distance of blade length not   including the hub)
- blade fraction (blfrac) - percentage of blade radius
"""
function CreateAD15Blade(rads, radschords, radstwists, radscones, radsconeangs, radssweeps, radsafid, tiprad, hubrad, cylinderrad, airfoilrad, pitch; numnodes=100, importantrads=[], notes="This is a turbine.", verbose=true)
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
    radsafid = nametonumber(radsafid) #.-1 #TODO: Why do a subtract one here? 
    # I was subtracting one to deal with the whole transition region thing, which isn't very general. So I need a general solution, then form to that. 

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
    afid = integerfit(rads, radsafid, locs)
    adprops = hcat(blrads, precone, sweep, preconeangle, twist, chords, afid)
    directory = ["BlSpn" "BlCrvAC" "BlSwpAC" "BlCrvAng" "BlTwist" "BlChord" "BlAFID"]

    adblade = ADBlade(directory, notes, n, adprops, blrads, precone, sweep,  preconeangle, twist, chords, afid) #Maybe remove adprops from this struct

    # Find the nodes of the important idxs
    nodeidxs = []
    for i = 1:length(locs)
        if in(locs[i], importantrads)
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
    - pitch - The value that the tip of the blade is pitched (assuming pitch is constant throughout the analysis) (degrees)
    - importantrads - radial distances that the user would like to insure a node is placed. (meters)
    - notes - notes that the user would like placed at the top of the blade file.
    - verbose - boolean that marks whether to make statements about creating the blade.
    
    ### Outputs
    - adblade - an adblade struct
    - importantnodes - the node numbers of the important radi that the user declared. 
    
    ### Notes
    - Note that this function does not place nodes in the transition region between the cylinder and the airfoils. It also does not interpolate the airfoils between nodes, but uses an integer fit to populate the airfoil id in the blade file. 
    
    ### Definitions 
    Below is a short list of the naming convention used in this function.
    - radius (rads) - distance from the center of rotation
    - fractions (fracs) - percentage of total blade radius
    - blade radius (blrads) - distance from the hub (distance of blade length not   including the hub)
    - blade fraction (blfrac) - percentage of blade radius
"""
function CreateAD15Blade(props, tiprad, hubrad, cylinderrad, airfoilrad, pitch; importantrads = [], notes = "This is a turbine.", verbose=true)

    return CreateAD15Blade(props[:,1], props[:,2], props[:,3], props[:,4], props[:,5], props[:,6], props[:,7], tiprad, hubrad, cylinderrad, airfoilrad, pitch; importantrads = [], notes = "This is a turbine.", verbose=false)
end

"""
    CreateAirfoilInput(Polar, Re, NumCoords; InterpOrd="Default", NonDimArea=1)

Creates an Airfoil Input file object. 

### Inputs
- Polar::Array{Float64, 2} - nx4 array of the airfoil coefficients in order of aoa, cl, cd, cm
- Re::Float64 - Reynolds number of the airfoil polar
- NumCoords::String - file containing the coordinate file ("@\"s809_coords.dat\"")
"""
function CreateAirfoilInput(Polar, Re, NumCoords; InterpOrd="Default", NonDimArea=1)
    BL_file = "ununsed"
    NumTabs = 1
    UserProp = 0
    InclUAdata = "false"
    alpha0 = 0
    alpha1 = 0
    alpha2 = 0
    eta_e = 0
    C_nalpha = 0
    T_f0 = 0
    T_V0 = 0
    T_p = 0
    T_VL = 0
    b1 = 0
    b2 = 0
    b5 = 0
    A1 = 0
    A2 = 0
    A5 = 0
    S1 = 0
    S2 = 0
    S3 = 0
    S4 = 0
    Cn1 = 0
    Cn2 = 0
    St_sh = 0
    Cd0 = 0
    Cm0 = 0
    k0 = 0
    k1 = 0
    k2 = 0
    k3 = 0
    k1_hat = 0
    x_cp_bar = 0
    UACutout="Default"
    filtCutOff="Default"
    NumAlf, n = size(Polar)
    return AirfoilInput(InterpOrd, NonDimArea, NumCoords, BL_file, NumTabs, Re, UserProp, InclUAdata, alpha0, alpha1, alpha2, eta_e, C_nalpha, T_f0, T_V0, T_p, T_VL, b1, b2, b5, A1, A2, A5, S1, S2, S3, S4, Cn1, Cn2, St_sh, Cd0, Cm0, k0, k1, k2, k3, k1_hat, x_cp_bar, UACutout, filtCutOff, NumAlf, Polar)
end