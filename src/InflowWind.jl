##############################################################
##################     STRUCTURES     ########################
##############################################################
mutable struct IWFile
    Directory::Array{String,1}
    Notes::String
    Echo::String
    WindType::Int
    PropagationDir::AbstractFloat
    NWindVel::Int
    WindVxiList::Array{AbstractFloat}
    WindVyiList::Array{AbstractFloat}
    WindVziList::Array{AbstractFloat}
    HWindSpeedSteady::AbstractFloat
    RefHtSteady::AbstractFloat
    PLexpSteady::AbstractFloat
    FilenameUniform::String
    RefHtUniform::AbstractFloat
    RefLengthUniform::AbstractFloat
    FilenameTurbSim::String
    FilenameBinary::String
    TowerFile::String
    FileName_u::String
    FileName_v::String
    FileName_w::String
    nx::Int
    ny::Int
    nz::Int
    dx::AbstractFloat
    dy::AbstractFloat
    dz::AbstractFloat
    RefHtHAWC::AbstractFloat
    ScaleMethod::Int
    SFx::AbstractFloat
    SFy::AbstractFloat
    SFz::AbstractFloat
    SigmaFx::AbstractFloat
    SigmaFy::AbstractFloat
    SigmaFz::AbstractFloat
    URef::AbstractFloat
    WindProfile::Int
    PLexpHAWC::AbstractFloat
    Z0::AbstractFloat
    SumPrint::String
    Outlist::Array{String, 1}
