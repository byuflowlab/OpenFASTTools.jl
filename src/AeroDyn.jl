
##############################################################
##################     STRUCTURES     ########################
##############################################################

# TODO: Could I read an entire file with a package? 
# TODO: does each file need to be in the format with the text? Could I just have a pure numbers input file? I don't know if that would be faster. (I don't know if that is worth looking into. )
mutable struct ADfile{TS, TB, TF, TI}
    notes::TS
    echo::TB
    dtaero::TF
    wakemod::TI
    afaeromod::TI
    twrpotent::TI
    twrshadow::TB
    twraero::TB
    frozenwake::TB
    cavitcheck::TB
    compaa::TB
    aa_inputfile::TS
    airdens::TF
    kinvisc::TF
    spdsound::TF
    patm::TF
    pvap::TF
    fluiddepth::TF
    skewmod::TI
    skewmodfactor::TF
    tiploss::TB
    hubloss::TB
    tanind::TB
    ai_drag::TB
    ti_drag::TB
    ind_toler::TF
    maxiter::TI
    dbemt_mod::TI
    tau1_const::TF
    olaf_inputfilename::TS
    uamod::TI
    flookup::TB
    aftabmod::TI
    incol_alfa::TI
    incol_cl::TI
    incol_cd::TI
    incol_cm::TI
    incol_cpmin::TI
    numaffiles::TI
    foils::Array{TS}
    useblcm::TB
    blades::Array{TS}
    numtwrnds::TI
    twrnds::Array
    sumprint::TB
    nblouts::TI
    bloutnd::Array
    ntwouts::TI
    twoutnd::Array
    outlist::Array{TS}
    bldnd_bladesout::TI
    bldnd_bloutnd::Array{TI}
    nodeoutlist::Array{TS}
end

mutable struct ADBlade{TS, TI, TF}
    notes::TS
    numnds::TI
    span::Array{TF,1}
    curve::Array{TF,1}
    sweep::Array{TF,1}
    curveangle::Array{TF,1}
    twist::Array{TF,1}
    chord::Array{TF,1}
    afid::Array{TI,1}
end

#Aerodata structure, not to be confused with the airfoils input structure #Todo Which of these files do I actually use? -> It appears that I typically use airfoilinput files. I updated this struct, in case I need it. 
struct Aerodata{TS, TF, TI} 
    notes::TS
    numairfoils::TI
    tableid::TI
    aoa_stall::TF
    aoa_0cn::TF
    dcn_0l::TF
    cn_stall_positive::TF
    cn_stall_negative::TF
    aoa_mincd::TF
    cd_min::TF
    aoa::Array{TF, 1}
    cl::Array{TF, 1}
    cd::Array{TF, 1}
    cm::Array{TF, 1}

    #TODO: I need an inner constructor to snag the stall aoa, and other positive/negative values. 

    ### base constructor
    function Aerodata(Notes::TS, NumAirfoils::TI, TableID::TI, Aoa_stall::TF, Aoa_0Cn::TF, dCn_0L::TF, Cn_stall_positive::TF, Cn_stall_negative::TF, Aoa_minCd::TF, Cd_min::TF, Aoa::Array{TF, 1}, Cl::Array{TF, 1}, Cd::Array{TF, 1}, Cm::Array{TF, 1}) where {TS, TF, TI}
        if length(Aoa) != length(Cl) != length(Cd) != length(Cm)
            error("Aerodata: Airfoil polar columns aren't same length.")
        end

        return new{TS, TF, TI}(Notes, NumAirfoils, TableID, Aoa_stall, Aoa_0Cn, dCn_0L, Cn_stall_positive, Cn_stall_negative, Aoa_minCd, Cd_min, Aoa, Cl, Cd, Cm)
    end

    ### no Cm constructor
    function Aerodata(Notes::TS, NumAirfoils::TI, TableID::TI, Aoa_stall::TF, Aoa_0Cn::TF, dCn_0L::TF, Cn_stall_positive::TF, Cn_stall_negative::TF, Aoa_minCd::TF, Cd_min::TF, Aoa::Array{TF, 1}, Cl::Array{TF, 1}, Cd::Array{TF, 1}) where {TS, TF, TI}
        Cm = zeros(length(Aoa))

        return new{TS, TF, TI}(Notes, NumAirfoils, TableID, Aoa_stall, Aoa_0Cn, dCn_0L, Cn_stall_positive, Cn_stall_negative, Aoa_minCd, Cd_min, Aoa, Cl, Cd, Cm)
    end
end

abstract type AirfoilInput end

#TODO: Add inner constructors for base construction and construction without cm. 
struct AirfoilInputSteady{TS, TI, TF, TB} <: AirfoilInput
    interpord::TI
    nondimarea::TF
    numcoords::Union{TS, TI}
    bl_file::TS
    numtabs::TI
    re::TF
    userprop::TI
    incluadata::TB
    numalf::TI
    aoa::Array{TF, 1}
    cl::Array{TF, 1}
    cd::Array{TF, 1}
    cm::Array{TF, 1}
end

struct AirfoilInputUnsteady{TS, TI, TF, TB} <: AirfoilInput
    interpord::TI
    nondimarea::TF
    numcoords::Union{TS, TI}
    bl_file::TS
    numtabs::TI
    re::TF
    userprop::TI
    incluadata::TB
    alpha0::TF
    alpha1::TF
    alpha2::TF
    eta_e::TF
    c_nalpha::TF
    t_f0::TF
    t_v0::TF
    t_p::TF
    t_vl::TF
    b1::TF
    b2::TF
    b5::TF
    a1::TF
    a2::TF
    a5::TF
    s1::TF
    s2::TF
    s3::TF
    s4::TF
    cn1::TF
    cn2::TF
    st_sh::TF
    cd0::TF
    cm0::TF
    k0::TF
    k1::TF
    k2::TF
    k3::TF
    k1_hat::TF
    x_cp_bar::TF
    uacutout::TF
    filtcutoff::TF
    numalf::TI
    aoa::Array{TF, 1}
    cl::Array{TF, 1}
    cd::Array{TF, 1}
    cm::Array{TF, 1}
end

struct AirfoilCoords{TI, TF}
    numcoords::TI
    airfoilreference::Array{TF,2}
    coordinates::Array{TF, 2}
end
 
mutable struct ADDriver{TF, TS, TI, TB}
    notes::TS
    echo::TB
    ad_inputfile::TS
    numblades::TI
    hubrad::TF
    hubht::TF
    overhang::TF
    shfttilt::TF
    precone ::TF
    outfileroot::TS
    tabdel::TB
    outfmt::TS
    beep::TB
    numcases::TI
    windspeed::Array{TF, 1}
    shearexp::Array{TF, 1}
    rpm::Array{TF, 1}
    pitch::Array{TF, 1}
    yaw::Array{TF, 1}
    dt::Array{TF, 1}
    tmax::Array{TF, 1}

    ### Base Constructor
    function ADDriver(notes::TS, echo::TB, ad_inputfile::TS, numblades::TI, hubrad::TF, hubht::TF, overhang::TF, shfttilt::TF, precone ::TF, outfileroot::TS, tabdel::TB, outfmt::TS, beep::TB, numcases::TI, windspeed::Array{TF, 1}, shearexp::Array{TF, 1}, rpm::Array{TF, 1}, pitch::Array{TF, 1}, yaw::Array{TF, 1}, dt::Array{TF, 1}, tmax::Array{TF, 1}) where {TF, TS, TI, TB}

        if length(windspeed) != length(shearexp) != length(rpm) != length(yaw) != length(dt) != numcases
            error("Did not provide an equal amount of wind information.")
        end
        
        return new{TF, TS, TI, TB}(notes, echo, ad_inputfile, numblades, hubrad, hubht, overhang, shfttilt, precone , outfileroot, tabdel, outfmt, beep, numcases, windspeed, shearexp, rpm, pitch, yaw, dt, tmax)
    end

    ### Constructor where shear, yaw, dt, and tmax are constant
    function ADDriver(notes::TS, echo::TB, ad_inputfile::TS, numblades::TI, hubrad::TF, hubht::TF, overhang::TF, shfttilt::TF, precone ::TF, outfileroot::TS, windspeed::Array{TF, 1}, rpm::Array{TF, 1}, pitch::Array{TF, 1}, shearexp::TF, yaw::TF, dt::TF, tmax::TF; tabdel::TB=true, outfmt::TS="ES20.3E2", beep::TB=false) where {TF, TS, TI, TB}

        numcases = length(windspeed)
        shearexp = ones(numcases).*shearexp
        yaw = ones(numcases).*yaw
        dt = ones(numcases).*dt
        tmax = ones(numcases).*dt
        
        return ADDriver{TF, TS, TI, TB}(notes, echo, ad_inputfile, numblades, hubrad, hubht, overhang, shfttilt, precone , outfileroot, tabdel, outfmt, beep, numcases, windspeed, shearexp, rpm, pitch, yaw, dt, tmax)
    end

    ### Constructor with TSR - Can't do a constructor with TSR cause this object doesn't have tip radius. 

    ### Constructor with scalar inputs
    function ADDriver(notes::TS, echo::TB, ad_inputfile::TS, numblades::TI, hubrad::TF, hubht::TF, overhang::TF, shfttilt::TF, precone ::TF, outfileroot::TS, windspeed::TF, shearexp::TF, rpm::TF, pitch::TF, yaw::TF, dt::TF, tmax::TF; tabdel::TB=true, outfmt::TS="ES20.3E2", beep::TB=true) where {TF, TS, TI, TB}

        numcases = 1
        
        return ADDriver{TF, TS, TI, TB}(notes, echo, ad_inputfile, numblades, hubrad, hubht, overhang, shfttilt, precone , outfileroot, tabdel, outfmt, beep, numcases, [windspeed], [shearexp], [rpm], [pitch], [yaw], [dt], [tmax])
    end

