###########################################################
################### Structures ############################
###########################################################

# abstract type Flag end

# struct True <:Flag end

# struct False <:Flag end

# struct Default <:Flag end

# abstract type Blade end

# mutable struct BladeA{TS, TF, TI} <: Blade
#     notes::TS
#     numnds::TI
#     hubrad::TF
#     tiprad::TF
#     span::Array{TF, 1} #Measured from the hub
#     frac::Array{TF, 1} #Measured from the hub
#     radii::Array{TF, 1} #Measured from the center of rotation
#     rhat::Array{TF, 1} #Measured from the center of rotation
#     chord::Array{TF, 1}
#     twist::Array{TF, 1}
#     sweep::Array{TF, 1}
#     curve::Array{TF, 1}
#     curveangle::Array{TF, 1}
#     airfoils::Array{TS, 1}
#     afid::Array{TI, 1}
#     airfoillist::Array{TS, 1}
#     # airfoilfiles::Array{AirfoilInput, 1} # I don't know if I want to include the airfoil input files here. I don't really know if I need them. Maybe. 

#     ### Base Constructor
#     function BladeA(notes::TS, numnds::TI, hubrad::TF, tiprad::TF, span::Array{TF, 1}, radii::Array{TF, 1}, chord::Array{TF, 1}, twist::Union{Array{TF, 1}, TF}, sweep::Union{Array{TF, 1}, TF}, curve::Union{Array{TF, 1}, TF}, curveangle::Union{Array{TF, 1}, TF}, airfoils::Union{Array{TS, 1}, TS}) where {TS, TF, TI}
#         ### for scalar inputs
#         if length(twist) == 1
#             twist = ones(length(radii)).*twist[1]
#         end

#         if length(sweep) == 1
#             sweep = ones(length(radii)).*sweep[1]
#         end

#         if length(curve) == 1
#             curve = ones(length(radii)).*curve[1]
#         end

#         if length(curveangle) == 1
#             curveangle = ones(length(radii)).*curveangle[1]
#         end

#         if (length(airfoils) == 1) || (typeof(airfoils)==String)
#             newairfoils = String[]
#             while length(newairfoils) < length(radii)
#                 push!(newairfoils, airfoils)
#             end
#             airfoils = newairfoils
#         end

#         if length(span) != length(radii) != length(chord) != length(twist) != length(sweep) != length(curve) != length(curveangle) != length(airfoils) != length(afid)
#             error("Number of blade properties do not match. - GlueCode.")
#         end

#         if length(span) != numnds
#             warning("Number of blade properties does not match number of nodes specified. - GlueCode")
#             numnds = length(span)
#         end

#         if any(x -> x>tiprad, radii)
#             warning("Specified radii larger than specified tip radius. - GlueCode")
#             tiprad = radii[end]
#         end

#         rhat = radii./tiprad
#         frac = span./span[end]

#         airfoillist = unique(airfoils)
#         afid = zeros(TI, length(airfoils))
#         for i = 1:length(airfoils)
#             afid[i] = findfirst(isequal(airfoils[i]), airfoillist)
#         end

#         return new{TS, TF, TI}(notes, numnds, hubrad, tiprad, span, frac, radii, rhat, chord, twist, sweep, curve, curveangle, airfoils, afid, airfoillist)
#     end

#     ### no radii constructor
#     function BladeA(notes::TS, hubrad::TF, tiprad::TF, span::Array{TF, 1}, chord::Array{TF, 1}, twist::Union{Array{TF, 1}, TF}, sweep::Union{Array{TF, 1}, TF}, curve::Union{Array{TF, 1}, TF}, curveangle::Union{Array{TF, 1}, TF}, airfoils::Union{Array{TS, 1}, TS}) where {TS, TF}

#         numnds = length(span)
#         radii = span .+ hubrad

#         return BladeA(notes, numnds, hubrad, tiprad, span, radii, chord, twist, sweep, curve, curveangle, airfoils)
#     end

#     ### no span and tiprad constructor
#     function BladeA(notes::TS, hubrad::TF, radii::Array{TF, 1}, chord::Array{TF, 1}, twist::Union{Array{TF, 1}, TF}, sweep::Union{Array{TF, 1}, TF}, curve::Union{Array{TF, 1}, TF}, curveangle::Union{Array{TF, 1}, TF}, airfoils::Union{Array{TS, 1}, TS}) where {TS, TF}

#         numnds = length(radii)
#         tiprad = radii[end]
#         span = filter(x -> x>=0, radii .- hubrad) 

