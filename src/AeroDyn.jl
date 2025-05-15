
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
struct AirfoilInputSteady{TS, TI, TF, TB, TSI} <: AirfoilInput
    interpord::TI
    nondimarea::TF
    numcoords::TSI
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

function create_cylinder(cd; aoa=collect(-180.:1:180), interpord="Default", nondimarea=1.0, numcoords="cylinder.dat", bl_file="cylinder.dat", numtabs=1, re=1.0, userprop=0, incluadata=false)
    cl = zeros(length(aoa))
    cd = ones(length(aoa)).*cd
    cm = zeros(length(aoa))

    interpord = isa(interpord, String) ? 3 : interpord

    return AirfoilInputSteady(interpord, nondimarea, numcoords, bl_file, numtabs, re, userprop, incluadata, length(aoa), aoa, cl, cd, cm)
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

function mimic_unsteady_airfoil(file, aoa, cl, cd, cm; alpha0range=(-7, 7), alpha1range=(0, 45), alpha2range=(-45,0), bl_file=nothing, numcoords=nothing)
    numalf = length(aoa)

    af = read_airfoilinput(file)

    interpord = af.interpord
    nondimarea = af.nondimarea
    
    if bl_file == nothing
        numcoords = af.numcoords
        bl_file = af.bl_file
    end
    
    numtabs = af.numtabs
    re = af.re
    userprop = af.userprop
    incluadata = af.incluadata

    clfit = Akima(aoa, cl)
    xstar, _ = brent(clfit, alpha0range[1], alpha0range[2])
    alpha0 = xstar

    idx_alpha1_start = argmin(abs.(aoa .- alpha1range[1]))
    idx_alpha1_end = argmin(abs.(aoa .- alpha1range[2]))
    # @show idx_alpha1_start, idx_alpha1_end
    alpha1 = aoa[argmax(cl[idx_alpha1_start:idx_alpha1_end])+idx_alpha1_start-1]

    idx_alpha2_start = argmin(abs.(aoa .- alpha2range[1]))
    idx_alpha2_end = argmin(abs.(aoa .- alpha2range[2]))
    # @show idx_alpha2_start, idx_alpha2_end
    alpha2 = aoa[argmin(cl[idx_alpha2_start:idx_alpha2_end])+idx_alpha2_start-1]

    eta_e = af.eta_e
    c_nalpha = af.c_nalpha
    t_f0 = af.t_f0
    t_v0 = af.t_v0
    t_p = af.t_p
    t_vl = af.t_vl
    b1 = af.b1
    b2 = af.b2
    b5 = af.b5
    a1 = af.a1
    a2 = af.a2
    a5 = af.a5
    s1 = af.s1
    s2 = af.s2
    s3 = af.s3
    s4 = af.s4
    cn1 = af.cn1
    cn2 = af.cn2
    st_sh = af.st_sh

    cdfit = Akima(aoa, cd)
    cd0 = cdfit(alpha0)

    cmfit = Akima(aoa, cm)
    cm0 = cmfit(alpha0)

    k0 = af.k0
    k1 = af.k1
    k2 = af.k2
    k3 = af.k3
    k1_hat = af.k1_hat
    x_cp_bar = af.x_cp_bar
    uacutout = af.uacutout
    filtcutoff = af.filtcutoff

    return AirfoilInputUnsteady(interpord, nondimarea, numcoords, bl_file, numtabs, re, userprop, incluadata, alpha0, alpha1, alpha2, eta_e, c_nalpha, t_f0, t_v0, t_p, t_vl, b1, b2, b5, a1, a2, a5, s1, s2, s3, s4, cn1, cn2, st_sh, cd0, cm0, k0, k1, k2, k3, k1_hat, x_cp_bar, uacutout, filtcutoff, numalf, aoa, cl, cd, cm)
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

Reads in AeroDyn input file and stores the options as a dictionary.

**Inputs**: 
- filename::String - The name of the file. 
- filepath::String - the path to the file. 

**Outputs**: 
- adfile::Dict() - a dictionary using the variable names as strings for keys, and the variable as the value. 

"""
function read_adfile(filename, filepath)
    
    fi = open(joinpath(filepath, filename), "r")
    lines = readlines(fi)
    close(fi)

    lines = cleanfile!(lines)

    adfile = Dict()
    adfile["Notes"] = lines[1]

    for i = 2:50
        key, entry = parseline(lines[i])
        adfile[key] = entry
    end

    adfile["AFNames"] = readlist(lines[51:51+Int(adfile["NumAFfiles"])-1]) 

    idx = 51+Int(adfile["NumAFfiles"])
    
    for i = idx:idx+13
        key, entry = parseline(lines[i])
        adfile[key] = entry
    end

    idx = idx+13

    twrnames, twrdata = parsematrix(lines[idx+1:idx+1+2+Int(adfile["NumTwrNds"])-1])

    #Todo: The parsematrix function only works when there aren't comments interjected in the header of the function.... :| I might need to come up with an alternate function. :| ... At least when it comes to getting the length of the matrix I'm trying to read. 
    for i = 1:5 #length(twrnames)
        adfile[twrnames[i]*("_mat")] = twrdata[:,i]
    end


    ### Outputs section
    idx = idx+1+2+Int(adfile["NumTwrNds"])

    for i = idx:idx+4
        key, entry = parseline(lines[i])
        adfile[key] = entry
    end

    outlist1idx = findlistbounds(lines[idx+5:end]) 

    outputs = readlist(lines[idx+5:idx+5+outlist1idx[end]-1])
    adfile["OutList"] = outputs

    idx = idx+5+outlist1idx[end]


    ### Nodal outputs #todo: I've encountered some files that don't have this section. Maybe have some behavior to adapt? (I don't know if OpenFAST errors if this section isn't present.)
    for i = idx:idx+1 
        key, entry = parseline(lines[i])
        adfile[key] = entry
    end

    outlist2idx = findlistbounds(lines[idx+2:end])
    outlist = readlist(lines[idx+2:idx+2+outlist2idx[end]-1])
    adfile["NodeOutList"] = outlist

    return adfile
end

"""
    read_adblade(filename, filepath)

This function navigates to the location of the file given, and reads in the named AD blade file.

**Inputs**:
    filename - A string of the name of the file, including the extension
    filepath - A string of the path to the file

**Outputs**: 
    adblade - a dictionary of the AD blade file variables

"""
function read_adblade(filename, filepath)
    fi = open(joinpath(filepath,filename), "r")
    lines = readlines(fi)
    close(fi)

    lines = cleanfile!(lines)

    adblade = Dict()
    adblade["Notes"] = lines[1]

    key, entry = parseline(lines[2])
    adblade[key] = entry

    bladenames, bladedata = parsematrix(lines[3:3+2+Int(adblade["NumBlNds"])-1])

    for i = 1:length(bladenames)
        adblade[bladenames[i]] = bladedata[:,i]
    end
    return adblade
end

"""
    read_aerodata(filename, filepath)

This function reads in the information from an aerodata file, including the polars
from the Aerodata folder. Note that currently you have to point it at the correct
file.

**Inputs**: 
- filename::String - The name of the file to be read
- filepath::String - the relative or absolute path to the file location. 

**Outputs**:
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

**Inputs**:
- filename::String - The name of the file
- filepath::String - the relative or absolute path to the file.

**Outputs**:
- airfoilinput::AirfoilInput

"""
function read_airfoilinput(filename) #(filename, filepath) #Todo: 
    
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

**Inputs**: 
- filename::String - The name of the file
- filepath::String - the relative or absolute path to the file. 

**Outputs**:
- airfoil::AirfoilCoords

"""
function read_airfoilcoordinates(filename, filepath) #Todo: Convert to something else. 
    fi = open(filepath*"/"*filename, "r") #Todo: joinpath
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

**Inputs** 
- filename::String - The name of the file in the directory to be read. 
- filepath::String - The path to the file to be read, not including the filename in the path

**Outputs**
- addriver - a dictionary containing the AD driver file entries

