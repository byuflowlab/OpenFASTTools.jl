##############################################################
##################     STRUCTURES     ########################
##############################################################

# mutable struct BDFile{TS, TB, TF, TI}
#     notes::TS
#     echo::TB
#     quasistaticinit::TB
#     rhoinf::TF
#     quadrature::TI
#     refine::TI #has default
#     n_fract::TI #has default
#     dtbeam::TF #has default
#     load_retries::TI #has default
#     nrmax::TI #has default
#     stop_tol::TF #has default
#     tngt_stf_fd::Flag #has default  
#     tngt_stf_comp::Flag #has default 
#     tngt_stf_pert::TF #has default
#     tngt_stf_difftol::TF #has default
#     rotstates::TB
#     member_total::TI
#     kp_total::TI
#     membernumber::Array{Tuple{TI, TI}, 1}
#     kp_xr::Array{TF, 1}
#     kp_yr::Array{TF, 1}
#     kp_zr::Array{TF, 1}
#     initial_twist::Array{TF, 1}
#     order_elem::TI
#     bldfile::TS
#     usepitchact::TB
#     pitchj::TF
#     pitchk::TF
#     pitchc::TF
#     sumprint::TB
#     outfmt::TS
#     nnodeouts::TI
#     outnd::Array{TI, 1}
#     outlist::Array{TS, 1}
#     nodeoutlist::Array{TS, 1}

#     function BDFile(Notes::TS, Echo::TB, QuasiStaticInit::TB, rhoinf::TF, quadrature::TI, refine::TI, n_fract::TI, DTBeam::TF, load_retries::TI, NRMax::TI, stop_tol::TF, tngt_stf_fd::Flag  , tngt_stf_comp::Flag , tngt_stf_pert::TF, tngt_stf_difftol::TF, RotStates::TB, member_total::TI, kp_total::TI, membernumber::Array{Tuple{TI, TI}, 1}, kp_xr::Array{TF, 1}, kp_yr::Array{TF, 1}, kp_zr::Array{TF, 1}, initial_twist::Array{TF, 1}, order_elem::TI, BldFile::TS, UsePitchAct::TB, PitchJ::TF, PitchK::TF, PitchC::TF, SumPrint::TB, OutFmt::TS, NNodeOuts::TI, OutNd::Array{TI, 1}, Outlist::Array{TS, 1}, NodeOutlist::Array{TS, 1}) where {TS, TB, TF, TI}

#         if length(kp_xr) != length(kp_yr) != length(kp_zr) != length(initial_twist)
#             error("Geometry Parameters not all the same length. - BeamDyn File")
#         end

#         if kp_total != length(kp_xr)
#             warning("Number of Key Points not correctly declared. - BeamDyn File")
#             kp_total = length(kp_xr)
#         end

#         return new{TS, TB, TF, TI}(Notes, Echo, QuasiStaticInit, rhoinf, quadrature, refine, n_fract, DTBeam, load_retries, NRMax, stop_tol, tngt_stf_fd, tngt_stf_comp, tngt_stf_pert, tngt_stf_difftol, RotStates, member_total, kp_total, membernumber, kp_xr, kp_yr, kp_zr, initial_twist, order_elem, BldFile, UsePitchAct, PitchJ, PitchK, PitchC, SumPrint, OutFmt, NNodeOuts, OutNd, Outlist, NodeOutlist)
#     end
# end


# # mutable struct BDBladeNode{TF}
# #     frac::TF
# #     stiffmatrix::Array{TF, 2}
# #     massmatrix::Array{TF, 2}

# #     #Stiffness Matrix values
# #     shredg::TF
# #     shrflp::TF
# #     ea::TF
# #     eiedg::TF
# #     eiflp::TF
# #     gj::TF
# #     e::TF
# #     g::TF
# #     j::TF

# #     #Mass Matrix values
# #     mass::TF
# #     ycm::TF
# #     xcm::TF
# #     iedg::TF
# #     icp::TF
# #     iflp::TF
# #     iplr::TF

# #     # function BDBlade(frac::TF, stiffmatrix::Array{TF, 2}, massmatrix::Array{TF, 2}, shredg::TF, shrflp::TF, ea::TF, eiedg::TF, eiflp::TF, gj::TF, e::TF, g::TF, j::TF, mass::TF, ycm::TF, xcm::TF, iedg::TF, icp::TF, iflp::TF, iplr::TF) where {TF}