#         return BladeA(notes, numnds, hubrad, tiprad, span, radii, chord, twist, sweep, curve, curveangle, airfoils)
#     end
# end

# mutable struct BladeAE{TS, TF, TI} <: Blade
#     notes::TS
#     numnds::TI
#     hubrad::TF
#     tiprad::TF
#     span::Array{TF, 1} #Measured from the hub
#     frac::Array{TF, 1} #Measured from the hub
#     radii::Array{TF, 1} #Measured from the center of rotation
#     rhat::Array{TF, 1} #Measured from the center of rotation
#     chord::Array{TF, 1}
#     twist::Array{TF, 1}
#     sweep::Array{TF, 1}
#     curve::Array{TF, 1}
#     curveangle::Array{TF, 1}
#     airfoils::Array{TS, 1}
#     afid::Array{TI, 1}
#     airfoillist::Array{TS, 1}
    
#     #flapdamp
#     #edgedamp
#     #pitchaxis
#     #structural twist
#     #blade mass density
#     #Flap stiffness
#     #edge stiffness

#     ### Base Constructor
#     # function BladeAE(notes::TS, numnds::TI, hubrad::TF, tiprad::TF, span::Array{TF, 1}, radii::Array{TF, 1}, chord::Array{TF, 1}, twist::Union{Array{TF, 1}, TF}, sweep::Union{Array{TF, 1}, TF}, curve::Union{Array{TF, 1}, TF}, curveangle::Union{Array{TF, 1}, TF}, airfoils::Union{Array{TS, 1}, TS}) where {TS, TF, TI}
#     #     ### for scalar inputs
#     #     if length(twist) == 1
#     #         twist = ones(length(radii)).*twist[1]
#     #     end

#     #     if length(sweep) == 1
#     #         sweep = ones(length(radii)).*sweep[1]
#     #     end

#     #     if length(curve) == 1
#     #         curve = ones(length(radii)).*curve[1]
#     #     end

#     #     if length(curveangle) == 1
#     #         curveangle = ones(length(radii)).*curveangle[1]
#     #     end

#     #     if (length(airfoils) == 1) || (typeof(airfoils)==String)
#     #         newairfoils = String[]
#     #         while length(newairfoils) < length(radii)
#     #             push!(newairfoils, airfoils)
#     #         end
#     #         airfoils = newairfoils
#     #     end

#     #     if length(span) != length(radii) != length(chord) != length(twist) != length(sweep) != length(curve) != length(curveangle) != length(airfoils) != length(afid)
#     #         error("Number of blade properties do not match. - GlueCode.")
#     #     end

#     #     if length(span) != numnds
#     #         warning("Number of blade properties does not match number of nodes specified. - GlueCode")
#     #         numnds = length(span)
#     #     end

#     #     if any(x -> x>tiprad, radii)
#     #         warning("Specified radii larger than specified tip radius. - GlueCode")
#     #         tiprad = radii[end]
#     #     end

#     #     rhat = radii./tiprad
#     #     frac = span./span[end]

#     #     airfoillist = unique(airfoils)
#     #     afid = zeros(TI, length(airfoils))
#     #     for i = 1:length(airfoils)
#     #         afid[i] = findfirst(isequal(airfoils[i]), airfoillist)
#     #     end

#     #     return new{TS, TF, TI}(notes, numnds, hubrad, tiprad, span, frac, radii, rhat, chord, twist, sweep, curve, curveangle, airfoils, afid, airfoillist)
#     # end

#     # ### no radii constructor
#     # function BladeAE(notes::TS, hubrad::TF, tiprad::TF, span::Array{TF, 1}, chord::Array{TF, 1}, twist::Union{Array{TF, 1}, TF}, sweep::Union{Array{TF, 1}, TF}, curve::Union{Array{TF, 1}, TF}, curveangle::Union{Array{TF, 1}, TF}, airfoils::Union{Array{TS, 1}, TS}) where {TS, TF}

#     #     numnds = length(span)
#     #     radii = span .+ hubrad

#     #     return BladeA(notes, numnds, hubrad, tiprad, span, radii, chord, twist, sweep, curve, curveangle, airfoils)
#     # end

#     # ### no span and tiprad constructor
#     # function BladeAE(notes::TS, hubrad::TF, radii::Array{TF, 1}, chord::Array{TF, 1}, twist::Union{Array{TF, 1}, TF}, sweep::Union{Array{TF, 1}, TF}, curve::Union{Array{TF, 1}, TF}, curveangle::Union{Array{TF, 1}, TF}, airfoils::Union{Array{TS, 1}, TS}) where {TS, TF}