end


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
function ReadInflowWindFile(filename, filepath)
    cd(filepath)
    fi = open(filename, "r")
    lines = readlines(fi)
    close(fi)

    Directory = ["title"]
    #Line 1 is the main title
    Notes = lines[2]
    # Line 3 is a separator
    Echo = fetchword15(lines[4])
    WindType = parse(Int, lines[5][1:14])
    PropagationDir = parse(Float64, lines[6][1:14])
    NWindVel = parse(Int, lines[7][1:14])
    WindVxiList = readvector(lines[8], NWindVel)
    WindVyiList = readvector(lines[9], NWindVel)
    WindVziList = readvector(lines[10], NWindVel)
    # Line 11 steady wind title
    HWindSpeedSteady = parse(Float64, lines[12][1:14])
    RefHtSteady = parse(Float64, lines[13][1:14])
    PLexpSteady = parse(Float64, lines[14][1:14])
    # Line 15 is the uniform wind file title
    FilenameUniform = fetchword(lines[16];lengthofword=length(lines[16])-78) #This is a sketchy hardcode
    RefHtUniform = parse(Float64, lines[17][1:14])
    RefLengthUniform = parse(Float64, lines[18][1:14])
    # Line 19 is the TurbSim title
    FilenameTurbSim = fetchword(lines[20];lengthofword=length(lines[20])-63) #HARDCODE
    # Line 21 is the binary title
    FilenameBinary = fetchword(lines[22];lengthofword=length(lines[22])-73) #HARDCODE
    TowerFile = fetchword15(lines[23])
    # Line 24 is HAWC format title
    FileName_u = fetchword(lines[25];lengthofword=length(lines[25])-84) #HARDCODE
    FileName_v = fetchword(lines[26];lengthofword=length(lines[26])-84) #HARDCODE
    FileName_w = fetchword(lines[27];lengthofword=length(lines[27])-84) #HARDCODE
    nx = parse(Int, lines[28][1:14])
    ny = parse(Int, lines[29][1:14])
    nz = parse(Int, lines[30][1:14])
    dx = parse(Float64, lines[31][1:14])
    dy = parse(Float64, lines[32][1:14])
    dz = parse(Float64, lines[33][1:14])
    RefHtHAWC = parse(Float64, lines[34][1:14])
    # Line 35 is the scaling parameters title
    ScaleMethod = parse(Int, lines[36][1:14])
    SFx = parse(Float64, lines[37][1:14])
    SFy = parse(Float64, lines[38][1:14])
    SFz = parse(Float64, lines[39][1:14])
    SigmaFx = parse(Float64, lines[40][1:14])
    SigmaFy = parse(Float64, lines[41][1:14])
    SigmaFz = parse(Float64, lines[42][1:14])
    # Line 43 is the Mean wind profile title
    URef = parse(Float64, lines[44][1:14])
    WindProfile = parse(Int, lines[45][1:14])
    PLexpHAWC = parse(Float64, lines[46][1:14])
    Z0 = parse(Float64, lines[47][1:14])
    # Line 48 is the output title
    SumPrint = fetchword15(lines[49])
    Outlist = readoutlist(lines[51:end])
    return IWFile(Directory, Notes, Echo, WindType, PropagationDir, NWindVel, WindVxiList, WindVyiList, WindVziList, HWindSpeedSteady, RefHtSteady, PLexpSteady, FilenameUniform, RefHtUniform, RefLengthUniform, FilenameTurbSim, FilenameBinary, TowerFile, FileName_u, FileName_v, FileName_w, nx, ny, nz, dx, dy, dz, RefHtHAWC, ScaleMethod, SFx, SFy, SFz, SigmaFx, SigmaFy, SigmaFz, URef, WindProfile, PLexpHAWC, Z0, SumPrint, Outlist)
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
function WriteIWFile(iwfile, outputfile; outputpath=pwd())
    lines = String[]
    line = string("-"^8, " InflowWind v3.01.* INPUT FILE ", "-"^60)
    push!(lines, line)
    push!(lines, iwfile.Notes)
    line = "-"^60
    push!(lines, line)
    line = string(formatword(iwfile.Echo;quotes=false),"   Echo           - Echo input data to <RootName>.ech (flag)")
    push!(lines, line)
    line = string(formatword(string(iwfile.WindType);location="back", quotes=false),"   WindType       - switch for wind file type (1=steady; 2=uniform; 3=binary TurbSim FF; 4=binary Bladed-style FF; 5=HAWC format; 6=User defined)")
    push!(lines, line)
    line = string(formatword(string(iwfile.PropagationDir);location="back", quotes=false),"   PropagationDir - Direction of wind propagation (meteoroligical rotation from aligned with X (positive rotates towards -Y) -- degrees)")
    push!(lines, line)
    line = string(formatword(string(iwfile.NWindVel);location="back", quotes=false),"   NWindVel       - Number of points to output the wind velocity    (0 to 9)")
    push!(lines, line)
    line = string(formatvector(iwfile.WindVxiList), "   WindVxiList    - List of coordinates in the inertial X direction (m)")
    push!(lines, line)
    line = string(formatvector(iwfile.WindVyiList), "   WindVyiList    - List of coordinates in the inertial Y direction (m)")
    push!(lines, line)
    line = string(formatvector(iwfile.WindVziList), "   WindVziList    - List of coordinates in the inertial Z direction (m)")
    push!(lines, line)
    line = string("="^20, " Parameters for Steady Wind Conditions [used only for WindType = 1] ", "="^20)
    push!(lines, line)
    line = string(formatword(string(iwfile.HWindSpeedSteady);location="back", quotes=false),"   HWindSpeed     - Horizontal windspeed                            (m/s)")
    push!(lines, line)
    line = string(formatword(string(iwfile.RefHtSteady);location="back", quotes=false),"   RefHt          - Reference height for horizontal wind speed      (m)")
    push!(lines, line)
    line = string(formatword(string(iwfile.PLexpSteady);location="back", quotes=false),"   PLexp          - Power law exponent                              (-)")
    push!(lines, line)
    line = string("="^20, " Parameters for Uniform wind file   [used only for WindType = 2] ", "="^20)
    push!(lines, line)
    line = string(formatword(iwfile.FilenameUniform;quotes=true, desiredlength=length(iwfile.FilenameUniform)+2),"   Filename       - Filename of time series data for uniform wind field.      (-)")
    push!(lines, line)
    line = string(formatword(string(iwfile.RefHtUniform);location="back", quotes=false),"   RefHt          - Reference height for horizontal wind speed                (m)")
    push!(lines, line)
    line = string(formatword(string(iwfile.RefLengthUniform);location="back", quotes=false),"   RefLength      - Reference length for linear horizontal and vertical sheer (-)")
    push!(lines, line)
    line = string("="^20, " Parameters for Binary TurbSim Full-Field files   [used only for WindType = 3] ", "="^20)
    push!(lines, line)
    line = string(formatword(iwfile.FilenameTurbSim;quotes=true, desiredlength=length(iwfile.FilenameTurbSim)+2),"   Filename       - Name of the Full field wind file to use (.bts)")
    push!(lines, line)
    line = string("="^20, " Parameters for Binary Bladed-style Full-Field files   [used only for WindType = 4] ", "="^20)
    push!(lines, line)
    line = string(formatword(iwfile.FilenameBinary;quotes=true, desiredlength=length(iwfile.FilenameBinary)+2),"   FilenameRoot   - Rootname of the full-field wind file to use (.wnd, .sum)")
    push!(lines, line)
    line = string(formatword(iwfile.TowerFile;quotes=false, desiredlength=length(iwfile.TowerFile)+2),"   TowerFile      - Have tower file (.twr) (flag)")
    push!(lines, line)
    line = string("="^20, " Parameters for HAWC-format binary files  [Only used with WindType = 5] ", "="^20)
    push!(lines, line)
    line = string(formatword(iwfile.FileName_u;quotes=true, desiredlength=length(iwfile.FileName_u)+2),"   FileName_u     - name of the file containing the u-component fluctuating wind (.bin)")
    push!(lines, line)
    line = string(formatword(iwfile.FileName_v;quotes=true, desiredlength=length(iwfile.FileName_v)+2),"   FileName_v     - name of the file containing the v-component fluctuating wind (.bin)")
    push!(lines, line)
    line = string(formatword(iwfile.FileName_w;quotes=true, desiredlength=length(iwfile.FileName_w)+2),"   FileName_w     - name of the file containing the w-component fluctuating wind (.bin)")
    push!(lines, line)
    line = string(formatword(string(iwfile.nx);location="back", quotes=false),"   nx             - number of grids in the x direction (in the 3 files above) (-)")
    push!(lines, line)
    line = string(formatword(string(iwfile.ny);location="back", quotes=false),"   ny             - number of grids in the y direction (in the 3 files above) (-)")
    push!(lines, line)
    line = string(formatword(string(iwfile.nz);location="back", quotes=false),"   nz             - number of grids in the z direction (in the 3 files above) (-)")
    push!(lines, line)
    line = string(formatword(string(iwfile.dx);location="back", quotes=false),"   dx             - distance (in meters) between points in the x direction    (m)")
    push!(lines, line)
    line = string(formatword(string(iwfile.dy);location="back", quotes=false),"   dy             - distance (in meters) between points in the y direction    (m)")
    push!(lines, line)
    line = string(formatword(string(iwfile.dz);location="back", quotes=false),"   dz             - distance (in meters) between points in the z direction    (m)")
    push!(lines, line)
    line = string(formatword(string(iwfile.RefHtHAWC);location="back", quotes=false),"   RefHt          - reference height; the height (in meters) of the vertical center of the grid (m)")
    push!(lines, line)
    line = string("-"^20, "   Scaling parameters for turbulence   ", "-"^2)
    push!(lines, line)
    line = string(formatword(string(iwfile.ScaleMethod);location="back", quotes=false),"   ScaleMethod    - Turbulence scaling method   [0 = none, 1 = direct scaling, 2 = calculate scaling factor based on a desired standard deviation]")
    push!(lines, line)
    line = string(formatword(string(iwfile.SFx);location="back", quotes=false),"   SFx            - Turbulence scaling factor for the x direction (-)   [ScaleMethod=1]")
    push!(lines, line)
    line = string(formatword(string(iwfile.SFy);location="back", quotes=false),"   SFy            - Turbulence scaling factor for the y direction (-)   [ScaleMethod=1]")
    push!(lines, line)
    line = string(formatword(string(iwfile.SFz);location="back", quotes=false),"   SFz            - Turbulence scaling factor for the z direction (-)   [ScaleMethod=1]")
    push!(lines, line)
    line = string(formatword(string(iwfile.SigmaFx);location="back", quotes=false),"   SigmaFx        - Turbulence standard deviation to calculate scaling from in x direction (m/s)    [ScaleMethod=2]")
    push!(lines, line)
    line = string(formatword(string(iwfile.SigmaFy);location="back", quotes=false),"   SigmaFy        - Turbulence standard deviation to calculate scaling from in y direction (m/s)    [ScaleMethod=2]")
    push!(lines, line)
    line = string(formatword(string(iwfile.SigmaFz);location="back", quotes=false),"   SigmaFz        - Turbulence standard deviation to calculate scaling from in z direction (m/s)    [ScaleMethod=2]")
    push!(lines, line)
    line = string("-"^20, "   Mean wind profile parameters (added to HAWC-format files)   ", "-"^20)
    push!(lines, line)
    line = string(formatword(string(iwfile.URef);location="back", quotes=false),"   URef           - Mean u-component wind speed at the reference height (m/s)")
    push!(lines, line)
    line = string(formatword(string(iwfile.WindProfile);location="back", quotes=false),"   WindProfile    - Wind profile type (0=constant;1=logarithmic,2=power law)")
    push!(lines, line)
    line = string(formatword(string(iwfile.PLexpHAWC);location="back", quotes=false),"   PLExp          - Power law exponent (-) (used for PL wind profile type only)")
    push!(lines, line)
    line = string(formatword(string(iwfile.Z0);location="back", quotes=false),"   Z0             - Surface roughness length (m) (used for LG wind profile type only)")
    push!(lines, line)
    line = string("="^20, " OUTPUT ", "="^20)
    push!(lines, line)
    line = string(formatword(iwfile.SumPrint;quotes=false),"   SumPrint     - Print summary data to <RootName>.IfW.sum (flag)")
    push!(lines, line)
    push!(lines, "              OutList      - The next line(s) contains a list of output parameters.  See OutListParameters.xlsx for a listing of available output channels, (-)")

    for i=1:length(iwfile.Outlist)
       local line = iwfile.Outlist[i]
       push!(lines,line)
    end
    line = "END of input file (the word \"END\" must appear in the first 3 columns of this last OutList line)"
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




##############################################################
############### CREATING FUNCTIONS ###########################
##############################################################