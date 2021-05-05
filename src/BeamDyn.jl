##############################################################
##################     STRUCTURES     ########################
##############################################################

mutable struct BDFile{TS, TB, TF, TI}
    notes::TS
    echo::TB
    quasistaticinit::TB
    rhoinf::TF
    quadrature::TI
    refine::TI #has default
    n_fract::TI #has default
    dtbeam::TF #has default
    load_retries::TI #has default
    nrmax::TI #has default
    stop_tol::TF #has default
    tngt_stf_fd::Flag #has default  
    tngt_stf_comp::Flag #has default 
    tngt_stf_pert::TF #has default
    tngt_stf_difftol::TF #has default
    rotstates::TB
    member_total::TI
    kp_total::TI
    membernumber::Array{Tuple{TI, TI}, 1}
    kp_xr::Array{TF, 1}
    kp_yr::Array{TF, 1}
    kp_zr::Array{TF, 1}
    initial_twist::Array{TF, 1}
    order_elem::TI
    bldfile::TS
    usepitchact::TB
    pitchj::TF
    pitchk::TF
    pitchc::TF
    sumprint::TB
    outfmt::TS
    nnodeouts::TI
    outnd::Array{TI, 1}
    outlist::Array{TS, 1}
    nodeoutlist::Array{TS, 1}

    function BDFile(Notes::TS, Echo::TB, QuasiStaticInit::TB, rhoinf::TF, quadrature::TI, refine::TI, n_fract::TI, DTBeam::TF, load_retries::TI, NRMax::TI, stop_tol::TF, tngt_stf_fd::Flag  , tngt_stf_comp::Flag , tngt_stf_pert::TF, tngt_stf_difftol::TF, RotStates::TB, member_total::TI, kp_total::TI, membernumber::Array{Tuple{TI, TI}, 1}, kp_xr::Array{TF, 1}, kp_yr::Array{TF, 1}, kp_zr::Array{TF, 1}, initial_twist::Array{TF, 1}, order_elem::TI, BldFile::TS, UsePitchAct::TB, PitchJ::TF, PitchK::TF, PitchC::TF, SumPrint::TB, OutFmt::TS, NNodeOuts::TI, OutNd::Array{TI, 1}, Outlist::Array{TS, 1}, NodeOutlist::Array{TS, 1}) where {TS, TB, TF, TI}

        if length(kp_xr) != length(kp_yr) != length(kp_zr) != length(initial_twist)
            error("Geometry Parameters not all the same length. - BeamDyn File")
        end

        if kp_total != length(kp_xr)
            warning("Number of Key Points not correctly declared. - BeamDyn File")
            kp_total = length(kp_xr)
        end

        return new{TS, TB, TF, TI}(Notes, Echo, QuasiStaticInit, rhoinf, quadrature, refine, n_fract, DTBeam, load_retries, NRMax, stop_tol, tngt_stf_fd, tngt_stf_comp, tngt_stf_pert, tngt_stf_difftol, RotStates, member_total, kp_total, membernumber, kp_xr, kp_yr, kp_zr, initial_twist, order_elem, BldFile, UsePitchAct, PitchJ, PitchK, PitchC, SumPrint, OutFmt, NNodeOuts, OutNd, Outlist, NodeOutlist)
    end
end


mutable struct BDBladeNode{TF}
    frac::TF
    stiffmatrix::Array{TF, 2}
    massmatrix::Array{TF, 2}

    #Stiffness Matrix values
    shredg::TF
    shrflp::TF
    ea::TF
    eiedg::TF
    eiflp::TF
    gj::TF
    e::TF
    g::TF
    j::TF

    #Mass Matrix values
    mass::TF
    ycm::TF
    xcm::TF
    iedg::TF
    icp::TF
    iflp::TF
    iplr::TF

    function BDBlade(frac::TF, stiffmatrix::Array{TF, 2}, massmatrix::Array{TF, 2}, shredg::TF, shrflp::TF, ea::TF, eiedg::TF, eiflp::TF, gj::TF, e::TF, g::TF, j::TF, mass::TF, ycm::TF, xcm::TF, iedg::TF, icp::TF, iflp::TF, iplr::TF) where {TF}

        return new{TF}(frac, stiffmat, massmat, shredg, shrflp, EA, EIedg, EIflp, GJ, E, G, J, mass, Ycm, Xcm, iedg, icp, iflp, iplr)
    end
end

