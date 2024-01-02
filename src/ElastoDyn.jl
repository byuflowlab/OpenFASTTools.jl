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

**Inputs**: 
- filename::String - The name of the file to be read. 
- filepath::String - The path of the file to be read. 

**Outputs**:
-edfile::EDFile - and ElastoDyn file object
"""
function read_edfile(filename::String, filepath::String)
    fi = open(filepath*"/"*filename, "r")
    lines = readlines(fi)
    close(fi)

    lines = cleanfile!(lines)

    edfile = Dict()
    edfile["Notes"] = lines[1]

    # @show lines[107]
    for i = 2:107 #Todo: I need to update parseline so that if there isn't an entry. Apparently that doesn't screw up OpenFAST. 
        # @show i
        key, entry = parseline(lines[i])
        edfile[key] = entry
    end


    idx = 108
    outlist1idx = findlistbounds(lines[idx:end])

    # # println("")
    # # println("This list")
    if length(outlist1idx)>0 #Todo: Add this check into the other readers. 
        outputs = readlist(lines[idx:idx+outlist1idx[end]-1])
        edfile["OutList"] = outputs
        idx = idx+outlist1idx[end]
    else
        edfile["OutList"] = nothing
        idx = idx
    end



    ### Nodal outputs
    for i = idx:idx+1
        key, entry = parseline(lines[i])
        edfile[key] = entry
    end

    outlist2idx = findlistbounds(lines[idx+2:end])
    if length(outlist2idx)>0
        outlist = readlist(lines[idx+2:idx+2+outlist2idx[end]-1])
        edfile["NodeOutList"] = outlist
    else
        edfile["NodeOutList"] = nothing
    end

    return edfile
end

"""
    read_edblade(filename, filepath)

Reads in an ElastoDyn Blade from file. 

**Inputs**:
- filename::String - The name of the file to be read in.
- filepath::String - The path to the file to be read in. 

**Outputs**:
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

**Inputs**:
- edfile::EDFile - The edfile object
- outputfile::String - The name of the file to be written
- outputpath::String - The location to write the file. 

