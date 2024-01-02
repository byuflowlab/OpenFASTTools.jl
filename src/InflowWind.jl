


##############################################################
################## READING FUNCTIONS #########################
##############################################################
"""
    read_inflowwind(filename, filepath)

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

    # @show length(lines)

    # @show lines[7]

    for i = 2:7
        key, entry = parseline(lines[i])
        inflowwind[key] = entry
    end

    for i = 8:10
        key, entry = parseline(lines[i], :vector)
        inflowwind[key] = entry
    end


    for i = 11:54
        key, entry = parseline(lines[i])
        inflowwind[key] = entry
    end



    ### Outputs section
    idx = 55
    # @show lines[54]

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


"""
    read_uniformwind(filename, filepath)

Reads a uniform wind file and produces a dictionary containing the data.

**Inputs**
- filename::String - a string containing the name of the file to be read.
- filepath::String - a string containing the path to the file to be read.

"""
function read_uniformwind(filename, filepath)
    fi = open(filepath*"/"*filename, "r")
    lines = readlines(fi)
    close(fi)

    lines = cleanfile!(lines)

    uniform = Dict()

    data = cat(readdlm.(IOBuffer.(lines))...,dims=1)

    uniform["time"] = data[:,1]
    uniform["windspeed"] = data[:,2]
    uniform["winddir"] = data[:,3]
    uniform["verticalspeed"] = data[:,4]
    uniform["horizontalshear"] = data[:,5]
    uniform["pwrlawvertshear"] = data[:,6]
    uniform["linlawvertshear"] = data[:,7]
    uniform["gustspeed"] = data[:,8]
    uniform["upflowang"] = data[:,9]

    return uniform
end



##############################################################
################## WRITING FUNCTIONS #########################
##############################################################


"""
    write_inflowwind(iwfile, outputfile; outputpath=pwd())

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

    line = string(formatword(addriver["VelInterpCubic"];quotes=false),"   VelInterpCubic - Use cubic interpolation for velocity in time (false=linear, true=cubic) [Used with WindType=2,3,4,5,7]")
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



    ###########################################################################
    line = "================== LIDAR Parameters ==========================================================================="
    push!(lines, line)

    line = string(formatword(Int(iwfile["SensorType"]);location="back", quotes=false),"   SensorType          - Switch for lidar configuration (0 = None, 1 = Single Point Beam(s), 2 = Continuous, 3 = Pulsed)")
    push!(lines, line)

    line = string(formatword(Int(iwfile["NumPulseGate"]);location="back", quotes=false),"   NumPulseGate        - Number of lidar measurement gates (used when SensorType = 3)")
    push!(lines, line)

    line = string(formatword(iwfile["PulseSpacing"];location="back", quotes=false),"   PulseSpacing        - Distance between range gates (m) (used when SensorType = 3)")
    push!(lines, line)

    line = string(formatword(Int(iwfile["NumBeam"]);location="back", quotes=false),"   NumBeam             - Number of lidar measurement beams (0-5)(used when SensorType = 1)")
    push!(lines, line)

    line = string(formatword(iwfile["FocalDistanceX"];location="back", quotes=false),"   FocalDistanceX      - Focal distance co-ordinates of the lidar beam in the x direction (relative to hub height) (only first coordinate used for SensorType 2 and 3) (m))")
    push!(lines, line)

    line = string(formatword(iwfile["FocalDistanceY"];location="back", quotes=false),"   FocalDistanceY      - Focal distance co-ordinates of the lidar beam in the y direction (relative to hub height) (only first coordinate used for SensorType 2 and 3) (m))")
    push!(lines, line)

    line = string(formatword(iwfile["FocalDistanceZ"];location="back", quotes=false),"   FocalDistanceZ      - Focal distance co-ordinates of the lidar beam in the z direction (relative to hub height) (only first coordinate used for SensorType 2 and 3) (m))")
    push!(lines, line)

    line = string(formatword(iwfile["RotorApexOffsetPos"];location="back", quotes=false),"   RotorApexOffsetPos  - Offset of the lidar from hub height (m)")
    push!(lines, line)

    line = string(formatword(iwfile["URefLid"];location="back", quotes=false),"   URefLid             - Reference average wind speed for the lidar[m/s]")
    push!(lines, line)

    line = string(formatword(iwfile["MeasurementInterval"];location="back", quotes=false),"   MeasurementInterval - Time between each measurement [s]")
    push!(lines, line)

    line = string(formatword(iwfile["LidRadialVel"];quotes=false),"   LidRadialVel        - TRUE => return radial component, FALSE => return 'x' direction estimate")
    push!(lines, line)

    line = string(formatword(Int(iwfile["ConsiderHubMotion"]);location="back", quotes=false),"   ConsiderHubMotion   - Flag whether to consider the hub motion's impact on Lidar measurements")
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


"""
    write_uniformwind(ufile, outputfile; outputpath=pwd())

Writes a file for InflowWind with uniform wind data. 

**Inputs**
- ufile::Dict - a dictionary containing the uniform wind data.
- outputfile::String - The desired name of the new file.
- outputpath::String - The path to the desired location of the new file.
"""
function write_uniformwind(ufile, outputfile; outputpath=pwd())
    lines = String[]

    line = "! Time     Wind    Wind    Vertical    Horiz.      Pwr.Law     Lin.Vert.   Gust     Upflow"
    push!(lines, line)

    line = "!          Speed   Dir     Speed       Shear       Vert.Shr    Shear       Speed    Angle "
    push!(lines, line)

    line = "! (sec)    (m/s)   (Deg)   (m/s)                                            (m/s)   (deg)"
    push!(lines, line)

    matrix = zeros(length(ufile["time"]), 9)
    matrix[:,1] = ufile["time"]
    matrix[:,2] = ufile["windspeed"]
    matrix[:,3] = ufile["winddir"]
    matrix[:,4] = ufile["verticalspeed"]
    matrix[:,5] = ufile["horizontalshear"]
    matrix[:,6] = ufile["pwrlawvertshear"]
    matrix[:,7] = ufile["linlawvertshear"]
    matrix[:,8] = ufile["gustspeed"]
    matrix[:,9] = ufile["upflowang"]

    line = formatcoordinates(matrix)
    append!(lines, line)

    # matrix = hcat(ufile["time"], ufile["windspeed"], ufile["winddir"], ufile["verticalspeed"], ufile["horizontalshear"], ufile["pwrlawvertshear"], ufile["linlawvertshear"], ufile["gustspeed"], ufile["upflowang"])

    # for i=1:size(matrix,1)
    #     line = string(formatword(matrix[i,1];location="back", quotes=false),"   ", formatword(matrix[i,2];location="back", quotes=false),"   ", formatword(matrix[i,3];location="back", quotes=false),"   ", formatword(matrix[i,4];location="back", quotes=false),"   ", formatword(matrix[i,5];location="back", quotes=false),"   ", formatword(matrix[i,6];location="back", quotes=false),"   ", formatword(matrix[i,7];location="back", quotes=false),"   ", formatword(matrix[i,8];location="back", quotes=false),"   ", formatword(matrix[i,9];location="back", quotes=false))
    #     push!(lines, line)
    # end

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