"""
    makenode(frac, stiffmat, massmat)

Take the makings of a BeamDyn blade node and make it into a node. 

### Inputs
- frac::Float64 - The percentage of the blade (not including hub distance) that the node is defined at. 
- stiffmat::Array{Float64, 2} - The 6x6 array defining the flap, edge, and polar shear and extension stiffnesses. See the OpenFAST docs for a description of this matrix (and the next one). 
- massmat::Array{Float64, 2} - The 6x6 array defining the mass, center of mass, and area moment of inertia. 

### Outputs
- BDBladeNode - An object containing the extractable data from the matrices. 
"""
function makenode(frac, stiffmat, massmat)
    mass = massmat[1,1]
    Ycm = massmat[3,4]/mass
    Xcm = massmat[2,6]/mass
    iedg = massmat[4,4]
    iflp = massmat[5,5]
    icp = -massmat[4,5]
    iplr = massmat[6,6]

    shrflp = stiffmat[1,1]
    shredg = stiffmat[2,2]
    EA = stiffmat[3,3]
    EIedg = stiffmat[4,4]
    EIflp = stiffmat[5,5]
    GJ = stiffmat[6,6]
    E = EIedg/iedg
    G = 1.0
    J = 1.0 #Isn't the iplr? 
    

    return BDBladeNode(frac, stiffmat, massmat, shredg, shrflp, EA, EIedg, EIflp, GJ, E, G, J, mass, Ycm, Xcm, iedg, icp, iflp, iplr)
end

mutable struct BDBlade{TS, TF, TI}
    Notes::TS
    station_total::TI
    damp_type::TI
    dampcoef::Array{TF,1}
    nodes::Array{BDBladeNode,1}
end

##############################################################
################## READING FUNCTIONS #########################
##############################################################

"""
    read_bdfile(filename, filepath)

Reads a BeamDyn file and creates an object to be used. 

### Inputs 
- filename::String - name of the file to read in. 
- filepath::String - path to the directory containing the file to read

### Outputs
- bdfile::BDFile - the BeamDyn object
"""
function read_bdfile(filename::String, filepath::String)
    fi = open(filepath*"/"*filename, "r")
    lines = readlines(fi)
    close(fi)

    # Line 1 is the title
    notes = lines[2]
    # Line 3 is the simulation control title
    echo = fetchword(lines[4]; adapt=true)
    quasistaticinit = fetchword(lines[5]; adapt=true)
    rhoinf = parse(Float64, lines[6][1:14])
    quadrature = parse(Int64, lines[7][1:14])
    refine = readinteger(lines[8])
    n_fract = readinteger(lines[9])
    dtbeam = readnumber(lines[10])
    load_retries = readinteger(lines[11])
    nrmax = readinteger(lines[12])
    stop_tol = readnumber(lines[13])
    tngt_stf_fd = readflag(lines[14][1:14])
    tngt_stf_comp = readflag(lines[15][1:14])
    tngt_stf_pert = readnumber(lines[16])
    tngt_stf_difftol = readnumber(lines[17])
    rotstates = fetchword(lines[18]; adapt=true)
    # Line 19 is the Geometry Parameter title
    member_total = parse(Int64, lines[20][1:14])
    kp_total = parse(Int64, lines[21][1:14])

    membernumber = Tuple{Int64, Int64}[] 
    for i=1:member_total
        temp = readpair(lines[21+i])
        push!(membernumber, temp)
    end

    idx = kp_total+member_total+24
    geoparams = cat(readdlm.(IOBuffer.(lines[24+member_total:idx-1]))...,dims=1)

    kp_xr = geoparams[:,1]
    kp_yr = geoparams[:,2]
    kp_zr = geoparams[:,3]
    initial_twist = geoparams[:,4]

    # Line idx is the Mesh Parameter title
    order_elem = parse(Int64, lines[idx+1][1:14])
    # Line idx+2 is the Material Paramer title
    bldfile = fetchword(lines[idx+3];lengthofword=length(lines[idx+3]))
    # Line idx+4 is the Pitch actuator parameters title
    usepitchact = fetchword(lines[idx+5]; adapt=true)
    pitchj = parse(Float64, lines[idx+6][1:14])
    pitchk = parse(Float64, lines[idx+7][1:14])
    pitchc = parse(Float64, lines[idx+8][1:14])
    # Line idx+9 is the Outputs title
    sumprint = fetchword(lines[idx+10]; adapt=true)
    outfmt = fetchword(lines[idx+11])
    nnodeouts = parse(Int64, lines[idx+12][1:14])
    outnd = Int64.(readvector(lines[idx+13])) 
    outlist = readoutlist(lines[idx+14:end])
    nodeoutputstitleidx = 0 
    for i = 1:length(lines)
        if lowercase(lines[i][1:3]) == "end"
            nodeoutputstitleidx = i+1 #This is the title index
            break
        end
    end

    # nodeoutputstitleidx+3 is a general title
    nodeoutlist = readoutlist(lines[nodeoutputstitleidx+3:end])


    return BDFile(notes, echo, quasistaticinit, rhoinf, quadrature, refine, n_fract, dtbeam, load_retries, nrmax, stop_tol, tngt_stf_fd, tngt_stf_comp, tngt_stf_pert, tngt_stf_difftol, rotstates, member_total, kp_total, membernumber, kp_xr, kp_yr, kp_zr, initial_twist, order_elem, bldfile, usepitchact, pitchj, pitchk, pitchc, sumprint, outfmt, nnodeouts, outnd, outlist, nodeoutlist)