end


##############################################################
################## READING FUNCTIONS #########################
##############################################################
"""
    read_adfile(filename, filepath)

Reads in AeroDyn input file and stores the options as a mutable struct.

### Inputs: 
- filename::String - The name of the file. 
- filepath::String - the path to the file. 

### Outputs: 
- adfile::ADfile

"""
function read_adfile(filename, filepath)
    fi = open(filepath*"/"*filename, "r")
    lines = readlines(fi)
    close(fi)

    ### Lines 1-44 are constant
    # Title = lines[1]
    Notes = lines[2]
    #Line 3 is a general title
    Echo = fetchword(lines[4]; adapt=true)
    if contains(lowercase(lines[5][1:14]), "d")
        DTAero = NaN
    else
        DTAero = parse(Float64, lines[5])
    end
    WakeMod = parse(Int, lines[6][1:14])
    AFAeroMod = parse(Int, lines[7][1:14])
    TwrPotent = parse(Int, lines[8][1:14])
    TwrShadow = fetchword(lines[9]; adapt=true)
    TwrAero = fetchword(lines[10]; adapt=true)
    FrozenWake = fetchword(lines[11]; adapt=true)
    CavitCheck = fetchword(lines[12]; adapt=true)
    CompAA = fetchword(lines[13]; adapt=true)
    AA_InputFile = fetchword(lines[14]; lengthofword=length(lines[14]))
    #Line 15 is a general title
    AirDens = parse(Float64, lines[16][1:14])
    KinVisc = parse(Float64, lines[17][1:14])
    SpdSound = parse(Float64, lines[18][1:14])
    Patm = parse(Float64, lines[19][1:14])
    Pvap = parse(Float64, lines[20][1:14])
    FluidDepth = parse(Float64, lines[21][1:14])
    #Line 22 is a general title
    SkewMod = parse(Int, lines[23][1:14])
    if contains(lowercase(lines[24][1:14]), 'd')
        SkewModFactor = NaN
    else
        SkewModFactor = parse(Float64, lines[24][1:14])
    end
    TipLoss = fetchword(lines[25]; adapt=true)
    HubLoss = fetchword(lines[26]; adapt=true) #TODO: Maybe change fetchword to also parse numbers. That might be slick. Just no matter what goes in, one function to grab it. 
    TanInd = fetchword(lines[27]; adapt=true)
    AIDrag = fetchword(lines[28]; adapt=true)
    TIDrag = fetchword(lines[29]; adapt=true)
    if contains(lowercase(lines[30][1:14]), 'd')
        IndToler = NaN
    else
        IndToler = parse(Float64, lines[30][1:14])
    end
    MaxIter = parse(Int, lines[31][1:14])
    #Line 32 is a general title
    DBEMT_Mod = parse(Int, lines[33][1:14])
    tau1_const = parse(Float64, lines[34][1:14])
    #Line 35 is a general title
    OLAFInputFileName = fetchword(lines[36];lengthofword=length(lines[14]))
    #Line 37 is a general title
    UAMod = parse(Int, lines[38][1:14])
    FLookup = fetchword(lines[39]; adapt=true)
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
        foilname = fetchword(lines[47 + i];lengthofword=length(lines[47 + i]))
        push!(Foils, foilname)
    end
    #Line 48+NumAFfiles is a general title
    UseBlCm = fetchword(lines[49+NumAFfiles]; adapt=true)
    Blades = String[]
    idx = 49+NumAFfiles
    i = 1
    for i = 1:3
       bladename = fetchword(lines[idx + i];lengthofword=length(lines[idx + i]))
       push!(Blades, bladename)
    end
    #Line 53+NumAFfiles is a general title
    NumTwrNds = parse(Int, lines[54 + NumAFfiles][1:14])
    #Line 55+NumAFfiles is a matrix title
    #Line 56+NumAFfiles is a matrix title
    ##Read Twr Nodes matrix
    for i = 57+NumAFfiles:56+NumAFfiles+NumTwrNds
        lines[i] = rmspaces(lines[i])
    end
    TwrNds = cat(readdlm.(IOBuffer.(lines[57+NumAFfiles:56+NumAFfiles+NumTwrNds]),' ')...,dims=1) 
    idx = NumAFfiles+NumTwrNds
    #Line 57 + idx is a general title
    SumPrint = fetchword(lines[58+idx]; adapt=true)
    NBlOuts = parse(Int, lines[59+idx][1:14])
    BlOutNd = readvector(lines[60+idx],NBlOuts) #Todo Can I replace read with the cat(readdlm) command? -> No need to. The cat(readdlm) command is built into the readvector command. 
    NTwOuts = parse(Int, lines[61+idx][1:14])
    TwOutNd = readvector(lines[62+idx])
    #Line 63+idx is a general title
    Outlist = readoutlist(lines[64+idx:end])
    # Node Outputs (Can't tell where the end, no way to hint how many   outputs we're looking at) 
    nodeoutputstitleidx = 0 
    for i = 1:length(lines)
        if lowercase(lines[i][1:3]) == "end"
            nodeoutputstitleidx = i+1 #This is the title index
            break
        end
    end
    BldNd_BladesOut = parse(Int, lines[nodeoutputstitleidx+1][1:14])
    BldNd_BlOutNd = readvector(lines[nodeoutputstitleidx+2],    BldNd_BladesOut) 
    # nodeoutputstitleidx+3 is a general title
    NodeOutlist = readoutlist(lines[nodeoutputstitleidx+4:end])
    return ADfile(Notes, Echo, DTAero, WakeMod, AFAeroMod, TwrPotent, TwrShadow, TwrAero, FrozenWake, CavitCheck, CompAA, AA_InputFile, AirDens, KinVisc, SpdSound, Patm, Pvap, FluidDepth, SkewMod, SkewModFactor, TipLoss, HubLoss, TanInd, AIDrag, TIDrag, IndToler, MaxIter, DBEMT_Mod, tau1_const, OLAFInputFileName, UAMod, FLookup, AFTabMod, InCol_Alfa, InCol_Cl, InCol_Cd, InCol_Cm, InCol_Cpmin, NumAFfiles, Foils, UseBlCm, Blades, NumTwrNds, TwrNds, SumPrint, NBlOuts, BlOutNd, NTwOuts, TwOutNd, Outlist, BldNd_BladesOut, BldNd_BlOutNd, NodeOutlist)
end

"""
    read_adblade(filename, filepath)

This function navigates to the location of the file given, and reads in the named AD blade file.

### Inputs:
    filename - A string of the name of the file, including the extension
    filepath - A string of the path to the file

### Outputs: 
    adblade - an immutable struct of the AD blade file

"""
function read_adblade(filename, filepath)
    fi = open(filepath*"/"*filename, "r")
    lines = readlines(fi)
    close(fi)

    Notes = lines[2]
    #Line 3 is a general title
    NumBlNds = parse(Int, lines[4][1:14])
    #Lines 5-6 are general titles
    for i = 7:6+NumBlNds
        lines[i] = rmspaces(lines[i])
    end
    BldProps = cat(readdlm.(IOBuffer.(lines[7:6+NumBlNds]),' ')...,dims=1) #readmatrix(lines[7:6+NumBlNds], 7) #This is not an error, I overloaded the function readmatrix. 
    BlSpn = BldProps[:,1]
    BlCrvAC = BldProps[:,2]
    BlSwpAC = BldProps[:,3]
    BlCrvAng = BldProps[:,4]
    BlTwist = BldProps[:,5]
    BlChord = BldProps[:,6]
    BlAFID = Int.(BldProps[:,7])

    adblade = ADBlade(Notes, NumBlNds, BlSpn, BlCrvAC, BlSwpAC,
                BlCrvAng, BlTwist, BlChord, BlAFID)
    return adblade
end

"""
    read_aerodata(filename, filepath)

This function reads in the information from an aerodata file, including the polars
from the Aerodata folder. Note that currently you have to point it at the correct
file.

### Inputs: 
- filename::String - The name of the file to be read
- filepath::String - the relative or absolute path to the file location. 

### Outputs:
- aerodata::Aerodata

"""
function read_aerodata(filename) #(filename, filepath) #Todo: This is broken and doesn't read every aerodata file. 
    # cd(filepath)
    # fi = open(filepath*"/"*filename, "r")
    fi = open(filename, "r")
    lines = readlines(fi)
    close(fi)

    # # Eliminate the comments from the file so we don't have to deal with multi-line comments
    # lines = String[]
    # for i=1:length(lined)
    #     # println(lined[i])
    #     if lined[i][1]!='!'
    #         line = lined[i]
    #         push!(lines,line)
    #     end
    # end

    flag = false
    j = 1
    while flag #I'm not really sure what I'm doing here. I bet there is a better way to read and parse all of these files. 
        if contains(lines[j], "Number of airfoil tables")
            break
        end
        j += 1
    end
    
    Notes = join(lines[1:j])
    NumAirfoils = parse(Int,lines[3][1:firstletter(lines[3])-1])
    TableID = Int(parse(Float64,lines[4][1:firstletter(lines[4])-1]))
    Aoa_stall = parse(Float64,lines[5][1:firstletter(lines[5])-1])
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
    Aoa = Polars[:,1]
    Cl = Polars[:,2]
    Cd = Polars[:,3]
    if size(Polars)[2] == 4
        Cm = Polars[:,4]
        return Aerodata(Notes, NumAirfoils, TableID, Aoa_stall, Aoa_0Cn, dCn_0L, Cn_stall_positive, Cn_stall_negative, Aoa_minCd, Cd_min, Aoa, Cl, Cd, Cm)
    else
        return Aerodata(Notes, NumAirfoils, TableID, Aoa_stall, Aoa_0Cn, dCn_0L, Cn_stall_positive, Cn_stall_negative, Aoa_minCd, Cd_min, Aoa, Cl, Cd)
    end
