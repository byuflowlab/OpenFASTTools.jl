##############################################################
##################     STRUCTURES     ########################
##############################################################
# mutable struct IWFile
#     Directory::Array{String,1}
#     Notes::String
#     Echo::String
#     WindType::Int
#     PropagationDir::AbstractFloat
#     NWindVel::Int
#     WindVxiList::Array{Float64, 1} #TODO: This could be an array of arrays
#     WindVyiList::Array{Float64, 1}
#     WindVziList::Array{Float64, 1}
#     HWindSpeedSteady::AbstractFloat
#     RefHtSteady::AbstractFloat
#     PLexpSteady::AbstractFloat
#     FilenameUniform::String
#     RefHtUniform::AbstractFloat
#     RefLengthUniform::AbstractFloat #TODO: Couldn't I just combine all of the Reference Heights, lengths, and power law exponents into one variable? 
#     FilenameTurbSim::String
#     FilenameBinary::String
#     TowerFile::String
#     FileName_u::String #TODO: This could be an array
#     FileName_v::String
#     FileName_w::String
#     nx::Int #TODO: This could be an array
#     ny::Int
#     nz::Int
#     dx::AbstractFloat #TODO: This could be an array
#     dy::AbstractFloat
#     dz::AbstractFloat
#     RefHtHAWC::AbstractFloat
#     ScaleMethod::Int
#     SFx::AbstractFloat #TODO: This could be an array
#     SFy::AbstractFloat
#     SFz::AbstractFloat
#     SigmaFx::AbstractFloat #TODO: This could be an array
#     SigmaFy::AbstractFloat
#     SigmaFz::AbstractFloat
#     URef::AbstractFloat
#     WindProfile::Int
#     PLexpHAWC::AbstractFloat
#     Z0::AbstractFloat
#     InitPositionx::AbstractFloat
#     SumPrint::String
#     Outlist::Array{String, 1}
# end


##############################################################
################## READING FUNCTIONS #########################
##############################################################
"""
    ReadInflowWindFile(filename, filepath)

Reads an InflowWind file and produces an IWFile object. 

### Inputs
- filename::String - a string containing the name of the file to be read.
- filepath::String - a string containing the path to the file to be read.

### Outputs
- iwfile::IWFile - an InflowWind file object
"""
function read_inflowwind(filename, filepath)
    fi = open(filepath*"/"*filename, "r")
    lines = readlines(fi)
    close(fi)

    lines = cleanfile!(lines)

    inflowwind = Dict()
    inflowwind["Notes"] = lines[1]

    for i = 2:41
        key, entry = parseline(lines[i])
        inflowwind[key] = entry
    end



    ### Outputs section
    idx = 42

    outlist1idx = findlistbounds(lines[idx:end])

    # println("")
    # println("This list")
    if length(outlist1idx)>0 #Todo: Not reading empty... which means the other readers might have things wrong. :|  Pain in my bottom. 
        outputs = readlist(lines[idx:idx+outlist1idx[end]-1])
        inflowwind["OutList"] = outputs
    else
        inflowwind["OutList"] = nothing
    end

    return inflowwind
end



##############################################################
################## WRITING FUNCTIONS #########################
##############################################################