end

"""
    read_bdblade(filename, filepath)

Reads a BeamDyn blade file and creates an object containing the data. 

### Inputs
- filename::String - a string containing the name of the file
- filepath::String - a string containing the path to the file to be read

### Outputs
- BDBlade - a BeamDyn Blade object. 
"""
function read_bdblade(filename::String, filepath::String)
    fi = open(filepath*"/"*filename, "r")
    lines = readlines(fi)
    close(fi)

    # Line 1 is the title
    Notes = lines[2]
    # Line 3 is the Blade Parameters title
    station_total = parse(Int, lines[4][1:5])
    damp_type = parse(Int, lines[5][1:5])
    # Line 6 is the damping coefficient title
    # line 7 is the damping coefficents header
    # line 8 is the damping coefficients units
    dampcoef = cat(readdlm.(IOBuffer.(lines[9]))...,dims=1)
    # line 10 is the distributed properties title
    nodes = BDBladeNode[]
    # for i=11:length(lines)
    #     lines[i] = string(" ", rmspaces(lines[i]), " ")
    # end
    let 
        idx = 11
        for i = 1:station_total
            frac = parse(Float64, lines[idx])
            # println("\"", lines[idx+1])
            stiffmat = cat(readdlm.(IOBuffer.(lines[idx+1:idx+6]))...,dims=1)
            # println(stiffmat)
            massmat = cat(readdlm.(IOBuffer.(lines[idx+8:idx+13]))...,dims=1)
            node = makenode(frac, stiffmat, massmat)
            push!(nodes, node)
            idx += 15
        end
    end
    return BDBlade(Notes, station_total, damp_type, dampcoef, nodes)
end



##############################################################
################## WRITING FUNCTIONS #########################
##############################################################

