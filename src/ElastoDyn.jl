##############################################################
##################     STRUCTURES     ########################
##############################################################

mutable struct EDFile{TS, TF, TI, TB}
    notes::TS
    echo::TB
    method::TI
    dt::TF
    gravity::TF
    flapdof1::TB
    flapdof2::TB
    edgedof::TB
    teetdof::TB
    drtrdof::TB
    gendof::TB
    yawdof::TB
    twfadof1::TB
    twfadof2::TB
    twssdof1::TB
    twssdof2::TB
    ptfmsgdof::TB
    ptfmswdof::TB
    ptfmhvdof::TB
    ptfmrdof::TB
    ptfmpdof::TB
    ptfmydof::TB
    oopdefl::TF
    ipdefl::TF
    blpitchs::Array{TF, 1} #Initial pitch
    teetdefl::TF
    azimuth::TF
    rotspeed::TF #RPM
    nacyaw::TF
    ttdspfa::TF
    ttdspss::TF
    ptfmsurge::TF
    ptfmsway::TF
    ptfmheave::TF
    ptfmroll::TF
    ptfmpitch::TF
    ptfmyaw::TF
    numbl::TI
    tiprad::TF
    hubrad::TF
    precones::Array{TF, 1} #Todo. length 3 -> There might be an issue using tuples. I suggest using Arrays, then forcing the length. 
    hubcm::TF
    undsling::TF
    delta3::TF
    azimb1up::TF
    overhang::TF
    shftgagl::TF
    shfttilt::TF
    naccmxyzn::Array{TF, 1} 
    ncimuxyzn::Array{TF, 1} 
    twr2shft::TF
    towerht::TF
    towerbsht::TF
    ptfmcmxyzt::Array{TF, 1} 
    ptfmrefzt::TF
    tipmasses::Array{TF, 1} 
    hubmass::TF
    hubiner::TF
    geniner::TF
    nacmass::TF
    nacyiner::TF
    yawbrmass::TF
    ptfmmass::TF
    ptfmriner::TF
    ptfmpiner::TF
    ptfmyiner::TF
    bldnodes::TI #Number of blade nodes
    bldfiles::Array{TS, 1} 
    teetmod::TI
    teetdmpp::TF
    teetdmp::TF
    teetcdmp::TF
    teetsstp::TF
    teethstp::TF
    teetsssp::TF
    teethssp::TF
    gboxeff::TF
    gbratio::TF
    dttorspr::TF
    dttordmp::TF
    furling::TB
    furlfile::TS
    twrnodes::TI
    twrfile::TS
    sumprint::TB
    outfile::TI
    tabdelim::TB #currently unused
    outfmt::TS #currently unused
    tstart::TF #currently unused
    decfact::TI #currently unused
    ntwgages::TI
    twrgagnd::Array{TI, 1}
    nblgages::TI
    bldgagnd::Array{TI, 1}
    outlist::Array{TS, 1}
    bldnd_bladesout::TI
    bldnd_bloutnd::Array{TI, 1} #currently unused
    nodeoutlist::Array{TS, 1}

    ### Base constructor
    function EDFile(notes::TS, echo::TB, method::TI, dt::TF, gravity::TF, flapdof1::TB, flapdof2::TB, edgedof::TB, teetdof::TB, drtrdof::TB, gendof::TB, yawdof::TB, twfadof1::TB, twfadof2::TB, twssdof1::TB, twssdof2::TB, ptfmsgdof::TB, ptfmswdof::TB, ptfmhvdof::TB, ptfmrdof::TB, ptfmpdof::TB, ptfmydof::TB, oopdefl::TF, ipdefl::TF, blpitchs::Array{TF ,1}, teetdefl::TF, azimuth::TF, rotspeed::TF, nacyaw::TF, ttdspfa::TF, ttdspss::TF, ptfmsurge::TF, ptfmsway::TF, ptfmheave::TF, ptfmroll::TF, ptfmpitch::TF, ptfmyaw::TF, numbl::TI, tiprad::TF, hubrad::TF, precones::Array{TF, 1}, hubcm::TF, undsling::TF, delta3::TF, azimb1up::TF, overhang::TF, shftgagl::TF, shfttilt::TF, naccmxyzn::Array{TF, 1}, ncimuxyzn::Array{TF, 1}, twr2shft::TF, towerht::TF, towerbsht::TF, ptfmcmxyzt::Array{TF, 1}, ptfmrefzt::TF, tipmasses::Array{TF, 1}, hubmass::TF, hubiner::TF, geniner::TF, nacmass::TF, nacyiner::TF, yawbrmass::TF, ptfmmass::TF, ptfmriner::TF, ptfmpiner::TF, ptfmyiner::TF, bldnodes::TI, bldfiles::Array{TS, 1}, teetmod::TI, teetdmpp::TF, teetdmp::TF, teetcdmp::TF, teetsstp::TF, teethstp::TF, teetsssp::TF, teethssp::TF, gboxeff::TF, gbratio::TF, dttorspr::TF, dttordmp::TF, furling::TB, furlfile::TS, twrnodes::TI, twrfile::TS, sumprint::TB, outfile::TI, tabdelim::TB, outfmt::TS, tstart::TF, decfact::TI, ntwgages::TI, twrgagnd::Array{TI,1}, nblgages::TI, bldgagnd::Array{TI,1}, outlist::Array{TS,1}, bldnd_bladesout::TI, bldnd_bloutnd::Array{TI,1}, nodeoutlist::Array{TS,1}) where {TS, TF, TI, TB}

        ### Check the lengths of each of the blade characteristics
        if length(blpitchs) != numbl
            error("Please provide pitch information for the given number of blades.")
        end
        if length(blpitchs) > 3
            error("Too many blades described - pitch. OpenFAST can only handle up to 3 bladed turbines.")
        end
        tf = eltype(blpitchs)
        if length(blpitchs) < 3
            while blpitchs <= 2
                push!(blpitchs, tf(0))
            end
        end

        if length(precones) != numbl
            error("Please provide precone information for the given number of blades.")
        end
        if length(precones) > 3
            error("Too many blades described - precone. OpenFAST can only handle up to 3 bladed turbines.")
        end
        if length(precones) < 3
            while precones <= 2
                push!(precones, tf(0))
            end
        end

        if length(tipmasses) != numbl
            error("Please provide tip mass information for the given number of blades.")
        end
        if length(tipmasses) > 3
            error("Too many blades described - tip mass. OpenFAST can only handle up to 3 bladed turbines.")
        end
        if length(tipmasses) < 3
            while tipmasses <= 2
                push!(tipmasses, tf(0))
            end
        end

        if length(bldfiles) != numbl
            error("Please provide bldfiles information for the given number of blades.")
        end
        if length(bldfiles) > 3
            error("Too many blades described - bldfiles. OpenFAST can only handle up to 3 bladed turbines.")
        end
        if length(bldfiles) < 3
            while bldfiles <= 2
                push!(bldfiles, "")
            end
        end

        return new{TS, TF, TI, TB}(notes, echo, method, dt, gravity, flapdof1, flapdof2, edgedof, teetdof, drtrdof, gendof, yawdof, twfadof1, twfadof2, twssdof1, twssdof2, ptfmsgdof, ptfmswdof, ptfmhvdof, ptfmrdof, ptfmpdof, ptfmydof, oopdefl, ipdefl, blpitchs, teetdefl, azimuth, rotspeed, nacyaw, ttdspfa, ttdspss, ptfmsurge, ptfmsway, ptfmheave, ptfmroll, ptfmpitch, ptfmyaw, numbl, tiprad, hubrad, precones, hubcm, undsling, delta3, azimb1up, overhang, shftgagl, shfttilt, naccmxyzn, ncimuxyzn, twr2shft, towerht, towerbsht, ptfmcmxyzt, ptfmrefzt, tipmasses, hubmass, hubiner, geniner, nacmass, nacyiner, yawbrmass, ptfmmass, ptfmriner, ptfmpiner, ptfmyiner, bldnodes, bldfiles, teetmod, teetdmpp, teetdmp, teetcdmp, teetsstp, teethstp, teetsssp, teethssp, gboxeff, gbratio, dttorspr, dttordmp, furling, furlfile, twrnodes, twrfile, sumprint, outfile, tabdelim, outfmt, tstart, decfact, ntwgages, twrgagnd, nblgages, bldgagnd, outlist, bldnd_bladesout, bldnd_bloutnd, nodeoutlist)
    end