### Notes
- Note that the reading function moves you to the directory of the file to be read. 
"""
function read_addriver(filename::String, filepath::String) 

    fi = open(filepath*"/"*filename, "r")
    lines = readlines(fi)
    close(fi)

    lines = cleanfile!(lines)

    addriver = Dict()
    addriver["Notes"] = lines[1]
    for i = 2:38
        key, entry = parseline(lines[i])
        addriver[key] = entry
    end

    windnames, winddata = parsematrix(lines[39:41+Int(addriver["NumCases"])-1])

    for i = 1:length(windnames)
        addriver[windnames[i]*"_mat"] = winddata[:,i]
    end

    idx = 41+Int(addriver["NumCases"])
    for i = idx:length(lines)
        key, entry = parseline(lines[i])
        addriver[key] = entry
    end

    return addriver
end




##############################################################
############# WRITING FUNCTIONS ##############################
##############################################################

"""
    write_adfile(adfile::ADfile, outputfile::string; outputpath::String=pwd())

Writes a AeroDyn v15 object to file. 

**Inputs**:
- adfile::ADfile - an AeroDyn file object
- outputfile::String - the desired name of the written file
- outputpath::String - the desired relative or absolute path of the written file.
"""
function write_adfile(adfile::Dict, outputfile::String; outputpath::String=pwd()) 

    lines = String[]
    line = string("-"^7, " AERODYN v15 for OpenFAST INPUT FILE ", "-"^47)
    push!(lines,line)
    push!(lines, adfile["Notes"])

    ########################################################################
    line = string("="^6, "  General Options  ", "="^76)
    push!(lines, line)

    line = string(formatword(adfile["Echo"];quotes=false),"   Echo               - Echo the input to \"<rootname>.AD.ech\"?  (flag)")
    push!(lines, line)

    line = string(formatword(adfile["DTAero"];quotes=false, location="back"),"   DTAero             - Time interval for aerodynamic calculations {or \"default\"} (s)")
    push!(lines, line)

    line = string(formatword(Int(adfile["Wake_Mod"]);location="back",quotes=false), "   Wake_Mod            - Type of wake/induction model (switch) {0=none, 1=BEMT, 2=DBEMT} [WakeMod cannot be 2 when linearizing]")
    push!(lines, line)

    # line = string(formatword(Int(adfile["AFAeroMod"]);location="back",quotes=false),"   AFAeroMod          - Type of blade airfoil aerodynamics model (switch) {1=steady model, 2=Beddoes-Leishman unsteady model} [AFAeroMod must be 1 when linearizing]")
    # push!(lines, line)

    line = string(formatword(Int(adfile["TwrPotent"]);location="back",quotes=false),"   TwrPotent          - Type tower influence on wind based on potential flow around the tower (switch) {0=none, 1=baseline potential flow, 2=potential flow with Bak correction}")
    push!(lines, line)

    line = string(formatword(Int(adfile["TwrShadow"]);quotes=false, location="back"), "   TwrShadow          - Calculate tower influence on wind based on downstream tower shadow? (flag)")
    # line = string(formatword(adfile["TwrShadow"];quotes=false, location="back"), "   TwrShadow          - Calculate tower influence on wind based on downstream tower shadow? (flag)")
    push!(lines,line)

    line = string(formatword(adfile["TwrAero"];quotes=false), "   TwrAero            - Calculate tower aerodynamic loads? (flag)")
    push!(lines, line)

    # line = string(formatword(adfile["FrozenWake"];quotes=false), "   FrozenWake         - Assume frozen wake during linearization? (flag) [used only when WakeMod=1 and when linearizing]")
    # push!(lines, line)

    line = string(formatword(adfile["CavitCheck"];quotes=false), "   CavitCheck         - Perform cavitation check? (flag) [AFAeroMod must be 1 when CavitCheck=true]")
    push!(lines, line)

    line = string(formatword(adfile["Buoyancy"];quotes=false), "   Buoyancy           - Include buoyancy effects? (flag)")
    push!(lines, line)

    line = string(formatword(adfile["NacelleDrag"];quotes=false), "   NacelleDrag        - Include nacelle drag effects? (flag)")
    push!(lines, line)

    line = string(formatword(adfile["CompAA"];quotes=false), "   CompAA             - Flag to compute AeroAcoustics calculation [only used when WakeMod=1 or 2]")
    push!(lines, line)

    line = string(formatword(adfile["AA_InputFile"], quotes=false,desiredlength=length(adfile["AA_InputFile"])+5), " AA_InputFile       - Aeroacoustics input file")
    push!(lines, line)




    #######################################################################
    line = string("="^6, "  Environmental Conditions  ", "="^67)
    push!(lines, line)

    line = string(formatword(string(adfile["AirDens"]);location="back", quotes=false), "   AirDens            - Air density (kg/m^3)")
    push!(lines, line)

    line = string(formatword(string(adfile["KinVisc"]);location="back", quotes=false), "   KinVisc            - Kinematic air viscosity (m^2/s)")
    push!(lines, line)

    line = string(formatword(string(adfile["SpdSound"]);location="back", quotes=false), "   SpdSound           - Speed of sound (m/s)")
    push!(lines, line)

    line = string(formatword(string(adfile["Patm"]);location="back", quotes=false), "   Patm               - Atmospheric pressure (Pa) [used only when CavitCheck=True]")
    push!(lines, line)

    line = string(formatword(string(adfile["Pvap"]);location="back", quotes=false), "   Pvap               - Vapour pressure of fluid (Pa) [used only when CavitCheck=True]")
    push!(lines, line)





    ########################################################################
    line = string("="^6, "  Blade-Element/Momentum Theory Options  ", "="^54)
    push!(lines, line)

    line = string(formatword(Int(adfile["BEM_Mod"]);location="back", quotes=false), "   BEM_Mod     - BEM model {1=legacy NoSweepPitchTwist, 2=polar} (switch) [used for all Wake_Mod to determine output coordinate system]")
    push!(lines, line)


    ###### 
    line = "--- Skew correction"
    push!(lines, line)

    line = string(formatword(Int(adfile["Skew_Mod"]);location="back", quotes=false), "   Skew_Mod            - Type of skewed-wake correction model (switch) {1=uncoupled, 2=Pitt/Peters, 3=coupled} [unused when WakeMod=0]")
    push!(lines, line)

    line = string(formatword(adfile["SkewMomCorr"];location="back", quotes=false), "   SkewMomCorr - Turn the skew momentum correction on or off [used only when Skew_Mod=1]")
    push!(lines, line)

    line = string(formatword(Int(adfile["SkewRedistr_Mod"]);location="back", quotes=false), "   SkewRedistr_Mod - Type of skewed-wake correction model (switch) {0=no redistribution, 1=Glauert/Pitt/Peters, default=1} [used only when Skew_Mod=1]")
    push!(lines, line)

    line = string(formatword(adfile["SkewRedistrFactor"];location="back", quotes=false), "   SkewRedistrFactor - Constant used in Pitt/Peters skewed wake model {or \"default\" is 15/32*pi} (-) [used only when Skew_Mod=1 and SkewRedistr_Mod=1]")
    push!(lines, line)

    # line = string(formatword(adfile["SkewModFactor"]; location="back", quotes=false), "   SkewModFactor      - Constant used in Pitt/Peters skewed wake model {or \"default\" is 15/32*pi} (-) [used only when SkewMod=2; unused when WakeMod=0]")
    # push!(lines, line)

    ### BEM Algorithm
    line = "--- BEM Algorithm"
    push!(lines, line)

    line = string(formatword(adfile["TipLoss"]; quotes=false), "   TipLoss            - Use the Prandtl tip-loss model? (flag) [unused when WakeMod=0]")
    push!(lines, line)

    line = string(formatword(adfile["HubLoss"]; quotes=false), "   HubLoss            - Use the Prandtl hub-loss model? (flag) [unused when WakeMod=0]")
    push!(lines, line)

    line = string(formatword(adfile["TanInd"];quotes=false), "   TanInd             - Include tangential induction in BEMT calculations? (flag) [unused when WakeMod=0]")
    push!(lines, line)

    line = string(formatword(adfile["AIDrag"];quotes=false), "   AIDrag             - Include the drag term in the axial-induction calculation? (flag) [unused when WakeMod=0]")
    push!(lines, line)

    line = string(formatword(adfile["TIDrag"];quotes=false), "   TIDrag             - Include the drag term in the tangential-induction calculation? (flag) [unused when WakeMod=0 or TanInd=FALSE]")
    push!(lines, line)

    line = string(formatword(adfile["IndToler"]; quotes=false, location="back"), "   IndToler           - Convergence tolerance for BEMT nonlinear solve residual equation {or \"default\"} (-) [unused when WakeMod=0]")
    push!(lines, line)

    line = string(formatword(Int(adfile["MaxIter"]);location="back", quotes=false), "   MaxIter            - Maximum number of iteration steps (-) [unused when WakeMod=0]")
    push!(lines, line)


    ### Shear correction
    line = "--- Shear correction"
    push!(lines, line)

    line = string(formatword(adfile["SectAvg"];location="back", quotes=false), "   SectAvg     - Use sector averaging (flag)")
    push!(lines, line)

    line = string(formatword(Int(adfile["SectAvgWeighting"]);location="back", quotes=false), "   SectAvgWeighting - Weighting function for sector average {1=Uniform, default=1} within a sector centered on the blade (switch) [used only when SectAvg=True]")
    push!(lines, line)

    line = string(formatword(adfile["SectAvgNPoints"];location="back", quotes=false), "   SectAvgNPoints - Number of points per sectors (-) {default=5} [used only when SectAvg=True]")
    push!(lines, line)

    line = string(formatword(adfile["SectAvgPsiBwd"];location="back", quotes=false), "   SectAvgPsiBwd - Backward azimuth relative to blade where the sector starts (<=0) {default=-60} (deg) [used only when SectAvg=True]")
    push!(lines, line)

    line = string(formatword(adfile["SectAvgPsiFwd"];location="back", quotes=false), "   SectAvgPsiFwd - Forward azimuth relative to blade where the sector ends (>=0) {default=60} (deg) [used only when SectAvg=True]")
    push!(lines, line)


    ### Dynamic wake/inflow
    line = "--- Dynamic wake/inflow"
    push!(lines, line)

    #####################################################################
    # line = string("="^6, "  Dynamic Blade-Element/Momentum Theory Options  ", "="^46)
    # push!(lines, line)

    line = string(formatword(Int(adfile["DBEMT_Mod"]);location="back", quotes=false), "   DBEMT_Mod          - Type of dynamic BEMT (DBEMT) model {1=constant tau1, 2=time-dependent tau1} (-) [used only when WakeMod=2]")
    push!(lines, line)

    line = string(formatword(adfile["tau1_const"];location="back", quotes=false), "   tau1_const         - Time constant for DBEMT (s) [used only when WakeMod=2 and DBEMT_Mod=1]")
    push!(lines, line)


    #########################################################################
    line = string("="^6, "   OLAF -- cOnvecting LAgrangian Filaments (Free Vortex Wake) Theory Options", "="^46)
    push!(lines, line)

    line = string(formatword(adfile["OLAFInputFileName"]), "   OLAFInputFileName - Input file for OLAF [used only when WakeMod=3]")
    push!(lines, line)



    ###########################################################################
    line = string("="^6, "  Unsteady Airfoil Aerodynamics Options  ", "="^37)
    push!(lines, line)

    line = string(formatword(adfile["AoA34"];location="back", quotes=false), "   AoA34       - Sample the angle of attack (AoA) at the 3/4 chord or the AC point {default=True} [always used]")
    push!(lines, line)

    line = string(formatword(Int(adfile["UA_Mod"]);location="back", quotes=false), "   UA_Mod              - Unsteady Aero Model Switch (switch) {1=Baseline model (Original), 2=Gonzalez's variant (changes in Cn,Cc,Cm), 3=Minemma/Pierce variant (changes in Cc and Cm)} [used only when AFAeroMod=2]")
    push!(lines, line)

    line = string(formatword(adfile["FLookup"];quotes=false), "   FLookup            - Flag to indicate whether a lookup for f\' will be calculated (TRUE) or whether best-fit exponential equations will be used (FALSE); if FALSE S1-S4 must be provided in airfoil input files (flag) [used only when AFAeroMod=2]")
    push!(lines, line)

    line = string(formatword(Int(adfile["IntegrationMethod"]);quotes=false), "   IntegrationMethod  - Switch to indicate which integration method UA uses (1=RK4, 2=AB4, 3=ABM4, 4=BDF2)")
    push!(lines, line)

    line = string(formatword(adfile["UAStartRad"];quotes=false), "   UAStartRad         - Starting radius for dynamic stall (fraction of rotor radius) [used only when AFAeroMod=2; if line is missing UAStartRad=0]]")
    push!(lines, line)

    line = string(formatword(adfile["UAEndRad"];quotes=false), "   UAEndRad           - Ending radius for dynamic stall (fraction of rotor radius) [used only when AFAeroMod=2; if line is missing UAEndRad=1]")
    push!(lines, line)







    #############################################################################
    line = string("="^6, "  Airfoil Information ", "="^73)
    push!(lines, line)

    line = string(formatword(Int(adfile["AFTabMod"]);location="back", quotes=false), "   AFTabMod           - Interpolation method for multiple airfoil tables {1=1D interpolation on AoA (first table only); 2=2D interpolation on AoA and Re; 3=2D interpolation on AoA and UserProp} (-)")
    push!(lines, line)

    line = string(formatword(Int(adfile["InCol_Alfa"]);location="back", quotes=false), "   InCol_Alfa         - The column in the airfoil tables that contains the angle of attack (-)")
    push!(lines, line)

    line = string(formatword(Int(adfile["InCol_Cl"]);location="back", quotes=false), "   InCol_Cl           - The column in the airfoil tables that contains the lift coefficient (-)")
    push!(lines, line)

    line = string(formatword(Int(adfile["InCol_Cd"]);location="back", quotes=false), "   InCol_Cd           - The column in the airfoil tables that contains the drag coefficient (-)")
    push!(lines, line)

    line = string(formatword(Int(adfile["InCol_Cm"]);location="back", quotes=false), "   InCol_Cm           - The column in the airfoil tables that contains the pitching-moment coefficient; use zero if there is no Cm column (-)")
    push!(lines, line)

    line = string(formatword(Int(adfile["InCol_Cpmin"]);location="back", quotes=false), "   InCol_Cpmin        - The column in the airfoil tables that contains the Cpmin coefficient; use zero if there is no Cpmin column (-)")
    push!(lines, line)

    line = string(formatword(Int(adfile["NumAFfiles"]);location="back", quotes=false), "   NumAFfiles         - Number of airfoil files used (-)")
    push!(lines, line)

    line = string(formatword(adfile["AFNames"][1];desiredlength=length(adfile["AFNames"][1])+5, quotes=true), "AFNames            - Airfoil file names (NumAFfiles lines) (quoted strings)")
    push!(lines, line)

    for i=2:length(adfile["AFNames"])
       line = formatword(adfile["AFNames"][i]; desiredlength=length(adfile["AFNames"][i])+5, quotes=true)
       push!(lines,line)
    end






    ##################################################################
    line = string("="^6, "  Rotor/Blade Properties  ", "="^69)
    push!(lines,line)

    line = string(formatword(adfile["UseBlCm"];quotes=false), "   UseBlCm            - Include aerodynamic pitching moment in calculations?  (flag)")
    push!(lines,line)

    for i=1:3
       line = string(formatword(adfile["ADBlFile($i)"];desiredlength=length(adfile["ADBlFile($i)"])+2),"   ADBlFile($i)        - Name of file containing distributed aerodynamic properties for Blade #$i (-)")
       push!(lines, line)
    end


    ##################################################################
    line = string("="^6, "  Hub Properties  ", "="^69)
    push!(lines,line)

    line = string(formatword(adfile["VolHub"];quotes=false), "   VolHub             - Hub volume (m^3)")
    push!(lines,line)

    line = string(formatword(adfile["HubCenBx"];quotes=false), "   HubCenBx           - Hub center of buoyancy x direction offset (m)")
    push!(lines,line)



    ##################################################################
    line = string("="^6, "  Nacelle Properties  ", "="^69)
    push!(lines,line)

    line = string(formatword(adfile["VolNac"];quotes=false), "   VolNac             - Nacelle volume (m^3)")
    push!(lines,line)

    line = string(formatword(adfile["NacCenB"];quotes=false, desiredlength=15), "   NacCenB            - Position of nacelle center of buoyancy from yaw bearing in nacelle coordinates (m)")
    push!(lines,line)

    line = string(formatword(adfile["NacArea"];quotes=false, desiredlength=15), "   NacArea        - Projected area of the nacelle in X, Y, Z in the nacelle coordinate system (m^2)")
    push!(lines,line)

    line = string(formatword(adfile["NacCd"];quotes=false, desiredlength=15), "   NacCd          - Drag coefficient for the nacelle areas defined above (-)")
    push!(lines,line)

    line = string(formatword(adfile["NacDragAC"];quotes=false, desiredlength=15), "   NacDragAC          - Position of aerodynamic center of nacelle drag in nacelle coordinates (m)")
    push!(lines,line)



    ##################################################################
    line = string("="^6, "  Tail Fin Aerodynamics  ", "="^69)
    push!(lines,line)

    line = string(formatword(adfile["TFinAero"];quotes=false), "   TFinAero    - Calculate tail fin aerodynamics model (flag)")
    push!(lines,line)

    line = string(formatword(adfile["TFinFile"];quotes=false), "   TFinFile    - Input file for tail fin aerodynamics [used only when TFinAero=True]")
    push!(lines,line)



    ############################################################
    line = string("="^6, "  Tower Influence and Aerodynamics ", "="^61)
    push!(lines, line)

    line = string(formatword(Int(adfile["NumTwrNds"]);location="back",quotes=false), "   NumTwrNds         - Number of tower nodes used in the analysis  (-) [used only when TwrPotent/=0, TwrShadow=True, or TwrAero=True]")
    push!(lines, line)

    line = "TwrElev        TwrDiam        TwrCd          TwrTI      TwrCb"
    push!(lines, line)

    line = "(m)            (m)            (-)            (-)            (-)"
    push!(lines, line)

    line = formatmatrix(hcat(adfile["TwrElev_mat"], adfile["TwrDiam_mat"], adfile["TwrCd_mat"], adfile["TwrTI_mat"], adfile["TwrCb_mat"]))
    append!(lines,line)





    ###########################################################################
    line = string("="^6, "  Outputs  ", "="^84)
    push!(lines, line)

    line = string(formatword(adfile["SumPrint"];quotes=false), "   SumPrint            - Generate a summary file listing input options and interpolated properties to \"<rootname>.AD.sum\"?  (flag)")
    push!(lines, line)

    line = string(formatword(Int(adfile["NBlOuts"]);location="back",quotes=false), "   NBlOuts             - Number of blade node outputs [0 - 9] (-)")
    push!(lines, line)

    if adfile["NBlOuts"]>0
       line = formatvector(Int.(adfile["BlOutNd"]), desiredlength=4)
    else
       line = string(" "^11, 1)
    end
    line = string(line, "   BlOutNd             - Blade nodes whose values will be output  (-)")
    push!(lines, line)

    line = string(formatword(Int(adfile["NTwOuts"]);location="back",quotes=false), "   NTwOuts             - Number of tower node outputs [0 - 9]  (-)")
    push!(lines, line)

    if length(adfile["TwOutNd"])>0
        line = formatvector(Int.(adfile["TwOutNd"])) #doesn't need a push because I combine on the next line. 
    else
        line = string("   ", 1)
    end
    line = string(line, "   TwOutNd             - Tower nodes whose values will be output  (-)")
    push!(lines, line)

    line = "                   OutList             - The next line(s) contains a list of output parameters.  See s for a listing of available output channels, (-)"
    push!(lines, line)

    for i=1:length(adfile["OutList"])
       line = formatword(adfile["OutList"][i]; quotes=true, desiredlength=length(adfile["OutList"][i])+2)
       push!(lines,line)
    end

    line = "END of input file (the word \"END\" must appear in the first 3 columns of this last OutList line)"
    push!(lines,line)




    ########################################################################
    line = "---------------------- NODE OUTPUTS --------------------------------------------"
    push!(lines, line)

    line = string(formatword(Int(adfile["BldNd_BladesOut"]);location="back",quotes=false), "   BldNd_BladesOut  - Blades to output")
    push!(lines, line)

    if adfile["BldNd_BladesOut"]>0
        line = eltype(adfile["BldNd_BlOutNd"]) <: Number ? formatvector(Int.(adfile["BldNd_BlOutNd"])) : formatword(adfile["BldNd_BlOutNd"]; quotes=false)
    else
        line = " "^11
    end
    line = string(line, "    BldNd_BlOutNd       - Future feature will allow selecting a portion of the nodes to output.  Not implemented yet. (-)")
    push!(lines, line)

    line = "                   OutList             - The next line(s) contains a list of output parameters.  See s for a listing of available output channels, (-)"
    push!(lines, line)
    
    for i=1:length(adfile["NodeOutList"])
       line = formatword(adfile["NodeOutList"][i]; quotes=true, desiredlength=length(adfile["NodeOutList"][i])+2)
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

**Inputs**:
- adblade::ADBlade - AeroDyn blade object
- outputfile::String - the desired name of the written file
- outputpath::String - the desired relative or absolute write location of the file. 
"""
function write_adblade(adblade::Dict, outputfile::String; outputpath::String=pwd())

    lines = String[]
    line = string("-"^7, " AERODYN v15.00.* BLADE DEFINITION INPUT FILE ", "-"^37)
    push!(lines, line)

    line = adblade["Notes"]
    push!(lines, line)

    line = string("="^6, "  Blade Properties ", "="^65)
    push!(lines, line)

    line = string(formatword(Int(adblade["NumBlNds"]);location="back", quotes=false),"   NumBlNds           - Number of blade nodes used in the analysis (-)")
    push!(lines, line)

    line = "  BlSpn        BlCrvAC        BlSwpAC        BlCrvAng       BlTwist        BlChord          BlAFID"
    push!(lines, line)

    line = "   (m)           (m)            (m)            (deg)         (deg)           (m)              (-)"
    push!(lines, line)

    BldProps = hcat(adblade["BlSpn"], adblade["BlCrvAC"], adblade["BlSwpAC"], adblade["BlCrvAng"], adblade["BlTwist"], adblade["BlChord"], adblade["BlAFID"])
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