"""
    write_bdfile(bdfile, outputfile; outputpath=pwd())

Writes a BeamDyn struct to file. 

### Inputs
- bdfile::BDFile : BeamDyn file
- outputfile::String : Name to give the written file. 
- outputpath::String : Path to the desired write location, otherwise, will write at current location. 

"""
function write_bdfile(bdfile::BDFile, outputfile::String; outputpath::String=pwd())
    lines = String[]
    line = string("-"^9, " BEAMDYN with OpenFAST INPUT FILE ", "-"^43)
    push!(lines,line)

    push!(lines, bdfile.notes)

    line = string("-"^22, " SIMULATION CONTROL ", "-"^43)
    push!(lines,line)

    line = string(formatword(bdfile.echo;quotes=false),"   Echo             - Echo  input data to \"<RootName>.ech\"? (flag)")
    push!(lines,line)

    line = string(formatword(string(bdfile.quasistaticinit);quotes=false),"   QuasiStaticInit  - Use quasistatic pre-conditioning with centripetal  accelerations in initialization? (flag) [dynamic solve only]")
    push!(lines,line)

    line = string(formatword(string(bdfile.rhoinf);location="back",quotes=false),"   rhoinf           - Numerical damping parameter for generalized-alpha integrator")
    push!(lines,line)

    line = string(formatword(string(bdfile.quadrature);location="back", quotes=false),  "   quadrature       - Quadrature method: 1=Gaussian; 2=Trapezoidal (switch)")
    push!(lines,line)

    line = string(formatword(bdfile.refine;quotes=false),"   refine           - Refinement factor for trapezoidal quadrature (-) [DEFAULT = 1; used only when   quadrature=2]")
    push!(lines,line)

    line = string(formatword(bdfile.n_fract;quotes=false),"   n_fact           -   Factorization frequency for the Jacobian in N-R iteration(-) [DEFAULT = 5]")
    push!(lines,line)

    line = string(formatword(bdfile.dtbeam;quotes=false),"   DTBeam           - Time step size (s)")
    push!(lines,line)

    line = string(formatword(bdfile.load_retries;quotes=false),"   load_retries  -   Number of factored load retries before quitting the aimulation [DEFAULT = 20]")
    push!(lines,line)

    line = string(formatword(bdfile.nrmax;quotes=false),"   NRMax            - Max  number of iterations in Newton-Raphson algorithm (-) [DEFAULT = 10]")
    push!(lines,line)

    line = string(formatword(bdfile.stop_tol;quotes=false),"   stop_tol         -   Tolerance for stopping criterion (-) [DEFAULT = 1E-5]")
    push!(lines,line)

    temp = typeof(bdfile.tngt_stf_fd)
    line = string(formatword("$temp";quotes=false),"   tngt_stf_fd      -    Use finite differenced tangent stiffness matrix? (flag)")
    push!(lines,line)

    temp = typeof(bdfile.tngt_stf_comp)
    line = string(formatword("$temp";quotes=false),"   tngt_stf_comp       - Compare analytical finite differenced tangent stiffness matrix? (flag)")
    push!(lines,line)

    line = string(formatword(bdfile.tngt_stf_pert;quotes=false),"   tngt_stf_pert       - Perturbation size for finite differencing (-) [DEFAULT = 1E-6]")
    push!(lines,line)

    line = string(formatword(bdfile.tngt_stf_difftol;quotes=false),"   tngt_stf_difftol - Maximum allowable relative difference between analytical and  fd tangent stiffness (-); [DEFAULT = 0.1]")
    push!(lines,line)

    line = string(formatword(bdfile.rotstates;quotes=false),"   RotStates        -  Orient states in the rotating frame during linearization? (flag) [used only when     linearizing]")
    push!(lines,line)

    line = string("-"^22, " GEOMETRY PARAMETER ", "-"^42)
    push!(lines, line)
    line = string(formatword(string(bdfile.member_total);location="back",   quotes=false),"   member_total    - Total number of members (-)")
    push!(lines,line)

    line = string(formatword(string(bdfile.kp_total);location="back", quotes=false),    "   kp_total        - Total number of key points (-) [must be at least 3]")
    push!(lines,line)

    if bdfile.member_total==1
        local line = string(formatpair(bdfile.membernumber[1]), "       - Member    number; Number of key points in this member ")
        push!(lines, line)
    else
        line = string(formatpair(bdfile.membernumber[1]), "       - Member number;  Number of key points in this member ")
        push!(lines, line)
        for i = 2:bdfile.member_total
            line = formatpair(bdfile.membernumber[i])
            push!(lines,line)

        end
    end

    line = "   kp_xr         kp_yr         kp_zr        initial_twist"
    push!(lines,line)

    line = "   (m)            (m)          (m)            (deg)"
    push!(lines,line)

    mat = formatmatrix(hcat(bdfile.kp_xr, bdfile.kp_yr, bdfile.kp_zr, bdfile.initial_twist))
    append!(lines, mat)

    line = string("-"^22, " MESH PARAMETER ", "-"^42)
    push!(lines, line)

    line = string(formatword(string(bdfile.order_elem);location="back", quotes=false),  "   order_elem     - Order of interpolation (basis) function (-)")
    push!(lines, line)

    line = string("-"^22, " MATERIAL PARAMETER ", "-"^39)
    push!(lines, line)

    line = string(formatword(bdfile.bldfile;quotes=true, desiredlength=length(bdfile.bldfile)+2),"   BldFile - Name of file containing properties for blade (quoted    string)")
    push!(lines, line)

    line = string("-"^22, "PITCH ACTUATOR PARAMETERS", "-"^33)
    push!(lines, line)

    line = string(formatword(bdfile.usepitchact;quotes=false),"   UsePitchAct -     Whether a pitch actuator should be used (flag)")
    push!(lines, line)

    line = string(formatword(string(bdfile.pitchj);location="back", quotes=false),"     PitchJ      - Pitch actuator inertia (kg-m^2) [used only when UsePitchAct is true]    ")
    push!(lines, line)

    line = string(formatword(string(bdfile.pitchk);location="back", quotes=false),"     PitchK      - Pitch actuator stiffness (kg-m^2/s^2) [used only when UsePitchAct   is true]")
    push!(lines, line)

    line = string(formatword(string(bdfile.pitchc);location="back", quotes=false),"     PitchC      - Pitch actuator damping (kg-m^2/s) [used only when UsePitchAct is    true]")
    push!(lines, line)

    line = string("-"^22, " OUTPUTS ", "-"^50)
    push!(lines, line)

    line = string(formatword(bdfile.sumprint;quotes=false),"   SumPrint       - Print   summary data to \"<RootName>.sum\" (flag)")
    push!(lines, line)

    line = string(formatword(bdfile.outfmt;quotes=false),"   OutFmt          - Format   used for text tabular output, excluding the time channel.")
    push!(lines, line)

    line = string(formatword(string(bdfile.nnodeouts);quotes=false),"       NNodeOuts      - Number of nodes to output to file [0 - 9] (-)")
    push!(lines, line)

    line = string(formatvector(bdfile.outnd), "   OutNd          - Nodes whose values   will be output  (-)")
    push!(lines, line)

    line = "          OutList        - The next line(s) contains a list of output   parameters. See OutListParameters.xlsx for a listing of available output  channels, (-)"
    push!(lines, line)

    for i=1:length(bdfile.outlist)
       local line = string("\"", bdfile.outlist[i], "\"")
       push!(lines,line)

    end
    line = "END of input file (the word \"END\" must appear in the first 3columns of    this last OutList line)"
    push!(lines,line)

    line = "---------------------- NODE OUTPUTS --------------------------------------------"
    push!(lines,line)

    line = "         99   BldNd_BlOutNd   - Blade nodes on each blade (currently    unused)" # Not sure if this section will get used because the other sections are   all the same, but for some odd reason, this nodal output section is different. 
    push!(lines, line)
    line = "                   OutList             - The next line(s) contains  list    of output parameters.  See s for a listing of available output channels, (-)"
    push!(lines, line)

    for i=1:length(bdfile.nodeoutlist)
       local line = string("\"", bdfile.nodeoutlist[i], "\"")
       push!(lines,line)
    end
    line = "END of input file (the word \"END\" must appear in the first  columns of    this last OutList line)"
    push!(lines,line)

    ## Write lines to file
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
    write_bdblade(bdblade, outputfile; outputpath=pwd())

