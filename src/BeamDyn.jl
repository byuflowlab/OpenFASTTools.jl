##############################################################
##################     STRUCTURES     ########################
##############################################################

mutable struct BDFile
    Directory::Array{String}
    Notes::String
    Echo::String
    QuasiStaticInit::String
    rhoinf::Float64
    quadrature::Int
    refine
    n_fact
    DTBeam
    load_retries
    NRMax
    stop_tol
    tngt_stf_fd
    tngt_stf_comp
    tngt_stf_pert
    tngt_stf_difftol
    RotStates::String
    member_total::Int
    kp_total::Int
    membernumber::Array{}
    geomparams::Array{Float64,2}
    order_elem::Int
    BldFile::String
    UsePitchAct::String
    PitchJ::Float64
    PitchK::Float64
    PitchC::Float64
    SumPrint::String
    OutFmt::String
    NNodeOuts::Int
    OutNd::Array{Int}
    Outlist::Array{String}
    NodeOutlist::Array{String}
end
mutable struct BDBladeNode
    frac::Float64
    stiffmatrix::Array{Float64, 2}
    massmatrix::Array{Float64, 2}

    #Stiffness Matrix values
    shredg::Float64
    shrflp::Float64
    EA::Float64
    EIedg::Float64
    EIflp::Float64
    GJ::Float64
    E::Float64
    Iedg::Float64
    Iflp::Float64
    G::Float64
    J::Float64

    #Mass Matrix values
    mass::Float64
    Ycm::Float64
    Xcm::Float64
    iedg::Float64
    icp::Float64
    iflp::Float64
    iplr::Float64

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
    shrflp = stiffmat[1,1]
    shredg = stiffmat[2,2]
    EA = stiffmat[3,3]
    EIedg = stiffmat[4,4]
    EIflp = stiffmat[5,5]
    GJ = stiffmat[6,6]
    E = 1
    Iedg = 1
    Iflp = 1
    G = 1
    J = 1
    mass = massmat[1,1]
    Ycm = massmat[3,4]/mass
    Xcm = massmat[2,6]/mass
    iedg = massmat[4,4]
    iflp = massmat[5,5]
    icp = -massmat[4,5]
    iplr = massmat[6,6]

    return BDBladeNode(frac, stiffmat, massmat, shredg, shrflp, EA, EIedg, EIflp, GJ, E, Iedg, Iflp, G, J, mass, Ycm, Xcm, iedg, icp, iflp, iplr)
end

mutable struct BDBlade
    Notes::String
    station_total::Int
    damp_type::Int
    dampcoef::Array{Float64,1}
    nodes::Array{BDBladeNode,1}
end

##############################################################
################## READING FUNCTIONS #########################
##############################################################

"""
    ReadBDFile(filename, filepath)

Reads a BeamDyn file and creates an object to be used. 

### Inputs 
- filename::String - name of the file to read in. 
- filepath::String - path to the directory containing the file to read

### Outputs
- bdfile::BDFile - the BeamDyn object
"""
function ReadBDFile(filename, filepath)
    cd(filepath)
    fi = open(filename, "r")
    lines = readlines(fi)
    close(fi)

    Directory = ["title"]

    # Line 1 is the title
    Notes = lines[2]
    # Line 3 is the simulation control title
    Echo = fetchword15(lines[4])
    QuasiStaticInit = fetchword15(lines[5])
    rhoinf = parse(Float64, lines[6][1:14])
    quadrature = parse(Int, lines[7][1:14])
    refine = fetchword15(lines[8])
    n_fact = fetchword15(lines[9])
    DTBeam = fetchword15(lines[10])
    load_retries = fetchword15(lines[11])
    NRMax = fetchword15(lines[12])
    stop_tol = fetchword15(lines[13])
    tngt_stf_fd = fetchword15(lines[14])
    tngt_stf_comp = fetchword15(lines[15])
    tngt_stf_pert = fetchword15(lines[16])
    tngt_stf_difftol = fetchword15(lines[17])
    RotStates = fetchword15(lines[18])
    # Line 19 is the Geometry Parameter title
    member_total = parse(Int, lines[20][1:14])
    kp_total = parse(Int, lines[21][1:14])

    membernumber = []
    for i=1:member_total
        temp = readpair(lines[21+i])
        push!(membernumber, temp)
    end

    idx = kp_total+member_total+24
    geomparams = cat(readdlm.(IOBuffer.(lines[24+member_total:idx-1]))...,dims=1)

    # Line idx is the Mesh Parameter title
    order_elem = parse(Int, lines[idx+1][1:14])
    # Line idx+2 is the Material Paramer title
    BldFile = fetchword(lines[idx+3];lengthofword=length(lines[idx+3]))
    # Line idx+4 is the Pitch actuator parameters title
    UsePitchAct = fetchword15(lines[idx+5])
    PitchJ = parse(Float64, lines[idx+6][1:14])
    PitchK = parse(Float64, lines[idx+7][1:14])
    PitchC = parse(Float64, lines[idx+8][1:14])
    # Line idx+9 is the Outputs title
    SumPrint = fetchword15(lines[idx+10])
    OutFmt = fetchword15(lines[idx+11])
    NNodeOuts = parse(Int, lines[idx+12][1:14])
    OutNd = readvector(lines[idx+13],NNodeOuts)
    OutList = readoutlist(lines[idx+14:end])
    nodeoutputstitleidx = 0 
    for i = 1:length(lines)
        if lowercase(lines[i][1:3]) == "end"
            nodeoutputstitleidx = i+1 #This is the title index
            break
        end
    end
    # BldNd_BladesOut = parse(Int, lines[nodeoutputstitleidx+1][1:14])
    # BldNd_BlOutNd = readvector(lines[nodeoutputstitleidx+2], BldNd_BladesOut) #   This is how they did it previously, so I wonder if they did the same thing with   BeamDyn
    # nodeoutputstitleidx+3 is a general title
    NodeOutlist = readoutlist(lines[nodeoutputstitleidx+4:end])

    bdfile = BDFile(Directory, Notes, Echo, QuasiStaticInit, rhoinf, quadrature, refine, n_fact, DTBeam, load_retries, NRMax, stop_tol, tngt_stf_fd, tngt_stf_comp, tngt_stf_pert, tngt_stf_difftol, RotStates, member_total, kp_total, membernumber, geomparams, order_elem, BldFile, UsePitchAct, PitchJ, PitchK, PitchC, SumPrint, OutFmt, NNodeOuts, OutNd, OutList, NodeOutlist)