end

"""
    read_airfoilinput(filename, filepath)

This function reads in the airfoil input file, which is similar to the aerodata file but points to the coordinates and has some different information. Using the fact that commented lines begin with "!".

### Inputs:
- filename::String - The name of the file
- filepath::String - the relative or absolute path to the file.

### Outputs:
- airfoilinput::AirfoilInput

"""
function read_airfoilinput(filename) #(filename, filepath)
    
    # fi = open(filepath*"/"*filename, "r")
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

    if contains(lowercase(lines[1][1:14]), "d")
        InterpOrd = 0
    else
        InterpOrd = parse(Int, lines[1][1:14])
    end
    NonDimArea = parse(Float64,lines[2][1:14])
    if contains(lines[3][1:5], '@')
        NumCoords = fetchword(lines[3], lengthofword=length(lines[3])-115) #Can't be forced into an Int or Float because the text pushes it towards another file. 
    else
        NumCoords = parse(Int, lines[3][1:14])
    end
    BL_file = fetchword(lines[4], lengthofword=length(lines[4])-145)
    NumTabs = parse(Int,lines[5][1:14])
    Re = parse(Float64,lines[6][1:14])
    UserProp = parse(Int,lines[7][1:14])
    InclUAdata = fetchword(lines[8]; adapt=true)

    if InclUAdata #Read an unsteady airfoil input. 
        alpha0 = parse(Float64,lines[9][1:14])
        alpha1 = parse(Float64,lines[10][1:14])
        alpha2 = parse(Float64,lines[11][1:14])
        eta_e = parse(Float64,lines[12][1:14])
        C_nalpha = parse(Float64,lines[13][1:14])
        
        if contains(lowercase(lines[14][1:14]), "d")
            T_f0 = 3.0
        else
            T_f0 = parse(Float64,lines[14][1:14])
        end
        
        if contains(lowercase(lines[15][1:14]), "d")
            T_V0 = 6.0
        else
            T_V0 = parse(Float64,lines[15][1:14])
        end
        
        if contains(lowercase(lines[16][1:14]), "d")
            T_p = 1.7
        else
            T_p = parse(Float64,lines[16][1:14])
        end
        
        if contains(lowercase(lines[17][1:14]), "d")
            T_VL = 11.0
        else
            T_VL = parse(Float64,lines[17][1:14])
        end
        
        if contains(lowercase(lines[18][1:14]), "d")
            b1 = 0.14
        else
            b1 = parse(Float64,lines[18][1:14]) 
        end
        
        if contains(lowercase(lines[19][1:14]), "d")
            b2 = 0.53
        else
            b2 = parse(Float64,lines[19][1:14])
        end
        
        if contains(lowercase(lines[20][1:14]), "d")
            b5 = 5.0
        else
            b5 = parse(Float64,lines[20][1:14])
        end
        
        if contains(lowercase(lines[21][1:14]), "d")
            A1 = 0.3
        else
            A1 = parse(Float64,lines[21][1:14])
        end
        
        if contains(lowercase(lines[22][1:14]), "d")
            A2 = 0.7
        else
            A2 = parse(Float64,lines[22][1:14])
        end
        
        if contains(lowercase(lines[23][1:14]), "d")
            A5 = 1.0
        else
            A5 = parse(Float64,lines[23][1:14])
        end

        S1 = parse(Float64,lines[24][1:14])
        S2 = parse(Float64,lines[25][1:14])
        S3 = parse(Float64,lines[26][1:14])
        S4 = parse(Float64,lines[27][1:14])
        Cn1 = parse(Float64,lines[28][1:14])
        Cn2 = parse(Float64,lines[29][1:14])
        
        if contains(lowercase(lines[30][1:14]), "d")
            St_sh = 0.19
        else
            St_sh = parse(Float64,lines[30][1:14])
        end

        Cd0 = parse(Float64,lines[31][1:14])
        Cm0 = parse(Float64,lines[32][1:14])
        k0 = parse(Float64,lines[33][1:14])
        k1 = parse(Float64,lines[34][1:14])
        k2 = parse(Float64,lines[35][1:14])
        k3 = parse(Float64,lines[36][1:14])
        k1_hat = parse(Float64,lines[37][1:14])
        
        if contains(lowercase(lines[38][1:14]), "d")
            x_cp_bar = 0.2
        else
            x_cp_bar = parse(Float64,lines[38][1:14])
        end
        
        if contains(lowercase(lines[39][1:14]), "d")
            UACutout = 45.0
        else
            UACutout = parse(Float64, lines[39][1:14])
        end
        
        if contains(lowercase(lines[40][1:14]), "d")
            filtCutOff = 20.0
        else
            filtCutOff = parse(Float64, lines[40][1:14])
        end

        NumAlf = parse(Int,lines[41][1:14])
        for i = 42:length(lines)
            lines[i] = rmspaces(lines[i])
        end
        Polar = cat(readdlm.(IOBuffer.(lines[42:end]))...,dims=1)
        Aoa = Polar[:,1]
        Cl = Polar[:,2]
        Cd = Polar[:,3]
        if size(Polar)[2] == 4
            Cm = Polar[:,4]
        else
            Cm = zeros(length(Cl))
        end
        
        airfoilinput = AirfoilInputUnsteady(InterpOrd, NonDimArea, NumCoords, BL_file, NumTabs, Re, UserProp, InclUAdata, alpha0, alpha1, alpha2, eta_e, C_nalpha, T_f0, T_V0, T_p, T_VL, b1, b2, b5, A1, A2, A5, S1, S2, S3, S4, Cn1, Cn2, St_sh, Cd0, Cm0, k0, k1, k2, k3, k1_hat, x_cp_bar, UACutout, filtCutOff, NumAlf, Aoa, Cl, Cd, Cm)

        return airfoilinput

    else #Read an steady airfoil input. 
        NumAlf = parse(Int,lines[9][1:14])
        for i = 10:length(lines)
            lines[i] = rmspaces(lines[i])
        end 
        Polar = cat(readdlm.(IOBuffer.(lines[10:end]))...,dims=1)
        Aoa = Polar[:,1]
        Cl = Polar[:,2]
        Cd = Polar[:,3]
        if size(Polar)[2] == 4
            Cm = Polar[:,4]
        else
            Cm = zeros(length(Cl))
        end

        airfoilinput = AirfoilInputSteady(InterpOrd, NonDimArea, NumCoords, BL_file, NumTabs, Re, UserProp, InclUAdata, NumAlf, Aoa, Cl, Cd, Cm)

        return airfoilinput
    end #End of if-else statement
end #end of function

"""
    read_airfoilcoordinates(filename, filepath)

Reads in the text file that has the airfoil coordinates, as per the format from OpenFAST

### Inputs: 
- filename::String - The name of the file
- filepath::String - the relative or absolute path to the file. 

### Outputs:
- airfoil::AirfoilCoords

"""
function read_airfoilcoordinates(filename, filepath)
    fi = open(filepath*"/"*filename, "r")
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
    AirfoilReference = cat(readdlm.(IOBuffer.(rmspaces(lines[2])))...,dims=2)

    for i = 3:length(lines)
        lines[i] = rmspaces(lines[i])
    end
    Coordinates = cat(readdlm.(IOBuffer.(lines[3:end]),' ')...,dims=1)

    airfoilcoords = AirfoilCoords(NumCoords, AirfoilReference, Coordinates)
    return airfoilcoords
end

"""
    read_addriver(filename, filepath)

Returns an ADDriver object by reading a ADDriver input file. Note that the driver file is different from the primary input file. 

### Inputs 
- filename::String - The name of the file in the directory to be read. 
- filepath::String - The path to the file to be read, not including the filename in the path

### Outputs
- addriver - the read AD driver file object

### Notes
- Note that the reading function moves you to the directory of the file to be read. 
"""
function read_addriver(filename::String, filepath::String) 

    fi = open(filepath*"/"*filename, "r")
    lines = readlines(fi)
    close(fi)

    #Line 1 is the main title
    Notes = lines[2]
    #Line 3 is the input configuration title
    Echo = fetchword(lines[4]; adapt=true)
    AD_InputFile = fetchword(lines[5]; lengthofword=length(lines[5])) 
    NumBlades = parse(Int, lines[7][1:14])
    HubRad = parse(Float64, lines[8][1:14])
    HubHt = parse(Float64, lines[9][1:14])
    Overhang = parse(Float64, lines[10][1:14])
    ShftTilt = parse(Float64, lines[11][1:14])
    Precone = parse(Float64, lines[12][1:14])
    #Line 13 is the I/O Settings title
    OutFileRoot = fetchword(lines[14]; lengthofword=length(lines[14])) 
    TabDel = fetchword(lines[15]; adapt=true)
    OutFmt = fetchword(lines[16])  
    Beep = fetchword(lines[17]; adapt=true)
    #Line 18 is the combined-case Analysis title
    NumCases = parse(Int, lines[19][1:14])
    #Line 20 is the wind data header
    #Line 21 is the wind data units
    # WindData = readmatrix(lines[22:21+NumCases], 7)
    for i = 22:21+NumCases
        lines[i] = rmspaces(lines[i])
    end
    WindData = cat(readdlm.(IOBuffer.(lines[22:21+NumCases]),' ')...,dims=1)
    windspeed = WindData[:,1]
    shearexp = WindData[:,2]
    rpm = WindData[:,3]
    pitch = WindData[:,4]
    yaw = WindData[:,5]
    dt = WindData[:,6]
    tmax = WindData[:,7]

    return ADDriver(Notes, Echo, AD_InputFile, NumBlades, HubRad, HubHt, Overhang, ShftTilt, Precone , OutFileRoot, TabDel, OutFmt, Beep, NumCases, windspeed, shearexp, rpm, pitch, yaw, dt, tmax)