Writes a bdblade object to file. 

### Inputs:
- bdblade::BDBlade - A BeamDyn blade object
- outputfile::String - The desired name of the written file. 
- outputpath::String - The desired location of the written file. 

### Outputs:
-  N/A - A file will be written. 
"""
function write_bdblade(bdblade::BDBlade, outputfile::String; outputpath::String=pwd())
    lines = String[]
    line = string("-"^9, " BEAMDYN V1.00.* INDIVIDUAL BLADE INPUT FILE ", "-"^43)
    push!(lines,line)
    push!(lines, bdblade.Notes)
    line = string("-"^22, " BLADE PARAMETERS ", "-"^43)
    push!(lines,line)
    line = string(formatword(string(bdblade.station_total);location="back", quotes=false, desiredlength=5),  "   station_total    - Number of blade input stations (-)")
    push!(lines,line)
    line = string(formatword(string(bdblade.damp_type);location="back", quotes=false, desiredlength=5),  "   damp_type        - Damping type: 0: no damping; 1: damped")
    push!(lines,line)
    line = string("-"^22, " DAMPING COEFFICIENT ", "-"^30)
    push!(lines,line)
    line = "   mu1        mu2        mu3        mu4        mu5        mu6"
    push!(lines,line)   
    line = "   (-)        (-)        (-)        (-)        (-)        (-)"
    push!(lines,line)
    let
        line = ""
        for i = 1:length(bdblade.dampcoef)
            s = @sprintf "%.1E" bdblade.dampcoef[i]
            if i<length(bdblade.dampcoef)
                space = "    "
            else
                space = ""
            end
            line = string(line, s, space)
        end
        push!(lines,line)
    end
    line = string("-"^22, " DISTRIBUTED PROPERTIES ", "-"^30)
    push!(lines,line)
    for i = 1:bdblade.station_total
        local line = string("  ", bdblade.nodes[i].frac)
        push!(lines, line)
        line = formatmatrix(bdblade.nodes[i].stiffmatrix;spacing=4)
        append!(lines, line)
        push!(lines, "")
        line = formatmatrix(bdblade.nodes[i].massmatrix;spacing=4)
        #There is some wonky spacing happening here because of the negative signs. 
        append!(lines, line)
        push!(lines, "")
    end

    ## Write lines to file
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