#     #     numnds = length(radii)
#     #     tiprad = radii[end]
#     #     span = filter(x -> x>=0, radii .- hubrad) 

#     #     return BladeA(notes, numnds, hubrad, tiprad, span, radii, chord, twist, sweep, curve, curveangle, airfoils)
#     # end
# end

# mutable struct BladeAEB{TS, TF, TI}<: Blade
#     notes::TS
#     numnds::TI
#     hubrad::TF
#     tiprad::TF
#     span::Array{TF, 1} #Measured from the hub
#     radii::Array{TF, 1} #Measured from the center of rotation
#     chord::Array{TF, 1}
#     twist::Array{TF, 1}
#     sweep::Array{TF, 1}
#     curve::Array{TF, 1}
#     curveangle::Array{TF, 1}
#     airfoils::Array{TS, 1}
# end

# mutable struct Turbine

# end

# abstract type OperationConditions end

# mutable struct SteadyOp <: OperationConditions

# end

# mutable struct UnsteadyOp <: OperationConditions
# end

# function make_adblade(blade::Blade)

#     #Todo: Something to make sure that the zero is added in, if it isn't already there. 
    
#     return ADBlade(blade.notes, blade.numnds, blade.span, blade.curve, blade.sweep, blade.curveangle, blade.twist, blade.chord, blade.afid)
# end






###########################################################
################### Reading Functions ###################
###########################################################

"""

"""
function read_inputfile(filename, filepath)
    fi = open(filepath*"/"*filename, "r")
    lines = readlines(fi)
    close(fi)

    lines = cleanfile!(lines)

    inputfile = Dict()
    inputfile["Notes"] = lines[1]

    for i = eachindex(lines)[2:end]
        key, entry = parseline(lines[i])
        inputfile[key] = entry
    end

    return inputfile
end


"""
    ReadOutput(filename, filepath)

ReadOutput reads the .out file from OpenFASt and parses it into a dictionary.

**Inputs**
    filename - String of the .out file to be read
    filepath - String of the path to the .out file.

**Outputs**
    outputs - a dictionary of all of the arrays within the .out file

### Notes
A dictionary was chosen because the out file can have a lot of different outputs, and it was easier to program a reactive function rather than a predictive one.

"""
function ReadOutput(filename, filepath)
        #Read in the file
        # cd(filepath)
        fi = open(filepath*"/"*filename, "r")
        lines = readlines(fi)
        close(fi)
        if length(lines)>2
            outputs = ReadOutput2(lines)
        else
            outputs = ReadOutput1(lines)
        end
        return outputs
end

function ReadOutput1(lines)

    #Find the first row
    line = lines[1]
    lines = String[]
    idx = findfirst('(',line)
    push!(lines,line[1:idx-1])

    #Find the number of columns
    m = numcolumns(lines[1])
    # println("number of columns: ", m)
    #Seperate out the rows
    rows = seprows(line, m)
    # println("rows: ")
    for i = 1:length(rows)
        # println(rows[i])
    end

    #Remove tabs and spaces in the numerical part of the matrix
    for i = 3:length(rows)
        rows[i]=rmspaces(rows[i])
    end

    #Convert the matrix to numbers
    matrix = readmatrix(rows[3:end])

    #Create output directory
    namesvec = parsenames(rows[1])
    # println("namesvec: ", namesvec)
    outputs = Dict()
    for i = 1:length(namesvec)
        outputs[namesvec[i]]=matrix[:,i]
    end
    return outputs
end

function ReadOutput2(lines)
    namesvec = parsenames(lines[7]) #Had an error where it would return an empty string if there were any spaces before the first word. 
    # println(namesvec)
    matrix = cat(readdlm.(IOBuffer.(lines[9:end]))...,dims=1)
    outputs = Dict()
    for i = 1:length(namesvec)
        outputs[namesvec[i]]=matrix[:, i]
    end
    return outputs
end








#################################################################
###################### Writing functions ######################
#################################################################