**Outputs**:
- A written file. 
"""
function write_edfile(edfile::Dict, outputfile::String; outputpath::String=pwd())
    lines = String[]
    line = string("-"^7, " ELASTODYN v1.03.* INPUT FILE ", "-"^43)
    push!(lines, line)

    line = edfile["Notes"]
    push!(lines, line)




    ##########################################################################
    line = string("-"^22, " SIMULATION CONTROL ", "-"^38)
    push!(lines, line)

    line = string(formatword(edfile["Echo"];quotes=false),"   Echo        - Echo input data to \"<RootName>.ech\" (flag)")
    push!(lines, line)

    line = string(formatword(Int(edfile["Method"]);location="back",quotes=false), "   Method      - Integration method: {1: RK4, 2: AB4, or 3: ABM4} (-)")
    push!(lines, line)

    line = string(formatword(edfile["DT"];quotes=false),"   DT          - Integration time step (s)")
    push!(lines, line)






    #########################################################################
    line = string("-"^22, " DEGREES OF FREEDOM ", "-"^38)
    push!(lines, line)

    line = string(formatword(edfile["FlapDOF1"];quotes=false),"   FlapDOF1    - First flapwise blade mode DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile["FlapDOF2"];quotes=false), "   FlapDOF2    - Second flapwise blade mode DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile["EdgeDOF"];quotes=false), "   EdgeDOF     - First edgewise blade mode DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile["TeetDOF"];quotes=false), "   TeetDOF     - Rotor-teeter DOF (flag) [unused for 3 blades]")
    push!(lines, line)

    line = string(formatword(edfile["DrTrDOF"];quotes=false), "   DrTrDOF     - Drivetrain rotational-flexibility DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile["GenDOF"];quotes=false), "   GenDOF      - Generator DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile["YawDOF"];quotes=false), "   YawDOF      - Yaw DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile["TwFADOF1"];quotes=false), "   TwFADOF1    - First fore-aft tower bending-mode DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile["TwFADOF2"];quotes=false), "   TwFADOF2    - Second fore-aft tower bending-mode DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile["TwSSDOF1"];quotes=false), "   TwSSDOF1    - First side-to-side tower bending-mode DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile["TwSSDOF2"];quotes=false), "   TwSSDOF2    - Second side-to-side tower bending-mode DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile["PtfmSgDOF"];quotes=false), "   PtfmSgDOF   - Platform horizontal surge translation DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile["PtfmSwDOF"];quotes=false), "   PtfmSwDOF   - Platform horizontal sway translation DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile["PtfmHvDOF"];quotes=false), "   PtfmHvDOF   - Platform vertical heave translation DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile["PtfmRDOF"];quotes=false), "   PtfmRDOF    - Platform roll tilt rotation DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile["PtfmPDOF"];quotes=false), "   PtfmPDOF    - Platform pitch tilt rotation DOF (flag)")
    push!(lines, line)

    line = string(formatword(edfile["PtfmYDOF"];quotes=false), "   PtfmYDOF    - Platform yaw rotation DOF (flag)")
    push!(lines, line)






    #########################################################################
    line = string("-"^22, " INITIAL CONDITIONS ", "-"^38)
    push!(lines, line)

    line = string(formatword(string(edfile["OoPDefl"]);location="back",quotes=false),"   OoPDefl     - Initial out-of-plane blade-tip displacement (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile["IPDefl"]);location="back",quotes=false),"   IPDefl      - Initial in-plane blade-tip deflection (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile["BlPitch(1)"]);location="back",quotes=false),"   BlPitch(1)  - Blade 1 initial pitch (degrees)")
    push!(lines, line)

    line = string(formatword(string(edfile["BlPitch(2)"]);location="back",quotes=false),"   BlPitch(2)  - Blade 2 initial pitch (degrees)")
    push!(lines, line)

    line = string(formatword(string(edfile["BlPitch(3)"]);location="back",quotes=false),"   BlPitch(3)  - Blade 3 initial pitch (degrees) [unused for 2 blades]")
    push!(lines, line)

    line = string(formatword(string(edfile["TeetDefl"]);location="back",quotes=false),"   TeetDefl    - Initial or fixed teeter angle (degrees) [unused for 3 blades]")
    push!(lines, line)

    line = string(formatword(string(edfile["Azimuth"]);location="back",quotes=false),"   Azimuth     - Initial azimuth angle for blade 1 (degrees)")
    push!(lines, line)

    line = string(formatword(string(edfile["RotSpeed"]);location="back",quotes=false),"   RotSpeed    - Initial or fixed rotor speed (rpm)")
    push!(lines, line)

    line = string(formatword(string(edfile["NacYaw"]);location="back",quotes=false),"   NacYaw      - Initial or fixed nacelle-yaw angle (degrees)")
    push!(lines, line)

    line = string(formatword(string(edfile["TTDspFA"]);location="back",quotes=false),"   TTDspFA     - Initial fore-aft tower-top displacement (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile["TTDspSS"]);location="back",quotes=false),"   TTDspSS     - Initial side-to-side tower-top displacement (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile["PtfmSurge"]);location="back",quotes=false),"   PtfmSurge   - Initial or fixed horizontal surge translational displacement of platform (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile["PtfmSway"]);location="back",quotes=false),"   PtfmSway    - Initial or fixed horizontal sway translational displacement of platform (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile["PtfmHeave"]);location="back",quotes=false),"   PtfmHeave   - Initial or fixed vertical heave translational displacement of platform (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile["PtfmRoll"]);location="back",quotes=false),"   PtfmRoll    - Initial or fixed roll tilt rotational displacement of platform (degrees)")
    push!(lines, line)

    line = string(formatword(string(edfile["PtfmPitch"]);location="back",quotes=false),"   PtfmPitch   - Initial or fixed pitch tilt rotational displacement of platform (degrees)")
    push!(lines, line)

    line = string(formatword(string(edfile["PtfmYaw"]);location="back",quotes=false),"   PtfmYaw     - Initial or fixed yaw rotational displacement of platform (degrees)")
    push!(lines, line)


    #########################################################################
    line = string("-"^22, " TURBINE CONFIGURATION ", "-"^35)
    push!(lines, line)

    line = string(formatword(Int(edfile["NumBl"]);location="back",quotes=false),"   NumBl       - Number of blades (-)")
    push!(lines, line)

    line = string(formatword(string(edfile["TipRad"]);location="back",quotes=false),"   TipRad      - The distance from the rotor apex to the blade tip (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile["HubRad"]);location="back",quotes=false),"   HubRad      - The distance from the rotor apex to the blade root (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile["PreCone(1)"]);location="back",quotes=false),"   PreCone(1)  - Blade 1 cone angle (degrees)")
    push!(lines, line)

    line = string(formatword(string(edfile["PreCone(2)"]);location="back",quotes=false),"   PreCone(2)  - Blade 2 cone angle (degrees)")
    push!(lines, line)

    line = string(formatword(string(edfile["PreCone(3)"]);location="back",quotes=false),"   PreCone(3)  - Blade 3 cone angle (degrees) [unused for 2 blades]")
    push!(lines, line)

    line = string(formatword(string(edfile["HubCM"]);location="back",quotes=false),"   HubCM       - Distance from rotor apex to hub mass [positive downwind] (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile["UndSling"]);location="back",quotes=false),"   UndSling    - Undersling length [distance from teeter pin to the rotor apex] (meters) [unused for 3 blades]")
    push!(lines, line)

    line = string(formatword(string(edfile["Delta3"]);location="back",quotes=false),"   Delta3      - Delta-3 angle for teetering rotors (degrees) [unused for 3 blades]")
    push!(lines, line)

    line = string(formatword(string(edfile["AzimB1Up"]);location="back",quotes=false),"   AzimB1Up    - Azimuth value to use for I/O when blade 1 points up (degrees)")
    push!(lines, line)

    line = string(formatword(string(edfile["OverHang"]);location="back",quotes=false),"   OverHang    - Distance from yaw axis to rotor apex [3 blades] or teeter pin [2 blades] (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile["ShftGagL"]);location="back",quotes=false),"   ShftGagL    - Distance from rotor apex [3 blades] or teeter pin [2 blades] to shaft strain gages [positive for upwind rotors] (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile["ShftTilt"]);location="back",quotes=false),"   ShftTilt    - Rotor shaft tilt angle (degrees)")
    push!(lines, line)

    line = string(formatword(string(edfile["NacCMxn"]);location="back",quotes=false),"   NacCMxn     - Downwind distance from the tower-top to the nacelle CM (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile["NacCMyn"]);location="back",quotes=false),"   NacCMyn     - Lateral  distance from the tower-top to the nacelle CM (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile["NacCMzn"]);location="back",quotes=false),"   NacCMzn     - Vertical distance from the tower-top to the nacelle CM (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile["NcIMUxn"]);location="back",quotes=false),"   NcIMUxn     - Downwind distance from the tower-top to the nacelle IMU (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile["NcIMUyn"]);location="back",quotes=false),"   NcIMUyn     - Lateral  distance from the tower-top to the nacelle IMU (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile["NcIMUzn"]);location="back",quotes=false),"   NcIMUzn     - Vertical distance from the tower-top to the nacelle IMU (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile["Twr2Shft"]);location="back",quotes=false),"   Twr2Shft    - Vertical distance from the tower-top to the rotor shaft (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile["TowerHt"]);location="back",quotes=false),"   TowerHt     - Height of tower above ground level [onshore] or MSL [offshore] (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile["TowerBsHt"]);location="back",quotes=false),"   TowerBsHt   - Height of tower base above ground level [onshore] or MSL [offshore] (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile["PtfmCMxt"]);location="back",quotes=false),"   PtfmCMxt    - Downwind distance from the ground level [onshore] or MSL [offshore] to the platform CM (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile["PtfmCMyt"]);location="back",quotes=false),"   PtfmCMyt    - Lateral distance from the ground level [onshore] or MSL [offshore] to the platform CM (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile["PtfmCMzt"]);location="back",quotes=false),"   PtfmCMzt    - Vertical distance from the ground level [onshore] or MSL [offshore] to the platform CM (meters)")
    push!(lines, line)

    line = string(formatword(string(edfile["PtfmRefzt"]);location="back",quotes=false),"   PtfmRefzt   - Vertical distance from the ground level [onshore] or MSL [offshore] to the platform reference point (meters)")
    push!(lines, line)





    ############################################################
    line = string("-"^22, " MASS AND INERTIA ", "-"^40)
    push!(lines, line)

    line = string(formatword(string(edfile["TipMass(1)"]);location="back",quotes=false),"   TipMass(1)  - Tip-brake mass, blade 1 (kg)")
    push!(lines, line)

    line = string(formatword(string(edfile["TipMass(2)"]);location="back",quotes=false),"   TipMass(2)  - Tip-brake mass, blade 2 (kg)")
    push!(lines, line)

    line = string(formatword(string(edfile["TipMass(3)"]);location="back",quotes=false),"   TipMass(3)  - Tip-brake mass, blade 3 (kg) [unused for 2 blades]")
    push!(lines, line)

    line = string(formatword(string(edfile["HubMass"]);location="back",quotes=false),"   HubMass     - Hub mass (kg)")
    push!(lines, line)

    line = string(formatword(string(edfile["HubIner"]);location="back",quotes=false),"   HubIner     - Hub inertia about rotor axis [3 blades] or teeter axis [2 blades] (kg m^2)")
    push!(lines, line)

    line = string(formatword(string(edfile["GenIner"]);location="back",quotes=false),"   GenIner     - Generator inertia about HSS (kg m^2)")
    push!(lines, line)

    line = string(formatword(string(edfile["NacMass"]);location="back",quotes=false),"   NacMass     - Nacelle mass (kg)")
    push!(lines, line)

    line = string(formatword(string(edfile["NacYIner"]);location="back",quotes=false),"   NacYIner    - Nacelle inertia about yaw axis (kg m^2)")
    push!(lines, line)

    line = string(formatword(string(edfile["YawBrMass"]);location="back",quotes=false),"   YawBrMass   - Yaw bearing mass (kg)")
    push!(lines, line)

    line = string(formatword(string(edfile["PtfmMass"]);location="back",quotes=false),"   PtfmMass    - Platform mass (kg)")
    push!(lines, line)

    line = string(formatword(string(edfile["PtfmRIner"]);location="back",quotes=false),"   PtfmRIner   - Platform inertia for roll tilt rotation about the platform CM (kg m^2)")
    push!(lines, line)

    line = string(formatword(string(edfile["PtfmPIner"]);location="back",quotes=false),"   PtfmPIner   - Platform inertia for pitch tilt rotation about the platform CM (kg m^2)")
    push!(lines, line)

    line = string(formatword(string(edfile["PtfmYIner"]);location="back",quotes=false),"   PtfmYIner   - Platform inertia for yaw rotation about the platform CM (kg m^2)")
    push!(lines, line)









    #######################################################################
    line = string("-"^22, " BLADE ", "-"^51)
    push!(lines, line)

    line = string(formatword(string(edfile["BldNodes"]);location="back",quotes=false),"   BldNodes    - Number of blade nodes (per blade) used for analysis (-)")
    push!(lines, line)

    line = string(formatword(edfile["BldFile(1)"];quotes=true,desiredlength=35), "   BldFile(1)  - Name of file containing properties for blade 1 (quoted string)")
    push!(lines, line)

    line = string(formatword(edfile["BldFile(2)"];quotes=true,desiredlength=35), "   BldFile(2)  - Name of file containing properties for blade 2 (quoted string)")
    push!(lines, line)

    line = string(formatword(edfile["BldFile(3)"];quotes=true,desiredlength=35), "   BldFile(3)  - Name of file containing properties for blade 3 (quoted string) [unused for 2 blades]")
    push!(lines, line)








    #######################################################################
    line = string("_"^22, " ROTOR-TEETER ", "-"^44)
    push!(lines, line)

    line = string(formatword(Int(edfile["TeetMod"]);location="back",quotes=false),"   TeetMod     - Rotor-teeter spring/damper model {0: none, 1: standard, 2: user-defined from routine UserTeet} (switch) [unused for 3 blades]")
    push!(lines, line)

    line = string(formatword(string(edfile["TeetDmpP"]);location="back",quotes=false),"   TeetDmpP    - Rotor-teeter damper position (degrees) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)

    line = string(formatword(string(edfile["TeetDmp"]);location="back",quotes=false),"   TeetDmp     - Rotor-teeter damping constant (N-m/(rad/s)) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)

    line = string(formatword(string(edfile["TeetCDmp"]);location="back",quotes=false),"   TeetCDmp    - Rotor-teeter rate-independent Coulomb-damping moment (N-m) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)

    line = string(formatword(string(edfile["TeetSStP"]);location="back",quotes=false),"   TeetSStP    - Rotor-teeter soft-stop position (degrees) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)

    line = string(formatword(string(edfile["TeetHStP"]);location="back",quotes=false),"   TeetHStP    - Rotor-teeter hard-stop position (degrees) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)

    line = string(formatword(string(edfile["TeetSSSp"]);location="back",quotes=false),"   TeetSSSp    - Rotor-teeter soft-stop linear-spring constant (N-m/rad) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)

    line = string(formatword(string(edfile["TeetHSSp"]);location="back",quotes=false),"   TeetHSSp    - Rotor-teeter hard-stop linear-spring constant (N-m/rad) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)







    #######################################################################
    line = string("-"^22, " DRIVETRAIN ", "-"^46)
    push!(lines, line)

    line = string(formatword(string(edfile["GBoxEff"]);location="back",quotes=false),"   GBoxEff     - Gearbox efficiency (%)")
    push!(lines, line)

    line = string(formatword(string(edfile["GBRatio"]);location="back",quotes=false),"   GBRatio     - Gearbox ratio (-)")
    push!(lines, line)

    line = string(formatword(string(edfile["DTTorSpr"]);location="back",quotes=false),"   DTTorSpr    - Drivetrain torsional spring (N-m/rad)")
    push!(lines, line)

    line = string(formatword(string(edfile["DTTorDmp"]);location="back",quotes=false),"   DTTorDmp    - Drivetrain torsional damper (N-m/(rad/s))")
    push!(lines, line)









    #######################################################################
    line = string("-"^22, " FURLING ", "-"^49)
    push!(lines, line)

    line = string(formatword(string(edfile["Furling"]);location="front",quotes=false),"   Furling     - Read in additional model properties for furling turbine (flag) [must currently be FALSE)")
    push!(lines, line)

    line = string(formatword(edfile["FurlFile"];quotes=true,desiredlength=35),"   FurlFile    - Name of file containing furling properties (quoted string) [unused when Furling=False]")
    push!(lines, line)







    #######################################################################
    line = string("-"^22, " TOWER ", "-"^51)
    push!(lines,line)

    line = string(formatword(Int(edfile["TwrNodes"]);location="back",quotes=false),"   TwrNodes    - Number of tower nodes used for analysis (-)")
    push!(lines, line)

    line = string(formatword(edfile["TwrFile"];quotes=true,desiredlength=35),"   TwrFile     - Name of file containing tower properties (quoted string)")
    push!(lines, line)







    #######################################################################
    line = string("-"^22, " OUTPUT ", "-"^50)
    push!(lines, line)

    line = string(formatword(edfile["SumPrint"];quotes=false), "   SumPrint    - Print summary data to \"<RootName>.sum\" (flag)")
    push!(lines, line)

    line = string(formatword(Int(edfile["OutFile"]);location="back",quotes=false),"   OutFile     - Switch to determine where output will be placed: {1: in module output file only; 2: in glue code output file only; 3: both} (currently unused)")
    push!(lines, line)

    line = string(formatword(edfile["TabDelim"]; quotes=false), "  TabDelim    - Use tab delimiters in text tabular output file? (flag) (currently unused)")
    push!(lines, line)

    line = string(formatword(edfile["OutFmt"]; quotes=true), "   OutFmt      - Format used for text tabular output (except time).  Resulting field should be 10 characters. (quoted string) (currently unused)")
    push!(lines, line)

    line = string(formatword(string(edfile["TStart"]);location="back",quotes=false),"   TStart      - Time to begin tabular output (s) (currently unused)")
    push!(lines, line)

    line = string(formatword(string(edfile["DecFact"]);location="back",quotes=false),"   DecFact     - Decimation factor for tabular output {1: output every time step} (-) (currently unused)")
    push!(lines, line)

    line = string(formatword(string(edfile["NTwGages"]);location="back",quotes=false),"   NTwGages    - Number of tower nodes that have strain gages for output [0 to 9] (-)")
    push!(lines, line)

    if length(edfile["NTwGages"])>0
       line = formatvector(Int.(edfile["TwrGagNd"]))
    else
       line = " "^11
    end

    line = string(line, "   TwrGagNd    - List of tower nodes that have strain gages [1 to TwrNodes] (-) [unused if NTwGages=0]")
    push!(lines, line)

    line = string(formatword(string(edfile["NBlGages"]);location="back",quotes=false),"   NBlGages    - Number of blade nodes that have strain gages for output [0 to 9] (-)")
    push!(lines, line)

    if length(edfile["NBlGages"])>0
       line = formatvector(Int.(edfile["BldGagNd"]))
    else
       line = " "^11
    end
    line = string(line, "   BldGagNd    - List of blade nodes that have strain gages [1 to BldNodes] (-) [unused if NBlGages=0]")
    push!(lines, line)

    line = "              OutList     - The next line(s) contains a list of output parameters.  See OutListParameters.xlsx for a listing of available output channels, (-)"
    push!(lines, line)

    for i=1:length(edfile["OutList"])
       line = formatword(edfile["OutList"][i]; quotes=true)
       push!(lines,line)
    end
    line = "END of input file (the word \"END\" must appear in the first 3 columns of this last OutList line)"
    push!(lines, line)





    #######################################################################
    line = "---------------------- NODE OUTPUTS --------------------------------------------"
    push!(lines, line)

    line = string(formatword(Int(edfile["BldNd_BladesOut"]);location="back",quotes=false, desiredlength=16), "   BldNd_BladesOut  - Blades to output")
    push!(lines, line)

    if edfile["BldNd_BladesOut"]>0
        line = formatvector(edfile["BldNd_BlOutNd"])
    else
        line = " "^11
    end
    line = string(line, "   BldNd_BlOutNd - Blade nodes on each blade (currently unused)")
    push!(lines, line)

    line = "                   OutList             - The next line(s) contains a list of output parameters.  See s for a listing of available output channels, (-)"
    push!(lines, line)

    for i=1:length(edfile["NodeOutList"])
       line = formatword(edfile["NodeOutList"][i]; quotes=true)
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

**Inputs**: 
- edblade::EDBlade - The blade object. Note this might not be defined on the range of the blade radius that AeroDyn is defined on (need to find out).
- outputfile::String - the desired filename to be written.
- outputpath::String - the desired write location. 

**Outputs**:
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


**Inputs**
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

**Outputs**
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