**Inputs**: 
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
    line = ""
    push!(lines, line)


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

**Inputs**:
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

    line = string(formatword(string(airfoilinput.bl_file);location="front", quotes=false, desiredlength=length(airfoilinput.bl_file)+5), "   BL_file           ! The file name including the boundary layer characteristics of the profile. Ignored if the aeroacoustic module is not called.")
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
    write_aerodata(aerodata::Aerodata, outputfile::String; outputpath::String=pwd())

This function takes an aerodata structure and writes an output file for it.

**Inputs**: 
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

**Inputs** 
- addriver::Dict - the AD driver file
- outputfile::String - The name of the file, containing the file ending.
- outputpath::String - the location to write the file

### No Outputs, but a file will be written
"""
function write_addriver(addriver::Dict, outputfile::String; outputpath::String=pwd())
    lines = []
    line = string("-"^7, " AeroDyn Driver v1.00.x Input File ", "-"^37)
    push!(lines, line)

    line = addriver["Notes"]
    push!(lines, line)

    line = string("-"^7, "  Input Options  ", "-"^30)
    push!(lines, line)

    line = string(formatword(addriver["Echo"];quotes=false),"   Echo               -   Echo the input to \"<rootname>.ech\"?  (flag)")
    push!(lines, line)

    line = string(formatword(Int(addriver["MHK"]);quotes=false),"   MHK          - MHK turbine type (switch) {0: not an MHK turbine, 1: fixed MHK turbine, 2: floating MHK turbine}")
    push!(lines, line)

    line = string(formatword(Int(addriver["AnalysisType"]);quotes=false),"   AnalysisType - {1: multiple turbines, one simulation, 2: one turbine, one time-dependent simulation, 3: one turbine, combined cases}")
    push!(lines, line)

    line = string(formatword(addriver["TMax"];quotes=false),"   TMax         - Total run time [used only when AnalysisType/=3] (s)")
    push!(lines, line)

    line = string(formatword(addriver["DT"];quotes=false),"   DT           - Simulation time step [used only when AnalysisType/=3] (s)")
    push!(lines, line)

    line = string(formatword(addriver["AeroFile"];quotes=true,desiredlength=length(addriver["AeroFile"])+5),"   AeroFile    -  Name of the primary AeroDyn input file")
    push!(lines, line)


    ##########################################################################
    line = string("-"^7, " Environmental Data ", "-"^30)
    push!(lines, line)

    line = string(formatword(addriver["FldDens"];quotes=false),"   FldDens      - Density of working fluid (kg/m^3)")
    push!(lines, line)

    line = string(formatword(addriver["KinVisc"];quotes=false),"   KinVisc      - Kinematic viscosity of working fluid (m^2/s)")
    push!(lines, line)

    line = string(formatword(addriver["SpdSound"];quotes=false),"   SpdSound     - Speed of sound in working fluid (m/s)")
    push!(lines, line)

    line = string(formatword(addriver["Patm"];quotes=false),"   Patm         - Atmospheric pressure (Pa) [used only for an MHK turbine cavitation check]")
    push!(lines, line)

    line = string(formatword(addriver["Pvap"];quotes=false),"   Pvap         - Vapour pressure of working fluid (Pa) [used only for an MHK turbine cavitation check]")
    push!(lines, line)

    line = string(formatword(addriver["WtrDpth"];quotes=false),"   WtrDpth      - Water depth (m)")
    push!(lines, line)



    ##########################################################################
    line = string("-"^7, " Inflow Data ", "-"^30)
    push!(lines, line)

    line = string(formatword(Int(addriver["CompInflow"]);quotes=false),"   CompInflow  - Compute inflow wind velocities (switch) {0=Steady Wind; 1=InflowWind}")
    push!(lines, line)

    line = string(formatword(addriver["InflowFile"];quotes=true, desiredlength=length(addriver["InflowFile"])+5),"   InflowFile  - Name of the InflowWind input file [used only when CompInflow=1]")
    push!(lines, line)

    line = string(formatword(addriver["HWindSpeed"];quotes=false),"   HWindSpeed  - Horizontal wind speed   [used only when CompInflow=0 and AnalysisType=1] (m/s)")
    push!(lines, line)

    line = string(formatword(addriver["RefHt"];quotes=false),"   RefHt       - Reference height for horizontal wind speed [used only when CompInflow=0]  (m)")
    push!(lines, line)

    line = string(formatword(addriver["PLExp"];quotes=false),"   PLExp       - Power law exponent   [used only when CompInflow=0 and AnalysisType=1]   (-)")
    push!(lines, line)




    ######################################################################
    line = string("-"^7, " Turbine Data ", "-"^30)
    push!(lines, line)

    line = string(formatword(Int(addriver["NumTurbines"]);quotes=false),"   NumTurbines  - Number of turbines")
    push!(lines, line)


    
    ######################################################################

    for i = 1:Int(addriver["NumTurbines"])
        line = string("-"^7, " Turbine($i) Geometry ", "-"^30)
        push!(lines, line)

        line = string(formatword(string(addriver["BasicHAWTFormat($i)"]);location="back", quotes=false)  , "   BasicHAWTFormat($i) - Flag to switch between basic or generic input format {True: next 7 lines are basic inputs, False: Base/Twr/Nac/Hub/Bld geometry and motion must follow}")
        push!(lines, line)

        line = string(formatword(addriver["BaseOriginInit($i)"];location="back", quotes=false, desiredlength=18)  , "   BaseOriginInit($i) - Coordinate of tower base in base coordinates (m)")
        push!(lines, line)

        line = string(formatword(Int(addriver["NumBlades($i)"]);location="back", quotes=false),    "   NumBlades($i)    - Number of blades (-)")
        push!(lines, line)

        line = string(formatword(string(addriver["HubRad($i)"]);location="back", quotes=false),    "   HubRad($i)          - Hub radius (m)")
        push!(lines, line)

        line = string(formatword(string(addriver["HubHt($i)"]);location="back", quotes=false),     "   HubHt($i)           - Hub height (m)")
        push!(lines, line)

        line = string(formatword(string(addriver["Overhang($i)"]);location="back", quotes=false)   , "   Overhang($i)        - Overhang (m)")
        push!(lines, line)

        line = string(formatword(string(addriver["ShftTilt($i)"]);location="back", quotes=false)   , "   ShftTilt($i)        - Shaft tilt (deg)")
        push!(lines, line)

        line = string(formatword(string(addriver["Precone($i)"]);location="back", quotes=false),   "   Precone($i)         - Blade precone (deg)")
        push!(lines, line)

        line = string(formatword(string(addriver["Twr2Shft($i)"]);location="back", quotes=false),   "   Twr2Shft(1)     - Vertical distance from the tower-top to the rotor shaft (m)")
        push!(lines, line)

        #############################
        line = string("-"^7, "Turbine($i) Motion [used only when AnalysisType=1]", "-"^30)
        push!(lines, line)

        line = string(formatword(Int(addriver["BaseMotionType($i)"]);location="back", quotes=false),   "   BaseMotionType($i)      - Type of motion prescribed for this base {0: fixed, 1: Sinusoidal motion, 2: arbitrary motion} (flag)")
        push!(lines, line)

        line = string(formatword(Int.(addriver["DegreeOfFreedom($i)"]);location="back", quotes=false),   "   DegreeOfFreedom(1)     - {1:xt, 2:yt, 3:zt, 4:theta_xt, 5:theta_yt, 6:theta_zt} [used only when BaseMotionType=1] (flag)")
        push!(lines, line)

        line = string(formatword(string(addriver["Amplitude($i)"]);location="back", quotes=false),   "   Amplitude(1)           - Amplitude of sinusoidal motion   [used only when BaseMotionType=1] (m or rad)")
        push!(lines, line)

        line = string(formatword(string(addriver["Frequency($i)"]);location="back", quotes=false),   "   Frequency(1)           - Frequency of sinusoidal motion   [used only when BaseMotionType=1] (Hz)")
        push!(lines, line)

        line = string(formatword(string(addriver["BaseMotionFileName($i)"]);location="back", quotes=true, desiredlength=length(addriver["BaseMotionFileName($i)"])+5),   "   BaseMotionFileName($i)  - Filename containing arbitrary base motion (19 columns: Time, x, y, z, theta_x, ..., alpha_z)  [used only when BaseMotionType=2]")
        push!(lines, line)

        line = string(formatword(string(addriver["NacYaw($i)"]);location="back", quotes=false),   "   NacYaw(1)              - Yaw angle (about z_t) of the nacelle (deg)")
        push!(lines, line)

        line = string(formatword(string(addriver["RotSpeed($i)"]);location="back", quotes=false),   "   RotSpeed(1)            - Rotational speed of rotor in rotor coordinates (rpm)")
        push!(lines, line)

        line = string(formatword(string(addriver["BldPitch($i)"]);location="back", quotes=false),   "   BldPitch(1)            - Blade 1 pitch (deg)")
        push!(lines, line)

    end


    



    #############################
    line = string("-"^7, "Time-dependent Analysis [used only when AnalysisType=2, numTurbines=1]", "-"^30)
    push!(lines, line)

    line = string(formatword(string(addriver["TimeAnalysisFileName"]);location="back", quotes=true, desiredlength=length(addriver["TimeAnalysisFileName"])+5),   "   TimeAnalysisFileName - Filename containing time series (6 column: Time, HWndSpeed, PLExp, RotSpd, Pitch, Yaw). ")
    push!(lines, line)






    ##############################################################################
    line = string("-"^7, "  Combined-Case Analysis [used only when AnalysisType=3, numTurbines=1 ", "-"^30)
    push!(lines, line)

    line = string(formatword(string(addriver["NumCases"]);location="back", quotes=false),   "   NumCases     - Number of cases to run")
    push!(lines, line)

    line = "HWndSpeed  PLExp  RotSpd  Pitch   Yaw   dT    Tmax  DOF  Amplitude Frequency "
    push!(lines, line)

    line = "(m/s)      (-)    (rpm)   (deg)  (deg)  (s)   (s)   (-)   (-)       (Hz)"
    push!(lines, line)

    if addriver["AnalysisType"]==2 #I suppose the AeroDyn Driver doesn't expect there to be any combined case data if the analysis type is 2. 
    else
        WindData = hcat(addriver["HWndSpeed_mat"], addriver["PLExp_mat"], addriver["RotSpd_mat"], addriver["Pitch_mat"], addriver["Yaw_mat"], addriver["dT_mat"], addriver["Tmax_mat"], addriver["DOF_mat"], addriver["Amplitude_mat"], addriver["Frequency_mat"])
        line = formatmatrix(WindData)
        append!(lines, line)
    end


    ##############################################################################
    line = string("-"^7, " Output Settings ", "-"^30)
    push!(lines, line)

    line = string(formatword(addriver["OutFmt"];quotes=true, desiredlength=length(addriver["OutFmt"])+5),"   OutFmt      - Format used for text tabular output, excluding the time channel.  Resulting field should be 10 characters. (quoted string)")
    push!(lines, line)

    line = string(formatword(Int(addriver["OutFileFmt"]);quotes=false, desiredlength=length(addriver["OutFileFmt"])+5),"        OutFileFmt  - Format for tabular (time-marching) output file (switch) {1: text file [<RootName>.out], 2: binary file [<RootName>.outb], 3: both}")
    push!(lines, line)

    line = string(formatword(Int(addriver["WrVTK"]);quotes=false),"   WrVTK       - VTK visualization data output: (switch) {0=none; 1=init; 2=animation}")
    push!(lines, line)

    line = string(formatword(Int(addriver["WrVTK_Type"]);quotes=false),"   WrVTK_Type  - VTK visualization data type: (switch) {1=surfaces; 2=lines; 3=both}")
    push!(lines, line)

    line = string(formatword(addriver["VTKHubRad"];quotes=false, location="back"),"   VTKHubRad   - HubRadius for VTK visualization (m)")
    push!(lines, line)

    line = string(formatword(addriver["VTKNacDim"];quotes=false, desiredlength=length(addriver["VTKNacDim"])*6),"   VTKNacDim   - Nacelle Dimension for VTK visualization x0,y0,z0,Lx,Ly,Lz (m)")
    push!(lines, line)
    # @show typeof(addriver["VTKNacDim"])


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
    create_addriver()

This function helps the user insure that they've put in all the 
required entries to write an AeroDyn driver file from a dictionary.
(This is for a single wind turbine)

**Inputs**
"""
function create_addriver(Notes, Echo, AnalysisType, AD_InputFile, NumBlades,
    HubRad, HubHt, RefHt, Overhang, ShftTilt, Precone, twr2shft, V, rho, kinvisc, a, ShearExp, RPM,
    Pitch, Yaw, dT, Tmax; MHK=0, Patm=0, Pvap=0, WtrDpth=0, 
    Amp=zeros(length(V)), Freq=zeros(length(V)), DOF=zeros(length(V)),
    CompInflow=false, Inflowfile="", HAWTformat=true, origin=[0,0,0],
    OutFmt="\"ES15.8E2\"", OutFileFmt=1, WrVTK=0, WrVTK_type=1,
    VTK_hubr=HubRad, VTKNacDim=[-1, -1, -1 ,2, 2, 2], TimeAnalysisFileName="unused")

    addriver = Dict()
 
    addriver["Notes"] = Notes
    addriver["Echo"] = Echo
    addriver["MHK"] = MHK
    addriver["AnalysisType"] = AnalysisType
    addriver["TMax"] = Tmax
    addriver["DT"] = dT[1]
    addriver["AeroFile"] = AD_InputFile
    addriver["FldDens"] = rho
    addriver["KinVisc"] = kinvisc
    addriver["SpdSound"] = a
    addriver["Patm"] = Patm
    addriver["Pvap"] = Pvap
    addriver["WtrDpth"] = WtrDpth
    addriver["CompInflow"] = CompInflow
    addriver["InflowFile"] = Inflowfile
    addriver["HWindSpeed"] = V
    addriver["RefHt"] = RefHt
    addriver["PLExp"] = ShearExp[1]

    addriver["NumTurbines"] = 1
    addriver["BasicHAWTFormat(1)"] = HAWTformat
    addriver["BaseOriginInit(1)"] = origin
    addriver["NumBlades(1)"] = NumBlades
    addriver["HubRad(1)"] = HubRad
    addriver["HubHt(1)"] = HubHt
    addriver["Overhang(1)"] = Overhang
    addriver["ShftTilt(1)"] = ShftTilt
    addriver["Precone(1)"] = Precone
    addriver["Twr2Shft(1)"] = twr2shft
    addriver["BaseMotionType(1)"] = 0
    addriver["DegreeOfFreedom(1)"] = 1
    addriver["Amplitude(1)"] = 1
    addriver["Frequency(1)"] = 1
    addriver["BaseMotionFileName(1)"] = "unused"
    addriver["NacYaw(1)"] = 1
    addriver["RotSpeed(1)"] = 1
    addriver["BldPitch(1)"] = 1
    addriver["TimeAnalysisFileName"] = TimeAnalysisFileName

    addriver["NumCases"] = length(V)
    addriver["HWndSpeed_mat"] = V
    addriver["PLExp_mat"] = ShearExp
    addriver["RotSpd_mat"] = RPM
    addriver["Pitch_mat"] = Pitch
    addriver["Yaw_mat"] = Yaw
    addriver["dT_mat"] = dT
    addriver["Tmax_mat"] = Tmax
    addriver["DOF_mat"] = DOF
    addriver["Amplitude_mat"] = Amp
    addriver["Frequency_mat"] = Freq

    addriver["OutFmt"] = OutFmt
    addriver["OutFileFmt"] = OutFileFmt
    addriver["WrVTK"] = WrVTK
    addriver["WrVTK_Type"] = WrVTK_type
    addriver["VTKHubRad"] = VTK_hubr
    addriver["VTKNacDim"] = VTKNacDim
     
    # @warn("create_addriver() is untested.")

    return addriver
