##############################################################
##################     STRUCTURES     ########################
##############################################################

mutable struct EDFile
    Directory::Array{String}
    Notes::String
    Echo::String
    Method::Int
    DT
    Gravity::Float64
    FlapDOF1::String
    FlapDOF2::String
    EdgeDOF::String
    TeetDOF::String
    DrTrDOF::String
    GenDOF::String
    YawDOF::String
    TwFADOF1::String
    TwFADOF2::String
    TwSSDOF1::String
    TwSSDOF2::String
    PtfmSgDOF::String
    PtfmSwDOF::String
    PtfmHvDOF::String
    PtfmRDOF::String
    PtfmPDOF::String
    PtfmYDOF::String
    OoPDefl::Float64
    IPDefl::Float64
    BlPitch1::Float64
    BlPitch2::Float64
    BlPitch3::Float64
    TeetDefl::Float64
    Azimuth::Float64
    RotSpeed::Float64
    NacYaw::Float64
    TTDspFA::Float64
    TTDspSS::Float64
    PtfmSurge::Float64
    PtfmSway::Float64
    PtfmHeave::Float64
    PtfmRoll::Float64
    PtfmPitch::Float64
    PtfmYaw::Float64
    NumBl::Int
    TipRad::Float64
    HubRad::Float64
    PreCone1::Float64
    PreCone2::Float64
    PreCone3::Float64
    HubCM::Float64
    UndSling::Float64
    Delta3::Float64
    AzimB1Up::Float64
    OverHang::Float64
    ShftGagL::Float64
    ShftTilt::Float64
    NacCMxn::Float64
    NacCMyn::Float64
    NacCMzn::Float64
    NcIMUxn::Float64
    NcIMUyn::Float64
    NcIMUzn::Float64
    Twr2Shft::Float64
    TowerHt::Float64
    TowerBsHt::Float64
    PtfmCMxt::Float64
    PtfmCMyt::Float64
    PtfmCMzt::Float64
    PtfmRefzt::Float64
    TipMass1::Float64
    TipMass2::Float64
    TipMass3::Float64
    HubMass::Float64
    HubIner::Float64
    GenIner::Float64
    NacMass::Float64
    NacYIner::Float64
    YawBrMass::Float64
    PtfmMass::Float64
    PtfmRIner::Float64
    PtfmPIner::Float64
    PtfmYIner::Float64
    BldNodes::Int
    BldFile1::String
    BldFile2::String
    BldFile3::String
    TeetMod::Int
    TeetDmpP::Float64
    TeetDmp::Float64
    TeetCDmp::Float64
    TeetSStP::Float64
    TeetHStP::Float64
    TeetSSSp::Float64
    TeetHSSp::Float64
    GBoxEff::Float64
    GBRatio::Float64
    DTTorSpr::Float64
    DTTorDmp::Float64
    Furling::String
    FurlFile::String
    TwrNodes::Int
    TwrFile::String
    SumPrint::String
    OutFile::Int
    TabDelim::String
    OutFmt::String
    TStart::Float64
    DecFact::Int
    NTwGages::Int
    TwrGagNd::Array{Int}
    NBlGages::Int
    BldGagNd::Array{Int}
    Outlist::Array{String}
    BldNd_BladesOut::Int
    BldNd_BlOutNd::Array{Int}
    NodeOutlist::Array{String}
end

mutable struct EDBlade
    Directory
    Notes
    NBlInpSt
    BldFlDmp1
    BldFlDmp2
    BldEdDmp1
    FlStTunr1
    FlStTunr2
    AdjBlMs
    AdjFlSt
    AdjEdSt
    BldProps
    BldFl1Sh2
    BldFl1Sh3
    BldFl1Sh4
    BldFl1Sh5
    BldFl1Sh6
    BldFl2Sh2
    BldFl2Sh3
    BldFl2Sh4
    BldFl2Sh5
    BldFl2Sh6
    BldEdgSh2
    BldEdgSh3
    BldEdgSh4
    BldEdgSh5
    BldEdgSh6
end

##############################################################
################## READING FUNCTIONS #########################
##############################################################

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
    DT = fetchword15(lines[6]) ### TODO: This can be an float as well. 
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
            TStart, DecFact, NTwGages, TwrGagNd, NBlGages, BldGagNd, Outlist, BldNd_BladesOut, BldNd_BlOutNd, NodeOutlist)
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