end

mutable struct EDBlade{TS, TF, TI}
    notes::TS
    numnds::TI
    flapdamp::Array{TF, 1} #Flapwise damping length 2
    edgedamp::TF #Edgewise damping
    flsttunr::Array{TF, 1} #length 2
    adjblms::TF
    adjflst::TF
    adjedst::TF
    frac::Array{TF, 1}
    pitchaxis::Array{TF, 1}
    twist::Array{TF, 1}
    massdensity::Array{TF, 1}
    flapstiff::Array{TF, 1}
    edgestiff::Array{TF, 1}
    flapmode1::Array{TF, 1} #length 5
    flapmode2::Array{TF, 1} #length 5
    edgemode1::Array{TF, 1} #length 5

    ### Base Constructor
    function EDBlade(notes::TS, numnds::TI, flapdamp::Array{TF, 1}, edgedamp::TF , flsttunr::Array{TF, 1}, adjblms::TF, adjflst::TF, adjedst::TF, frac::Array{TF, 1}, pitchaxis::Array{TF, 1}, twist::Array{TF, 1}, massdensity::Array{TF, 1}, flapstiff::Array{TF, 1}, edgestiff::Array{TF, 1}, flapmode1::Array{TF, 1}, flapmode2::Array{TF, 1}, edgemode1::Array{TF, 1}) where {TS, TI, TF}

        if length(flapdamp) > 2
            error("Too many flap modes described. - EDBlade")
        end
        if length(flapdamp) < 2
            push!(flapdamp, flapdamp[1])
        end

        if length(flsttunr) > 2
            error("Too many flapwise modal stiffness tuners described. - EDBlade")
        end
        if length(flsttunr) < 2
            push!(flsttunr, flsttunr[1])
        end

        if length(flapmode1) > 5
            error("Too many flap mode 1 coefficients provided. - EDBlade")
        end
        tf = eltype(flapmode1)
        if length(flapmode1) < 5
            while length(flapmode1) < 5
                push!(flapmode1, tf(0))
            end
        end

        if length(flapmode2) > 5
            error("Too many flap mode 2 coefficients provided. - EDBlade")
        end
        if length(flapmode2) < 5
            while length(flapmode2) < 5
                push!(flapmode2, tf(0))
            end
        end

        if length(edgemode1) > 5
            error("Too many edge mode 1 coefficients provided. - EDBlade")
        end
        if length(edgemode1) < 5
            while length(edgemode1) < 5
                push!(edgemode1, tf(0))
            end
        end
        
        return new{TS, TF, TI}(notes, numnds, flapdamp, edgedamp, flsttunr, adjblms, adjflst, adjedst, frac, pitchaxis, twist, massdensity, flapstiff, edgestiff, flapmode1, flapmode2, edgemode1)
    end
end

##############################################################
################## READING FUNCTIONS #########################
##############################################################