end

"""
    ReadBDBlade(filename, filepath)

Reads a BeamDyn blade file and creates an object containing the data. 

### Inputs
- filename::String - a string containing the name of the file
- filepath::String - a string containing the path to the file to be read

### Outputs
- BDBlade - a BeamDyn Blade object. 
"""
function ReadBDBlade(filename, filepath)
    cd(filepath)
    fi = open(filename, "r")
    lines = readlines(fi)
    close(fi)

    Directory = ["title"]

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
    let 
        idx = 11
        for i = 1:station_total
            frac = parse(Float64, lines[idx])
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
    WriteBDFile(bdfile, outputfile; outputpath=pwd())

Writes a BeamDyn struct to file. 

### Inputs
- bdfile::BDFile : BeamDyn file
- outputfile::String : Name to give the written file. 
- outputpath::String : Path to the desired write location, otherwise, will write at current location. 

"""
function WriteBDFile(bdfile, outputfile; outputpath=pwd())
    lines = String[]
    line = string("-"^9, " BEAMDYN with OpenFAST INPUT FILE ", "-"^43)
    push!(lines,line)
    push!(lines, bdfile.Notes)
    line = string("-"^22, " SIMULATION CONTROL ", "-"^43)
    push!(lines,line)
    line = string(formatword(bdfile.Echo;quotes=false),"   Echo             - Echo  input data to \"<RootName>.ech\"? (flag)")
    push!(lines,line)
    line = string(formatword(string(bdfile.QuasiStaticInit);quotes=false),"     QuasiStaticInit  - Use quasistatic pre-conditioning with centripetal  accelerations in initialization? (flag) [dynamic solve only]")
    push!(lines,line)
    line = string(formatword(string(bdfile.rhoinf);location="back",quotes=false),"   rhoinf           - Numerical damping parameter for generalized-alpha integrator")
    push!(lines,line)
    line = string(formatword(string(bdfile.quadrature);location="back", quotes=false),  "   quadrature       - Quadrature method: 1=Gaussian; 2=Trapezoidal (switch)")
    push!(lines,line)
    line = string(formatword(bdfile.refine;quotes=false),"   refine           - Refinement factor for trapezoidal quadrature (-) [DEFAULT = 1; used only when   quadrature=2]")
    push!(lines,line)
    line = string(formatword(bdfile.n_fact;quotes=false),"   n_fact           -   Factorization frequency for the Jacobian in N-R iteration(-) [DEFAULT = 5]")
    push!(lines,line)
    line = string(formatword(bdfile.DTBeam;quotes=false),"   DTBeam           - Time step size (s)")
    push!(lines,line)
    line = string(formatword(bdfile.load_retries;quotes=false),"   load_retries  -   Number of factored load retries before quitting the aimulation [DEFAULT = 20]")
    push!(lines,line)
    line = string(formatword(bdfile.NRMax;quotes=false),"   NRMax            - Max  number of iterations in Newton-Raphson algorithm (-) [DEFAULT = 10]")
    push!(lines,line)
    line = string(formatword(bdfile.stop_tol;quotes=false),"   stop_tol         -   Tolerance for stopping criterion (-) [DEFAULT = 1E-5]")
    push!(lines,line)
    line = string(formatword(bdfile.tngt_stf_fd;quotes=false),"   tngt_stf_fd      -    Use finite differenced tangent stiffness matrix? (flag)")
    push!(lines,line)
    line = string(formatword(bdfile.tngt_stf_comp;quotes=false),"   tngt_stf_comp       - Compare analytical finite differenced tangent stiffness matrix? (flag)")
    push!(lines,line)
    line = string(formatword(bdfile.tngt_stf_pert;quotes=false),"   tngt_stf_pert       - Perturbation size for finite differencing (-) [DEFAULT = 1E-6]")
    push!(lines,line)
    line = string(formatword(bdfile.tngt_stf_difftol;quotes=false),"    tngt_stf_difftol - Maximum allowable relative difference between analytical and  fd tangent stiffness (-); [DEFAULT = 0.1]")
    push!(lines,line)
    line = string(formatword(bdfile.RotStates;quotes=false),"   RotStates        -  Orient states in the rotating frame during linearization? (flag) [used only when     linearizing]")
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
    mat = formatmatrix(bdfile.geomparams)
    append!(lines, mat)

    line = string("-"^22, " MESH PARAMETER ", "-"^42)
    push!(lines, line)
    line = string(formatword(string(bdfile.order_elem);location="back", quotes=false),  "   order_elem     - Order of interpolation (basis) function (-)")
    push!(lines, line)
    line = string("-"^22, " MATERIAL PARAMETER ", "-"^39)
    push!(lines, line)
    line = string(formatword(bdfile.BldFile;quotes=false, desiredlength=length(bdfile.  BldFile)+1),"   BldFile - Name of file containing properties for blade (quoted    string)")
    push!(lines, line)
    line = string("-"^22, "PITCH ACTUATOR PARAMETERS", "-"^33)
    push!(lines, line)
    line = string(formatword(bdfile.UsePitchAct;quotes=false),"   UsePitchAct -     Whether a pitch actuator should be used (flag)")
    push!(lines, line)
    line = string(formatword(string(bdfile.PitchJ);location="back", quotes=false),"     PitchJ      - Pitch actuator inertia (kg-m^2) [used only when UsePitchAct is true]    ")
    push!(lines, line)
    line = string(formatword(string(bdfile.PitchK);location="back", quotes=false),"     PitchK      - Pitch actuator stiffness (kg-m^2/s^2) [used only when UsePitchAct   is true]")
    push!(lines, line)
    line = string(formatword(string(bdfile.PitchC);location="back", quotes=false),"     PitchC      - Pitch actuator damping (kg-m^2/s) [used only when UsePitchAct is    true]")
    push!(lines, line)
    line = string("-"^22, " OUTPUTS ", "-"^50)
    push!(lines, line)
    line = string(formatword(bdfile.SumPrint;quotes=false),"   SumPrint       - Print   summary data to \"<RootName>.sum\" (flag)")
    push!(lines, line)
    line = string(formatword(bdfile.OutFmt;quotes=false),"   OutFmt          - Format   used for text tabular output, excluding the time channel.")
    push!(lines, line)
    line = string(formatword(string(bdfile.NNodeOuts);quotes=false),"       NNodeOuts      - Number of nodes to output to file [0 - 9] (-)")
    push!(lines, line)
    line = string(formatvector(bdfile.OutNd), "   OutNd          - Nodes whose values   will be output  (-)")
    push!(lines, line)
    line = "          OutList        - The next line(s) contains a list of output   parameters. See OutListParameters.xlsx for a listing of available output  channels, (-)"
    push!(lines, line)
    for i=1:length(bdfile.Outlist)
       local line = bdfile.Outlist[i]
       push!(lines,line)
    end
    line = "END of input file (the word \"END\" must appear in the first 3columns of    this last OutList line)"
    push!(lines,line)
    line = "---------------------- NODE OUTPUTS     --------------------------------------------"
    # push!(lines, line)
    # line = string(formatword(string(bdfile.BldNd_BladesOut);  location="back"quotes=false), "   BldNd_BladesOut  - Blades to output")
    # push!(lines, line)

    # if bdfile.BldNd_BladesOut>0
    #     line = formatvector(bdfile.BldNd_BlOutNd)
    # else
    #     line = " "^11
    # end
    # line = string(line, "   - Blade nodes on each blade (currently unused)")
    line = "         99   BldNd_BlOutNd   - Blade nodes on each blade (currently    unused)" # Not sure if this section will get used because the other sections are   all the same, but for some odd reason, this nodal output section is different. 
    push!(lines, line)
    line = "                   OutList             - The next line(s) contains  list    of output parameters.  See s for a listing of available output channels, (-)"
    push!(lines, line)
    for i=1:length(bdfile.NodeOutlist)
       local line = string("\"", bdfile.NodeOutlist[i], "\"")
       push!(lines,line)
    end
    line = "END of input file (the word \"END\" must appear in the first  columns of    this last OutList line)"
    push!(lines,line)

    cd(outputpath)
    ## Write lines to file
    fi = open(outputfile,"w+")
    i = 1
    for i = 1:length(lines)-1
         write(fi,lines[i])
         write(fi,"\n")
    end
    write(fi,lines[end])
    close(fi)
end

function WriteBDBlade(bdblade, outputfile; outputpath=pwd())
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
            line = string(line, s, "    ")
        end
        push!(lines,line)
    end
    line = string("-"^22, " DISTRIBUTED PROPERTIES ", "-"^30)

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

    cd(outputpath)
    ## Write lines to file
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