end




##############################################################
############# WRITING FUNCTIONS ##############################
##############################################################

"""
    write_adfile(adfile::ADfile, outputfile::string; outputpath::String=pwd())

Writes a AeroDyn v15 object to file. 

### Inputs:
- adfile::ADfile - an AeroDyn file object
- outputfile::String - the desired name of the written file
- outputpath::String - the desired relative or absolute path of the written file.
"""
function write_adfile(adfile::ADfile, outputfile::String; outputpath::String=pwd()) 
    lines = String[]
    line = string("-"^7, " AERODYN v15 for OpenFAST INPUT FILE ", "-"^47)
    push!(lines,line)
    push!(lines, adfile.notes)
    line = string("="^6, "  General Options  ", "="^76)
    push!(lines, line)
    line = string(formatword(adfile.echo;quotes=false),"   Echo               - Echo the input to \"<rootname>.AD.ech\"?  (flag)")
    push!(lines, line)
    if isnan(adfile.dtaero)
        line = string(formatword("Default";quotes=true),"   DTAero             - Time interval for aerodynamic calculations {or \"default\"} (s)")
    else
        line = string(formatword(adfile.dtaero;quotes=false, location="back"),"   DTAero             - Time interval for aerodynamic calculations {or \"default\"} (s)")
    end
    push!(lines, line)
    line = string(formatword(string(adfile.wakemod);location="back",quotes=false), "   WakeMod            - Type of wake/induction model (switch) {0=none, 1=BEMT, 2=DBEMT} [WakeMod cannot be 2 when linearizing]")
    push!(lines, line)
    line = string(formatword(string(adfile.afaeromod);location="back",quotes=false),"   AFAeroMod          - Type of blade airfoil aerodynamics model (switch) {1=steady model, 2=Beddoes-Leishman unsteady model} [AFAeroMod must be 1 when linearizing]")
    push!(lines, line)
    line = string(formatword(string(adfile.twrpotent);location="back",quotes=false),"   TwrPotent          - Type tower influence on wind based on potential flow around the tower (switch) {0=none, 1=baseline potential flow, 2=potential flow with Bak correction}")
    push!(lines, line)
    line = string(formatword(adfile.twrshadow;quotes=false), "   TwrShadow          - Calculate tower influence on wind based on downstream tower shadow? (flag)")
    push!(lines,line)
    line = string(formatword(adfile.twraero;quotes=false), "   TwrAero            - Calculate tower aerodynamic loads? (flag)")
    push!(lines, line)
    line = string(formatword(adfile.frozenwake;quotes=false), "   FrozenWake         - Assume frozen wake during linearization? (flag) [used only when WakeMod=1 and when linearizing]")
    push!(lines, line)
    line = string(formatword(adfile.cavitcheck;quotes=false), "   CavitCheck         - Perform cavitation check? (flag) [AFAeroMod must be 1 when CavitCheck=true]")
    push!(lines, line)
    line = string(formatword(adfile.compaa;quotes=false), "   CompAA             - Flag to compute AeroAcoustics calculation [only used when WakeMod=1 or 2]")
    push!(lines, line)
    line = string(formatword(adfile.aa_inputfile), "   - Aeroacoustics input file")
    push!(lines, line)
    line = string("="^6, "  Environmental Conditions  ", "="^67)
    push!(lines, line)
    line = string(formatword(string(adfile.airdens);location="back", quotes=false), "   AirDens            - Air density (kg/m^3)")
    push!(lines, line)
    line = string(formatword(string(adfile.kinvisc);location="back", quotes=false), "   KinVisc            - Kinematic air viscosity (m^2/s)")
    push!(lines, line)
    line = string(formatword(string(adfile.spdsound);location="back", quotes=false), "   SpdSound           - Speed of sound (m/s)")
    push!(lines, line)
    line = string(formatword(string(adfile.patm);location="back", quotes=false), "   Patm               - Atmospheric pressure (Pa) [used only when CavitCheck=True]")
    push!(lines, line)
    line = string(formatword(string(adfile.pvap);location="back", quotes=false), "   Pvap               - Vapour pressure of fluid (Pa) [used only when CavitCheck=True]")
    push!(lines, line)
    line = string(formatword(string(adfile.fluiddepth);location="back", quotes=false), "   FluidDepth         - Water depth above mid-hub height (m) [used only when CavitCheck=True]")
    push!(lines, line)
    line = string("="^6, "  Blade-Element/Momentum Theory Options  ", "="^54)
    push!(lines, line)
    line = string(formatword(string(adfile.skewmod);location="back", quotes=false), "   SkewMod            - Type of skewed-wake correction model (switch) {1=uncoupled, 2=Pitt/Peters, 3=coupled} [unused when WakeMod=0]")
    push!(lines, line)
    if isnan(adfile.skewmodfactor)
        line = string(formatword("Default"), "   SkewModFactor      - Constant used in Pitt/Peters skewed wake model {or \"default\" is 15/32*pi} (-) [used only when SkewMod=2; unused when WakeMod=0]")
    else
        line = string(formatword(adfile.skewmodfactor; location="back", quotes=false), "   SkewModFactor      - Constant used in Pitt/Peters skewed wake model {or \"default\" is 15/32*pi} (-) [used only when SkewMod=2; unused when WakeMod=0]")
    end
    push!(lines, line)
    line = string(formatword(adfile.tiploss;quotes=false), "   TipLoss            - Use the Prandtl tip-loss model? (flag) [unused when WakeMod=0]")
    push!(lines, line)
    line = string(formatword(adfile.hubloss;quotes=false), "   HubLoss            - Use the Prandtl hub-loss model? (flag) [unused when WakeMod=0]")
    push!(lines, line)
    line = string(formatword(adfile.tanind;quotes=false), "   TanInd             - Include tangential induction in BEMT calculations? (flag) [unused when WakeMod=0]")
    push!(lines, line)
    line = string(formatword(adfile.ai_drag;quotes=false), "   AIDrag             - Include the drag term in the axial-induction calculation? (flag) [unused when WakeMod=0]")
    push!(lines, line)
    line = string(formatword(adfile.ti_drag;quotes=false), "   TIDrag             - Include the drag term in the tangential-induction calculation? (flag) [unused when WakeMod=0 or TanInd=FALSE]")
    push!(lines, line)
    if isnan(adfile.ind_toler)
        line = string(formatword("Default"), "   IndToler           - Convergence tolerance for BEMT nonlinear solve residual equation {or \"default\"} (-) [unused when WakeMod=0]")
    else
        line = string(formatword(adfile.ind_toler; quotes=false, location="back"), "   IndToler           - Convergence tolerance for BEMT nonlinear solve residual equation {or \"default\"} (-) [unused when WakeMod=0]")
    end
    push!(lines, line)
    line = string(formatword(string(adfile.maxiter);location="back", quotes=false), "   MaxIter            - Maximum number of iteration steps (-) [unused when WakeMod=0]")
    push!(lines, line)
    line = string("="^6, "  Dynamic Blade-Element/Momentum Theory Options  ", "="^46)
    push!(lines, line)
    line = string(formatword(string(adfile.dbemt_mod);location="back", quotes=false), "   DBEMT_Mod          - Type of dynamic BEMT (DBEMT) model {1=constant tau1, 2=time-dependent tau1} (-) [used only when WakeMod=2]")
    push!(lines, line)
    line = string(formatword(string(adfile.tau1_const);location="back", quotes=false), "   tau1_const         - Time constant for DBEMT (s) [used only when WakeMod=2 and DBEMT_Mod=1]")
    push!(lines, line)
    line = string("="^6, "   OLAF -- cOnvecting LAgrangian Filaments (Free Vortex Wake) Theory Options", "="^46)
    push!(lines, line)
    line = string(formatword(adfile.olaf_inputfilename), "   - Aeroacoustics input file")
    push!(lines, line)
    line = string("="^6, "  Beddoes-Leishman Unsteady Airfoil Aerodynamics Options  ", "="^37)
    push!(lines, line)
    line = string(formatword(string(adfile.uamod);location="back", quotes=false), "   UAMod              - Unsteady Aero Model Switch (switch) {1=Baseline model (Original), 2=Gonzalez's variant (changes in Cn,Cc,Cm), 3=Minemma/Pierce variant (changes in Cc and Cm)} [used only when AFAeroMod=2]")
    push!(lines, line)
    line = string(formatword(adfile.flookup;quotes=false), "   FLookup            - Flag to indicate whether a lookup for f\' will be calculated (TRUE) or whether best-fit exponential equations will be used (FALSE); if FALSE S1-S4 must be provided in airfoil input files (flag) [used only when AFAeroMod=2]")
    push!(lines, line)
    line = string("="^6, "  Airfoil Information ", "="^73)
    push!(lines, line)
    line = string(formatword(string(adfile.aftabmod);location="back", quotes=false), "   AFTabMod           - Interpolation method for multiple airfoil tables {1=1D interpolation on AoA (first table only); 2=2D interpolation on AoA and Re; 3=2D interpolation on AoA and UserProp} (-)")
    push!(lines, line)
    line = string(formatword(string(adfile.incol_alfa);location="back", quotes=false), "   InCol_Alfa         - The column in the airfoil tables that contains the angle of attack (-)")
    push!(lines, line)
    line = string(formatword(string(adfile.incol_cl);location="back", quotes=false), "   InCol_Cl           - The column in the airfoil tables that contains the lift coefficient (-)")
    push!(lines, line)
    line = string(formatword(string(adfile.incol_cd);location="back", quotes=false), "   InCol_Cd           - The column in the airfoil tables that contains the drag coefficient (-)")
    push!(lines, line)
    line = string(formatword(string(adfile.incol_cm);location="back", quotes=false), "   InCol_Cm           - The column in the airfoil tables that contains the pitching-moment coefficient; use zero if there is no Cm column (-)")
    push!(lines, line)
    line = string(formatword(string(adfile.incol_cpmin);location="back", quotes=false), "   InCol_Cpmin        - The column in the airfoil tables that contains the Cpmin coefficient; use zero if there is no Cpmin column (-)")
    push!(lines, line)
    line = string(formatword(string(adfile.numaffiles);location="back", quotes=false), "   NumAFfiles         - Number of airfoil files used (-)")
    push!(lines, line)

    line = string(formatword(adfile.foils[1];desiredlength=length(adfile.foils[2])+5), "AFNames            - Airfoil file names (NumAFfiles lines) (quoted strings)")
    push!(lines, line)

    for i=2:length(adfile.foils)
       line = string("\"",adfile.foils[i],"\"")
       push!(lines,line)
    end

    line = string("="^6, "  Rotor/Blade Properties  ", "="^69)
    push!(lines,line)
    line = string(formatword(adfile.useblcm;quotes=false), "   UseBlCm            - Include aerodynamic pitching moment in calculations?  (flag)")
    push!(lines,line)

    while length(adfile.blades)<3 #If only one blade file is given, this repeats it 3 times so that the file is the correct length. I suppose I could always add "unused" instead, but the same name works just fine. 
       push!(adfile.blades,adfile.blades[1])
    end

    for i=1:length(adfile.blades)
       line = string(formatword(adfile.blades[i];desiredlength=length(adfile.blades[i])+2),"   ADBlFile($i)        - Name of file containing distributed aerodynamic properties for Blade #$i (-)")
       push!(lines, line)
    end

    line = string("="^6, "  Tower Influence and Aerodynamics ", "="^61)
    push!(lines, line)
    line = string(formatword(string(adfile.numtwrnds);location="back",quotes=false), "   NumTwrNds         - Number of tower nodes used in the analysis  (-) [used only when TwrPotent/=0, TwrShadow=True, or TwrAero=True]")
    push!(lines, line)
    line = "TwrElev        TwrDiam        TwrCd"
    push!(lines, line)
    line = "(m)              (m)           (-)"
    push!(lines, line)
    line = formatmatrix(adfile.twrnds) #TODO: Can I accomplish this with writedlm instead of a homegrown function? 
    append!(lines,line)
    line = string("="^6, "  Outputs  ", "="^84)
    push!(lines, line)
    line = string(formatword(adfile.sumprint;quotes=false), "   SumPrint            - Generate a summary file listing input options and interpolated properties to \"<rootname>.AD.sum\"?  (flag)")
    push!(lines, line)
    line = string(formatword(string(adfile.nblouts);location="back",quotes=false), "   NBlOuts             - Number of blade node outputs [0 - 9] (-)")
    push!(lines, line)
    if adfile.nblouts>0
       line = formatvector(adfile.bloutnd)
    else
       line = string(" "^11, 1)
    end
    line = string(line, "   BlOutNd             - Blade nodes whose values will be output  (-)")
    push!(lines, line)
    line = string(formatword(string(adfile.ntwouts);location="back",quotes=false), "   NTwOuts             - Number of tower node outputs [0 - 9]  (-)")
    push!(lines, line)
    if length(adfile.twoutnd)>0
        line = formatvector(adfile.twoutnd) #doesn't need a push because I combine on the next line. 
    else
        line = string("   ", 1)
    end
    line = string(line, "   TwOutNd             - Tower nodes whose values will be output  (-)")
    push!(lines, line)
    line = "                   OutList             - The next line(s) contains a list of output parameters.  See s for a listing of available output channels, (-)"
    push!(lines, line)
    for i=1:length(adfile.outlist)
       line = string("\"", adfile.outlist[i], "\"")
       push!(lines,line)
    end
    line = "END of input file (the word \"END\" must appear in the first 3 columns of this last OutList line)"
    push!(lines,line)
    line = "---------------------- NODE OUTPUTS --------------------------------------------"
    push!(lines, line)
    line = string(formatword(string(adfile.bldnd_bladesout);location="back",quotes=false), "   BldNd_BladesOut  - Blades to output")
    push!(lines, line)

    if adfile.bldnd_bladesout>0
        line = formatvector(adfile.bldnd_bloutnd)
    else
        line = " "^11
    end
     line = string(line, "   - Blade nodes on each blade (currently unused)")
     push!(lines, line)

     line = "                   OutList             - The next line(s) contains a list of output parameters.  See s for a listing of available output channels, (-)"

     push!(lines, line)
     for i=1:length(adfile.nodeoutlist)
        line = string("\"", adfile.nodeoutlist[i], "\"")
        push!(lines,line)
     end
     line = "END of input file (the word \"END\" must appear in the first 3 columns of this last OutList line)"
     push!(lines,line)

    ### Write lines to file
    fi = open(outputpath*"/"*outputfile,"w+")
    i = 1
    for i = 1:length(lines)-1
         write(fi,lines[i])
         write(fi,"\n")
    end
    write(fi,lines[end])
    close(fi)