"""
    read_edfile(filename, filepath)
This function reads in a ElastoDyn input file and stores the values in an ED structure.

### Inputs: 
- filename::String - The name of the file to be read. 
- filepath::String - The path of the file to be read. 

### Outputs:
-edfile::EDFile - and ElastoDyn file object
"""
function read_edfile(filename::String, filepath::String)
    fi = open(filepath*"/"*filename, "r")
    lines = readlines(fi)
    close(fi)

    #Line 1 is the main title
    notes = lines[2]
    #line 3 is a general title
    echo = fetchword(lines[4]; adapt=true)
    method = parse(Int, lines[5][1:14])
    if contains(lowercase(lines[6][1:14]), "d") #If it says default, set the value to zero, and then we'll deal with it in the write function. 
        dt = NaN
    else
        dt = parse(Float64, lines[6][1:14])
    end
    #line 7 is a general title
    gravity = parse(Float64, lines[8][1:14])
    #line 9 is a general title
    flapdof1 = fetchword(lines[10]; adapt=true) 
    flapdof2 = fetchword(lines[11]; adapt=true)
    edgedof = fetchword(lines[12]; adapt=true)
    teetdof = fetchword(lines[13]; adapt=true)
    drtrdof = fetchword(lines[14]; adapt=true)
    gendof = fetchword(lines[15]; adapt=true)
    yawdof = fetchword(lines[16]; adapt=true)
    twfadof1 = fetchword(lines[17]; adapt=true)
    twfadof2 = fetchword(lines[18]; adapt=true)
    twssdof1 = fetchword(lines[19]; adapt=true)
    twssdof2 = fetchword(lines[20]; adapt=true)
    ptfmsgdof = fetchword(lines[21]; adapt=true)
    ptfmswdof = fetchword(lines[22]; adapt=true)
    ptfmhvdof = fetchword(lines[23]; adapt=true)
    ptfmrdof = fetchword(lines[24]; adapt=true)
    ptfmpdof = fetchword(lines[25]; adapt=true)
    ptfmydof = fetchword(lines[26]; adapt=true)
    #line 27 is a general title
    oopdefl = parse(Float64, lines[28][1:14])
    ipdefl = parse(Float64, lines[29][1:14])
    blpitchs = zeros(3)
    blpitchs[1] = parse(Float64, lines[30][1:14])
    blpitchs[2] = parse(Float64, lines[31][1:14])
    blpitchs[3] = parse(Float64, lines[32][1:14])
    teetdefl = parse(Float64, lines[33][1:14])
    azimuth = parse(Float64, lines[34][1:14])
    rotspeed = parse(Float64, lines[35][1:14])
    nacyaw = parse(Float64, lines[36][1:14])
    ttdspfa = parse(Float64, lines[37][1:14])
    ttdspss = parse(Float64, lines[38][1:14])
    ptfmsurge = parse(Float64, lines[39][1:14])
    ptfmsway = parse(Float64, lines[40][1:14])
    ptfmheave = parse(Float64, lines[41][1:14])
    ptfmroll = parse(Float64, lines[42][1:14])
    ptfmpitch = parse(Float64, lines[43][1:14])
    ptfmyaw = parse(Float64, lines[44][1:14])
    #Line 45 is a general title
    numbl = parse(Int, lines[46][1:14])
    tiprad = parse(Float64, lines[47][1:14])
    hubrad = parse(Float64, lines[48][1:14])
    precones = zeros(3)
    precones[1] = parse(Float64, lines[49][1:14])
    precones[2] = parse(Float64, lines[50][1:14])
    precones[3] = parse(Float64, lines[51][1:14])
    hubcm = parse(Float64, lines[52][1:14])
    undsling = parse(Float64, lines[53][1:14])
    delta3 = parse(Float64, lines[54][1:14])
    azimb1up = parse(Float64, lines[55][1:14])
    overhang = parse(Float64, lines[56][1:14])
    shftgagl = parse(Float64, lines[57][1:14])
    shfttilt = parse(Float64, lines[58][1:14])
    naccmxyzn = zeros(3)
    naccmxyzn[1] = parse(Float64, lines[59][1:14])
    naccmxyzn[2] = parse(Float64, lines[60][1:14])
    naccmxyzn[3] = parse(Float64, lines[61][1:14])
    ncimuxyzn = zeros(3)
    ncimuxyzn[1] = parse(Float64, lines[62][1:14])
    ncimuxyzn[2] = parse(Float64, lines[63][1:14])
    ncimuxyzn[3] = parse(Float64, lines[64][1:14])
    twr2shft = parse(Float64, lines[65][1:14])
    towerht = parse(Float64, lines[66][1:14])
    towerbsht = parse(Float64, lines[67][1:14])
    ptfmcmxyzt = zeros(3)
    ptfmcmxyzt[1] = parse(Float64, lines[68][1:14])
    ptfmcmxyzt[2] = parse(Float64, lines[69][1:14])
    ptfmcmxyzt[3] = parse(Float64, lines[70][1:14])
    ptfmrefzt = parse(Float64, lines[71][1:14])
    #Line 72 is a general title
    tipmasses = zeros(3)
    tipmasses[1] = parse(Float64, lines[73][1:14])
    tipmasses[2] = parse(Float64, lines[74][1:14])
    tipmasses[3] = parse(Float64, lines[75][1:14])
    hubmass = parse(Float64, lines[76][1:14])
    hubiner = parse(Float64, lines[77][1:14])
    geniner = parse(Float64, lines[78][1:14])
    nacmass = parse(Float64, lines[79][1:14])
    nacyiner = parse(Float64, lines[80][1:14])
    yawbrmass = parse(Float64, lines[81][1:14])
    ptfmmass = parse(Float64, lines[82][1:14])
    ptfmriner = parse(Float64, lines[83][1:14])
    ptfmpiner = parse(Float64, lines[84][1:14])
    ptfmyiner = parse(Float64, lines[85][1:14])
    #line 86 is a general title
    bldnodes = parse(Int, lines[87][1:14])
    bldfiles = [fetchword(lines[88];lengthofword=35), fetchword(lines[89];lengthofword=35), fetchword(lines[90];lengthofword=35)]
    #line 91 is a general title
    teetmod = parse(Int, lines[92][1:14])
    teetdmpp = parse(Float64, lines[93][1:14])
    teetdmp = parse(Float64, lines[94][1:14])
    teetcdmp = parse(Float64, lines[95][1:14])
    teetsstp = parse(Float64, lines[96][1:14])
    teethstp = parse(Float64, lines[97][1:14])
    teetsssp = parse(Float64, lines[98][1:14])
    teethssp = parse(Float64, lines[99][1:14])
    #line 100 is a general title
    gboxeff = parse(Float64, lines[101][1:14])
    gbratio = parse(Float64, lines[102][1:14])
    dttorspr = parse(Float64, lines[103][1:14])
    dttordmp = parse(Float64, lines[104][1:14])
    #line 105 is a general title
    furling = fetchword(lines[106]; adapt=true)
    furlfile = fetchword(lines[107];lengthofword=30)
    #line 108 is a general title
    twrnodes = parse(Int, lines[109][1:14])
    twrfile = fetchword(lines[110];lengthofword=30)
    #line 111 is a general title
    sumprint = fetchword(lines[112]; adapt=true)
    outfile = parse(Int, lines[113][1:14])
    tabdelim = fetchword(lines[114]; adapt=true)
    outfmt = fetchword(lines[115])
    tstart = parse(Float64, lines[116][1:14])
    decfact = parse(Int, lines[117][1:14])
    ntwgages = parse(Int, lines[118][1:14])
    twrgagnd = readvector(lines[119], ntwgages) #this one returns Ints
    nblgages = parse(Int, lines[120][1:14])
    bldgagnd = readvector(lines[121], nblgages)
    #line 122 is the outlist parameter
    outlist = readoutlist(lines[123:end])
    nodeoutputstitleidx = 0 
    for i = 1:length(lines)
        if lowercase(lines[i][1:3]) == "end"
            nodeoutputstitleidx = i+1 #this is the title index
            break
        end
    end
    bldnd_bladesout = parse(Int, lines[nodeoutputstitleidx+1][1:14])
    bldnd_bloutnd = readvector(lines[nodeoutputstitleidx+2], bldnd_bladesout) 
    # nodeoutputstitleidx+3 is a general title
    nodeoutlist = readoutlist(lines[nodeoutputstitleidx+4:end]) #Todo: This function needs to be upgraded to recognize words with or without quotation marks. 
    # nnn = length(lines[nodeoutputstitleidx+4:end])
    # for i = 1:nnn
    #     println(lines[nodeoutputstitleidx+3+i])
    # end

    return EDFile(notes, echo, method, dt, gravity, flapdof1, flapdof2, edgedof, teetdof, drtrdof, gendof, yawdof, twfadof1, twfadof2, twssdof1, twssdof2, ptfmsgdof, ptfmswdof, ptfmhvdof, ptfmrdof, ptfmpdof, ptfmydof, oopdefl, ipdefl, blpitchs, teetdefl, azimuth, rotspeed, nacyaw, ttdspfa, ttdspss, ptfmsurge, ptfmsway, ptfmheave, ptfmroll, ptfmpitch, ptfmyaw, numbl, tiprad, hubrad, precones, hubcm, undsling, delta3, azimb1up, overhang, shftgagl, shfttilt, naccmxyzn, ncimuxyzn, twr2shft, towerht, towerbsht, ptfmcmxyzt, ptfmrefzt, tipmasses, hubmass, hubiner, geniner, nacmass, nacyiner, yawbrmass, ptfmmass, ptfmriner, ptfmpiner, ptfmyiner, bldnodes, bldfiles, teetmod, teetdmpp, teetdmp, teetcdmp, teetsstp, teethstp, teetsssp, teethssp, gboxeff, gbratio, dttorspr, dttordmp, furling, furlfile, twrnodes, twrfile, sumprint, outfile, tabdelim, outfmt, tstart, decfact, ntwgages, twrgagnd, nblgages, bldgagnd, outlist, bldnd_bladesout, bldnd_bloutnd, nodeoutlist)