end


function create_adfile(WakeMod, AFAeroMod, TwrPotent, TwrShadow, TwrAero, AirDens, KinVisc,
    SkewMod, TipLoss, HubLoss, TanInd, AIDrag, TIDrag, UAMod, FLookup, UAStartRad, UAEndRad, AFNames, UseBlCm, ADBlFile, TwrElev, TwrDiam,
    TwrCd, TwrTI, TwrCb, OutList, NodeOutList;
    Echo=false, DTAero="\"defaults\"", FrozenWake=false, CavitCheck=false, Buoyancy=false,
    CompAA=false, AA_InputFile="unused", SpdSound=335.0, Patm=0., Pvap=0., SkewModFactor="\"default\"", IndToler=1e-6, MaxIter=400, DBEMT_Mod=1, tau1_const=4, OLAFInputFileName="\"unused\"", AFTabMod=1, InCol_Alfa=1, InCol_Cl=2, InCol_Cd=3, InCol_Cm=4, InCol_Cpmin=0, VolHub=0., HubCenBx=0., VolNac=0., NacCenB=[0., 0., 0.], SumPrint=false, NBlOuts=1, BlOutNd=[1, 2], NTwOuts=0, TwOutNd=[1, 2], BldNd_BladesOut=1, BldNd_BlOutNd="\"All\"", Notes="")

    adfile = Dict()

    ### General Options
    adfile["Notes"] = Notes
    adfile["Echo"] = Echo
    adfile["DTAero"] = DTAero
    adfile["WakeMod"] = WakeMod
    adfile["AFAeroMod"] = AFAeroMod
    adfile["TwrPotent"] = TwrPotent
    adfile["TwrShadow"]= TwrShadow
    adfile["TwrAero"] = TwrAero
    adfile["FrozenWake"] = FrozenWake
    adfile["CavitCheck"] = CavitCheck
    adfile["Buoyancy"] = Buoyancy
    adfile["CompAA"] = CompAA
    adfile["AA_InputFile"] = AA_InputFile

    ### Environmental Conditions
    adfile["AirDens"] = AirDens
    adfile["KinVisc"] = KinVisc
    adfile["SpdSound"] = SpdSound
    adfile["Patm"] = Patm
    adfile["Pvap"] = Pvap

    ### BEMT Options
    adfile["SkewMod"] = SkewMod
    adfile["SkewModFactor"] = SkewModFactor
    adfile["TipLoss"] = TipLoss
    adfile["HubLoss"] = HubLoss
    adfile["TanInd"] = TanInd
    adfile["AIDrag"] = AIDrag
    adfile["TIDrag"] = TIDrag
    adfile["IndToler"] = IndToler
    adfile["MaxIter"] = MaxIter

    ### Dynamic BEMT Options
    adfile["DBEMT_Mod"] = DBEMT_Mod
    adfile["tau1_const"] = tau1_const

    ### OLAF options
    adfile["OLAFInputFileName"] = OLAFInputFileName

    ### Unsteady Aerodynamics options
    adfile["UAMod"] = UAMod
    adfile["FLookup"] = FLookup
    adfile["UAStartRad"] = UAStartRad
    adfile["UAEndRad"] = UAEndRad

    ### Airfoil Information
    adfile["AFTabMod"] = AFTabMod
    adfile["InCol_Alfa"] = InCol_Alfa
    adfile["InCol_Cl"] = InCol_Cl
    adfile["InCol_Cd"] = InCol_Cd
    adfile["InCol_Cm"] = InCol_Cm
    adfile["InCol_Cpmin"] = InCol_Cpmin
    adfile["NumAFfiles"] = length(AFNames)
    adfile["AFNames"] = AFNames
    
    ### Rotor/Blade Properties
    adfile["UseBlCm"] = UseBlCm
    for i=1:3
       adfile["ADBlFile($i)"] = ADBlFile
    end

    ### Hub Properties
    adfile["VolHub"] =  VolHub
    adfile["HubCenBx"] = HubCenBx

    ### Nacelle Properties
    adfile["VolNac"] = VolNac
    adfile["NacCenB"] = NacCenB

    ### Tower Influence
    adfile["NumTwrNds"] = length(TwrElev)
    adfile["TwrElev_mat"] = TwrElev
    adfile["TwrDiam_mat"] = TwrDiam
    adfile["TwrCd_mat"] = TwrCd
    adfile["TwrTI_mat"] = TwrTI
    adfile["TwrCb_mat"] = TwrCb
    
    ### Outputs
    adfile["SumPrint"] = SumPrint
    adfile["NBlOuts"] = NBlOuts
    adfile["BlOutNd"] = BlOutNd
    adfile["NTwOuts"] = NTwOuts
    adfile["TwOutNd"] = TwOutNd
    adfile["OutList"] = OutList

    ### Section Outputs
    adfile["BldNd_BladesOut"] = BldNd_BladesOut
    adfile["BldNd_BlOutNd"] = BldNd_BlOutNd
    adfile["NodeOutList"] = NodeOutList

    return adfile