# #     #     return new{TF}(frac, stiffmat, massmat, shredg, shrflp, EA, EIedg, EIflp, GJ, E, G, J, mass, Ycm, Xcm, iedg, icp, iflp, iplr)
# #     # end
# # end

# """
#     makenode(frac, stiffmat, massmat)

# Take the makings of a BeamDyn blade node and make it into a node. 

# ### Inputs
# - frac::Float64 - The percentage of the blade (not including hub distance) that the node is defined at. 
# - stiffmat::Array{Float64, 2} - The 6x6 array defining the flap, edge, and polar shear and extension stiffnesses. See the OpenFAST docs for a description of this matrix (and the next one). 
# - massmat::Array{Float64, 2} - The 6x6 array defining the mass, center of mass, and area moment of inertia. 

# ### Outputs
# - BDBladeNode - An object containing the extractable data from the matrices. 
# """
# function makenode(frac, stiffmat, massmat)
#     mass = massmat[1,1]
#     Ycm = massmat[3,4]/mass
#     Xcm = massmat[2,6]/mass
#     iedg = massmat[4,4]
#     iflp = massmat[5,5]
#     icp = -massmat[4,5]
#     iplr = massmat[6,6]

#     shrflp = stiffmat[1,1]
#     shredg = stiffmat[2,2]
#     EA = stiffmat[3,3]
#     EIedg = stiffmat[4,4]
#     EIflp = stiffmat[5,5]
#     GJ = stiffmat[6,6]
#     E = 1.0 # EIedg/iedg #Todo: I don't think that this works... because that i should be the mass momentum of inertia. 
#     G = 1.0
#     J = 1.0 #Isn't that the iplr? No, because it is Ix + Iy, not ix + iy. It's the difference if mass is included or not. 
    

#     return BDBladeNode(frac, stiffmat, massmat, shredg, shrflp, EA, EIedg, EIflp, GJ, E, G, J, mass, Ycm, Xcm, iedg, icp, iflp, iplr)
# end