end

"""
    read_edblade(filename, filepath)

Reads in an ElastoDyn Blade from file. 

### Inputs:
- filename::String - The name of the file to be read in.
- filepath::String - The path to the file to be read in. 

### Outputs:
- edfile::EDBlade - An ElastoDyn blade object. 
"""
function read_edblade(filename::String, filepath::String)
    fi = open(filepath*"/"*filename, "r")
    lines = readlines(fi)
    close(fi)

    notes = lines[2]
    #Line 3 is a general title
    numnds = parse(Int, lines[4][1:14])
    flapdamp = [parse(Float64, lines[5][1:14]), parse(Float64, lines[6][1:14])]
    edgedamp = parse(Float64, lines[7][1:14])

    #line 8 is a general title
    flsttunr = [parse(Float64, lines[9][1:14]), parse(Float64, lines[10][1:14])]
    adjblms = parse(Float64, lines[11][1:14])
    adjflst = parse(Float64, lines[12][1:14])
    adjedst = parse(Float64, lines[13][1:14])

    #lines 14-16 are general titles
    bldprops = fetchmatrix(lines[17:16+numnds], 88, 6)
    frac = bldprops[:,1]
    pitchaxis = bldprops[:,2]
    twist = bldprops[:,3]
    massdensity = bldprops[:,4]
    flapstiff = bldprops[:,5]
    edgestiff = bldprops[:,6]

    #line 17+numnds is a general title
    flapmode1 = [parse(Float64, lines[18+numnds][1:14]), parse(Float64, lines[19+numnds][1:14]), parse(Float64, lines[20+numnds][1:14]), parse(Float64, lines[21+numnds][1:14]), parse(Float64, lines[22+numnds][1:14])]

    flapmode2 = [parse(Float64, lines[23+numnds][1:14]), parse(Float64, lines[24+numnds][1:14]), parse(Float64, lines[25+numnds][1:14]), parse(Float64, lines[26+numnds][1:14]), parse(Float64, lines[27+numnds][1:14])]

    edgemode1 = [parse(Float64, lines[28+numnds][1:14]), parse(Float64, lines[29+numnds][1:14]), parse(Float64, lines[30+numnds][1:14]), parse(Float64, lines[31+numnds][1:14]), parse(Float64, lines[32+numnds][1:14])]

    return EDBlade(notes, numnds, flapdamp, edgedamp, flsttunr, adjblms, adjflst, adjedst, frac, pitchaxis, twist, massdensity, flapstiff, edgestiff, flapmode1, flapmode2, edgemode1)
end



##############################################################
################## WRITING FUNCTIONS #########################
##############################################################