end



# """
#     CreateAD15(Blades, Foils; Notes = "Notes on what this Aerodyn File is.", Echo="False",
# DTAero="default", WakeMod=1,
# AFAeroMod=2, TwrPotent=1, TwrShadow="False", TwrAero="True", FrozenWake="False",
# CavitCheck="False", CompAA="False", AA_InputFile="unused", AirDens=1.225, KinVisc=1.464e-5, SpdSound = 335.0, Patm=103500,
# Pvap=1700, FluidDepth=0.5, SkewMod=2, SkewModFactor="\"default\"", TipLoss="True",
# HubLoss="True", TanInd="True", AIDrag="False", TIDrag="False", IndToler="default",
# MaxIter=100, DBEMT_Mod=2, tau1_const=4, OLAFInputFileName="unused", UAMod=3, FLookup="True", AFTabMod=1,
# InCol_Alfa=1, InCol_Cl=2, InCol_Cd=3, InCol_Cm=4, InCol_Cpmin=0, UseBlCm="True",
# TwrNds=zeros(1,3), SumPrint="False", NBlOuts=0, BlOutNd=[0], NTwOuts=0, TwOutNd=[0],
# Outlist=String[], BldNd_BladesOut=0, BldNd_BlOutNd=[], NodeOutlist=String[]) 