# mutable struct BDBlade{TS, TF, TI}
#     Notes::TS
#     station_total::TI
#     damp_type::TI
#     dampcoef::Array{TF,1} #Length = 6
#     nodes::Array{BDBladeNode,1}
# end

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
- bdfile::Dict - a dictionary holding the BeamDyn primary file. 
"""
function read_bdfile(filename::String, filepath::String)
    fi = open(filepath*"/"*filename, "r")
    lines = readlines(fi)
    close(fi)

    lines = cleanfile!(lines)

    bdfile = Dict()
    bdfile["Notes"] = lines[1]

    for i = 2:18
        key, entry = parseline(lines[i])
        bdfile[key] = entry
    end

    idx = 18+Int(bdfile["member_total"])
    bdfile["KeyPairs"] = parsepairs(lines[19:idx])

    twrnames, twrdata = parsematrix(lines[idx+1:idx+Int(bdfile["kp_total"])+2])

    #Todo: The parsematrix function only works when there aren't comments interjected in the header of the  function.... :| I might need to come up with an alternate function. :| ... At least when it comes to getting the     length of the matrix I'm trying to read. 
    for i = eachindex(twrnames)
        bdfile[twrnames[i]] = twrdata[:,i]
    end

    idx += Int(bdfile["kp_total"]) + 3

    for i = idx:idx+10
        key, entry = parseline(lines[i])
        bdfile[key] = entry
    end

    ### Outputs section
    outlist1idx = findlistbounds(lines[idx+11:end])

    outputs = readlist(lines[idx+11:idx+11+outlist1idx[end]-1])
    bdfile["OutList"] = outputs

    idx = idx+11+outlist1idx[end]

    for i = idx:idx+1
        key, entry = parseline(lines[i])
        bdfile[key] = entry
    end

    ### Nodal outputs
    outlist2idx = findlistbounds(lines[idx+2:end])
    outlist = readlist(lines[idx+2:idx+2+outlist2idx[end]-1])
    bdfile["NodeOutList"] = outlist

    return bdfile
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

    lines = cleanfile!(lines)

    bdblade = Dict()
    bdblade["Notes"] = lines[1]

    for i = 2:3
        key, entry = parseline(lines[i])
        bdblade[key] = entry
    end

    _, mus = parsematrix(lines[4:6])

    bdblade["mu"] = mus

    rfracvec = zeros(Int(bdblade["station_total"]))

    for i = 1:Int(bdblade["station_total"])
        idx = (i-1) + 6 + 14*(i-1)
        # @show lines[idx+1]
        rfracvec[i] = parseentry(lines[idx+1])

        bdblade["K$i"] = parsematrix(lines[idx+2:idx+7]; nameheader=false)
        bdblade["M$i"] = parsematrix(lines[idx+9:idx+14]; nameheader=false)
    end

    bdblade["rfrac"] = rfracvec

    return bdblade
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
function write_bdfile(bdfile::Dict, outputfile::String; outputpath::String=pwd())
    lines = String[]
    line = string("-"^9, " BEAMDYN with OpenFAST INPUT FILE ", "-"^43)
    push!(lines,line)

    push!(lines, bdfile["Notes"])




    ##############################################################
    line = string("-"^22, " SIMULATION CONTROL ", "-"^43)
    push!(lines,line)

    line = string(formatword(bdfile["Echo"];quotes=false),"   Echo             - Echo  input data to \"<RootName>.ech\"? (flag)")
    push!(lines,line)

    line = string(formatword(string(bdfile["QuasiStaticInit"]);quotes=false),"   QuasiStaticInit  - Use quasistatic pre-conditioning with centripetal  accelerations in initialization? (flag) [dynamic solve only]")
    push!(lines,line)

    line = string(formatword(string(bdfile["rhoinf"]);location="back",quotes=false),"   rhoinf           - Numerical damping parameter for generalized-alpha integrator")
    push!(lines,line)

    line = string(formatword(Int(bdfile["quadrature"]);location="back", quotes=false),  "   quadrature       - Quadrature method: 1=Gaussian; 2=Trapezoidal (switch)")
    push!(lines,line)

    line = string(formatword(bdfile["refine"];quotes=false),"   refine           - Refinement factor for trapezoidal quadrature (-) [DEFAULT = 1; used only when   quadrature=2]")
    push!(lines,line)

    line = string(formatword(bdfile["n_fact"];quotes=false),"   n_fact           -   Factorization frequency for the Jacobian in N-R iteration(-) [DEFAULT = 5]")
    push!(lines,line)

    line = string(formatword(bdfile["DTBeam"];quotes=false),"   DTBeam           - Time step size (s)")
    push!(lines,line)

    line = string(formatword(bdfile["load_retries"];quotes=false),"   load_retries  -   Number of factored load retries before quitting the aimulation [DEFAULT = 20]")
    push!(lines,line)

    line = string(formatword(Int(bdfile["NRMax"]);quotes=false),"   NRMax            - Max  number of iterations in Newton-Raphson algorithm (-) [DEFAULT = 10]")
    push!(lines,line)

    line = string(formatword(bdfile["stop_tol"];quotes=false),"   stop_tol         -   Tolerance for stopping criterion (-) [DEFAULT = 1E-5]")
    push!(lines,line)

    line = string(formatword(bdfile["tngt_stf_fd"];quotes=false),"   tngt_stf_fd      -    Use finite differenced tangent stiffness matrix? (flag)")
    push!(lines,line)

    line = string(formatword(bdfile["tngt_stf_comp"];quotes=false),"   tngt_stf_comp       - Compare analytical finite differenced tangent stiffness matrix? (flag)")
    push!(lines,line)

    line = string(formatword(bdfile["tngt_stf_pert"];quotes=false),"   tngt_stf_pert       - Perturbation size for finite differencing (-) [DEFAULT = 1E-6]")
    push!(lines,line)

    line = string(formatword(bdfile["tngt_stf_difftol"];quotes=false),"   tngt_stf_difftol - Maximum allowable relative difference between analytical and  fd tangent stiffness (-); [DEFAULT = 0.1]")
    push!(lines,line)

    line = string(formatword(bdfile["RotStates"];quotes=false),"   RotStates        -  Orient states in the rotating frame during linearization? (flag) [used only when     linearizing]")
    push!(lines,line)












    ##############################################################
    line = string("-"^22, " GEOMETRY PARAMETER ", "-"^42)
    push!(lines, line)

    line = string(formatword(Int(bdfile["member_total"]);location="back",   quotes=false),"   member_total    - Total number of members (-)")
    push!(lines,line)

    line = string(formatword(Int(bdfile["kp_total"]);location="back", quotes=false),    "   kp_total        - Total number of key points (-) [must be at least 3]")
    push!(lines,line)

    if bdfile["member_total"]==1
        local line = string(formatpair(Int.(bdfile["KeyPairs"][1,:])), "       - Member    number; Number of key points in this member ")
        push!(lines, line)
    else
        line = string(formatpair(Int.(bdfile["KeyPairs"][1,:])), "       - Member number;  Number of key points in this member ")
        push!(lines, line)
        
        for i = 2:bdfile["member_total"]
            line = formatpair(Int.(bdfile["KeyPairs"][i, :]))
            push!(lines,line)

        end
    end

    line = "   kp_xr         kp_yr         kp_zr        initial_twist"
    push!(lines,line)

    line = "   (m)            (m)          (m)            (deg)"
    push!(lines,line)

    mat = formatmatrix(hcat(bdfile["kp_xr"], bdfile["kp_yr"], bdfile["kp_zr"], bdfile["initial_twist"]))
    append!(lines, mat)








    ##############################################################
    line = string("-"^22, " MESH PARAMETER ", "-"^42)
    push!(lines, line)

    line = string(formatword(Int(bdfile["order_elem"]);location="back", quotes=false),  "   order_elem     - Order of interpolation (basis) function (-)")
    push!(lines, line)











    ##############################################################
    line = string("-"^22, " MATERIAL PARAMETER ", "-"^39)
    push!(lines, line)

    line = string(formatword(bdfile["BldFile"];quotes=true, desiredlength=length(bdfile["BldFile"])+2),"   BldFile - Name of file containing properties for blade (quoted    string)")
    push!(lines, line)








    ##############################################################
    line = string("-"^22, "PITCH ACTUATOR PARAMETERS", "-"^33)
    push!(lines, line)

    line = string(formatword(bdfile["UsePitchAct"];quotes=false),"   UsePitchAct -     Whether a pitch actuator should be used (flag)")
    push!(lines, line)

    line = string(formatword(string(bdfile["PitchJ"]);location="back", quotes=false),"     PitchJ      - Pitch actuator inertia (kg-m^2) [used only when UsePitchAct is true]    ")
    push!(lines, line)

    line = string(formatword(string(bdfile["PitchK"]);location="back", quotes=false),"     PitchK      - Pitch actuator stiffness (kg-m^2/s^2) [used only when UsePitchAct   is true]")
    push!(lines, line)

    line = string(formatword(string(bdfile["PitchC"]);location="back", quotes=false),"     PitchC      - Pitch actuator damping (kg-m^2/s) [used only when UsePitchAct is    true]")
    push!(lines, line)










    ##############################################################
    line = string("-"^22, " OUTPUTS ", "-"^50)
    push!(lines, line)

    line = string(formatword(bdfile["SumPrint"];quotes=false),"   SumPrint       - Print   summary data to \"<RootName>.sum\" (flag)")
    push!(lines, line)

    line = string(formatword(bdfile["OutFmt"];quotes=true),"   OutFmt          - Format   used for text tabular output, excluding the time channel.")
    push!(lines, line)

    line = string(formatword(Int(bdfile["NNodeOuts"]);quotes=false),"       NNodeOuts      - Number of nodes to output to file [0 - 9] (-)")
    push!(lines, line)

    line = string(formatvector(Int.(bdfile["OutNd"])), "   OutNd          - Nodes whose values   will be output  (-)")
    push!(lines, line)

    # line = 
    # push!(lines, line)

    for i=1:length(bdfile["OutList"])
        local line = formatword(bdfile["OutList"][i]; quotes=true)
        if i==1
            line = line*"          OutList        - The next line(s) contains a list of output   parameters. See OutListParameters.xlsx for a listing of available output  channels, (-)"
        end
       push!(lines,line)

    end
    line = "END of input file (the word \"END\" must appear in the first 3columns of    this last OutList line)"
    push!(lines,line)

    line = "---------------------- NODE OUTPUTS --------------------------------------------"
    push!(lines,line)

    line = string(formatvector(Int(bdfile["BldNd_BladesOut"])), "   BldNd_BladesOut  - Blades to output")
    push!(lines, line)

    line = string(formatvector(bdfile["BldNd_BlOutNd"]), "   BldNd_BlOutNd - Blade nodes on each blade (currently unused)")
    push!(lines, line)

    line = "                   OutList             - The next line(s) contains  list    of output parameters.  See s for a listing of available output channels, (-)"
    push!(lines, line)

    for i=1:length(bdfile["NodeOutList"])
       local line = formatword(bdfile["NodeOutList"][i]; quotes=true)
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
function write_bdblade(bdblade::Dict, outputfile::String; outputpath::String=pwd())
    
    lines = String[]
    line = string("-"^9, " BEAMDYN V1.00.* INDIVIDUAL BLADE INPUT FILE ", "-"^43)
    push!(lines,line)
    push!(lines, bdblade["Notes"])



    line = string("-"^22, " BLADE PARAMETERS ", "-"^43)
    push!(lines,line)
    line = string(formatword(Int(bdblade["station_total"]);location="back", quotes=false, desiredlength=5),  "   station_total    - Number of blade input stations (-)")
    push!(lines,line)
    line = string(formatword(Int(bdblade["damp_type"]);location="back", quotes=false, desiredlength=5),  "   damp_type        - Damping type: 0: no damping; 1: damped")
    push!(lines,line)




    ##############################################################
    line = string("-"^22, " DAMPING COEFFICIENT ", "-"^30)
    push!(lines,line)
    line = "   mu1        mu2        mu3        mu4        mu5        mu6"
    push!(lines,line)   
    line = "   (-)        (-)        (-)        (-)        (-)        (-)"
    push!(lines,line)
    let
        line = ""
        for i = 1:length(bdblade["mu"])
            s = @sprintf "%.1E" bdblade["mu"][i]
            if i<length(bdblade["mu"])
                space = "    "
            else
                space = ""
            end
            line = string(line, s, space)
        end
        push!(lines,line)
    end







    ##############################################################
    line = string("-"^22, " DISTRIBUTED PROPERTIES ", "-"^30)
    push!(lines,line)
    for i = 1:Int(bdblade["station_total"])
        local line = string("  ", bdblade["rfrac"][i])
        push!(lines, line)

        line = formatmatrix(bdblade["K$i"];spacing=4)
        append!(lines, line)
        push!(lines, "")

        line = formatmatrix(bdblade["M$i"];spacing=4)
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

"""
    stiffness_matrix(E, nu, A, Ix, Iy; G=E/(2*(1+nu)), xc=0, yc=0, xs=xc, ys=yc, theta_p=0, theta_s=theta_p, kxs=1, kys=kxs)