"""
    write_edfile(edfile, outputfile)

This function takes an ElastoDyn structure and writes it to file.

### Inputs:
- edfile::EDFile - The edfile object
- outputfile::String - The name of the file to be written
- outputpath::String - The location to write the file. 

### Outputs:
- A written file. 
"""
function write_edfile(edfile::EDFile, outputfile::String; outputpath::String=pwd())
    lines = String[]
    line = string("-"^7, " ELASTODYN v1.03.* INPUT FILE ", "-"^43)
    push!(lines, line)

    line = edfile.notes
    push!(lines, line)

    line = string("-"^22, " SIMULATION CONTROL ", "-"^38)
    push!(lines, line)

    line = string(formatword(edfile.echo;quotes=false),"   Echo        - Echo input data to \"<RootName>.ech\" (flag)")
    push!(lines, line)

    line = string(formatword(string(edfile.method);location="back",quotes=false), "   Method      - Integration method: {1: RK4, 2: AB4, or 3: ABM4} (-)")
    push!(lines, line)
    if isnan(edfile.dt)
        line = string(formatword("Default";quotes=true),"   DT          - Integration time step (s)")
    else
        line = string(formatword(edfile.dt;quotes=false),"   DT          - Integration time step (s)")
    end
    
    push!(lines, line)

    line = string("-"^22, " ENVIRONMENTAL CONDITION ", "-"^33)
    push!(lines, line)

    line = string(formatword(string(edfile.gravity);location="back",quotes=false),"   Gravity     - Gravitational acceleration (m/s^2)")
    push!(lines, line)

    line = string("-"^22, " DEGREES OF FREEDOM ", "-"^38)
    push!(lines, line)

    line = string(formatword(edfile.flapdof1;quotes=false),"   FlapDOF1    - First flapwise blade mode DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile.flapdof2;quotes=false), "   FlapDOF2    - Second flapwise blade mode DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile.edgedof;quotes=false), "   EdgeDOF     - First edgewise blade mode DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile.teetdof;quotes=false), "   TeetDOF     - Rotor-teeter DOF (flag) [unused for 3 blades]")
    push!(lines, line)

    line = string(formatword(edfile.drtrdof;quotes=false), "   DrTrDOF     - Drivetrain rotational-flexibility DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile.gendof;quotes=false), "   GenDOF      - Generator DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile.yawdof;quotes=false), "   YawDOF      - Yaw DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile.twfadof1;quotes=false), "   TwFADOF1    - First fore-aft tower bending-mode DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile.twfadof2;quotes=false), "   TwFADOF2    - Second fore-aft tower bending-mode DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile.twssdof1;quotes=false), "   TwSSDOF1    - First side-to-side tower bending-mode DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile.twssdof2;quotes=false), "   TwSSDOF2    - Second side-to-side tower bending-mode DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile.ptfmsgdof;quotes=false), "   PtfmSgDOF   - Platform horizontal surge translation DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile.ptfmswdof;quotes=false), "   PtfmSwDOF   - Platform horizontal sway translation DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile.ptfmhvdof;quotes=false), "   PtfmHvDOF   - Platform vertical heave translation DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile.ptfmrdof;quotes=false), "   PtfmRDOF    - Platform roll tilt rotation DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile.ptfmpdof;quotes=false), "   PtfmPDOF    - Platform pitch tilt rotation DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile.ptfmydof;quotes=false), "   PtfmYDOF    - Platform yaw rotation DOF (flag)")
    push!(lines, line)

    line = string("-"^22, " INITIAL CONDITIONS ", "-"^38)
    push!(lines, line)

    line = string(formatword(string(edfile.oopdefl);location="back",quotes=false),"   OoPDefl     - Initial out-of-plane blade-tip displacement (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile.ipdefl);location="back",quotes=false),"   IPDefl      - Initial in-plane blade-tip deflection (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile.blpitchs[1]);location="back",quotes=false),"   BlPitch(1)  - Blade 1 initial pitch (degrees)")
    push!(lines, line)

    line = string(formatword(string(edfile.blpitchs[2]);location="back",quotes=false),"   BlPitch(2)  - Blade 2 initial pitch (degrees)")
    push!(lines, line)

    line = string(formatword(string(edfile.blpitchs[3]);location="back",quotes=false),"   BlPitch(3)  - Blade 3 initial pitch (degrees) [unused for 2 blades]")
    push!(lines, line)

    line = string(formatword(string(edfile.teetdefl);location="back",quotes=false),"   TeetDefl    - Initial or fixed teeter angle (degrees) [unused for 3 blades]")
    push!(lines, line)

    line = string(formatword(string(edfile.azimuth);location="back",quotes=false),"   Azimuth     - Initial azimuth angle for blade 1 (degrees)")
    push!(lines, line)

    line = string(formatword(string(edfile.rotspeed);location="back",quotes=false),"   RotSpeed    - Initial or fixed rotor speed (rpm)")
    push!(lines, line)

    line = string(formatword(string(edfile.nacyaw);location="back",quotes=false),"   NacYaw      - Initial or fixed nacelle-yaw angle (degrees)")
    push!(lines, line)

    line = string(formatword(string(edfile.ttdspfa);location="back",quotes=false),"   TTDspFA     - Initial fore-aft tower-top displacement (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile.ttdspss);location="back",quotes=false),"   TTDspSS     - Initial side-to-side tower-top displacement (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile.ptfmsurge);location="back",quotes=false),"   PtfmSurge   - Initial or fixed horizontal surge translational displacement of platform (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile.ptfmsway);location="back",quotes=false),"   PtfmSway    - Initial or fixed horizontal sway translational displacement of platform (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile.ptfmheave);location="back",quotes=false),"   PtfmHeave   - Initial or fixed vertical heave translational displacement of platform (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile.ptfmroll);location="back",quotes=false),"   PtfmRoll    - Initial or fixed roll tilt rotational displacement of platform (degrees)")
    push!(lines, line)

    line = string(formatword(string(edfile.ptfmpitch);location="back",quotes=false),"   PtfmPitch   - Initial or fixed pitch tilt rotational displacement of platform (degrees)")
    push!(lines, line)

    line = string(formatword(string(edfile.ptfmyaw);location="back",quotes=false),"   PtfmYaw     - Initial or fixed yaw rotational displacement of platform (degrees)")
    push!(lines, line)

    line = string("-"^22, " TURBINE CONFIGURATION ", "-"^35)
    push!(lines, line)

    line = string(formatword(string(edfile.numbl);location="back",quotes=false),"   NumBl       - Number of blades (-)")
    push!(lines, line)

    line = string(formatword(string(edfile.tiprad);location="back",quotes=false),"   TipRad      - The distance from the rotor apex to the blade tip (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile.hubrad);location="back",quotes=false),"   HubRad      - The distance from the rotor apex to the blade root (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile.precones[1]);location="back",quotes=false),"   PreCone(1)  - Blade 1 cone angle (degrees)")
    push!(lines, line)

    line = string(formatword(string(edfile.precones[2]);location="back",quotes=false),"   PreCone(2)  - Blade 2 cone angle (degrees)")
    push!(lines, line)

    line = string(formatword(string(edfile.precones[3]);location="back",quotes=false),"   PreCone(3)  - Blade 3 cone angle (degrees) [unused for 2 blades]")
    push!(lines, line)

    line = string(formatword(string(edfile.hubcm);location="back",quotes=false),"   HubCM       - Distance from rotor apex to hub mass [positive downwind] (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile.undsling);location="back",quotes=false),"   UndSling    - Undersling length [distance from teeter pin to the rotor apex] (meters) [unused for 3 blades]")
    push!(lines, line)

    line = string(formatword(string(edfile.delta3);location="back",quotes=false),"   Delta3      - Delta-3 angle for teetering rotors (degrees) [unused for 3 blades]")
    push!(lines, line)

    line = string(formatword(string(edfile.azimb1up);location="back",quotes=false),"   AzimB1Up    - Azimuth value to use for I/O when blade 1 points up (degrees)")
    push!(lines, line)

    line = string(formatword(string(edfile.overhang);location="back",quotes=false),"   OverHang    - Distance from yaw axis to rotor apex [3 blades] or teeter pin [2 blades] (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile.shftgagl);location="back",quotes=false),"   ShftGagL    - Distance from rotor apex [3 blades] or teeter pin [2 blades] to shaft strain gages [positive for upwind rotors] (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile.shfttilt);location="back",quotes=false),"   ShftTilt    - Rotor shaft tilt angle (degrees)")
    push!(lines, line)

    line = string(formatword(string(edfile.naccmxyzn[1]);location="back",quotes=false),"   NacCMxn     - Downwind distance from the tower-top to the nacelle CM (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile.naccmxyzn[2]);location="back",quotes=false),"   NacCMyn     - Lateral  distance from the tower-top to the nacelle CM (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile.naccmxyzn[3]);location="back",quotes=false),"   NacCMzn     - Vertical distance from the tower-top to the nacelle CM (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile.ncimuxyzn[1]);location="back",quotes=false),"   NcIMUxn     - Downwind distance from the tower-top to the nacelle IMU (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile.ncimuxyzn[2]);location="back",quotes=false),"   NcIMUyn     - Lateral  distance from the tower-top to the nacelle IMU (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile.ncimuxyzn[3]);location="back",quotes=false),"   NcIMUzn     - Vertical distance from the tower-top to the nacelle IMU (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile.twr2shft);location="back",quotes=false),"   Twr2Shft    - Vertical distance from the tower-top to the rotor shaft (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile.towerht);location="back",quotes=false),"   TowerHt     - Height of tower above ground level [onshore] or MSL [offshore] (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile.towerbsht);location="back",quotes=false),"   TowerBsHt   - Height of tower base above ground level [onshore] or MSL [offshore] (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile.ptfmcmxyzt[1]);location="back",quotes=false),"   PtfmCMxt    - Downwind distance from the ground level [onshore] or MSL [offshore] to the platform CM (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile.ptfmcmxyzt[2]);location="back",quotes=false),"   PtfmCMyt    - Lateral distance from the ground level [onshore] or MSL [offshore] to the platform CM (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile.ptfmcmxyzt[3]);location="back",quotes=false),"   PtfmCMzt    - Vertical distance from the ground level [onshore] or MSL [offshore] to the platform CM (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile.ptfmrefzt);location="back",quotes=false),"   PtfmRefzt   - Vertical distance from the ground level [onshore] or MSL [offshore] to the platform reference point (meters)")
    push!(lines, line)

    line = string("-"^22, " MASS AND INERTIA ", "-"^40)
    push!(lines, line)

    line = string(formatword(string(edfile.tipmasses[1]);location="back",quotes=false),"   TipMass(1)  - Tip-brake mass, blade 1 (kg)")
    push!(lines, line)

    line = string(formatword(string(edfile.tipmasses[2]);location="back",quotes=false),"   TipMass(2)  - Tip-brake mass, blade 2 (kg)")
    push!(lines, line)

    line = string(formatword(string(edfile.tipmasses[3]);location="back",quotes=false),"   TipMass(3)  - Tip-brake mass, blade 3 (kg) [unused for 2 blades]")
    push!(lines, line)

    line = string(formatword(string(edfile.hubmass);location="back",quotes=false),"   HubMass     - Hub mass (kg)")
    push!(lines, line)

    line = string(formatword(string(edfile.hubiner);location="back",quotes=false),"   HubIner     - Hub inertia about rotor axis [3 blades] or teeter axis [2 blades] (kg m^2)")
    push!(lines, line)

    line = string(formatword(string(edfile.geniner);location="back",quotes=false),"   GenIner     - Generator inertia about HSS (kg m^2)")
    push!(lines, line)

    line = string(formatword(string(edfile.nacmass);location="back",quotes=false),"   NacMass     - Nacelle mass (kg)")
    push!(lines, line)

    line = string(formatword(string(edfile.nacyiner);location="back",quotes=false),"   NacYIner    - Nacelle inertia about yaw axis (kg m^2)")
    push!(lines, line)

    line = string(formatword(string(edfile.yawbrmass);location="back",quotes=false),"   YawBrMass   - Yaw bearing mass (kg)")
    push!(lines, line)

    line = string(formatword(string(edfile.ptfmmass);location="back",quotes=false),"   PtfmMass    - Platform mass (kg)")
    push!(lines, line)

    line = string(formatword(string(edfile.ptfmriner);location="back",quotes=false),"   PtfmRIner   - Platform inertia for roll tilt rotation about the platform CM (kg m^2)")
    push!(lines, line)

    line = string(formatword(string(edfile.ptfmpiner);location="back",quotes=false),"   PtfmPIner   - Platform inertia for pitch tilt rotation about the platform CM (kg m^2)")
    push!(lines, line)

    line = string(formatword(string(edfile.ptfmyiner);location="back",quotes=false),"   PtfmYIner   - Platform inertia for yaw rotation about the platform CM (kg m^2)")
    push!(lines, line)

    line = string("-"^22, " BLADE ", "-"^51)
    push!(lines, line)

    line = string(formatword(string(edfile.bldnodes);location="back",quotes=false),"   BldNodes    - Number of blade nodes (per blade) used for analysis (-)")
    push!(lines, line)

    line = string(formatword(edfile.bldfiles[1];quotes=true,desiredlength=35), "   BldFile(1)  - Name of file containing properties for blade 1 (quoted string)")
    push!(lines, line)

    line = string(formatword(edfile.bldfiles[2];quotes=true,desiredlength=35), "   BldFile(2)  - Name of file containing properties for blade 2 (quoted string)")
    push!(lines, line)

    line = string(formatword(edfile.bldfiles[3];quotes=true,desiredlength=35), "   BldFile(3)  - Name of file containing properties for blade 3 (quoted string) [unused for 2 blades]")
    push!(lines, line)

    line = string("_"^22, " ROTOR-TEETER ", "-"^44)
    push!(lines, line)

    line = string(formatword(string(edfile.teetmod);location="back",quotes=false),"   TeetMod     - Rotor-teeter spring/damper model {0: none, 1: standard, 2: user-defined from routine UserTeet} (switch) [unused for 3 blades]")
    push!(lines, line)

    line = string(formatword(string(edfile.teetdmpp);location="back",quotes=false),"   TeetDmpP    - Rotor-teeter damper position (degrees) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)

    line = string(formatword(string(edfile.teetdmp);location="back",quotes=false),"   TeetDmp     - Rotor-teeter damping constant (N-m/(rad/s)) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)

    line = string(formatword(string(edfile.teetcdmp);location="back",quotes=false),"   TeetCDmp    - Rotor-teeter rate-independent Coulomb-damping moment (N-m) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)

    line = string(formatword(string(edfile.teetsstp);location="back",quotes=false),"   TeetSStP    - Rotor-teeter soft-stop position (degrees) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)

    line = string(formatword(string(edfile.teethstp);location="back",quotes=false),"   TeetHStP    - Rotor-teeter hard-stop position (degrees) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)

    line = string(formatword(string(edfile.teetsssp);location="back",quotes=false),"   TeetSSSp    - Rotor-teeter soft-stop linear-spring constant (N-m/rad) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)

    line = string(formatword(string(edfile.teethssp);location="back",quotes=false),"   TeetHSSp    - Rotor-teeter hard-stop linear-spring constant (N-m/rad) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)

    line = string("-"^22, " DRIVETRAIN ", "-"^46)
    push!(lines, line)

    line = string(formatword(string(edfile.gboxeff);location="back",quotes=false),"   GBoxEff     - Gearbox efficiency (%)")
    push!(lines, line)

    line = string(formatword(string(edfile.gbratio);location="back",quotes=false),"   GBRatio     - Gearbox ratio (-)")
    push!(lines, line)

    line = string(formatword(string(edfile.dttorspr);location="back",quotes=false),"   DTTorSpr    - Drivetrain torsional spring (N-m/rad)")
    push!(lines, line)

    line = string(formatword(string(edfile.dttordmp);location="back",quotes=false),"   DTTorDmp    - Drivetrain torsional damper (N-m/(rad/s))")
    push!(lines, line)

    line = string("-"^22, " FURLING ", "-"^49)
    push!(lines, line)

    line = string(formatword(string(edfile.furling);location="front",quotes=false),"   Furling     - Read in additional model properties for furling turbine (flag) [must currently be FALSE)")
    push!(lines, line)

    line = string(formatword(edfile.furlfile;quotes=false,desiredlength=35),"   FurlFile    - Name of file containing furling properties (quoted string) [unused when Furling=False]")
    push!(lines, line)

    line = string("-"^22, " TOWER ", "-"^51)
    push!(lines,line)
    line = string(formatword(string(edfile.twrnodes);location="back",quotes=false),"   TwrNodes    - Number of tower nodes used for analysis (-)")
    push!(lines, line)

    line = string(formatword(edfile.twrfile;quotes=false,desiredlength=35),"   TwrFile     - Name of file containing tower properties (quoted string)")
    push!(lines, line)

    line = string("-"^22, " OUTPUT ", "-"^50)
    push!(lines, line)

    line = string(formatword(edfile.sumprint;quotes=false), "   SumPrint    - Print summary data to \"<RootName>.sum\" (flag)")
    push!(lines, line)

    line = string(formatword(string(edfile.outfile);location="back",quotes=false),"   OutFile     - Switch to determine where output will be placed: {1: in module output file only; 2: in glue code output file only; 3: both} (currently unused)")
    push!(lines, line)

    line = string(formatword(edfile.tabdelim;quotes=false), "  TabDelim    - Use tab delimiters in text tabular output file? (flag) (currently unused)")
    push!(lines, line)

    line = string(formatword(edfile.outfmt;quotes=true), "   OutFmt      - Format used for text tabular output (except time).  Resulting field should be 10 characters. (quoted string) (currently unused)")
    push!(lines, line)

    line = string(formatword(string(edfile.tstart);location="back",quotes=false),"   TStart      - Time to begin tabular output (s) (currently unused)")
    push!(lines, line)

    line = string(formatword(string(edfile.decfact);location="back",quotes=false),"   DecFact     - Decimation factor for tabular output {1: output every time step} (-) (currently unused)")
    push!(lines, line)

    line = string(formatword(string(edfile.ntwgages);location="back",quotes=false),"   NTwGages    - Number of tower nodes that have strain gages for output [0 to 9] (-)")
    push!(lines, line)

    if edfile.ntwgages>0
       line = formatvector(edfile.twrgagnd)
    else
       line = " "^11
    end
    line = string(line, "   TwrGagNd    - List of tower nodes that have strain gages [1 to TwrNodes] (-) [unused if NTwGages=0]")
    push!(lines, line)

    line = string(formatword(string(edfile.nblgages);location="back",quotes=false),"   NBlGages    - Number of blade nodes that have strain gages for output [0 to 9] (-)")
    push!(lines, line)

    if edfile.nblgages>0
       line = formatvector(edfile.bldgagnd)
    else
       line = " "^11
    end
    line = string(line, "   BldGagNd    - List of blade nodes that have strain gages [1 to BldNodes] (-) [unused if NBlGages=0]")
    push!(lines, line)

    line = "              OutList     - The next line(s) contains a list of output parameters.  See OutListParameters.xlsx for a listing of available output channels, (-)"
    push!(lines, line)

    for i=1:length(edfile.outlist)
       line = string("\"",edfile.outlist[i],"\"")
       push!(lines,line)
    end
    line = "END of input file (the word \"END\" must appear in the first 3 columns of this last OutList line)"
    push!(lines, line)

    line = "---------------------- NODE OUTPUTS --------------------------------------------"
    push!(lines, line)

    line = string(formatword(string(edfile.bldnd_bladesout);location="back",quotes=false), "   BldNd_BladesOut  - Blades to output")
    push!(lines, line)

    if edfile.bldnd_bladesout>0
        line = formatvector(edfile.bldnd_bloutnd)
    else
        line = " "^11
    end
     line = string(line, "   - Blade nodes on each blade (currently unused)")
     push!(lines, line)

     line = "                   OutList             - The next line(s) contains a list of output parameters.  See s for a listing of available output channels, (-)"
     push!(lines, line)

     for i=1:length(edfile.nodeoutlist)
        line = string("\"", edfile.nodeoutlist[i], "\"")
        push!(lines,line)
     end
     line = "END of input file (the word \"END\" must appear in the first 3 columns of this last OutList line)"
     push!(lines,line)

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

"""
    write_edblade(edblade, outputfile; outputpath=pwd())

Takes an edblade structure and prints it to file.

### Inputs: 
- edblade::EDBlade - The blade object. Note this might not be defined on the range of the blade radius that AeroDyn is defined on (need to find out).
- outputfile::String - the desired filename to be written.
- outputpath::String - the desired write location. 

### Outputs:
- A written file. 


"""
function write_edblade(edblade::EDBlade, outputfile::String; outputpath::String=pwd())
    lines = String[]
    line = string("-"^7, "  ELASTODYN V1.00.* INDIVIDUAL BLADE INPUT FILE  ", "-"^26)
    push!(lines, line)

    line = edblade.notes
    push!(lines, line)

    line = string("-"^22, " BLADE PARAMETERS ", "-"^40)
    push!(lines, line)

    line = string(formatword(string(edblade.numnds);location="back", quotes=false),"   NBlInpSt    - Number of blade input stations (-)")
    push!(lines, line)

    line = string(formatword(string(edblade.flapdamp[1]);location="back", quotes=false),"   BldFlDmp(1) - Blade flap mode #1 structural damping in percent of critical (%)")
    push!(lines, line)

    line = string(formatword(string(edblade.flapdamp[2]);location="back", quotes=false),"   BldFlDmp(2) - Blade flap mode #2 structural damping in percent of critical (%)")
    push!(lines, line)
    
    line = string(formatword(string(edblade.edgedamp);location="back", quotes=false),"   BldEdDmp(1) - Blade edge mode #1 structural damping in percent of critical (%)")
    push!(lines, line)

    line = string("-"^22, " BLADE ADJUSTMENT FACTORS ", "-"^32)
    push!(lines, line)

    line = string(formatword(string(edblade.flsttunr[1]);location="back", quotes=false),"   FlStTunr(1) - Blade flapwise modal stiffness tuner, 1st mode (-)")
    push!(lines, line)

    line = string(formatword(string(edblade.flsttunr[2]);location="back", quotes=false),"   FlStTunr(2) - Blade flapwise modal stiffness tuner, 2nd mode (-)")
    push!(lines, line)

    line = string(formatword(string(edblade.adjblms);location="back", quotes=false),"   AdjBlMs     - Factor to adjust blade mass density (-)  !bjj: value for AD14=1.04536; value for AD15=1.057344 (it would be nice to enter the requested blade mass instead of a factor here)")
    push!(lines, line)

    line = string(formatword(string(edblade.adjflst);location="back", quotes=false),"   AdjFlSt     - Factor to adjust blade flap stiffness (-)")
    push!(lines, line)

    line = string(formatword(string(edblade.adjedst);location="back", quotes=false),"   AdjEdSt     - Factor to adjust blade edge stiffness (-)")
    push!(lines, line)

    line = string("-"^22, " DISTRIBUTED BLADE PROPERTIES ", "-"^28)
    push!(lines, line)

    line = "    BlFract      PitchAxis      StrcTwst       BMassDen        FlpStff        EdgStff"
    push!(lines, line)

    line = "      (-)           (-)          (deg)          (kg/m)         (Nm^2)         (Nm^2)"
    push!(lines, line)

    BldProps = hcat(edblade.frac, edblade.pitchaxis, edblade.twist, edblade.massdensity, edblade.flapstiff, edblade.edgestiff)
    line = formatmatrix(BldProps)
    append!(lines, line)

    line = string("-"^22, " BLADE MODE SHAPES ", "-"^39)
    push!(lines, line)

    line = string(formatword(string(edblade.flapmode1[1]);location="back", quotes=false),"   BldFl1Sh(2) - Flap mode 1, coeff of x^2")
    push!(lines, line)

    line = string(formatword(string(edblade.flapmode1[2]);location="back", quotes=false),"   BldFl1Sh(3) -            , coeff of x^3")
    push!(lines, line)

    line = string(formatword(string(edblade.flapmode1[3]);location="back", quotes=false),"   BldFl1Sh(4) -            , coeff of x^4")
    push!(lines, line)

    line = string(formatword(string(edblade.flapmode1[4]);location="back", quotes=false),"   BldFl1Sh(5) -            , coeff of x^5")
    push!(lines, line)

    line = string(formatword(string(edblade.flapmode1[5]);location="back", quotes=false),"   BldFl1Sh(6) -            , coeff of x^6")
    push!(lines, line)

    line = string(formatword(string(edblade.flapmode2[1]);location="back", quotes=false),"   BldFl2Sh(2) - Flap mode 2, coeff of x^2")
    push!(lines, line)

    line = string(formatword(string(edblade.flapmode2[2]);location="back", quotes=false),"   BldFl2Sh(3) -            , coeff of x^3")
    push!(lines, line)

    line = string(formatword(string(edblade.flapmode2[3]);location="back", quotes=false),"   BldFl2Sh(4) -            , coeff of x^4")
    push!(lines, line)

    line = string(formatword(string(edblade.flapmode2[4]);location="back", quotes=false),"   BldFl2Sh(5) -            , coeff of x^5")
    push!(lines, line)

    line = string(formatword(string(edblade.flapmode2[5]);location="back", quotes=false),"   BldFl2Sh(6) -            , coeff of x^6")
    push!(lines, line)

    line = string(formatword(string(edblade.edgemode1[1]);location="back", quotes=false),"   BldEdgSh(2) - Edge mode 1, coeff of x^2")
    push!(lines, line)

    line = string(formatword(string(edblade.edgemode1[2]);location="back", quotes=false),"   BldEdgSh(3) -            , coeff of x^3")
    push!(lines, line)

    line = string(formatword(string(edblade.edgemode1[3]);location="back", quotes=false),"   BldEdgSh(4) -            , coeff of x^4")
    push!(lines, line)

    line = string(formatword(string(edblade.edgemode1[4]);location="back", quotes=false),"   BldEdgSh(5) -            , coeff of x^5")
    push!(lines, line)

    line = string(formatword(string(edblade.edgemode1[5]);location="back", quotes=false),"   BldEdgSh(6) -            , coeff of x^6")
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