end

"""
    write_adblade(adblade::ADBlade, outputfile::String; outputpath::String = pwd())

Writes an AeroDyn Blade object to file. 

### Inputs:
- adblade::ADBlade - AeroDyn blade object
- outputfile::String - the desired name of the written file
- outputpath::String - the desired relative or absolute write location of the file. 
"""
function write_adblade(adblade::ADBlade, outputfile::String; outputpath::String=pwd())
    lines = String[]
    line = string("-"^7, " AERODYN v15.00.* BLADE DEFINITION INPUT FILE ", "-"^37)
    push!(lines, line)
    line = adblade.notes
    push!(lines, line)
    line = string("="^6, "  Blade Properties ", "="^65)
    push!(lines, line)
    line = string(formatword(string(adblade.numnds);location="back", quotes=false),"   NumBlNds           - Number of blade nodes used in the analysis (-)")
    push!(lines, line)
    line = "  BlSpn        BlCrvAC        BlSwpAC        BlCrvAng       BlTwist        BlChord          BlAFID"
    push!(lines, line)
    line = "   (m)           (m)            (m)            (deg)         (deg)           (m)              (-)"
    push!(lines, line)
    BldProps = hcat(adblade.span, adblade.curve, adblade.sweep, adblade.curveangle, adblade.twist, adblade.chord, adblade.afid)
    line = formatmatrix(BldProps[:,1:end-1])
    newcolumn = formatwidecolumn(Int.(BldProps[:,end]))
    line = formatmatrix_appendcolumn(line, newcolumn)
    append!(lines, line)

    ### Write lines to file
    fi = open(outputpath*"/"*outputfile,"w+") 
    i = 1
    for i = 1:length(lines)-1
         write(fi,lines[i])
         write(fi,"\n")
    end
    write(fi,lines[end])
    close(fi)
end

"""
    write_airfoilcoordinates(airfoilcoords::AirfoilCoords, outputfile::String; outputpath::String=pwd())

Writes a file for the OpenFAST airfoil coordinates file.

### Inputs: 
- airfoilcoords::AirfoilCoords - airfoil coordinates object
- outputfile::String - The desired name of the written file
- outputpath::String - The desired relative or absolute path of the write file. 

"""
function write_airfoilcoordinates(airfoilcoords::AirfoilCoords, outputfile::String; outputpath::String=pwd())
    lines = String[]
    line = string(formatword(string(airfoilcoords.numcoords);location="back", quotes=false),"   NumCoords         ! The number of coordinates in the airfoil shape file (including an extra coordinate for airfoil reference).  Set to zero if coordinates not included." )
    push!(lines, line)
    line = "! ......... x-y coordinates are next if NumCoords > 0 ............."
    push!(lines, line)
    line = "! x-y coordinate of airfoil reference"
    push!(lines, line)
    line = "!  x/c        y/c"
    push!(lines, line)
    line = formatcoordinates(airfoilcoords.airfoilreference)
    append!(lines, line)
    line = "! Airfoil Coordinates"
    push!(lines, line)
    line = "! x/c     y/c"
    push!(lines, line)
    line = formatcoordinates(airfoilcoords.coordinates)
    append!(lines, line)


    ### Write lines to file
    fi = open(outputpath*"/"*outputfile,"w+")
    i = 1
    for i = 1:length(lines)-1
         write(fi,lines[i])
         write(fi,"\n")
    end
    write(fi,lines[end])
    close(fi)