### Inputs
- E = Young's Modulus
- A = Cross sectional area
- Ix = Area moment of inertia about the x axis
- Iy = Area moment of inertia about the y axis
- G = !!
- xc, yc = Coordinates of the centroid
- xs, ys = Coordinates of the shear center
- theta_p = angle between the cross section axes, and the principle axes of the axial force. 
- theta_s = andgle between the cross section axes and the principle axes of the shear.
- kxs, kys = dimensionless shear factor 

### Notes:
- From the BeamDyn inputs and sectional properties manual
"""
function stiffness_matrix(E, nu, A, Ix, Iy; G=E/(2*(1+nu)), xc=0, yc=0, xs=xc, ys=yc, theta_p=0, theta_s=theta_p, kxs=1, kys=kxs)
    

    
    Kxx = G*A*(kxs*(cos(theta_s)^2) + kys*(sin(theta_s)^2))
    Kyy = G*A*(kxs*(sin(theta_s)^2) + kys*(cos(theta_s)^2))
    Kxy = G*A*(kys-kxs)*sin(theta_s)*cos(theta_s)

    Hxx = E*Ix*(cos(theta_p)^2) + E*Iy*(sin(theta_p)^2)
    Hyy = E*Ix*(sin(theta_p)^2) + E*Iy*(cos(theta_p)^2)
    Hxy = E*(Iy - Ix)*sin(theta_p)*cos(theta_p)


    Kt = Ix + Iy


    K11 = Kxx
    K12 = K21 = Kxy
    K16 = K61 = -Kxx*ys - Kxy*xs
    K22 = Kyy
    K26 = K62 = Kxy*ys + Kyy*xs
    K66 = G*Kt + Kxx*(ys^2) + 2*Kxy*xs*ys + Kyy*(xs^2)
    K33 = E*A
    K34 = K43 = E*A*yc
    K35 = K53 = -E*A*xc
    K44 = Hxx + E*A*(yc^2)
    K45 = K54 = -Hxy - E*A*xc*yc
    K55 = Hyy + E*A*(xc^2)

    return [K11 K12 0 0 0 K16;
            K21 K22 0 0 0 K26;
            0 0 K33 K34 K35 0;
            0 0 K43 K44 K45 0;
            0 0 K53 K54 K55 0;
            K61 K62 0 0 0 K66]
end


"""
    mass_matrix(m, Ix, Iy; x=0, y=0, theta=0)