# **Inputs**::
# - Blades::Array{String, 1} - an array containing the names of the blade files
# - foils::Array{String, 1} - an array containing the names of airfoils to be used. 

# **Outputs**:
# - ad15file::AD15file - the AeroDyn v15 input file object
# """
# function create_adfile(Blades, Foils; Notes = "Notes on what this Aerodyn File is.", Echo="False",
#     DTAero="default", WakeMod=1,
#     AFAeroMod=2, TwrPotent=1, TwrShadow="False", TwrAero="True", FrozenWake="False",
#     CavitCheck="False", CompAA="False", AA_InputFile="unused", AirDens=1.225, KinVisc=1.464e-5, SpdSound = 335.0, Patm=103500,
#     Pvap=1700, FluidDepth=0.5, SkewMod=2, SkewModFactor="default", TipLoss="True",
#     HubLoss="True", TanInd="True", AIDrag="False", TIDrag="False", IndToler="default",
#     MaxIter=100, DBEMT_Mod=2, tau1_const=4, OLAFInputFileName="unused", UAMod=3, FLookup="True", AFTabMod=1,
#     InCol_Alfa=1, InCol_Cl=2, InCol_Cd=3, InCol_Cm=4, InCol_Cpmin=0, UseBlCm="True",
#     TwrNds=zeros(1,3), SumPrint="False", NBlOuts=0, BlOutNd=[0], NTwOuts=0, TwOutNd=[0],
#     Outlist=String[], BldNd_BladesOut=0, BldNd_BlOutNd=[], NodeOutlist=String[]) 