end


"""
    write_airfoilinput(airfoilinput::AirfoilInput, outputfile::String; outputpath::String=pwd())

Writes an Airfoil Input file object to file. 

### Inputs:
- airfoilinput::AirfoilInput - The airfoil input file. This is different from the airfoil coordinates file. 
- outputfile::String - The desired name of the written file. 
- outputpath::String - The desired relative or absolute path to the written file. 
"""
function write_airfoilinput(airfoilinput::AirfoilInput, outputfile::String; outputpath::String=pwd()) 
    lines = String[]
    line = "! ------------ AirfoilInfo v1.01.x Input File ----------------------------------"
    push!(lines, line)

    if airfoilinput.interpord==0
        line = string(formatword("Default";location="front", quotes=true),"   InterpOrd         ! Interpolation order to use for quasi-steady table lookup {1=linear; 3=cubic spline; \"default\"} [default=1]" )
    else
        line = string(formatword(string(airfoilinput.interpord);location="back", quotes=false),"   InterpOrd         ! Interpolation order to use for quasi-steady table lookup {1=linear; 3=cubic spline; \"default\"} [default=1]" )
    end
    push!(lines, line)

    line = string(formatword(string(airfoilinput.nondimarea);location="back", quotes=false),"   NonDimArea        ! The non-dimensional area of the airfoil (area/chord^2) (set to 1.0 if unsure or unneeded)")
    push!(lines, line)

    if isa(airfoilinput.numcoords, String)
        line = string(formatword(string(airfoilinput.numcoords);location="front", quotes=false, desiredlength=length(string(airfoilinput.numcoords))+5),"   NumCoords         ! The number of coordinates in the airfoil shape file.  Set to zero if coordinates not included.")
    else
        line = string(formatword(string(airfoilinput.numcoords);location="back", quotes=false),"   NumCoords         ! The number of coordinates in the airfoil shape file.  Set to zero if coordinates not included.")
    end
    push!(lines, line)

    line = string(formatword(string(airfoilinput.bl_file);location="front", quotes=true, desiredlength=length(airfoilinput.bl_file)+5), "   BL_file           ! The file name including the boundary layer characteristics of the profile. Ignored if the aeroacoustic module is not called.")
    push!(lines, line)

    line = string(formatword(string(airfoilinput.numtabs);location="back", quotes=false),"   NumTabs           ! Number of airfoil tables in this file.")
    push!(lines, line)

    line = "! ------------------------------------------------------------------------------"
    push!(lines, line)

    line = "! data for table 1"
    push!(lines, line)

    line = "! ------------------------------------------------------------------------------"
    push!(lines, line)

    line = string(formatword(string(airfoilinput.re);location="back", quotes=false),"   Re                ! Reynolds number in millions")
    push!(lines, line)

    line = string(formatword(string(airfoilinput.userprop);location="back", quotes=false),"   UserProp          ! User property (control) setting")
    push!(lines, line)

    line = string(formatword(string(airfoilinput.incluadata);location="front", quotes=false),"   InclUAdata        ! Is unsteady aerodynamics data included in this table? If TRUE, then include 30 UA coefficients below this line")
    push!(lines, line)
    if airfoilinput.incluadata
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

        line = string(formatword(string(airfoilinput.c_nalpha);location="back",     quotes=false),"   C_nalpha          ! Slope of the 2D normal force  coefficient curve. (1/rad)")
        push!(lines, line)

        if isnan(airfoilinput.t_f0)
            line = string(formatword("Default";location="front",     quotes=true),"   T_f0              ! Initial value of the time constant    associated with Df in the expression of Df and f''. [default = 3]")
        else
            line = string(formatword(string(airfoilinput.t_f0);location="back",     quotes=false),"   T_f0              ! Initial value of the time constant    associated with Df in the expression of Df and f''. [default = 3]")
        end
        push!(lines, line)

        if isnan(airfoilinput.t_v0)
            line = string(formatword("Default";location="front",     quotes=true),"   T_V0              ! Initial value of the time constant    associated with the vortex lift decay process; it is used in the expression    of Cvn. It depends on Re,M, and airfoil class. [default = 6]")
        else
            line = string(formatword(string(airfoilinput.t_v0);location="back",     quotes=false),"   T_V0              ! Initial value of the time constant    associated with the vortex lift decay process; it is used in the expression    of Cvn. It depends on Re,M, and airfoil class. [default = 6]")
        end
        push!(lines, line)

        if isnan(airfoilinput.t_p)
            line = string(formatword("Default";location="front",  quotes=true),"   T_p               ! Boundary-layer,leading edge pressure   gradient time constant in the expression of Dp. It should be tuned based on   airfoil experimental data. [default = 1.7]")
        else
            line = string(formatword(string(airfoilinput.t_p);location="back",  quotes=false),"   T_p               ! Boundary-layer,leading edge pressure   gradient time constant in the expression of Dp. It should be tuned based on   airfoil experimental data. [default = 1.7]")
        end
        push!(lines, line)

        if isnan(airfoilinput.t_vl)
            line = string(formatword("Default";location="front",     quotes=true),"   T_VL              ! Initial value of the time constant    associated with the vortex advection process; it represents the    non-dimensional time in semi-chords, needed for a vortex to travel from LE     to trailing edge (TE); it is used in the expression of Cvn. It depends on   Re, M (weakly), and airfoil. [valid range = 6 - 13, default = 11]")
        else
            line = string(formatword(string(airfoilinput.t_vl);location="back",     quotes=false),"   T_VL              ! Initial value of the time constant    associated with the vortex advection process; it represents the    non-dimensional time in semi-chords, needed for a vortex to travel from LE     to trailing edge (TE); it is used in the expression of Cvn. It depends on   Re, M (weakly), and airfoil. [valid range = 6 - 13, default = 11]")
        end
        push!(lines, line)

        if isnan(airfoilinput.b1)
            line = string(formatword("Default";location="front",   quotes=true),"   b1                ! Constant in the expression of   phi_alpha^c and phi_q^c.  This value is relatively insensitive for thin   airfoils, but may be different for turbine airfoils. [from experimental   results, defaults to 0.14]")
        else
            line = string(formatword(string(airfoilinput.b1);location="back",   quotes=false),"   b1                ! Constant in the expression of   phi_alpha^c and phi_q^c.  This value is relatively insensitive for thin   airfoils, but may be different for turbine airfoils. [from experimental   results, defaults to 0.14]")
        end
        push!(lines, line)

        if isnan(airfoilinput.b2)
            line = string(formatword("Default";location="front",   quotes=true),"   b2                ! Constant in the expression of   phi_alpha^c and phi_q^c.  This value is relatively insensitive for thin   airfoils, but may be different for turbine airfoils. [from experimental   results, defaults to 0.53]")
        else
            line = string(formatword(string(airfoilinput.b2);location="back",   quotes=false),"   b2                ! Constant in the expression of   phi_alpha^c and phi_q^c.  This value is relatively insensitive for thin   airfoils, but may be different for turbine airfoils. [from experimental   results, defaults to 0.53]")
        end
        push!(lines, line)

        if isnan(airfoilinput.b5)
            line = string(formatword("Default";location="front",   quotes=true),"   b5                ! Constant in the expression of K'''_q,   Cm_q^nc, and k_m,q.  [from  experimental results, defaults to 5]")
        else
            line = string(formatword(string(airfoilinput.b5);location="back",   quotes=false),"   b5                ! Constant in the expression of K'''_q,   Cm_q^nc, and k_m,q.  [from  experimental results, defaults to 5]")
        end
        push!(lines, line)

        if isnan(airfoilinput.a1)
            line = string(formatword("Default";location="front",   quotes=true),"   A1                ! Constant in the expression of   phi_alpha^c and phi_q^c.  This value is relatively insensitive for thin   airfoils, but may be different for turbine airfoils. [from experimental   results, defaults to 0.3]")
        else
            line = string(formatword(string(airfoilinput.a1);location="back",   quotes=false),"   A1                ! Constant in the expression of   phi_alpha^c and phi_q^c.  This value is relatively insensitive for thin   airfoils, but may be different for turbine airfoils. [from experimental   results, defaults to 0.3]")
        end
        push!(lines, line)

        if isnan(airfoilinput.a2)
            line = string(formatword("Default";location="front", quotes=true),"   A2                ! Constant in the expression of   phi_alpha^c and phi_q^c.  This value is relatively insensitive for thin   airfoils, but may be different for turbine airfoils. [from experimental   results, defaults to 0.7]")
        else
            line = string(formatword(string(airfoilinput.a2);location="back",   quotes=false),"   A2                ! Constant in the expression of   phi_alpha^c and phi_q^c.  This value is relatively insensitive for thin   airfoils, but may be different for turbine airfoils. [from experimental   results, defaults to 0.7]")
        end
        push!(lines, line)

        if isnan(airfoilinput.a5)
            line = string(formatword("Default";location="front",   quotes=true),"   A5                ! Constant in the expression of K'''_q,   Cm_q^nc, and k_m,q. [from experimental results, defaults to 1]")
        else
            line = string(formatword(string(airfoilinput.a5);location="back",   quotes=false),"   A5                ! Constant in the expression of K'''_q,   Cm_q^nc, and k_m,q. [from experimental results, defaults to 1]")
        end
        push!(lines, line)

        line = string(formatword(string(airfoilinput.s1);location="back",   quotes=false),"   S1                ! Constant in the f curve best-fit for    alpha0<=AOA<=alpha1; by definition it depends on the airfoil. [ignored if  UAMod<>1]")
        push!(lines, line)

        line = string(formatword(string(airfoilinput.s2);location="back",   quotes=false),"   S2                ! Constant in the f curve best-fit    for         AOA> alpha1; by definition it depends on the airfoil. [ignored     if UAMod<>1]")
        push!(lines, line)

        line = string(formatword(string(airfoilinput.s3);location="back",   quotes=false),"   S3                ! Constant in the f curve best-fit for    alpha2<=AOA< alpha0; by definition it depends on the airfoil. [ignored if  UAMod<>1]")
        push!(lines, line)

        line = string(formatword(string(airfoilinput.s4);location="back",   quotes=false),"   S4                ! Constant in the f curve best-fit    for         AOA< alpha2; by definition it depends on the airfoil. [ignored     if UAMod<>1]")
        push!(lines, line)

        line = string(formatword(string(airfoilinput.cn1);location="back",  quotes=false),"   Cn1               ! Critical value of C0n at leading edge  separation. It should be extracted from airfoil data at a given Mach and     Reynolds number. It can be calculated from the static value of Cn at either     the break in the pitching moment or the loss of chord force at the onset of     stall. It is close to the condition of maximum lift of the airfoil at low   Mach numbers.")
        push!(lines, line)

        line = string(formatword(string(airfoilinput.cn2);location="back",  quotes=false),"   Cn2               ! As Cn1 for negative AOAs.")
        push!(lines, line)

        if isnan(airfoilinput.st_sh)
            line = string(formatword("Default";location="front",    quotes=true),"   St_sh             ! Strouhal's shedding frequency    constant.  [default = 0.19]")
        else
            line = string(formatword(string(airfoilinput.st_sh);location="back",    quotes=false),"   St_sh             ! Strouhal's shedding frequency    constant.  [default = 0.19]")
        end
        push!(lines, line)

        line = string(formatword(string(airfoilinput.cd0);location="back",  quotes=false),"   Cd0               ! 2D drag coefficient value at 0-lift.")
        push!(lines, line)

        line = string(formatword(string(airfoilinput.cm0);location="back",  quotes=false),"   Cm0               ! 2D pitching moment coefficient about 1/    4-chord location, at 0-lift, positive if nose up. [If the aerodynamics  coefficients table does not include a column for Cm, this needs to be set to     0.0]")
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

        if isnan(airfoilinput.x_cp_bar)
            line = string(formatword("Default";location="front",     quotes=true),"   x_cp_bar          ! Constant in the expression of hat(x)  _cp^v. [ignored if UAMod<>1, default = 0.2]")
        else
            line = string(formatword(string(airfoilinput.x_cp_bar);location="back",     quotes=false),"   x_cp_bar          ! Constant in the expression of hat(x)  _cp^v. [ignored if UAMod<>1, default = 0.2]")
        end
        push!(lines, line)

        if isnan(airfoilinput.uacutout)
            line = string(formatword("Default";location="front",    quotes=true),"   UACutout          ! Angle of attack above which unsteady     aerodynamics are disabled (deg). [Specifying the string \"Default\" sets    UACutout to 45 degrees]")
        else
            line = string(formatword(string(airfoilinput.uacutout);location="back",    quotes=false),"   UACutout          ! Angle of attack above which unsteady     aerodynamics are disabled (deg). [Specifying the string \"Default\" sets    UACutout to 45 degrees]")
        end
        push!(lines, line)

        if isnan(airfoilinput.filtcutoff)
            line = string(formatword("Default";location="front", quotes=true),"   filtCutOff        ! Cut-off frequency (-3 dB corner frequency) for low-pass filtering the AoA input to UA, as well as the 1st and 2nd derivatives (Hz) [default = 20]")
        else
            line = string(formatword(string(airfoilinput.filtcutoff);location="back", quotes=false),"   filtCutOff        ! Cut-off frequency (-3 dB corner frequency) for low-pass filtering the AoA input to UA, as well as the 1st and 2nd derivatives (Hz) [default = 20]")
        end
        push!(lines, line)
    end
    line = "!........................................"
    push!(lines, line)

    line = "! Table of aerodynamics coefficients"
    push!(lines, line)

    line = string(formatword(string(airfoilinput.numalf);location="back", quotes=false),"   NumAlf            ! Number of data lines in the following table")
    push!(lines, line)

    line = "!    Alpha      Cl      Cd        Cm"
    push!(lines, line)

    line = "!    (deg)      (-)     (-)       (-)"
    push!(lines, line)

    Polar = hcat(airfoilinput.aoa, airfoilinput.cl, airfoilinput.cd, airfoilinput.cm)
    line = formatcoordinates(Polar)
    append!(lines, line)

    ### Write lines to file
    fi = open(outputpath*"/"*outputfile,"w+")
    i = 1
    for i = 1:length(lines)-1
         write(fi,lines[i])
         write(fi,"\n")
    end
    write(fi,lines[end])
    close(fi)