### Inputs
- m = distributed mass
- Ix, Iy = mass moment of inertia about its respective axis
- x, y = coordinates of the center of principle inertia relative to the cross section coordinate frame
- theta = the angle between the principle inertial axes and the cross-section frame. 
"""
function mass_matrix(m, Ix, Iy; x=0, y=0, theta=0)

    Ixx = Ix*(cos(theta)^2) + Iy*(sin(theta)^2) + m*(y^2)
    Iyy = Ix*(sin(theta)^2) + Iy*(cos(theta)^2) + m*(x^2)
    Ixy = (Iy - Ix)*sin(theta)*cos(theta) + m*x*y
    Ip = Ix + Iy + m*(x^2 + y^2)


    return [m 0 0 0 0 -m*y;
            0 m 0 0 0 m*x;
            0 0 m m*y -m*x 0;
            0 0 m*y Ixx -Ixy 0;
            0 0 -m*x -Ixy Iyy 0;
            -m*y m*x 0 0 0 Ip]
end







function rotate_x(alpha_x)
    return [
        1.0     0.0             0.0;
        0.0     cos(alpha_x)   -sin(alpha_x);
        0.0     sin(alpha_x)    cos(alpha_x)]
end

function rotate_y(alpha_y)
    return [cos(alpha_y) 0 sin(alpha_y);
            0.0 1.0 0.0;
            -sin(alpha_y) 0 cos(alpha_y)]
end

function rotate_z(alpha_z)
    return [cos(alpha_z) -sin(alpha_z) 0.0;
            sin(alpha_z) cos(alpha_z) 0.0;
            0.0 0.0 1.0]
end

function make_element(x, points, stiffness, mass, Cab, damping)
    # element length
    DeltaL = LinearAlgebra.norm(points[2] - points[1])
    # @show DeltaL
    # @show x
    
    #Reorganize the openfast stiffness matrix into the form that GXBeam uses.
    # stiffness_gx = zero(stiffness)  
    # stiffness_gx[1,:] = stiffness[3,:]
    # stiffness_gx[2,:] = stiffness[1,:]
    # stiffness_gx[3,:] = stiffness[2,:]
    # stiffness_gx[4,:] = stiffness[6,:]
    # stiffness_gx[5,:] = stiffness[4,:]
    # stiffness_gx[6,:] = stiffness[5,:]

    # R = rotate_y(-pi/2)
    # stiffness_gx = R*stiffness*(R')

    k = view(stiffness, :, :)

    stiffness_gx = [
        k[3,3] k[3,2] k[3,1] k[3,6] k[3,5] k[3,4]
        k[2,3] k[2,2] k[2,1] k[2,6] k[2,5] k[2,4]
        k[1,3] k[1,2] k[1,1] k[1,6] k[1,5] k[1,4]
        k[6,3] k[6,2] k[6,1] k[6,6] k[6,5] k[6,4]
        k[5,3] k[5,2] k[5,1] k[5,6] k[5,5] k[5,4]
        k[4,3] k[4,2] k[4,1] k[4,6] k[4,5] k[4,4]] #TODO: Back it out to a tensor, then do the rotation, and map to stiffness matrix. Dr. Ning sent out a pdf. 

    compliance = LinearAlgebra.inv(stiffness_gx) #TODO. It might be faster to manually invert the matrix. -> Not worried about speed here.
 
    # element compliance matrix
    C = SMatrix{6,6}(compliance)  

    ### element mass matrix 
    mu = mass[1,1]
    xm2 = -mass[1,6]/mu
    xm3 = mass[2,6]/mu
    i22 = mass[5,5]
    i33 = mass[4,4]
    i23 = -mass[5,4]

    M = @SMatrix [
             mu       0     0       0 mu*xm3 -mu*xm2;
             0       mu     0  -mu*xm3     0      0;
             0       0     mu   mu*xm2     0      0;
             0  -mu*xm3 mu*xm2 i22+i33     0      0;
          mu*xm3      0     0       0   i22   -i23;
         -mu*xm2      0     0       0  -i23    i33]
 
       
    # mass_gx = R*mass*(R')
    # M = SMatrix{6,6}(mass_gx)
 
    mu = SVector(damping[1], damping[2], damping[3], damping[4], damping[5], damping[6]) #Damping coefficients
     
    return GXBeam.Element(DeltaL, x, C, M, Cab, mu) #For constant-mass-matrix branch
    # return GXBeam.Element(DeltaL, x, C, mass_gx, Cab)
end


"""
make_assembly(rhub, rtip, bdblade)