#     NumAFfiles=length(Foils)
#     if NumAFfiles==0
#      error("Too few airfoils included in AD15 file. - CreateAD15")
#     end

#     for i=1:NumAFfiles
#      temp = "Foil $i"
#      push!(directory, temp)
#     end

#     if length(Blades)>3
#      error("Too many blade files included in AD15 file. - CreateAD15")
#     elseif length(Blades)==0
#      error("A blade file is required to create an AD15 file.")
#     end

#     m,n = size(TwrNds)
#     NumTwrNds = m
#     if n!=3
#      error("AD15 TwrNds formatted incorrectly. There must be 3 columns.")
#     end

#     if NBlOuts>9
#      error("Max number of NBlOuts is 9. CreateAD15")
#     end
#     if NTwOuts>9
#      error("Max number of NBlOuts is 9. CreateAD15")
#     end

#     file = ADfile(directory, Notes, Echo, DTAero, WakeMod, AFAeroMod, TwrPotent, TwrShadow, TwrAero, FrozenWake, CavitCheck, CompAA, AA_InputFile, AirDens, KinVisc, SpdSound, Patm, Pvap, FluidDepth, SkewMod, SkewModFactor, TipLoss, HubLoss, TanInd, AIDrag, TIDrag, IndToler, MaxIter, DBEMT_Mod, tau1_const, OLAFInputFileName, UAMod, FLookup, AFTabMod, InCol_Alfa, InCol_Cl, InCol_Cd, InCol_Cm, InCol_Cpmin, NumAFfiles, Foils, UseBlCm, Blades, NumTwrNds, TwrNds, SumPrint, NBlOuts, BlOutNd, NTwOuts, TwOutNd, Outlist, BldNd_BladesOut, BldNd_BlOutNd, NodeOutlist)
#     return file
# end