end

"""
    WriteAerodata(aerodata::Aerodata, outputfile::String; outputpath::String=pwd())

This function takes an aerodata structure and writes an output file for it.

### Inputs: 
- aerodata::Aerodata - the aerodata object. It looks like it is information about the airfoil polar. 
- outputfile::String - the desired name of the written file
- outputpath::String - the desired relative or absolute path of the written file. 
"""
function write_aerodata(aerodata::Aerodata, outputfile::String; outputpath::String=pwd())
    lines = String[]
    line = aerodata.notes
    push!(lines, line)
    line = string(formatword(string(aerodata.numairfoils);location="back", quotes=false),"   Number of airfoil tables in this file")
    push!(lines, line)
    line = string(formatword(string(aerodata.tableid);location="back", quotes=false),"   Table ID parameter")
    push!(lines, line)
    line = string(formatword(string(aerodata.aoa_stall);location="back", quotes=false),"   Stall angle (deg)")
    push!(lines, line)
    line = string("   0.0   ","   No longer used, enter zero") #z1 - not used any more
    push!(lines, line)
    line = string("   0.0   ","   No longer used, enter zero") #z2
    push!(lines, line)
    line = string("   0.0   ","   No longer used, enter zero") #z3
    push!(lines, line)
    line = string(formatword(string(aerodata.aoa_0cn);location="back", quotes=false),"   Zero Cn angle of attack (deg)")
    push!(lines, line)
    line = string(formatword(string(aerodata.dcn_0l);location="back", quotes=false),"   Cn slope for zero lift (dimensionless)")
    push!(lines, line)
    line = string(formatword(string(aerodata.cn_stall_positive);location="back", quotes=false),"   Cn extrapolated to value at positive stall angle of attack")
    push!(lines, line)
    line = string(formatword(string(aerodata.cn_stall_negative);location="back", quotes=false),"   Cn at stall value for negative angle of attack")
    push!(lines, line)
    line = string(formatword(string(aerodata.aoa_mincd);location="back", quotes=false),"   Angle of attack for minimum CD (deg)")
    push!(lines, line)
    line = string(formatword(string(aerodata.cd_min);location="back", quotes=false),"   Minimum CD value")
    push!(lines, line)
    Polar = hcat(aerodata.aoa, aerodata.cl, aerodata.cd, aerodata.cm)
    line = formatcoordinates(Polar)
    # println(line)
    # println(aerodata.Polar)
    append!(lines, line)

    ### Write lines to file
    fi = open(outputpath*"/"*outputfile,"w+")
    i = 1
    for i = 1:length(lines)-1
         write(fi,lines[i])
         write(fi,"\n")
    end
    write(fi,lines[end])
    close(fi)
end