Takes the ElastoDyn file and BeamDyn blade structures and creates a GXBeam assembly struct for use with the Rotors.jl package. 

### Inputs:
- rhub::TF - hub radius
- rtip::TF - tip radius
- bdblade::BDBlade - a BeamDyn blade struct

### Outputs:
- assembly::GXBeam.Assembly
"""
function make_assembly(rhub, rtip, rstructural, twist, bdblade)

    np = length(bdblade.nodes) #Number of points
    ne = np - 1 #Number of elements



    L = rtip - rhub #Length of the blade

    rvec = [L*bdblade.nodes[i].frac + rhub for i in 1:np]

    points = [SVector(rvec[i], 0.0, 0.0) for i in 1:np] #The beginning and ending of every element. 

    x_elements = [SVector((rvec[i]+rvec[i+1])/2, 0.0, 0.0) for i in 1:ne] #The xyz location of each of the structural nodes. 

    twist = twist .- twist[1] #Decreased instabilities. 
 

    twistfit = Akima(rstructural, twist)
    
    # element triad
    Cab = @SMatrix [
        1.0 0.0 0.0;
         0.0 1.0 0.0;
         0.0 0.0 1.0]


    Cabvec = [rotate_x(-twistfit(x_elements[i][1]))*Cab for i in 1:ne] #Todo: I might need a negative on the twist angle that comes out of there. 

    ### Create each Element #TODO: This doesn't interpolate the stiffness and mass matrices, although we're interpolating the GXBeam element node as the center of two BeamDyn nodes. 
    elements = [make_element(x_elements[i], points[i:i+1], bdblade.nodes[i].stiffmatrix, bdblade.nodes[i].massmatrix, Cabvec[i], bdblade.dampcoef) for i = 1:ne]

    start = 1:ne
    stop = 2:np
     
    return GXBeam.Assembly(points, start, stop, elements)
end

"""
make_assembly(edfile, bdblade)

Takes the ElastoDyn file and BeamDyn blade structures and creates a GXBeam assembly struct for use with the Rotors.jl package. 

### Inputs:
- edfile::EDFile - ElastoDyn file struct
- bdblade::BDBlade - a BeamDyn blade struct

### Outputs:
- assembly::GXBeam.Assembly
"""
function make_assembly(edfile, bdfile, bdblade)
    rhub = edfile["HubRad"]
    rtip = edfile["TipRad"]

    rstructural = bdfile["kp_zr"]
    twist = bdfile["initial_twist"].*(pi/180) #Structural twist given in the BeamDyn file, converted to radians.

    return make_assembly(rhub, rtip, rstructural, twist, bdblade)
end