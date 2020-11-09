
 """
 ReadOutput(filename, filepath)

    ReadOutput reads the .out file from OpenFASt and parses it into a dictionary.
    A dictionary was chosen because the out file can have a lot of different
    outputs, and it was easier to program a reactive function rather than a predictive
    one.
    filename - String of the .out file to be read
    filepath - String of the path to the .out file.
    # Returns
    outputs - a dictionary of all of the arrays within the .out file

"""

function ReadOutput(filename, filepath)
    #Read in the file
    cd(filepath)
    fi = open(filename, "r")
    lines = readlines(fi)
    close(fi)

    #Find the first row
    line = lines[1]
    lines = String[]
    idx = findfirst('(',line)
    push!(lines,line[1:idx-1])

    #Find the number of columns
    m = numcolumns(lines[1])
    # println("number of columns: ", m)
    #Seperate out the rows
    rows = seprows(line, m)
    # println("rows: ")
    for i = 1:length(rows)
        # println(rows[i])
    end

    #Remove tabs and spaces in the numerical part of the matrix
    for i = 3:length(rows)
        rows[i]=rmspaces(rows[i])
    end

    #Convert the matrix to numbers
    matrix = readmatrix(rows[3:end])

    #Create output directory
    namesvec = parsenames(rows[1])
    # println("namesvec: ", namesvec)
    outputs = Dict()
    for i = 1:length(namesvec)
        outputs[namesvec[i]]=matrix[:,i]
    end
    return outputs