function write_inputfile(inputfile::Dict, outputfile::String; outputpath::String=pwd()) 

    lines = String[]

    line = "------- OpenFAST example INPUT FILE -------------------------------------------"
    push!(lines, line)

    line = inputfile["Notes"]
    push!(lines, line)



    #############################################################
    line = "---------------------- SIMULATION CONTROL --------------------------------------"
    push!(lines, line)

    line = string(formatword(inputfile["Echo"], quotes=false), "Echo            - Echo input data to <RootName>.ech (flag)")
    push!(lines, line)

    line = string(formatword(inputfile["AbortLevel"]), "   AbortLevel      - Error level when simulation should abort (string) {\"WARNING\", \"SEVERE\", \"FATAL\"}")
    push!(lines, line)

    line = string(formatword(inputfile["TMax"], quotes=false), "   TMax            - Total run time (s)")
    push!(lines, line)

    line = string(formatword(inputfile["DT"], quotes=false), "   DT              - Recommended module time step (s)")
    push!(lines, line)

    line = string(formatword(Int(inputfile["InterpOrder"]), quotes=false), "   InterpOrder     - Interpolation order for input/output time history (-) {1=linear, 2=quadratic}")
    push!(lines, line)

    line = string(formatword(Int(inputfile["NumCrctn"]), quotes=false), "   NumCrctn        - Number of correction iterations (-) {0=explicit calculation, i.e., no corrections}")
    push!(lines, line)

    line = string(formatword(inputfile["DT_UJac"], quotes=false), "   DT_UJac         - Time between calls to get Jacobians (s)")
    push!(lines, line)

    line = string(formatword(inputfile["UJacSclFact"], quotes=false), "   UJacSclFact     - Scaling factor used in Jacobians (-)")
    push!(lines, line)








    #############################################################
    line = "---------------------- FEATURE SWITCHES AND FLAGS ------------------------------"
    push!(lines, line)
    
    line = string(formatword(Int(inputfile["CompElast"]), quotes=false), "   CompElast       - Compute structural dynamics (switch) {1=ElastoDyn; 2=ElastoDyn + BeamDyn for blades}")
    push!(lines, line)

    line = string(formatword(Int(inputfile["CompInflow"]), quotes=false), "   CompInflow      - Compute inflow wind velocities (switch) {0=still air; 1=InflowWind; 2=external from OpenFOAM}")
    push!(lines, line)

    line = string(formatword(Int(inputfile["CompAero"]), quotes=false), "   CompAero        - Compute aerodynamic loads (switch) {0=None; 1=AeroDyn v14; 2=AeroDyn v15}")
    push!(lines, line)

    line = string(formatword(Int(inputfile["CompServo"]), quotes=false), "   CompServo       - Compute control and electrical-drive dynamics (switch) {0=None; 1=ServoDyn}")
    push!(lines, line)

    line = string(formatword(Int(inputfile["CompHydro"]), quotes=false), "   CompHydro       - Compute hydrodynamic loads (switch) {0=None; 1=HydroDyn}")
    push!(lines, line)


    line = string(formatword(Int(inputfile["CompSub"]), quotes=false), "   CompSub         - Compute sub-structural dynamics (switch) {0=None; 1=SubDyn; 2=External Platform MCKF}")
    push!(lines, line)

    line = string(formatword(Int(inputfile["CompMooring"]), quotes=false), "   CompMooring     - Compute mooring system (switch) {0=None; 1=MAP++; 2=FEAMooring; 3=MoorDyn; 4=OrcaFlex}")
    push!(lines, line)

    line = string(formatword(Int(inputfile["CompIce"]), quotes=false), "   CompIce         - Compute ice loads (switch) {0=None; 1=IceFloe; 2=IceDyn}")
    push!(lines, line)

    line = string(formatword(Int(inputfile["MHK"]), quotes=false), "   MHK             - MHK turbine type (switch) {0=Not an MHK turbine; 1=Fixed MHK turbine; 2=Floating MHK turbine}")
    push!(lines, line)







    #############################################################
    line = "---------------------- ENVIRONMENTAL CONDITIONS --------------------------------"
    push!(lines, line)

    line = string(formatword(inputfile["Gravity"], quotes=false), "   Gravity         - Gravitational acceleration (m/s^2)")
    push!(lines, line)

    line = string(formatword(inputfile["AirDens"], quotes=false), "   AirDens         - Air density (kg/m^3)")
    push!(lines, line)

    line = string(formatword(inputfile["WtrDens"], quotes=false), "   WtrDens         - Water density (kg/m^3)")
    push!(lines, line)

    line = string(formatword(inputfile["KinVisc"], quotes=false), "   KinVisc         - Kinematic viscosity of working fluid (m^2/s)")
    push!(lines, line)

    line = string(formatword(inputfile["SpdSound"], quotes=false), "   SpdSound        - Speed of sound in working fluid (m/s)")
    push!(lines, line)

    line = string(formatword(inputfile["Patm"], quotes=false), "   Patm            - Atmospheric pressure (Pa) [used only for an MHK turbine cavitation check]")
    push!(lines, line)

    line = string(formatword(inputfile["Pvap"], quotes=false), "   Pvap            - Vapour pressure of working fluid (Pa) [used only for an MHK turbine cavitation check]")
    push!(lines, line)

    line = string(formatword(inputfile["WtrDpth"], quotes=false), "   WtrDpth         - Water depth (m)")
    push!(lines, line)

    line = string(formatword(inputfile["MSL2SWL"], quotes=false), "   MSL2SWL         - Offset between still-water level and mean sea level (m) [positive upward]")
    push!(lines, line)







    #############################################################
    line = "---------------------- INPUT FILES ---------------------------------------------"
    push!(lines, line)

    line = string(formatword(inputfile["EDFile"]; quotes=true, desiredlength=length(inputfile["EDFile"])), "   EDFile      - ElastoDyn input file (string)")
    push!(lines, line)

    line = string(formatword(inputfile["BDBldFile(1)"]; quotes=true, desiredlength=length(inputfile["BDBldFile(1)"])), "   BDBldFile(1)    - Name of file containing BeamDyn input parameters for blade 1 (quoted string)")
    push!(lines, line)

    line = string(formatword(inputfile["BDBldFile(2)"]; quotes=true, desiredlength=length(inputfile["BDBldFile(2)"])), "   BDBldFile(2)    - Name of file containing BeamDyn input parameters for blade 1 (quoted string)")
    push!(lines, line)

    line = string(formatword(inputfile["BDBldFile(3)"]; quotes=true, desiredlength=length(inputfile["BDBldFile(3)"])), "   BDBldFile(3)    - Name of file containing BeamDyn input parameters for blade 1 (quoted string)")
    push!(lines, line)

    line = string(formatword(inputfile["InflowFile"]; quotes=true, desiredlength=length(inputfile["InflowFile"])), "   InflowFile      - Inflow wind file (string)")
    push!(lines, line)

    line = string(formatword(inputfile["AeroFile"]; quotes=true, desiredlength=length(inputfile["AeroFile"])), "   AeroFile        - AeroDyn input file (string)")
    push!(lines, line)

    line = string(formatword(inputfile["ServoFile"]; quotes=true, desiredlength=length(inputfile["ServoFile"])), "   ServoFile       - ServoDyn input file (string)")
    push!(lines, line)

    line = string(formatword(inputfile["HydroFile"]; quotes=true, desiredlength=length(inputfile["HydroFile"])), "   HydroFile       - HydroDyn input file (string)")
    push!(lines, line)

    line = string(formatword(inputfile["SubFile"]; quotes=true, desiredlength=length(inputfile["SubFile"])), "   SubFile         - SubDyn input file (string)")
    push!(lines, line)

    line = string(formatword(inputfile["MooringFile"]; quotes=true, desiredlength=length(inputfile["MooringFile"])), "   MooringFile     - Mooring input file (string)")
    push!(lines, line)

    line = string(formatword(inputfile["IceFile"]; quotes=true, desiredlength=length(inputfile["IceFile"])), "   IceFile         - IceDyn input file (string)")
    push!(lines, line)







    #############################################################
    line = "---------------------- OUTPUT --------------------------------------------------"
    push!(lines, line)

    line = string(formatword(inputfile["SumPrint"], quotes=false), "   SumPrint        - Print summary data to \"<RootName>.sum\" (flag)")
    push!(lines, line)

    line = string(formatword(inputfile["SttsTime"], quotes=false), "   SttsTime        - Amount of time between screen status messages (s)")
    push!(lines, line)

    line = string(formatword(inputfile["ChkptTime"], quotes=false), "   ChkptTime       - Amount of time between creating checkpoint files for potential restart (s)")
    push!(lines, line)

    line = string(formatword(inputfile["DT_Out"], quotes=false), "   DT_Out          - Time step for tabular output (s) (or \"default\")")
    push!(lines, line)

    line = string(formatword(inputfile["TStart"], quotes=false), "   TStart          - Time to begin tabular output (s)")
    push!(lines, line)

    line = string(formatword(Int(inputfile["OutFileFmt"]), quotes=false), "   OutFileFmt      - Format for tabular (time-marching) output file (switch) {1: text file [<RootName>.out], 2: binary file [<RootName>.outb], 3: both}")
    push!(lines, line)

    line = string(formatword(inputfile["TabDelim"], quotes=false), "   TabDelim        - Use tab delimiters in text tabular output file? (flag) {uses spaces if false}")
    push!(lines, line)

    line = string(formatword(inputfile["OutFmt"], quotes=true), "   OutFmt          - Format used for text tabular output, excluding the time channel.  Resulting field should be 10 characters. (quoted string)")
    push!(lines, line)







    #############################################################
    line = "---------------------- LINEARIZATION -------------------------------------------"
    push!(lines, line)

    line = string(formatword(inputfile["Linearize"], quotes=false), "   Linearize       - Linearization analysis (flag)")
    push!(lines, line)

    line = string(formatword(inputfile["CalcSteady"], quotes=false), "   CalcSteady      - Calculate a steady-state periodic operating point before linearization? [unused if Linearize=False] (flag)")
    push!(lines, line)

    line = string(formatword(Int(inputfile["TrimCase"]), quotes=false), "   TrimCase        - Controller parameter to be trimmed {1:yaw; 2:torque; 3:pitch} [used only if CalcSteady=True] (-)")
    push!(lines, line)

    line = string(formatword(inputfile["TrimTol"], quotes=false), "   TrimTol         - Tolerance for the rotational speed convergence [used only if CalcSteady=True] (-)")
    push!(lines, line)

    line = string(formatword(inputfile["TrimGain"], quotes=false), "   TrimGain        - Proportional gain for the rotational speed error (>0) [used only if CalcSteady=True] (rad/(rad/s) for yaw or pitch; Nm/(rad/s) for torque)")
    push!(lines, line)

    line = string(formatword(inputfile["Twr_Kdmp"], quotes=false), "   Twr_Kdmp        - Damping factor for the tower [used only if CalcSteady=True] (N/(m/s))")
    push!(lines, line)

    line = string(formatword(inputfile["Bld_Kdmp"], quotes=false), "   Bld_Kdmp        - Damping factor for the blades [used only if CalcSteady=True] (N/(m/s))")
    push!(lines, line)

    line = string(formatword(Int(inputfile["NLinTimes"]), quotes=false), "   NLinTimes       - Number of times to linearize (-) [>=1] [unused if Linearize=False]")
    push!(lines, line)

    line = string(formatword(Int.(inputfile["LinTimes"]), quotes=false), "   LinTimes        - List of times at which to linearize (s) [1 to NLinTimes] [used only when Linearize=True and CalcSteady=False]")
    push!(lines, line)

    line = string(formatword(Int(inputfile["LinInputs"]), quotes=false), "   LinInputs       - Inputs included in linearization (switch) {0=none; 1=standard; 2=all module inputs (debug)} [unused if Linearize=False]")
    push!(lines, line)

    line = string(formatword(Int(inputfile["LinOutputs"]), quotes=false), "   LinOutputs      - Outputs included in linearization (switch) {0=none; 1=from OutList(s); 2=all module outputs (debug)} [unused if Linearize=False]")
    push!(lines, line)

    line = string(formatword(inputfile["LinOutJac"], quotes=false), "   LinOutJac       - Include full Jacobians in linearization output (for debug) (flag) [unused if Linearize=False; used only if LinInputs=LinOutputs=2]")
    push!(lines, line)

    line = string(formatword(inputfile["LinOutMod"], quotes=false), "   LinOutMod       - Write module-level linearization output files in addition to output for full system? (flag) [unused if Linearize=False]")
    push!(lines, line)






    #############################################################
    line = "---------------------- VISUALIZATION ------------------------------------------"
    push!(lines, line)

    line = string(formatword(Int(inputfile["WrVTK"]), quotes=false), "   WrVTK           - VTK visualization data output: (switch) {0=none; 1=initialization data only; 2=animation}")
    push!(lines, line)

    line = string(formatword(Int(inputfile["VTK_type"]), quotes=false), "   VTK_type        - Type of VTK visualization data: (switch) {1=surfaces; 2=basic meshes (lines/points); 3=all meshes (debug)} [unused if WrVTK=0]")
    push!(lines, line)

    line = string(formatword(inputfile["VTK_fields"], quotes=false), "   VTK_fields      - Write mesh fields to VTK data files? (flag) {true/false} [unused if WrVTK=0]")
    push!(lines, line)

    line = string(formatword(Int(inputfile["VTK_fps"]), quotes=false), "   VTK_fps         - Frame rate for VTK output (frames per second){will use closest integer multiple of DT} [used only if WrVTK=2]")
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