"""
    CreateAD15Blade(rads, radschords, radstwists, radscones, radsconeangs, radssweeps, radsafid, tiprad, hubrad, cylinderrad, airfoilrad; importantrads=[], notes="This is a turbine.", verbose=true)

Takes the iodenputs and creats a adblade struct. Note that this is a file that mainly contains nodes that describe the turbine blade to AeroDyn. At each node the distance from the hub will be given; the chord length, twist, cone distance, cone angle, sweep, and airfoil will also be given. 

**Inputs**
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

**Outputs**
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
function CreateAD15Blade(rads, radschords, radstwists, radscones, radsconeangs, radssweeps, radsafid, tiprad, hubrad, cylinderrad, airfoilrad, pitch; numnodes=100, importantrads=[], importantfracs=[], notes="This is a turbine.", verbose=true)
    # Definitions #todo: I probably shouldn't name this as CreateAD15Blade... it is creating a blade, but it is also interpolating. 
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
    minus = 2 #todo: What is this? 
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
    append!(importantblfracs, importantfracs)
    unique!(importantblfracs)
    # blfracs = collect(range(airfoilblfrac,tipblfrac, length=numnodes-length(importantrads)-minus))
    blfracs = collect(range(airfoilblfrac,tipblfrac, length=numnodes-length(importantblfracs)-minus))
    append!(blfracs, importantblfracs)

    push!(blfracs, hubblfrac,  airfoilblfrac, tipblfrac)

    if cylinderblfrac>0
        push!(blfracs, cylinderblfrac)
    end
    unique!(blfracs)
    sort!(blfracs)

    # Convert from blfracs to radius positions and their radial locations
    blrads = blfracs.*(bladelength) #Note do not use this to get any property values    with the fits.
    locs = blrads.+hubrad #0.508 #The rads location of the blrads nodes #Todo. What is this 0.508? This looks like a hard coded thing.... which should probably be hub radius. 
    n = length(blrads)
    precone = conefit.(locs)
    sweep = sweepfit.(locs)
    preconeangle = coneangfit.(locs)
    twist = twistfit.(locs)
    twist = twist.+(-twist[end]+pitch) #Correct twist to OpenFAST input style,  including blade pitch
    chords = chordfit.(locs)
    afid = integerfit(rads, radsafid, locs)


    adblade = Dict()
    adblade["Notes"] = notes
    adblade["NumBlNds"] = n

    adblade["BlSpn"] = blrads
    adblade["BlCrvAC"] = precone
    adblade["BlSwpAC"] = sweep
    adblade["BlCrvAng"] = preconeangle
    adblade["BlTwist"] = twist
    adblade["BlChord"] = chords
    adblade["BlAFID"] = afid

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

    **Inputs**
    - props - a n x 7 array holding the nodal values in order (radius, chord length, twist, cone, cone angle, sweep, airfoil name)
    - tiprad - tip radius from center of rotation (meters)
    - hubrad - hub radius from center of rotation (meters)
    - cylinderrad - the radial distance (from the center of rotation) of the end of the cynlinder section. If no cylinder section is included, set this value to the hub radius. 
    - airfoilrad - the radial distance (from the center of rotation) of the first airfoil 
    - pitch - The value that the tip of the blade is pitched (assuming pitch is constant throughout the analysis) (degrees)
    - importantrads - radial distances that the user would like to insure a node is placed. (meters)
    - notes - notes that the user would like placed at the top of the blade file.
    - verbose - boolean that marks whether to make statements about creating the blade.
    
    **Outputs**
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

**Inputs**:
- Polar::Array{Float64, 2} - nx4 array of the airfoil coefficients in order of aoa, cl, cd, cm
- Re::Float64 - Reynolds number of the airfoil polar
- NumCoords::String - file containing the coordinate file ("@\"s809_coords.dat\"")

**Outputs**: 
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

"""
    make_dsairfoil(afi::AirfoilInputUnsteady, chord; radians=false, zeta=0.5, separationpointfun::Symbol=:Fit, model::Symbol=:Gonzalez, interp=Akima, a=343.0, cutrad = 5*pi/180) 

Make an DynamicStallModels airfoil object. (I don't know if this belongs here, or in DynamicStallModels). 

**Arguments**
- afi::AirfoilInputUnsteady - An unsteady Airfoil object.
- chord::Float - the chord length of the airfoil.
- radians::Bool - Whether the associated polar is in degrees or radians.
- zeta::Float - I think this is the efficiency #TODO: 
- separationpointfun::Symbol - a symbol indicating which separation point function to use. Options include `:fit` (which defaults to Aerodyn's original or Gonzalez depending on what model you have chosen), or `:Fun` for Beddoes-Leishman's original separation point function. 
- model::Symbol - a symbol indicating which stall model to use. Options include `:Original` and `:Gonzalez`. 
- interp::Function - What interpolation scheme you'd like to use on the polars.
- a::Float - speed of sound
- cutrad:: - the cutout radius around the cutout angle of attack. 
- A::Vector{Float} - a vector of A values to overide the A values that the given inputfile has (useful for optimization). 
"""
function make_dsairfoil(afi::AirfoilInputUnsteady, chord; radians=false, zeta=0.5, separationpointfun::Symbol=:Fit, model::Symbol=:Gonzalez, interp=Akima, a=343.0, cutrad = 5*pi/180, A=nothing) 
    if radians || maximum(afi.aoa)<=pi
        aoa = afi.aoa
    else
        aoa = afi.aoa.*(pi/180)
    end
    polar = hcat(aoa, afi.cl, afi.cd, afi.cm)

    cl = interp(polar[:,1], polar[:,2])
    cd = interp(polar[:,1], polar[:,3])
    cm = interp(polar[:,1], polar[:,4])

    cnvec = @. afi.cl*cos(aoa) + afi.cd*sin(aoa)
    ccvec = @. afi.cl*sin(aoa) - afi.cd*cos(aoa)

    cn = interp(aoa, cnvec)
    cc = interp(aoa, ccvec)

    dcldalpha = afi.c_nalpha #Todo: Get the dcldalpha. I don't know if I'll ever use it, but yeah. 
    dcndalpha = afi.c_nalpha

    alpha0 = afi.alpha0*(pi/180)
    alphasep = sort([afi.alpha2, afi.alpha1].*(pi/180))
    alphacut = [-afi.uacutout, afi.uacutout].*(pi/180)

   
    Cd0 = afi.cd0
    # Cn1 = afi.cn1
    # Cd0 = cd(alpha0)
    # Cm0 = cm(alpha0)
    alpha1 = alphasep[2]
    Cn1 = cl(alpha1)*cos(alpha1) + (cd(alpha1) - Cd0)*sin(alpha1)
    Cm0 = afi.cm0

    if separationpointfun==:Fit
        if model==:Original
            sfun = DS.ADSP(aoa, cnvec, ccvec, alpha0, alphasep, dcldalpha, eta)
        elseif model == :Gonzalez
            sfun = DS.ADGSP()
        end

    elseif separationpointfun==:Fun
        S = [afi.s1, afi.s2, afi.s3, afi.s4]
        sfun = DS.BLSP(S)

    else
        @warn("make_dsairfoil() only acts on a :Fit or :Fun argument for calculating the separation point. Returning to default (:Fit).")
        sfun = DS.ADSP(aoa, cn, cc, alpha0, alphasep, dcldalpha, eta)

    end

    xcp = afi.x_cp_bar

    if isnothing(A)
        A = [afi.a1, afi.a2, afi.a5]
    end
    b = [afi.b1, afi.b2, afi.b5]
    T = [afi.t_p, afi.t_f0, afi.t_v0, afi.t_vl, afi.st_sh]

    eta = afi.eta_e

    dsmodel = DS.BeddoesLeishman(DS.Indicial(), 3, A, b, T, Cn1, Cd0, Cm0, eta, zeta, a)
    
    return DS.Airfoil(dsmodel, polar, cl, cd, cm, cn, cc, dcldalpha, dcndalpha, alpha0, alphasep, alphacut, cutrad, sfun, chord, xcp) 
end

function make_blade()
end