end

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
idx = 50+NumAFfiles
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
TwOutNd = readvector(lines[62+idx],NTwOuts)
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
    Cd_min = parse(Float64,lines[14][1:firstletter(lines[14])-1])

    for i = 15:length(lines)
        lines[i] = rmspaces(lines[i])
    end
    Polars = readmatrix(lines[15:end], 4)

    aerodata = Aerodata(Notes1, Notes2, NumAirfoils, TableID, Aoa_stall, z1, z2, z3,
            Aoa_0Cn, dCn_0L, Cn_stall_positive, Cn_stall_negative, Aoa_0Cn, Cd_min, Polars)
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
    NonDimArea = parse(Int,lines[2][1:14])
    NumCoords = fetchword15(lines[3], lengthofword=26)
    NumTabs = parse(Int,lines[4][1:14])
    Re = parse(Float64,lines[5][1:14])
    UserProp = parse(Int,lines[6][1:14])
    InclUAdata = fetchword15(lines[7])
    alpha0 = parse(Float64,lines[8][1:14])
    alpha1 = parse(Float64,lines[9][1:14])
    alpha2 = parse(Float64,lines[10][1:14])
    eta_e = parse(Float64,lines[11][1:14])
    C_nalpha = parse(Float64,lines[12][1:14])
    T_f0 = parse(Float64,lines[13][1:14])
    T_V0 = parse(Float64,lines[14][1:14])
    T_p = parse(Float64,lines[15][1:14])
    T_VL = parse(Float64,lines[16][1:14])
    b1 = parse(Float64,lines[17][1:14])
    b2 = parse(Float64,lines[18][1:14])
    b5 = parse(Float64,lines[19][1:14])
    A1 = parse(Float64,lines[20][1:14])
    A2 = parse(Float64,lines[21][1:14])
    A5 = parse(Float64,lines[22][1:14])
    S1 = parse(Float64,lines[23][1:14])
    S2 = parse(Float64,lines[24][1:14])
    S3 = parse(Float64,lines[25][1:14])
    S4 = parse(Float64,lines[26][1:14])
    Cn1 = parse(Float64,lines[27][1:14])
    Cn2 = parse(Float64,lines[28][1:14])
    St_sh = parse(Float64,lines[29][1:14])
    Cd0 = parse(Float64,lines[30][1:14])
    Cm0 = parse(Float64,lines[31][1:14])
    k0 = parse(Float64,lines[32][1:14])
    k1 = parse(Float64,lines[33][1:14])
    k2 = parse(Float64,lines[34][1:14])
    k3 = parse(Float64,lines[35][1:14])
    k1_hat = parse(Float64,lines[36][1:14])
    x_cp_bar = parse(Float64,lines[37][1:14])
    UACutout = fetchword15(lines[38])
    filtCutOff = fetchword15(lines[39])
    NumAlf = parse(Int,lines[40][1:14])

    for i = 41:length(lines)
        lines[i] = rmspaces(lines[i])
    end
    Polar = readmatrix(lines[41:end],4) #This is having troubles reading the lines that have a different number of characters per entry. say 180.0 and 80.0/ 

    airfoilinput = AirfoilInput(InterpOrd, NonDimArea, NumCoords, NumTabs, Re, UserProp,
            InclUAdata, alpha0, alpha1, alpha2, eta_e, C_nalpha, T_f0, T_V0, T_p, T_VL, b1,
            b2, b5, A1, A2, A5, S1, S2, S3, S4, Cn1, Cn2, St_sh, Cd0, Cm0, k0, k1, k2, k3,
            k1_hat, x_cp_bar, UACutout, filtCutOff, NumAlf, Polar)
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
ReadEDFile(filename, filepath)
This function reads in a ElastoDyn input file and stores the values in an ED structure.
"""

function ReadEDFile(filename, filepath)
    cd(filepath)
    fi = open(filename, "r")
    lines = readlines(fi)
    close(fi)

    directory = ["Title", "Notes", "Simulation Control", "Echo", "Integration Method",
    "DT", "Gravity", "FlapDOF1", "FlapDOF2", "EdgeDOF", "TeetDOF", "DrTrDOF", "GenDOF",
    "YawDOF", "TwFADOF1", "TwFADOF2", "TwSSDOF1", "TwSSDOF2", "PtfmSgDOF", "PtfmSwDOF",
    "PtfmHvDOF", "PtfmRDOF", "PtfmPDOF", "PtfmYDOF", "Initial Conditions", "ooFDefl",
    "IPDefl", "BlPitch(1)", "BlPitch(2)", "BlPitch(3)", "TeetDefl", "Azimuth", "RotSpeed",
    "NacYaw", "TTDspFA", "TTDspSS", "PtfmSurge", "PtfmSway", "PtfmHeave", "PtfmRoll",
    "PtfmPitch", "PtfmYaw", "Turbine Configuration", "NumBl", "TipRad", "HubRad", "PreCone(1)",
    "PreCone(2)", "PreCone(3)", "HubCM", "UndSling", "Delta3", "AximB1UP", "OverHang",
    "ShftGagL", "ShftTilt", "NacCMxn", "NacCMyn", "NacCMzn", "NcIMUxn", "NcIMUyn", "NcIMUzn",
    "Twr2Shft", "TowerHt", "TowerBsHt", "PtfmCMxt", "PtfmCMyt", "PtfmCMzt", "PtfmRefzt",
    "Mass and Inertia", "TipMass(1)", "TipMass(2)", "TipMass(3)", "HubMass", "HubIner",
    "GenIner", "NacMass", "NacYIner", "YawBrMass", "PtfmMass", "PtfmRIner", "PtfmPIner",
    "PtfmYIner", "Blade", "BldNodes", "BldFile(1)", "BldFile(2)", "BldFile(3)", "Rotor-Teeter",
    "TeetMod", "TeetDmpP", "TeetDmp", "TeetCDmp", "TeetSStP", "TeetHStP", "TeetSSSp", "TeetHSSp",
    "Drivetrain", "GBoxEff", "GBRatio", "DTTorSpr", "DTTorDmp", "Furling Title", "Furling", "FurlFile",
    "Tower", "TwrNodes", "TwrFile", "Output", "SumPrint", "OutFile", "TabDelim", "OutFmt",
    "TStart", "DecFact", "NTwGages", "TwrGagNd", "NBlGages", "BldGagNd", "Outlist"]

    #Line 1 is the main title
    Notes = lines[2]
    #line 3 is a general title
    Echo = fetchword15(lines[4])
    Method = parse(Int, lines[5][1:14])
    DT = fetchword15(lines[6])
    #line 7 is a general title
    Gravity = parse(Float64, lines[8][1:14])
    #line 9 is a general title
    FlapDOF1 = fetchword15(lines[10]) ######## Fix lines starting here
    FlapDOF2 = fetchword15(lines[11])
    EdgeDOF = fetchword15(lines[12])
    TeetDOF = fetchword15(lines[13])
    DrTrDOF = fetchword15(lines[14])
    GenDOF = fetchword15(lines[15])
    YawDOF = fetchword15(lines[16])
    TwFADOF1 = fetchword15(lines[17])
    TwFADOF2 = fetchword15(lines[18])
    TwSSDOF1 = fetchword15(lines[19])
    TwSSDOF2 = fetchword15(lines[20])
    PtfmSgDOF = fetchword15(lines[21])
    PtfmSwDOF = fetchword15(lines[22])
    PtfmHvDOF = fetchword15(lines[23])
    PtfmRDOF = fetchword15(lines[24])
    PtfmPDOF = fetchword15(lines[25])
    PtfmYDOF = fetchword15(lines[26])
    #line 27 is a general title
    OoPDefl = parse(Float64, lines[28][1:14])
    IPDefl = parse(Float64, lines[29][1:14])
    BlPitch1 = parse(Float64, lines[30][1:14])
    BlPitch2 = parse(Float64, lines[31][1:14])
    BlPitch3 = parse(Float64, lines[32][1:14])
    TeetDefl = parse(Float64, lines[33][1:14])
    Azimuth = parse(Float64, lines[34][1:14])
    RotSpeed = parse(Float64, lines[35][1:14])
    NacYaw = parse(Float64, lines[36][1:14])
    TTDspFA = parse(Float64, lines[37][1:14])
    TTDspSS = parse(Float64, lines[38][1:14])
    PtfmSurge = parse(Float64, lines[39][1:14])
    PtfmSway = parse(Float64, lines[40][1:14])
    PtfmHeave = parse(Float64, lines[41][1:14])
    PtfmRoll = parse(Float64, lines[42][1:14])
    PtfmPitch = parse(Float64, lines[43][1:14])
    PtfmYaw = parse(Float64, lines[44][1:14])
    #Line 45 is a general title
    NumBl = parse(Int, lines[46][1:14])
    TipRad = parse(Float64, lines[47][1:14])
    HubRad = parse(Float64, lines[48][1:14])
    PreCone1 = parse(Float64, lines[49][1:14])
    PreCone2 = parse(Float64, lines[50][1:14])
    PreCone3 = parse(Float64, lines[51][1:14])
    HubCM = parse(Float64, lines[52][1:14])
    UndSling = parse(Float64, lines[53][1:14])
    Delta3 = parse(Float64, lines[54][1:14])
    AzimB1Up = parse(Float64, lines[55][1:14])
    OverHang = parse(Float64, lines[56][1:14])
    ShftGagL = parse(Float64, lines[57][1:14])
    ShftTilt = parse(Float64, lines[58][1:14])
    NacCMxn = parse(Float64, lines[59][1:14])
    NacCMyn = parse(Float64, lines[60][1:14])
    NacCMzn = parse(Float64, lines[61][1:14])
    NcIMUxn = parse(Float64, lines[62][1:14])
    NcIMUyn = parse(Float64, lines[63][1:14])
    NcIMUzn = parse(Float64, lines[64][1:14])
    Twr2Shft = parse(Float64, lines[65][1:14])
    TowerHt = parse(Float64, lines[66][1:14])
    TowerBsHt = parse(Float64, lines[67][1:14])
    PtfmCMxt = parse(Float64, lines[68][1:14])
    PtfmCMyt = parse(Float64, lines[69][1:14])
    PtfmCMzt = parse(Float64, lines[70][1:14])
    PtfmRefzt = parse(Float64, lines[71][1:14])
    #Line 72 is a general title
    TipMass1 = parse(Float64, lines[73][1:14])
    TipMass2 = parse(Float64, lines[74][1:14])
    TipMass3 = parse(Float64, lines[75][1:14])
    HubMass = parse(Float64, lines[76][1:14])
    HubIner = parse(Float64, lines[77][1:14])
    GenIner = parse(Float64, lines[78][1:14])
    NacMass = parse(Float64, lines[79][1:14])
    NacYIner = parse(Float64, lines[80][1:14])
    YawBrMass = parse(Float64, lines[81][1:14])
    PtfmMass = parse(Float64, lines[82][1:14])
    PtfmRIner = parse(Float64, lines[83][1:14])
    PtfmPIner = parse(Float64, lines[84][1:14])
    PtfmYIner = parse(Float64, lines[85][1:14])
    #Line 86 is a general title
    BldNodes = parse(Int, lines[87][1:14])
    BldFile1 = fetchword15(lines[88];lengthofword=35)
    BldFile2 = fetchword15(lines[89];lengthofword=35)
    BldFile3 = fetchword15(lines[90];lengthofword=35)
    #Line 91 is a general title
    TeetMod = parse(Int, lines[92][1:14])
    TeetDmpP = parse(Float64, lines[93][1:14])
    TeetDmp = parse(Float64, lines[94][1:14])
    TeetCDmp = parse(Float64, lines[95][1:14])
    TeetSStP = parse(Float64, lines[96][1:14])
    TeetHStP = parse(Float64, lines[97][1:14])
    TeetSSSp = parse(Float64, lines[98][1:14])
    TeetHSSp = parse(Float64, lines[99][1:14])
    #Line 100 is a general title
    GBoxEff = parse(Float64, lines[101][1:14])
    GBRatio = parse(Float64, lines[102][1:14])
    DTTorSpr = parse(Float64, lines[103][1:14])
    DTTorDmp = parse(Float64, lines[104][1:14])
    #Line 105 is a general title
    Furling = fetchword15(lines[106])
    FurlFile = fetchword15(lines[107];lengthofword=30)
    #Line 108 is a general title
    TwrNodes = parse(Int, lines[109][1:14])
    TwrFile = fetchword15(lines[110];lengthofword=30)
    #line 111 is a general title
    SumPrint = fetchword15(lines[112])
    OutFile = parse(Int, lines[113][1:14])
    TabDelim = fetchword15(lines[114])
    OutFmt = fetchword15(lines[115])
    TStart = parse(Float64, lines[116][1:14])
    DecFact = parse(Int, lines[117][1:14])
    NTwGages = parse(Int, lines[118][1:14])
    TwrGagNd = readvector(lines[119], NTwGages)
    NBlGages = parse(Int, lines[120][1:14])
    BldGagNd = readvector(lines[121], NBlGages)
    #Line 122 is the outlist parameter
    Outlist = readoutlist(lines[123:end])

    file = EDFile(directory, Notes, Echo, Method, DT, Gravity, FlapDOF1, FlapDOF2,
            EdgeDOF, TeetDOF, DrTrDOF, GenDOF, YawDOF, TwFADOF1, TwFADOF2, TwSSDOF1,
            TwSSDOF2, PtfmSgDOF, PtfmSwDOF, PtfmHvDOF, PtfmRDOF, PtfmPDOF, PtfmYDOF,
            OoPDefl, IPDefl, BlPitch1, BlPitch2, BlPitch3, TeetDefl, Azimuth, RotSpeed,
            NacYaw, TTDspFA, TTDspSS, PtfmSurge, PtfmSway, PtfmHeave, PtfmRoll, PtfmPitch,
            PtfmYaw, NumBl, TipRad, HubRad, PreCone1, PreCone2, PreCone3, HubCM, UndSling,
            Delta3, AzimB1Up, OverHang, ShftGagL, ShftTilt, NacCMxn, NacCMyn, NacCMzn,
            NcIMUxn, NcIMUyn, NcIMUzn, Twr2Shft, TowerHt, TowerBsHt, PtfmCMxt, PtfmCMyt,
            PtfmCMzt, PtfmRefzt, TipMass1, TipMass2, TipMass3, HubMass, HubIner, GenIner,
            NacMass, NacYIner, YawBrMass, PtfmMass, PtfmRIner, PtfmPIner, PtfmYIner,
            BldNodes, BldFile1, BldFile2, BldFile3, TeetMod, TeetDmpP, TeetDmp, TeetCDmp,
            TeetSStP, TeetHStP, TeetSSSp, TeetHSSp, GBoxEff, GBRatio, DTTorSpr, DTTorDmp,
            Furling, FurlFile, TwrNodes, TwrFile, SumPrint, OutFile, TabDelim, OutFmt,
            TStart, DecFact, NTwGages, TwrGagNd, NBlGages, BldGagNd, Outlist)
    return file
end

function ReadEDBlade(filename, filepath)
    cd(filepath)
    fi = open(filename, "r")
    lines = readlines(fi)
    close(fi)

    Directory = ["Title", "Notes", "Blade Parameters", "NBlInpSt", "BldFlDmp(1)", "BldFlDmp(2)",
                    "BldEdDmp(1)", "Blade Adjustment Factors", "FlStTunr(1)", "FlStTunr(2)",
                    "AdjBlMs", "AdjFlSt", "AdjEdSt", "Distributed Blade Properties", "BldProps",
                    "BldFl1Sh2", "BldFl1Sh3", "BldFl1Sh4", "BldFl1Sh5", "BldFl1Sh6", "BldFl2Sh2",
                    "BldFl2Sh3", "BldFl2Sh4", "BldFl2Sh5", "BldFl2Sh6", "BldEdgSh2", "BldEdgSh3",
                    "BldEdgSh4", "BldEdgSh5", "BldEdgSh6"]

    Notes = lines[2]
    #Line 3 is a general title
    NBlInpSt = parse(Int, lines[4][1:14])
    BldFlDmp1 = parse(Float64, lines[5][1:14])
    BldFlDmp2 = parse(Float64, lines[6][1:14])
    BldEdDmp1 = parse(Float64, lines[7][1:14])
    #Line 8 is a general title
    FlStTunr1 = parse(Float64, lines[9][1:14])
    FlStTunr2 = parse(Float64, lines[10][1:14])
    AdjBlMs = parse(Float64, lines[11][1:14])
    AdjFlSt = parse(Float64, lines[12][1:14])
    AdjEdSt = parse(Float64, lines[13][1:14])
    #Lines 14-16 are general titles
    BldProps = fetchmatrix(lines[17:16+NBlInpSt], 88, 6)
    #Line 17+NBlInpSt is a general title
    BldFl1Sh2 = parse(Float64, lines[18+NBlInpSt][1:14])
    BldFl1Sh3 = parse(Float64, lines[19+NBlInpSt][1:14])
    BldFl1Sh4 = parse(Float64, lines[20+NBlInpSt][1:14])
    BldFl1Sh5 = parse(Float64, lines[21+NBlInpSt][1:14])
    BldFl1Sh6 = parse(Float64, lines[22+NBlInpSt][1:14])
    BldFl2Sh2 = parse(Float64, lines[23+NBlInpSt][1:14])
    BldFl2Sh3 = parse(Float64, lines[24+NBlInpSt][1:14])
    BldFl2Sh4 = parse(Float64, lines[25+NBlInpSt][1:14])
    BldFl2Sh5 = parse(Float64, lines[26+NBlInpSt][1:14])
    BldFl2Sh6 = parse(Float64, lines[27+NBlInpSt][1:14])
    BldEdgSh2 = parse(Float64, lines[28+NBlInpSt][1:14])
    BldEdgSh3 = parse(Float64, lines[29+NBlInpSt][1:14])
    BldEdgSh4 = parse(Float64, lines[30+NBlInpSt][1:14])
    BldEdgSh5 = parse(Float64, lines[31+NBlInpSt][1:14])
    BldEdgSh6 = parse(Float64, lines[32+NBlInpSt][1:14])


    edblade = EDBlade(Directory, Notes, NBlInpSt, BldFlDmp1, BldFlDmp2, BldEdDmp1,
                FlStTunr1, FlStTunr2, AdjBlMs, AdjFlSt, AdjEdSt, BldProps,
                BldFl1Sh2, BldFl1Sh3, BldFl1Sh4, BldFl1Sh5, BldFl1Sh6, BldFl2Sh2,
                BldFl2Sh3, BldFl2Sh4, BldFl2Sh5, BldFl2Sh6, BldEdgSh2, BldEdgSh3,
                BldEdgSh4, BldEdgSh5, BldEdgSh6)
    return edblade
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
    BldProps = readmatrix(lines[7:6+NumBlNds], 7)
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