##############################################################
################## WRITING FUNCTIONS #########################
##############################################################

"""
WriteEDFile(edfile, outputfile)

    This function takes an ElastoDyn structure and writes it to file.
"""
function WriteEDFile(edfile, outputfile)
    lines = String[]
    line = string("-"^7, " ELASTODYN v1.03.* INPUT FILE ", "-"^43)
    push!(lines, line)
    line = edfile.Notes
    push!(lines, line)
    line = string("-"^22, " SIMULATION CONTROL ", "-"^38)
    push!(lines, line)
    line = string(formatword(edfile.Echo;quotes=false),"   Echo        - Echo input data to \"<RootName>.ech\" (flag)")
    push!(lines, line)
    line = string(formatword(string(edfile.Method);location="back",quotes=false), "   Method      - Integration method: {1: RK4, 2: AB4, or 3: ABM4} (-)")
    push!(lines, line)
    line = string(formatword(edfile.DT;quotes=false),"   DT          - Integration time step (s)")
    push!(lines, line)
    line = string("-"^22, " ENVIRONMENTAL CONDITION ", "-"^33)
    push!(lines, line)
    line = string(formatword(string(edfile.Gravity);location="back",quotes=false),"   Gravity     - Gravitational acceleration (m/s^2)")
    push!(lines, line)
    line = string("-"^22, " DEGREES OF FREEDOM ", "-"^38)
    push!(lines, line)
    line = string(formatword(edfile.FlapDOF1;quotes=false),"   FlapDOF1    - First flapwise blade mode DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.FlapDOF2;quotes=false), "   FlapDOF2    - Second flapwise blade mode DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.EdgeDOF;quotes=false), "   EdgeDOF     - First edgewise blade mode DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.TeetDOF;quotes=false), "   TeetDOF     - Rotor-teeter DOF (flag) [unused for 3 blades]")
    push!(lines, line)
    line = string(formatword(edfile.DrTrDOF;quotes=false), "   DrTrDOF     - Drivetrain rotational-flexibility DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.GenDOF;quotes=false), "   GenDOF      - Generator DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.YawDOF;quotes=false), "   YawDOF      - Yaw DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.TwFADOF1;quotes=false), "   TwFADOF1    - First fore-aft tower bending-mode DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.TwFADOF2;quotes=false), "   TwFADOF2    - Second fore-aft tower bending-mode DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.TwSSDOF1;quotes=false), "   TwSSDOF1    - First side-to-side tower bending-mode DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.TwSSDOF2;quotes=false), "   TwSSDOF2    - Second side-to-side tower bending-mode DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.PtfmSgDOF;quotes=false), "   PtfmSgDOF   - Platform horizontal surge translation DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.PtfmSwDOF;quotes=false), "   PtfmSwDOF   - Platform horizontal sway translation DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.PtfmHvDOF;quotes=false), "   PtfmHvDOF   - Platform vertical heave translation DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.PtfmRDOF;quotes=false), "   PtfmRDOF    - Platform roll tilt rotation DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.PtfmPDOF;quotes=false), "   PtfmPDOF    - Platform pitch tilt rotation DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.PtfmYDOF;quotes=false), "   PtfmYDOF    - Platform yaw rotation DOF (flag)")
    push!(lines, line)
    line = string("-"^22, " INITIAL CONDITIONS ", "-"^38)
    push!(lines, line)
    line = string(formatword(string(edfile.OoPDefl);location="back",quotes=false),"   OoPDefl     - Initial out-of-plane blade-tip displacement (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.IPDefl);location="back",quotes=false),"   IPDefl      - Initial in-plane blade-tip deflection (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.BlPitch1);location="back",quotes=false),"   BlPitch(1)  - Blade 1 initial pitch (degrees)")
    push!(lines, line)
    line = string(formatword(string(edfile.BlPitch2);location="back",quotes=false),"   BlPitch(2)  - Blade 2 initial pitch (degrees)")
    push!(lines, line)
    line = string(formatword(string(edfile.BlPitch3);location="back",quotes=false),"   BlPitch(3)  - Blade 3 initial pitch (degrees) [unused for 2 blades]")
    push!(lines, line)
    line = string(formatword(string(edfile.TeetDefl);location="back",quotes=false),"   TeetDefl    - Initial or fixed teeter angle (degrees) [unused for 3 blades]")
    push!(lines, line)
    line = string(formatword(string(edfile.Azimuth);location="back",quotes=false),"   Azimuth     - Initial azimuth angle for blade 1 (degrees)")
    push!(lines, line)
    line = string(formatword(string(edfile.RotSpeed);location="back",quotes=false),"   RotSpeed    - Initial or fixed rotor speed (rpm)")
    push!(lines, line)
    line = string(formatword(string(edfile.NacYaw);location="back",quotes=false),"   NacYaw      - Initial or fixed nacelle-yaw angle (degrees)")
    push!(lines, line)
    line = string(formatword(string(edfile.TTDspFA);location="back",quotes=false),"   TTDspFA     - Initial fore-aft tower-top displacement (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.TTDspSS);location="back",quotes=false),"   TTDspSS     - Initial side-to-side tower-top displacement (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmSurge);location="back",quotes=false),"   PtfmSurge   - Initial or fixed horizontal surge translational displacement of platform (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmSway);location="back",quotes=false),"   PtfmSway    - Initial or fixed horizontal sway translational displacement of platform (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmHeave);location="back",quotes=false),"   PtfmHeave   - Initial or fixed vertical heave translational displacement of platform (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmRoll);location="back",quotes=false),"   PtfmRoll    - Initial or fixed roll tilt rotational displacement of platform (degrees)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmPitch);location="back",quotes=false),"   PtfmPitch   - Initial or fixed pitch tilt rotational displacement of platform (degrees)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmYaw);location="back",quotes=false),"   PtfmYaw     - Initial or fixed yaw rotational displacement of platform (degrees)")
    push!(lines, line)
    line = string("-"^22, " TURBINE CONFIGURATION ", "-"^35)
    push!(lines, line)
    line = string(formatword(string(edfile.NumBl);location="back",quotes=false),"   NumBl       - Number of blades (-)")
    push!(lines, line)
    line = string(formatword(string(edfile.TipRad);location="back",quotes=false),"   TipRad      - The distance from the rotor apex to the blade tip (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.HubRad);location="back",quotes=false),"   HubRad      - The distance from the rotor apex to the blade root (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.PreCone1);location="back",quotes=false),"   PreCone(1)  - Blade 1 cone angle (degrees)")
    push!(lines, line)
    line = string(formatword(string(edfile.PreCone2);location="back",quotes=false),"   PreCone(2)  - Blade 2 cone angle (degrees)")
    push!(lines, line)
    line = string(formatword(string(edfile.PreCone3);location="back",quotes=false),"   PreCone(3)  - Blade 3 cone angle (degrees) [unused for 2 blades]")
    push!(lines, line)
    line = string(formatword(string(edfile.HubCM);location="back",quotes=false),"   HubCM       - Distance from rotor apex to hub mass [positive downwind] (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.UndSling);location="back",quotes=false),"   UndSling    - Undersling length [distance from teeter pin to the rotor apex] (meters) [unused for 3 blades]")
    push!(lines, line)
    line = string(formatword(string(edfile.Delta3);location="back",quotes=false),"   Delta3      - Delta-3 angle for teetering rotors (degrees) [unused for 3 blades]")
    push!(lines, line)
    line = string(formatword(string(edfile.AzimB1Up);location="back",quotes=false),"   AzimB1Up    - Azimuth value to use for I/O when blade 1 points up (degrees)")
    push!(lines, line)
    line = string(formatword(string(edfile.OverHang);location="back",quotes=false),"   OverHang    - Distance from yaw axis to rotor apex [3 blades] or teeter pin [2 blades] (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.ShftGagL);location="back",quotes=false),"   ShftGagL    - Distance from rotor apex [3 blades] or teeter pin [2 blades] to shaft strain gages [positive for upwind rotors] (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.ShftTilt);location="back",quotes=false),"   ShftTilt    - Rotor shaft tilt angle (degrees)")
    push!(lines, line)
    line = string(formatword(string(edfile.NacCMxn);location="back",quotes=false),"   NacCMxn     - Downwind distance from the tower-top to the nacelle CM (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.NacCMyn);location="back",quotes=false),"   NacCMyn     - Lateral  distance from the tower-top to the nacelle CM (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.NacCMzn);location="back",quotes=false),"   NacCMzn     - Vertical distance from the tower-top to the nacelle CM (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.NcIMUxn);location="back",quotes=false),"   NcIMUxn     - Downwind distance from the tower-top to the nacelle IMU (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.NcIMUyn);location="back",quotes=false),"   NcIMUyn     - Lateral  distance from the tower-top to the nacelle IMU (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.NcIMUzn);location="back",quotes=false),"   NcIMUzn     - Vertical distance from the tower-top to the nacelle IMU (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.Twr2Shft);location="back",quotes=false),"   Twr2Shft    - Vertical distance from the tower-top to the rotor shaft (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.TowerHt);location="back",quotes=false),"   TowerHt     - Height of tower above ground level [onshore] or MSL [offshore] (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.TowerBsHt);location="back",quotes=false),"   TowerBsHt   - Height of tower base above ground level [onshore] or MSL [offshore] (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmCMxt);location="back",quotes=false),"   PtfmCMxt    - Downwind distance from the ground level [onshore] or MSL [offshore] to the platform CM (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmCMyt);location="back",quotes=false),"   PtfmCMyt    - Lateral distance from the ground level [onshore] or MSL [offshore] to the platform CM (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmCMzt);location="back",quotes=false),"   PtfmCMzt    - Vertical distance from the ground level [onshore] or MSL [offshore] to the platform CM (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmRefzt);location="back",quotes=false),"   PtfmRefzt   - Vertical distance from the ground level [onshore] or MSL [offshore] to the platform reference point (meters)")
    push!(lines, line)
    line = string("-"^22, " MASS AND INERTIA ", "-"^40)
    push!(lines, line)
    line = string(formatword(string(edfile.TipMass1);location="back",quotes=false),"   TipMass(1)  - Tip-brake mass, blade 1 (kg)")
    push!(lines, line)
    line = string(formatword(string(edfile.TipMass2);location="back",quotes=false),"   TipMass(2)  - Tip-brake mass, blade 2 (kg)")
    push!(lines, line)
    line = string(formatword(string(edfile.TipMass3);location="back",quotes=false),"   TipMass(3)  - Tip-brake mass, blade 3 (kg) [unused for 2 blades]")
    push!(lines, line)
    line = string(formatword(string(edfile.HubMass);location="back",quotes=false),"   HubMass     - Hub mass (kg)")
    push!(lines, line)
    line = string(formatword(string(edfile.HubIner);location="back",quotes=false),"   HubIner     - Hub inertia about rotor axis [3 blades] or teeter axis [2 blades] (kg m^2)")
    push!(lines, line)
    line = string(formatword(string(edfile.GenIner);location="back",quotes=false),"   GenIner     - Generator inertia about HSS (kg m^2)")
    push!(lines, line)
    line = string(formatword(string(edfile.NacMass);location="back",quotes=false),"   NacMass     - Nacelle mass (kg)")
    push!(lines, line)
    line = string(formatword(string(edfile.NacYIner);location="back",quotes=false),"   NacYIner    - Nacelle inertia about yaw axis (kg m^2)")
    push!(lines, line)
    line = string(formatword(string(edfile.YawBrMass);location="back",quotes=false),"   YawBrMass   - Yaw bearing mass (kg)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmMass);location="back",quotes=false),"   PtfmMass    - Platform mass (kg)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmRIner);location="back",quotes=false),"   PtfmRIner   - Platform inertia for roll tilt rotation about the platform CM (kg m^2)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmPIner);location="back",quotes=false),"   PtfmPIner   - Platform inertia for pitch tilt rotation about the platform CM (kg m^2)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmYIner);location="back",quotes=false),"   PtfmYIner   - Platform inertia for yaw rotation about the platform CM (kg m^2)")
    push!(lines, line)
    line = string("-"^22, " BLADE ", "-"^51)
    push!(lines, line)
    line = string(formatword(string(edfile.BldNodes);location="back",quotes=false),"   BldNodes    - Number of blade nodes (per blade) used for analysis (-)")
    push!(lines, line)
    line = string(formatword(edfile.BldFile1;quotes=false,desiredlength=35), "   BldFile(1)  - Name of file containing properties for blade 1 (quoted string)")
    push!(lines, line)
    line = string(formatword(edfile.BldFile2;quotes=false,desiredlength=35), "   BldFile(2)  - Name of file containing properties for blade 2 (quoted string)")
    push!(lines, line)
    line = string(formatword(edfile.BldFile3;quotes=false,desiredlength=35), "   BldFile(3)  - Name of file containing properties for blade 3 (quoted string) [unused for 2 blades]")
    push!(lines, line)
    line = string("_"^22, " ROTOR-TEETER ", "-"^44)
    push!(lines, line)
    line = string(formatword(string(edfile.TeetMod);location="back",quotes=false),"   TeetMod     - Rotor-teeter spring/damper model {0: none, 1: standard, 2: user-defined from routine UserTeet} (switch) [unused for 3 blades]")
    push!(lines, line)
    line = string(formatword(string(edfile.TeetDmpP);location="back",quotes=false),"   TeetDmpP    - Rotor-teeter damper position (degrees) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)
    line = string(formatword(string(edfile.TeetDmp);location="back",quotes=false),"   TeetDmp     - Rotor-teeter damping constant (N-m/(rad/s)) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)
    line = string(formatword(string(edfile.TeetCDmp);location="back",quotes=false),"   TeetCDmp    - Rotor-teeter rate-independent Coulomb-damping moment (N-m) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)
    line = string(formatword(string(edfile.TeetSStP);location="back",quotes=false),"   TeetSStP    - Rotor-teeter soft-stop position (degrees) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)
    line = string(formatword(string(edfile.TeetHStP);location="back",quotes=false),"   TeetHStP    - Rotor-teeter hard-stop position (degrees) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)
    line = string(formatword(string(edfile.TeetSSSp);location="back",quotes=false),"   TeetSSSp    - Rotor-teeter soft-stop linear-spring constant (N-m/rad) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)
    line = string(formatword(string(edfile.TeetHSSp);location="back",quotes=false),"   TeetHSSp    - Rotor-teeter hard-stop linear-spring constant (N-m/rad) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)
    line = string("-"^22, " DRIVETRAIN ", "-"^46)
    push!(lines, line)
    line = string(formatword(string(edfile.GBoxEff);location="back",quotes=false),"   GBoxEff     - Gearbox efficiency (%)")
    push!(lines, line)
    line = string(formatword(string(edfile.GBRatio);location="back",quotes=false),"   GBRatio     - Gearbox ratio (-)")
    push!(lines, line)
    line = string(formatword(string(edfile.DTTorSpr);location="back",quotes=false),"   DTTorSpr    - Drivetrain torsional spring (N-m/rad)")
    push!(lines, line)
    line = string(formatword(string(edfile.DTTorDmp);location="back",quotes=false),"   DTTorDmp    - Drivetrain torsional damper (N-m/(rad/s))")
    push!(lines, line)
    line = string("-"^22, " FURLING ", "-"^49)
    push!(lines, line)
    line = string(formatword(string(edfile.Furling);location="back",quotes=false),"   Furling     - Read in additional model properties for furling turbine (flag) [must currently be FALSE)")
    push!(lines, line)
    line = string(formatword(edfile.FurlFile;quotes=false,desiredlength=35),"   FurlFile    - Name of file containing furling properties (quoted string) [unused when Furling=False]")
    push!(lines, line)
    line = string("-"^22, " TOWER ", "-"^51)
    push!(lines,line)
    line = string(formatword(string(edfile.TwrNodes);location="back",quotes=false),"   TwrNodes    - Number of tower nodes used for analysis (-)")
    push!(lines, line)
    line = string(formatword(edfile.TwrFile;quotes=false,desiredlength=35),"   TwrFile     - Name of file containing tower properties (quoted string)")
    push!(lines, line)
    line = string("-"^22, " OUTPUT ", "-"^50)
    push!(lines, line)
    line = string(formatword(edfile.SumPrint;quotes=false), "   SumPrint    - Print summary data to \"<RootName>.sum\" (flag)")
    push!(lines, line)
    line = string(formatword(string(edfile.OutFile);location="back",quotes=false),"   OutFile     - Switch to determine where output will be placed: {1: in module output file only; 2: in glue code output file only; 3: both} (currently unused)")
    push!(lines, line)
    line = string(formatword(edfile.TabDelim;quotes=false), "  TabDelim    - Use tab delimiters in text tabular output file? (flag) (currently unused)")
    push!(lines, line)
    line = string(formatword(edfile.OutFmt;quotes=false), "   OutFmt      - Format used for text tabular output (except time).  Resulting field should be 10 characters. (quoted string) (currently unused)")
    push!(lines, line)
    line = string(formatword(string(edfile.TStart);location="back",quotes=false),"   TStart      - Time to begin tabular output (s) (currently unused)")
    push!(lines, line)
    line = string(formatword(string(edfile.DecFact);location="back",quotes=false),"   DecFact     - Decimation factor for tabular output {1: output every time step} (-) (currently unused)")
    push!(lines, line)
    line = string(formatword(string(edfile.NTwGages);location="back",quotes=false),"   NTwGages    - Number of tower nodes that have strain gages for output [0 to 9] (-)")
    push!(lines, line)
    if edfile.NTwGages>0
       line = formatvector(edfile.TwrGagNd)
    else
       line = " "^11
    end
    line = string(line, "   TwrGagNd    - List of tower nodes that have strain gages [1 to TwrNodes] (-) [unused if NTwGages=0]")
    push!(lines, line)
    line = string(formatword(string(edfile.NBlGages);location="back",quotes=false),"   NBlGages    - Number of blade nodes that have strain gages for output [0 to 9] (-)")
    push!(lines, line)
    if edfile.NBlGages>0
       line = formatvector(edfile.BldGagNd)
    else
       line = " "^11
    end
    line = string(line, "   BldGagNd    - List of blade nodes that have strain gages [1 to BldNodes] (-) [unused if NBlGages=0]")
    push!(lines, line)
    line = "              OutList     - The next line(s) contains a list of output parameters.  See OutListParameters.xlsx for a listing of available output channels, (-)"
    push!(lines, line)
    for i=1:length(edfile.Outlist)
       line = string("\"",edfile.Outlist[i],"\"")
       push!(lines,line)
    end
    line = "END of input file (the word \"END\" must appear in the first 3 columns of this last OutList line)"
    push!(lines, line)
    line = "---------------------- NODE OUTPUTS --------------------------------------------"
    push!(lines, line)
    line = string(formatword(string(edfile.BldNd_BladesOut);location="back",quotes=false), "   BldNd_BladesOut  - Blades to output")
    push!(lines, line)

    if edfile.BldNd_BladesOut>0
        line = formatvector(edfile.BldNd_BlOutNd)
    else
        line = " "^11
    end
     line = string(line, "   - Blade nodes on each blade (currently unused)")
     push!(lines, line)

     line = "                   OutList             - The next line(s) contains a list of output parameters.  See s for a listing of available output channels, (-)"

     push!(lines, line)
     for i=1:length(edfile.NodeOutlist)
        line = string("\"", edfile.NodeOutlist[i], "\"")
        push!(lines,line)
     end
     line = "END of input file (the word \"END\" must appear in the first 3 columns of this last OutList line)"

    #Write lines to file
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
WriteEDBlade(edblade, outputfile)

Takes an edblade structure and prints it to file.

"""
function WriteEDBlade(edblade, outputfile)
    lines = String[]
    line = string("-"^7, "  ELASTODYN V1.00.* INDIVIDUAL BLADE INPUT FILE  ", "-"^26)
    push!(lines, line)
    line = edblade.Notes
    push!(lines, line)
    line = string("-"^22, " BLADE PARAMETERS ", "-"^40)
    push!(lines, line)
    line = string(formatword(string(edblade.NBlInpSt);location="back", quotes=false),"   NBlInpSt    - Number of blade input stations (-)")
    push!(lines, line)
    line = string(formatword(string(edblade.BldFlDmp1);location="back", quotes=false),"   BldFlDmp(1) - Blade flap mode #1 structural damping in percent of critical (%)")
    push!(lines, line)
    line = string(formatword(string(edblade.BldFlDmp2);location="back", quotes=false),"   BldFlDmp(2) - Blade flap mode #2 structural damping in percent of critical (%)")
    push!(lines, line)
    line = string(formatword(string(edblade.BldEdDmp1);location="back", quotes=false),"   BldEdDmp(1) - Blade edge mode #1 structural damping in percent of critical (%)")
    push!(lines, line)
    line = string("-"^22, " BLADE ADJUSTMENT FACTORS ", "-"^32)
    push!(lines, line)
    line = string(formatword(string(edblade.FlStTunr1);location="back", quotes=false),"   FlStTunr(1) - Blade flapwise modal stiffness tuner, 1st mode (-)")
    push!(lines, line)
    line = string(formatword(string(edblade.FlStTunr2);location="back", quotes=false),"   FlStTunr(2) - Blade flapwise modal stiffness tuner, 2nd mode (-)")
    push!(lines, line)
    line = string(formatword(string(edblade.AdjBlMs);location="back", quotes=false),"   AdjBlMs     - Factor to adjust blade mass density (-)  !bjj: value for AD14=1.04536; value for AD15=1.057344 (it would be nice to enter the requested blade mass instead of a factor here)")
    push!(lines, line)
    line = string(formatword(string(edblade.AdjFlSt);location="back", quotes=false),"   AdjFlSt     - Factor to adjust blade flap stiffness (-)")
    push!(lines, line)
    line = string(formatword(string(edblade.AdjEdSt);location="back", quotes=false),"   AdjEdSt     - Factor to adjust blade edge stiffness (-)")
    push!(lines, line)
    line = string("-"^22, " DISTRIBUTED BLADE PROPERTIES ", "-"^28)
    push!(lines, line)
    line = "    BlFract      PitchAxis      StrcTwst       BMassDen        FlpStff        EdgStff"
    push!(lines, line)
    line = "      (-)           (-)          (deg)          (kg/m)         (Nm^2)         (Nm^2)"
    push!(lines, line)
    line = formatmatrix(edblade.BldProps)
    append!(lines, line)
    line = string("-"^22, " BLADE MODE SHAPES ", "-"^39)
    push!(lines, line)
    line = string(formatword(string(edblade.BldFl1Sh2);location="back", quotes=false),"   BldFl1Sh(2) - Flap mode 1, coeff of x^2")
    push!(lines, line)
    line = string(formatword(string(edblade.BldFl1Sh3);location="back", quotes=false),"   BldFl1Sh(3) -            , coeff of x^3")
    push!(lines, line)
    line = string(formatword(string(edblade.BldFl1Sh4);location="back", quotes=false),"   BldFl1Sh(4) -            , coeff of x^4")
    push!(lines, line)
    line = string(formatword(string(edblade.BldFl1Sh5);location="back", quotes=false),"   BldFl1Sh(5) -            , coeff of x^5")
    push!(lines, line)
    line = string(formatword(string(edblade.BldFl1Sh6);location="back", quotes=false),"   BldFl1Sh(6) -            , coeff of x^6")
    push!(lines, line)
    line = string(formatword(string(edblade.BldFl2Sh2);location="back", quotes=false),"   BldFl2Sh(2) - Flap mode 2, coeff of x^2")
    push!(lines, line)
    line = string(formatword(string(edblade.BldFl2Sh3);location="back", quotes=false),"   BldFl2Sh(3) -            , coeff of x^3")
    push!(lines, line)
    line = string(formatword(string(edblade.BldFl2Sh4);location="back", quotes=false),"   BldFl2Sh(4) -            , coeff of x^4")
    push!(lines, line)
    line = string(formatword(string(edblade.BldFl2Sh5);location="back", quotes=false),"   BldFl2Sh(5) -            , coeff of x^5")
    push!(lines, line)
    line = string(formatword(string(edblade.BldFl2Sh6);location="back", quotes=false),"   BldFl2Sh(6) -            , coeff of x^6")
    push!(lines, line)
    line = string(formatword(string(edblade.BldEdgSh2);location="back", quotes=false),"   BldEdgSh(2) - Edge mode 1, coeff of x^2")
    push!(lines, line)
    line = string(formatword(string(edblade.BldEdgSh3);location="back", quotes=false),"   BldEdgSh(3) -            , coeff of x^3")
    push!(lines, line)
    line = string(formatword(string(edblade.BldEdgSh4);location="back", quotes=false),"   BldEdgSh(4) -            , coeff of x^4")
    push!(lines, line)
    line = string(formatword(string(edblade.BldEdgSh5);location="back", quotes=false),"   BldEdgSh(5) -            , coeff of x^5")
    push!(lines, line)
    line = string(formatword(string(edblade.BldEdgSh6);location="back", quotes=false),"   BldEdgSh(6) -            , coeff of x^6")
    push!(lines, line)

    ### Write lines to file
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
    function CreateEDBlade(rads, radspitchaxis, radstwists, radsdensity, radsflapstiff, radsedgestiff, tiprad, hubrad, cylinderrad, airfoilrad, pitch, numnodes, bladedamping, adjustfactor, tuner, blmdadj, modeshapes;importantrads=[], notes = "This is a turbine.", verbose=false)

Creates an instance of EDBlade based off of input data. 


### Inputs
- rads - node distance from the center of rotation. (meters)
- radspitchaxis -  Fraction of chord from leading edge to pitch axis 
- radstwist - node twist angle (degrees)
- radsdensity - node blade density (kg/m) 
- radsflapstiff - node flapwise stiffness (Nm^2)
- radsedgestiff - node edgewise stiffness (Nm^2)
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
- Note that this function does not place nodes in the transition region between the cylinder and the airfoils. Properties are interpolated by Akima spline. 

### Definitions 
Below is a short list of the naming convention used in this function.
- radius (rads) - distance from the center of rotation
- fractions (fracs) - percentage of total blade radius
- blade radius (blrads) - distance from the hub (distance of blade length not   including the hub)
- blade fraction (blfrac) - percentage of blade radius
"""
function CreateEDBlade(rads, radspitchaxis, radstwists, radsdensity, radsflapstiff, radsedgestiff, tiprad, hubrad, cylinderrad, airfoilrad, pitch, numnodes, bladedamping, adjustfactor, tuner, blmdadj, modeshapes;importantrads=[], notes = "This is a turbine.", verbose=false)

        # Definitions
    # radius (rads) - distance from the center of rotation
    # fractions (fracs) - percentage of total blade radius
    # blade radius (blrads) - distance from the hub (distance of blade length not   including the hub)
    # blade fraction (blfrac) - percentage of blade radius

    pitchaxisfit = Akima(rads, radspitchaxis)
    twistfit = Akima(rads, radstwists) 
    densityfit = Akima(rads, radsdensity)
    flapstifffit = Akima(rads, radsflapstiff)
    edgestifffit = Akima(rads, radsedgestiff)


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
    blrads = blfracs.*(bladelength) #Note do not use this to get any property   values    with the fits.
    locs = blrads.+0.508 #The rads location of the blrads nodes
    n = length(blrads)
    pitchaxis = pitchaxisfit.(locs)
    twist = twistfit.(locs)
    twist = twist.+(-twist[end]+pitch) #Correct twist to OpenFAST input style,      including blade pitch
    bmassdens = densityfit.(locs)
    flpstiff = flapstifffit.(locs)
    edgstiff = edgestifffit.(locs)

    bldprops = hcat(blfracs, pitchaxis, twist, bmassdens, flpstiff, edgstiff)

    directory = ["Directory" "Notes" "NBlInpSt" "BldFlDmp1" "BldFlDmp2"     "BldEdDmp1"     "FlStTunr1" "FlStTunr2" "AdjBlMs" "AdjFlSt" "AdjEdSt" "BldProps"    "BldFl1Sh2"    "BldFl1Sh3" "BldFl1Sh4" "BldFl1Sh5" "BldFl1Sh6" "BldFl2Sh2"     "BldFl2Sh3"    "BldFl2Sh4" "BldFl2Sh5" "BldFl2Sh6" "BldEdgSh2" "BldEdgSh3"  "BldEdgSh4"    "BldEdgSh5" "BldEdgSh6"]

    # Find the nodes of the important idxs
    nodeidxs = []
    for i = 1:length(locs)
        if in(locs[i], importantrads)
            push!(nodeidxs, i)
        end
    end


    edblade = EDBlade(directory, notes, n, bladedamping, bladedamping, bladedamping, tuner, tuner, blmdadj, adjustfactor, adjustfactor, bldprops,modeshapes[1], modeshapes[2], modeshapes[3], modeshapes[4], modeshapes[5], modeshapes[6], modeshapes[7], modeshapes[8], modeshapes[9], modeshapes[10], modeshapes[11], modeshapes[12], modeshapes[13], modeshapes[14], modeshapes[15])
end

function CreateEDBlade(props, tiprad, hubrad, cylinderrad, airfoilrad, pitch, numnodes, bladedamping, adjustfactor, tuner, blmdadj, modeshapes;importantrads=[], notes = "This is a turbine.", verbose=false)
    return CreateEDBlade(props[1], props[2], props[3], props[4], props[5], props[6], tiprad, hubrad, cylinderrad, airfoilrad, pitch, numnodes, bladedamping, adjustfactor, tuner, blmdadj, modeshapes;importantrads=[], notes = "This is a turbine.", verbose=false)
end