"""
    write_addriver(addriver, outputfile;outputpath=pwd())

Writes the desired AD driver file at the stated location. 

### Inputs 
- addriver - the AD driver file
- outputfile::String - The name of the file, containing the file ending.
- outputpath::String - the location to write the file

### No Outputs, but a file will be written
"""
function write_addriver(addriver::ADDriver, outputfile::String; outputpath::String=pwd())
    lines = []
    line = string("-"^7, " AeroDyn Driver v1.00.x Input File ", "-"^37)
    push!(lines, line)

    line = addriver.notes
    push!(lines, line)

    line = string("="^7, "  General Options  ", "="^30)
    push!(lines, line)

    line = string(formatword(addriver.echo;quotes=false),"   Echo               -   Echo the input to \"<rootname>.ech\"?  (flag)")
    push!(lines, line)

    line = string(formatword(addriver.ad_inputfile;quotes=true,desiredlength=length(addriver.ad_inputfile)+5),"   AD_InputFile    -  Name of the primary AeroDyn input file")
    push!(lines, line)

    line = string("-"^7, " Turbine Data ", "-"^30)
    push!(lines, line)

    line = string(formatword(string(addriver.numblades);location="back", quotes=false)  , "   NumBlades       - Number of blades (-)")
    push!(lines, line)

    line = string(formatword(string(addriver.hubrad);location="back", quotes=false),    "   HubRad          - Hub radius (m)")
    push!(lines, line)

    line = string(formatword(string(addriver.hubht);location="back", quotes=false),     "   HubHt           - Hub height (m)")
    push!(lines, line)

    line = string(formatword(string(addriver.overhang);location="back", quotes=false)   , "   Overhang        - Overhang (m)")
    push!(lines, line)

    line = string(formatword(string(addriver.shfttilt);location="back", quotes=false)   , "   ShftTilt        - Shaft tilt (deg)")
    push!(lines, line)

    line = string(formatword(string(addriver.precone);location="back", quotes=false),   "   Precone         - Blade precone (deg)")
    push!(lines, line)

    line = string("-"^7, " I/O Settings ", "-"^30)
    push!(lines, line)

    line = string(formatword(addriver.outfileroot;quotes=true, desiredlength=length(addriver.outfileroot)+5),"   OutFileRoot     -   Root name for any output files (use \"\" for .dvr rootname) (-)")
    push!(lines, line)

    line = string(formatword(addriver.tabdel;quotes=false),"   TabDel          - When   generating formatted output (OutForm=True), make output tab-delimited     (fixed-width otherwise) (flag)")
    push!(lines, line)

    line = string(formatword(addriver.outfmt;quotes=true),"   OutFmt          -    Format used for text tabular output, excluding the time channel.  Resulting field  should be 10 characters. (quoted string)")
    push!(lines, line)

    line = string(formatword(addriver.beep;quotes=false),"   Beep            - Beep     on exit (flag)")
    push!(lines, line)

    line = string("-"^7, "  Combined-Case Analysis  ", "-"^30)
    push!(lines, line)

    line = string(formatword(string(addriver.numcases);location="back", quotes=false)   , "   NumCases        - Number of cases to run")
    push!(lines, line)

    line = "WndSpeed       ShearExp       RotSpd        Pitch               Yaw           dT             Tmax"
    push!(lines, line)

    line = "(m/s)            (-)          (rpm)         (deg)               (deg)          (s)            (s)"
    push!(lines, line)

    WindData = hcat(addriver.windspeed, addriver.shearexp, addriver.rpm, addriver.pitch, addriver.yaw, addriver.dt, addriver.tmax)
    line = formatmatrix(WindData)
    append!(lines, line)

    #Write lines to file
    fi = open(outputpath*"/"*outputfile,"w+")
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
    CreateAD15(Blades, Foils; Notes = "Notes on what this Aerodyn File is.", Echo="False",
DTAero="default", WakeMod=1,
AFAeroMod=2, TwrPotent=1, TwrShadow="False", TwrAero="True", FrozenWake="False",
CavitCheck="False", CompAA="False", AA_InputFile="unused", AirDens=1.225, KinVisc=1.464e-5, SpdSound = 335.0, Patm=103500,
Pvap=1700, FluidDepth=0.5, SkewMod=2, SkewModFactor="\"default\"", TipLoss="True",
HubLoss="True", TanInd="True", AIDrag="False", TIDrag="False", IndToler="default",
MaxIter=100, DBEMT_Mod=2, tau1_const=4, OLAFInputFileName="unused", UAMod=3, FLookup="True", AFTabMod=1,
InCol_Alfa=1, InCol_Cl=2, InCol_Cd=3, InCol_Cm=4, InCol_Cpmin=0, UseBlCm="True",
TwrNds=zeros(1,3), SumPrint="False", NBlOuts=0, BlOutNd=[0], NTwOuts=0, TwOutNd=[0],
Outlist=String[], BldNd_BladesOut=0, BldNd_BlOutNd=[], NodeOutlist=String[]) 

### Inputs::
- Blades::Array{String, 1} - an array containing the names of the blade files
- foils::Array{String, 1} - an array containing the names of airfoils to be used. 

### Outputs:
- ad15file::AD15file - the AeroDyn v15 input file object
"""
function create_adfile(Blades, Foils; Notes = "Notes on what this Aerodyn File is.", Echo="False",
    DTAero="default", WakeMod=1,
    AFAeroMod=2, TwrPotent=1, TwrShadow="False", TwrAero="True", FrozenWake="False",
    CavitCheck="False", CompAA="False", AA_InputFile="unused", AirDens=1.225, KinVisc=1.464e-5, SpdSound = 335.0, Patm=103500,
    Pvap=1700, FluidDepth=0.5, SkewMod=2, SkewModFactor="default", TipLoss="True",
    HubLoss="True", TanInd="True", AIDrag="False", TIDrag="False", IndToler="default",
    MaxIter=100, DBEMT_Mod=2, tau1_const=4, OLAFInputFileName="unused", UAMod=3, FLookup="True", AFTabMod=1,
    InCol_Alfa=1, InCol_Cl=2, InCol_Cd=3, InCol_Cm=4, InCol_Cpmin=0, UseBlCm="True",
    TwrNds=zeros(1,3), SumPrint="False", NBlOuts=0, BlOutNd=[0], NTwOuts=0, TwOutNd=[0],
    Outlist=String[], BldNd_BladesOut=0, BldNd_BlOutNd=[], NodeOutlist=String[]) 

    NumAFfiles=length(Foils)
    if NumAFfiles==0
     error("Too few airfoils included in AD15 file. - CreateAD15")
    end

    for i=1:NumAFfiles
     temp = "Foil $i"
     push!(directory, temp)
    end

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

    file = ADfile(directory, Notes, Echo, DTAero, WakeMod, AFAeroMod, TwrPotent, TwrShadow, TwrAero, FrozenWake, CavitCheck, CompAA, AA_InputFile, AirDens, KinVisc, SpdSound, Patm, Pvap, FluidDepth, SkewMod, SkewModFactor, TipLoss, HubLoss, TanInd, AIDrag, TIDrag, IndToler, MaxIter, DBEMT_Mod, tau1_const, OLAFInputFileName, UAMod, FLookup, AFTabMod, InCol_Alfa, InCol_Cl, InCol_Cd, InCol_Cm, InCol_Cpmin, NumAFfiles, Foils, UseBlCm, Blades, NumTwrNds, TwrNds, SumPrint, NBlOuts, BlOutNd, NTwOuts, TwOutNd, Outlist, BldNd_BladesOut, BldNd_BlOutNd, NodeOutlist)
    return file
end

"""
    CreateAD15Blade(rads, radschords, radstwists, radscones, radsconeangs, radssweeps, radsafid, tiprad, hubrad, cylinderrad, airfoilrad; importantrads=[], notes="This is a turbine.", verbose=true)

Takes the iodenputs and creats a adblade struct. Note that this is a file that mainly contains nodes that describe the turbine blade to AeroDyn. At each node the distance from the hub will be given; the chord length, twist, cone distance, cone angle, sweep, and airfoil will also be given. 

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
    radsafid = nametonumber(radsafid) #.-1 #TODO. Why do a subtract one here? 
    # I was subtracting one to deal with the whole transition region thing, which isn't very general. So I need a general solution, then form to that. 
    # I can only assume that I resolved the issue. 

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
    locs = blrads.+0.508 #The rads location of the blrads nodes #Todo: What is this 0.508? This looks like a hard coded thing.... which should probably be hub radius. 
    n = length(blrads)
    precone = conefit.(locs)
    sweep = sweepfit.(locs)
    preconeangle = coneangfit.(locs)
    twist = twistfit.(locs)
    twist = twist.+(-twist[end]+pitch) #Correct twist to OpenFAST input style,  including blade pitch
    chords = chordfit.(locs)
    afid = integerfit(rads, radsafid, locs)

    adblade = ADBlade(notes, n, blrads, precone, sweep,  preconeangle, twist, chords, afid)  

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

### Inputs:
- Polar::Array{Float64, 2} - nx4 array of the airfoil coefficients in order of aoa, cl, cd, cm
- Re::Float64 - Reynolds number of the airfoil polar
- NumCoords::String - file containing the coordinate file ("@\"s809_coords.dat\"")

### Outputs: 
- airfoilinput::AirfoilInput - an airfoil input file object. 
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

export make_dsairfoil

function make_dsairfoil(afi::AirfoilInputUnsteady; radians=false, zeta=-3, separationpointfun::Symbol=:Fit) 
    if radians || maximum(afi.aoa)<=pi
        aoa = afi.aoa
    else
        aoa = afi.aoa.*(pi/180)
    end
    polar = hcat(aoa, afi.cl, afi.cd, afi.cm)

    cl = Akima(polar[:,1], polar[:,2])
    cd = Akima(polar[:,1], polar[:,3])
    cm = Akima(polar[:,1], polar[:,4])

    dcldalpha = afi.c_nalpha #TODO: Is this in the correct units? I think it is. It's close to 2pi. -> It appears that the input file wants it in radians, as we want. 
    alpha0 = afi.alpha0*(pi/180)
    alphasep = sort([afi.alpha2, afi.alpha1].*(pi/180))

    A = [afi.a1, afi.a2]
    b = [afi.b1, afi.b2]
    T = [afi.t_p, afi.t_f0, afi.t_v0, afi.t_vl]

    # 
    if separationpointfun==:Fit
        sfun = DS.ADFSP(polar, alpha0, alphasep, dcldalpha)

    elseif separationpointfun==:Fun
        S = [afi.s1, afi.s2, afi.s3, afi.s4]
        sfun = DS.ADSP(S)

    else
        @warn("make_dsairfoil() only acts on a :Fit or :Fun argument for calculating the separation point. Returning to default (:Fit).")
        sfun = DS.ADFSP(polar, alpha0, alphasep, dcldalpha)

    end

    xcp = afi.x_cp_bar

    airfoil = DS.Airfoil(polar, cl, cd, cm, dcldalpha, alpha0, alphasep, A, b, T, sfun, xcp)

    A5 = afi.a5
    b5 = afi.b5
    Tsh = afi.st_sh
    eta = afi.eta_e
    constants = [zeta, A5, b5, Tsh, eta]

    return airfoil, constants
end