"""
    WriteIWFile(iwfile, outputfile; outputpath=pwd())

Writes an InflowWind file from and InflowWind file object. 

### Inputs
- iwfile::IWFile - InflowWind file object to be written
- outputfile::String - The desired name of the new file. 
- outputpath::String - The path to the desired location of the new file. 
"""
function write_inflowwind(iwfile, outputfile; outputpath=pwd())
    lines = String[]
    line = string("-"^8, " InflowWind v3.01.* INPUT FILE ", "-"^60)
    push!(lines, line)
    
    push!(lines, iwfile["Notes"])

    ############################################################
    line = "-"^60
    push!(lines, line)

    line = string(formatword(iwfile["Echo"];quotes=false),"   Echo           - Echo input data to <RootName>.ech (flag)")
    push!(lines, line)

    line = string(formatword(Int(iwfile["WindType"]);location="back", quotes=false),"   WindType       - switch for wind file type (1=steady; 2=uniform; 3=binary TurbSim FF; 4=binary Bladed-style FF; 5=HAWC format; 6=User defined)")
    push!(lines, line)

    line = string(formatword(string(iwfile["PropagationDir"]);location="back", quotes=false),"   PropagationDir - Direction of wind propagation (meteoroligical rotation from aligned with X (positive rotates towards -Y) -- degrees)")
    push!(lines, line)

    line = string(formatword(string(iwfile["VFlowAng"]);location="back", quotes=false),"   VFlowAng       - Upflow angle (degrees) (not used for native Bladed format WindType=7)")
    push!(lines, line)

    line = string(formatword(Int(iwfile["NWindVel"]);location="back", quotes=false),"   NWindVel       - Number of points to output the wind velocity    (0 to 9)")
    push!(lines, line)

    line = string(formatvector(iwfile["WindVxiList"]), "   WindVxiList    - List of coordinates in the inertial X direction (m)")
    push!(lines, line)

    line = string(formatvector(iwfile["WindVyiList"]), "   WindVyiList    - List of coordinates in the inertial Y direction (m)")
    push!(lines, line)

    line = string(formatvector(iwfile["WindVziList"]), "   WindVziList    - List of coordinates in the inertial Z direction (m)")
    push!(lines, line)






    ########################################################
    line = string("="^20, " Parameters for Steady Wind Conditions [used only for WindType = 1] ", "="^20)
    push!(lines, line)

    line = string(formatword(string(iwfile["HWindSpeed"]);location="back", quotes=false),"   HWindSpeed     - Horizontal windspeed                            (m/s)")
    push!(lines, line)

    line = string(formatword(string(iwfile["RefHt"]);location="back", quotes=false),"   RefHt          - Reference height for horizontal wind speed      (m)")
    push!(lines, line)

    line = string(formatword(string(iwfile["PLexp"]);location="back", quotes=false),"   PLexp          - Power law exponent                              (-)")
    push!(lines, line)








    ##########################################################################
    line = string("="^20, " Parameters for Uniform wind file   [used only for WindType = 2] ", "="^20)
    push!(lines, line)

    line = string(formatword(iwfile["FileName_Uni"];quotes=true, desiredlength=length(iwfile["FileName_Uni"])+2),"   FileName_Uni       - Filename of time series data for uniform wind field.      (-)")
    push!(lines, line)

    line = string(formatword(string(iwfile["RefHt_Uni"]);location="back", quotes=false),"   RefHt_Uni          - Reference height for horizontal wind speed                (m)")
    push!(lines, line)

    line = string(formatword(string(iwfile["RefLength"]);location="back", quotes=false),"   RefLength      - Reference length for linear horizontal and vertical sheer (-)")
    push!(lines, line)










    ###############################################################
    line = string("="^20, " Parameters for Binary TurbSim Full-Field files   [used only for WindType = 3] ", "="^20)
    push!(lines, line)

    line = string(formatword(iwfile["FileName_BTS"];quotes=true, desiredlength=length(iwfile["FileName_BTS"])+2),"   FileName_BTS       - Name of the Full field wind file to use (.bts)")
    push!(lines, line)










    ###############################################################
    line = string("="^20, " Parameters for Binary Bladed-style Full-Field files   [used only for WindType = 4] ", "="^20)
    push!(lines, line)

    line = string(formatword(iwfile["FilenameRoot"];quotes=true, desiredlength=length(iwfile["FilenameRoot"])+2),"   FilenameRoot   - Rootname of the full-field wind file to use (.wnd, .sum)")
    push!(lines, line)

    line = string(formatword(iwfile["TowerFile"];quotes=false, desiredlength=length(iwfile["TowerFile"])+2),"   TowerFile      - Have tower file (.twr) (flag)")
    push!(lines, line)






    ##############################################################################
    line = string("="^20, " Parameters for HAWC-format binary files  [Only used with WindType = 5] ", "="^20)
    push!(lines, line)

    line = string(formatword(iwfile["FileName_u"];quotes=true, desiredlength=length(iwfile["FileName_u"])+2),"   FileName_u     - name of the file containing the u-component fluctuating wind (.bin)")
    push!(lines, line)

    line = string(formatword(iwfile["FileName_v"];quotes=true, desiredlength=length(iwfile["FileName_v"])+2),"   FileName_v     - name of the file containing the v-component fluctuating wind (.bin)")
    push!(lines, line)

    line = string(formatword(iwfile["FileName_w"];quotes=true, desiredlength=length(iwfile["FileName_w"])+2),"   FileName_w     - name of the file containing the w-component fluctuating wind (.bin)")
    push!(lines, line)

    line = string(formatword(Int(iwfile["nx"]);location="back", quotes=false),"   nx             - number of grids in the x direction (in the 3 files above) (-)")
    push!(lines, line)

    line = string(formatword(Int(iwfile["ny"]);location="back", quotes=false),"   ny             - number of grids in the y direction (in the 3 files above) (-)")
    push!(lines, line)

    line = string(formatword(Int32(iwfile["nz"]);location="back", quotes=false),"   nz             - number of grids in the z direction (in the 3 files above) (-)")
    push!(lines, line)

    line = string(formatword(string(iwfile["dx"]);location="back", quotes=false),"   dx             - distance (in meters) between points in the x direction    (m)")
    push!(lines, line)

    line = string(formatword(string(iwfile["dy"]);location="back", quotes=false),"   dy             - distance (in meters) between points in the y direction    (m)")
    push!(lines, line)

    line = string(formatword(string(iwfile["dz"]);location="back", quotes=false),"   dz             - distance (in meters) between points in the z direction    (m)")
    push!(lines, line)

    line = string(formatword(string(iwfile["RefHt_HAWC"]);location="back", quotes=false),"   RefHt_HAWC          - reference height; the height (in meters) of the vertical center of the grid (m)")
    push!(lines, line)








    ##############################################################################
    line = string("-"^20, "   Scaling parameters for turbulence   ", "-"^2)
    push!(lines, line)

    line = string(formatword(Int(iwfile["ScaleMethod"]);location="back", quotes=false),"   ScaleMethod    - Turbulence scaling method   [0 = none, 1 = direct scaling, 2 = calculate scaling factor based on a desired standard deviation]")
    push!(lines, line)

    line = string(formatword(string(iwfile["SFx"]);location="back", quotes=false),"   SFx            - Turbulence scaling factor for the x direction (-)   [ScaleMethod=1]")
    push!(lines, line)

    line = string(formatword(string(iwfile["SFy"]);location="back", quotes=false),"   SFy            - Turbulence scaling factor for the y direction (-)   [ScaleMethod=1]")
    push!(lines, line)

    line = string(formatword(string(iwfile["SFz"]);location="back", quotes=false),"   SFz            - Turbulence scaling factor for the z direction (-)   [ScaleMethod=1]")
    push!(lines, line)

    line = string(formatword(string(iwfile["SigmaFx"]);location="back", quotes=false),"   SigmaFx        - Turbulence standard deviation to calculate scaling from in x direction (m/s)    [ScaleMethod=2]")
    push!(lines, line)

    line = string(formatword(string(iwfile["SigmaFy"]);location="back", quotes=false),"   SigmaFy        - Turbulence standard deviation to calculate scaling from in y direction (m/s)    [ScaleMethod=2]")
    push!(lines, line)

    line = string(formatword(string(iwfile["SigmaFz"]);location="back", quotes=false),"   SigmaFz        - Turbulence standard deviation to calculate scaling from in z direction (m/s)    [ScaleMethod=2]")
    push!(lines, line)









    ##############################################################################
    line = string("-"^20, "   Mean wind profile parameters (added to HAWC-format files)   ", "-"^20)
    push!(lines, line)

    line = string(formatword(string(iwfile["URef"]);location="back", quotes=false),"   URef           - Mean u-component wind speed at the reference height (m/s)")
    push!(lines, line)

    line = string(formatword(Int(iwfile["WindProfile"]);location="back", quotes=false),"   WindProfile    - Wind profile type (0=constant;1=logarithmic,2=power law)")
    push!(lines, line)

    line = string(formatword(string(iwfile["PLExp_HAWC"]);location="back", quotes=false),"   PLExp_HAWC          - Power law exponent (-) (used for PL wind profile type only)")
    push!(lines, line)

    line = string(formatword(string(iwfile["Z0"]);location="back", quotes=false),"   Z0             - Surface roughness length (m) (used for LG wind profile type only)")
    push!(lines, line)

    line = string(formatword(string(iwfile["XOffset"]);location="back", quotes=false), "   XOffset         - Initial offset in +x direction (shift of wind box)")
    push!(lines, line)








    ##############################################################################
    line = string("="^20, " OUTPUT ", "="^20)
    push!(lines, line)

    line = string(formatword(iwfile["SumPrint"];quotes=false),"   SumPrint     - Print summary data to <RootName>.IfW.sum (flag)")
    push!(lines, line)

    push!(lines, "              OutList      - The next line(s) contains a list of output parameters.  See OutListParameters.xlsx for a listing of available output channels, (-)")

    for i=1:length(iwfile["OutList"])
       local line = formatword(iwfile["OutList"][i]; quotes=true)
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




##############################################################
############### CREATING FUNCTIONS ###########################
##############################################################