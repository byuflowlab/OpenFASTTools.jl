
"""
Part of the OpenFASTsr wrapper of OpenFAST

"""
# using Printf

function WritefstFile(filename;description = "A fast input file.")

    """
    I don't know if this function is needed really for my uses.
    I just need to be able to modify the files... right?
    I guess I'll come back to this to work on it.
    """

    # open fst file
    f = open(filename,"w")
    l1 = string("-"^7, " ", filename, " ", "INPUT FIle ", "-"^43, "\n")
    l2 = string("# ", description, "\n")
    l3 = string("-"^22, " SIMULATION CONTROL ", "-"^38, "\n")


    write(f, l1)
    write(f, l2)
    write(f, l3)
    close(f)

end

function ModifyfstFile()
    # Might need this if I change the name of the Inflow file, AD file, etc
end

function WriteAD14File(adfile, outputfile)
    #Create lines from adfile

    lines = String[]
    line = string("-"^9, " AeroDyn v14.04.* INPUT FILE ", "-"^73)
    push!(lines,line)                   # 1 - Title
    push!(lines,adfile.Notes)           # 2 - File Notes
    line = string(formatword(adfile.StallMod),"   StallMod     - Dynamic stall included [BEDDOES or STEADY] (unquoted string)")
    push!(lines,line)                   # 3 - StallMod
    line = string(formatword(adfile.UseCm), "   UseCm        - Use aerodynamic pitching moment model? [USE_CM or NO_CM] (unquoted string)")
    push!(lines, line)                  # 4 - UseCm
    line = string(formatword(adfile.InfModel), "   InfModel     - Inflow model [DYNIN or EQUIL] (unquoted string)")
    push!(lines, line)                  # 5 - InfModel
    line = string(formatword(adfile.IndModel), "   IndModel     - Induction-factor model [NONE or WAKE or SWIRL] (unquoted string)")
    push!(lines, line)                  # 6 - IndModel
    line = string(formatword(string(adfile.AToler);location="back", quotes=false), "   AToler       - Induction-factor tolerance (convergence criteria) (-)")
    push!(lines, line)                  # 7 - AToler
    line = string(formatword(adfile.TLModel), "   TLModel      - Tip-loss model (EQUIL only) [PRANDtl, GTECH, or NONE] (unquoted string)")
    push!(lines, line)                  # 8 - TLModel
    line = string(formatword(adfile.HLModel), "   HLModel      - Hub-loss model (EQUIL only) [PRANdtl or NONE] (unquoted string)")
    push!(lines, line)                  # 9 - HLModel
    line = string(formatword(string(adfile.TwrShad); location="back", quotes=false), "   TwrShad      - Tower-shadow velocity deficit (-)")
    push!(lines, line)                  # 10 - TwrShad
    line = string(formatword(string(adfile.ShadHWid); location="back", quotes=false), "   ShadHWid     - Tower-shadow half width (m)")
    push!(lines, line)                  # 11 - ShadHWid
    line = string(formatword(string(adfile.T_Shad_Refpt); location="back", quotes=false), "   T_Shad_Refpt - Tower-shadow reference point (m)")
    push!(lines, line)                  # 12 - T_Shad_Refpt
    line = string(formatword(string(adfile.AirDens); location="back", quotes=false), "   AirDens      - Air density (kg/m^3)")
    push!(lines, line)                  # 13 - AirDens
    line = string(formatword(@sprintf "%.4E" adfile.KinVisc; location="back", quotes = false), "   KinVisc      - Kinematic air viscosity [CURRENTLY IGNORED] (m^2/sec)")
    push!(lines, line)                  # 14 - KinVisc
    line = string(formatword(string(adfile.DTAero); location="back", quotes=false), "   DTAero       - Time interval for aerodynamic calculations (sec)")
    push!(lines, line)                  # 15 - DTAero
    line = string(formatword(string(adfile.NumFoil); location="back", quotes=false), "   NumFoil      - Number of airfoil files (-)")
    push!(lines, line)                  # 16 - NumFoil
    line = string(formatword(adfile.Foils[1]; desiredlength=32), "FoilNm      - Names of the airfoil files [NumFoil lines] (quoted strings)")
    push!(lines, line)                  # 17 Foil name

    for i = 2:adfile.NumFoil
        line = string(formatword(adfile.Foils[i]; desiredlength=32))
        push!(lines,line)               # Adding all foils (lines 16+NumFoil)
    end

    line = string(formatword(string(adfile.BldNodes); location="back", quotes=false), "   BldNodes    - Number of blade nodes used for analysis (-)")
    push!(lines, line)                  # BldNodes (line 17+NumFoil)
    line = "RNodes         AeroTwst       DRNodes        Chord          NFoil          PrnElm"
    push!(lines, line)                  # Nodes title (line 18+NumFoil)

    #Create Nodes Matrix
    smat = formatmatrix(adfile.Nodes[:,1:4])
    column = Int.(adfile.Nodes[:,5])
    column = formatword.(string.(column); location="back", quotes=false, desiredlength=9)
    smat = formatmatrix_appendcolumn(smat, column)
    column = String[]
    for i=1:length(adfile.Nodes[:,5])
        push!(column,"      NOPRINT")
    end
    smat = formatmatrix_appendcolumn(smat, column)
    append!(lines, smat)

    #Check that filename is appropriate
    # if outputfile[end-2]!="ipt"
    #     error("Output file name ending of AD writer incorrect.")
    # end

    #Write lines to file
    fi = open(outputfile,"w+")
    i = 1
    for i = 1:length(lines)-1
        write(fi,lines[i])
        write(fi,"\n")
        # println(lines[i])
    end
    write(fi,lines[end])
    close(fi)
end

function WriteAD15File(adfile, outputfile)
    lines = String[]
    line = string("-"^7, " AERODYN v15 for OpenFAST INPUT FILE ", "-"^47)
    push!(lines,line)
    push!(lines, adfile.Notes)
    line = string("="^6, "  General Options  ", "="^76)
    push!(lines, line)
    line = string(formatword(adfile.Echo;quotes=false),"   Echo               - Echo the input to \"<rootname>.AD.ech\"?  (flag)")
    push!(lines, line)
    line = string(formatword(adfile.DTAero;quotes=false),"   DTAero             - Time interval for aerodynamic calculations {or \"default\"} (s)")
    push!(lines, line)
    line = string(formatword(string(adfile.WakeMod);location="back",quotes=false), "   WakeMod            - Type of wake/induction model (switch) {0=none, 1=BEMT, 2=DBEMT} [WakeMod cannot be 2 when linearizing]")
    push!(lines, line)
    line = string(formatword(string(adfile.AFAeroMod);location="back",quotes=false),"   AFAeroMod          - Type of blade airfoil aerodynamics model (switch) {1=steady model, 2=Beddoes-Leishman unsteady model} [AFAeroMod must be 1 when linearizing]")
    push!(lines, line)
    line = string(formatword(string(adfile.TwrPotent);location="back",quotes=false),"   TwrPotent          - Type tower influence on wind based on potential flow around the tower (switch) {0=none, 1=baseline potential flow, 2=potential flow with Bak correction}")
    push!(lines, line)
    line = string(formatword(adfile.TwrShadow;quotes=false), "   TwrShadow          - Calculate tower influence on wind based on downstream tower shadow? (flag)")
    push!(lines,line)
    line = string(formatword(adfile.TwrAero;quotes=false), "   TwrAero            - Calculate tower aerodynamic loads? (flag)")
    push!(lines, line)
    line = string(formatword(adfile.FrozenWake;quotes=false), "   FrozenWake         - Assume frozen wake during linearization? (flag) [used only when WakeMod=1 and when linearizing]")
    push!(lines, line)
    line = string(formatword(adfile.CavitCheck;quotes=false), "   CavitCheck         - Perform cavitation check? (flag) [AFAeroMod must be 1 when CavitCheck=true]")
    push!(lines, line)
    line = string(formatword(adfile.CompAA;quotes=false), "   CompAA             - Flag to compute AeroAcoustics calculation [only used when WakeMod=1 or 2]")
    push!(lines, line)
    line = string(formatword(adfile.AA_InputFile), "   - Aeroacoustics input file")
    push!(lines, line)
    line = string("="^6, "  Environmental Conditions  ", "="^67)
    push!(lines, line)
    line = string(formatword(string(adfile.AirDens);location="back", quotes=false), "   AirDens            - Air density (kg/m^3)")
    push!(lines, line)
    line = string(formatword(string(adfile.KinVisc);location="back", quotes=false), "   KinVisc            - Kinematic air viscosity (m^2/s)")
    push!(lines, line)
    line = string(formatword(string(adfile.SpdSound);location="back", quotes=false), "   SpdSound           - Speed of sound (m/s)")
    push!(lines, line)
    line = string(formatword(string(adfile.Patm);location="back", quotes=false), "   Patm               - Atmospheric pressure (Pa) [used only when CavitCheck=True]")
    push!(lines, line)
    line = string(formatword(string(adfile.Pvap);location="back", quotes=false), "   Pvap               - Vapour pressure of fluid (Pa) [used only when CavitCheck=True]")
    push!(lines, line)
    line = string(formatword(string(adfile.FluidDepth);location="back", quotes=false), "   FluidDepth         - Water depth above mid-hub height (m) [used only when CavitCheck=True]")
    push!(lines, line)
    line = string("="^6, "  Blade-Element/Momentum Theory Options  ", "="^54)
    push!(lines, line)
    line = string(formatword(string(adfile.SkewMod);location="back", quotes=false), "   SkewMod            - Type of skewed-wake correction model (switch) {1=uncoupled, 2=Pitt/Peters, 3=coupled} [unused when WakeMod=0]")
    push!(lines, line)
    line = string(formatword(adfile.SkewModFactor), "   SkewModFactor      - Constant used in Pitt/Peters skewed wake model {or \"default\" is 15/32*pi} (-) [used only when SkewMod=2; unused when WakeMod=0]")
    push!(lines, line)
    line = string(formatword(adfile.TipLoss;quotes=false), "   TipLoss            - Use the Prandtl tip-loss model? (flag) [unused when WakeMod=0]")
    push!(lines, line)
    line = string(formatword(adfile.HubLoss;quotes=false), "   HubLoss            - Use the Prandtl hub-loss model? (flag) [unused when WakeMod=0]")
    push!(lines, line)
    line = string(formatword(adfile.TanInd;quotes=false), "   TanInd             - Include tangential induction in BEMT calculations? (flag) [unused when WakeMod=0]")
    push!(lines, line)
    line = string(formatword(adfile.AIDrag;quotes=false), "   AIDrag             - Include the drag term in the axial-induction calculation? (flag) [unused when WakeMod=0]")
    push!(lines, line)
    line = string(formatword(adfile.TIDrag;quotes=false), "   TIDrag             - Include the drag term in the tangential-induction calculation? (flag) [unused when WakeMod=0 or TanInd=FALSE]")
    push!(lines, line)
    line = string(formatword(adfile.IndToler), "   IndToler           - Convergence tolerance for BEMT nonlinear solve residual equation {or \"default\"} (-) [unused when WakeMod=0]")
    push!(lines, line)
    line = string(formatword(string(adfile.MaxIter);location="back", quotes=false), "   MaxIter            - Maximum number of iteration steps (-) [unused when WakeMod=0]")
    push!(lines, line)
    line = string("="^6, "  Dynamic Blade-Element/Momentum Theory Options  ", "="^46)
    push!(lines, line)
    line = string(formatword(string(adfile.DBEMT_Mod);location="back", quotes=false), "   DBEMT_Mod          - Type of dynamic BEMT (DBEMT) model {1=constant tau1, 2=time-dependent tau1} (-) [used only when WakeMod=2]")
    push!(lines, line)
    line = string(formatword(string(adfile.tau1_const);location="back", quotes=false), "   tau1_const         - Time constant for DBEMT (s) [used only when WakeMod=2 and DBEMT_Mod=1]")
    push!(lines, line)
    line = string("="^6, "   OLAF -- cOnvecting LAgrangian Filaments (Free Vortex Wake) Theory Options", "="^46)
    push!(lines, line)
    line = string(formatword(adfile.OLAFInputFileName), "   - Aeroacoustics input file")
    push!(lines, line)
    line = string("="^6, "  Beddoes-Leishman Unsteady Airfoil Aerodynamics Options  ", "="^37)
    push!(lines, line)
    line = string(formatword(string(adfile.UAMod);location="back", quotes=false), "   UAMod              - Unsteady Aero Model Switch (switch) {1=Baseline model (Original), 2=Gonzalez's variant (changes in Cn,Cc,Cm), 3=Minemma/Pierce variant (changes in Cc and Cm)} [used only when AFAeroMod=2]")
    push!(lines, line)
    line = string(formatword(adfile.FLookup;quotes=false), "   FLookup            - Flag to indicate whether a lookup for f\' will be calculated (TRUE) or whether best-fit exponential equations will be used (FALSE); if FALSE S1-S4 must be provided in airfoil input files (flag) [used only when AFAeroMod=2]")
    push!(lines, line)
    line = string("="^6, "  Airfoil Information ", "="^73)
    push!(lines, line)
    line = string(formatword(string(adfile.AFTabMod);location="back", quotes=false), "   AFTabMod           - Interpolation method for multiple airfoil tables {1=1D interpolation on AoA (first table only); 2=2D interpolation on AoA and Re; 3=2D interpolation on AoA and UserProp} (-)")
    push!(lines, line)
    line = string(formatword(string(adfile.InCol_Alfa);location="back", quotes=false), "   InCol_Alfa         - The column in the airfoil tables that contains the angle of attack (-)")
    push!(lines, line)
    line = string(formatword(string(adfile.InCol_Cl);location="back", quotes=false), "   InCol_Cl           - The column in the airfoil tables that contains the lift coefficient (-)")
    push!(lines, line)
    line = string(formatword(string(adfile.InCol_Cd);location="back", quotes=false), "   InCol_Cd           - The column in the airfoil tables that contains the drag coefficient (-)")
    push!(lines, line)
    line = string(formatword(string(adfile.InCol_Cm);location="back", quotes=false), "   InCol_Cm           - The column in the airfoil tables that contains the pitching-moment coefficient; use zero if there is no Cm column (-)")
    push!(lines, line)
    line = string(formatword(string(adfile.InCol_Cpmin);location="back", quotes=false), "   InCol_Cpmin        - The column in the airfoil tables that contains the Cpmin coefficient; use zero if there is no Cpmin column (-)")
    push!(lines, line)
    line = string(formatword(string(adfile.NumAFfiles);location="back", quotes=false), "   NumAFfiles         - Number of airfoil files used (-)")
    push!(lines, line)

    line = string(formatword(adfile.Foils[1];desiredlength=length(adfile.Foils[2])+5), "AFNames            - Airfoil file names (NumAFfiles lines) (quoted strings)")
    push!(lines, line)

    for i=2:length(adfile.Foils)
       line = string("\"",adfile.Foils[i],"\"")
       push!(lines,line)
    end

    line = string("="^6, "  Rotor/Blade Properties  ", "="^69)
    push!(lines,line)
    line = string(formatword(adfile.UseBlCm;quotes=false), "   UseBlCm            - Include aerodynamic pitching moment in calculations?  (flag)")
    push!(lines,line)

    while length(adfile.Blades)<3 #If only one blade file is given, this repeats it 3 times so that the file is the correct length. I suppose I could always add "unused" instead, but the same name works just fine. 
       push!(adfile.Blades,adfile.Blades[1])
    end

    for i=1:length(adfile.Blades)
       line = string(formatword(adfile.Blades[i];desiredlength=length(adfile.Blades[i])+2),"   ADBlFile($i)        - Name of file containing distributed aerodynamic properties for Blade #$i (-)")
       push!(lines, line)
    end

    line = string("="^6, "  Tower Influence and Aerodynamics ", "="^61)
    push!(lines, line)
    line = string(formatword(string(adfile.NumTwrNds);location="back",quotes=false), "   NumTwrNds         - Number of tower nodes used in the analysis  (-) [used only when TwrPotent/=0, TwrShadow=True, or TwrAero=True]")
    push!(lines, line)
    line = "TwrElev        TwrDiam        TwrCd"
    push!(lines, line)
    line = "(m)              (m)           (-)"
    push!(lines, line)
    line = formatmatrix(adfile.TwrNds)
    append!(lines,line)
    line = string("="^6, "  Outputs  ", "="^84)
    push!(lines, line)
    line = string(formatword(adfile.SumPrint;quotes=false), "   SumPrint            - Generate a summary file listing input options and interpolated properties to \"<rootname>.AD.sum\"?  (flag)")
    push!(lines, line)
    line = string(formatword(string(adfile.NBlOuts);location="back",quotes=false), "   NBlOuts             - Number of blade node outputs [0 - 9] (-)")
    push!(lines, line)
    if adfile.NBlOuts>0
       line = formatvector(adfile.BlOutNd)
    else
       line = " "^11
    end
    line = string(line, "   BlOutNd             - Blade nodes whose values will be output  (-)")
    push!(lines, line)
    line = string(formatword(string(adfile.NTwOuts);location="back",quotes=false), "   NTwOuts             - Number of tower node outputs [0 - 9]  (-)")
    push!(lines, line)
    if adfile.NTwOuts>0
       line = formatvector(adfile.TwOutNd)
    else
       line = " "^11
    end
    line = string(line, "   TwOutNd             - Tower nodes whose values will be output  (-)")
    push!(lines, line)
    line = "                   OutList             - The next line(s) contains a list of output parameters.  See s for a listing of available output channels, (-)"
    push!(lines, line)
    for i=1:length(adfile.Outlist)
       line = adfile.Outlist[i]
       push!(lines,line)
    end
    line = "END of input file (the word \"END\" must appear in the first 3 columns of this last OutList line)"
    push!(lines,line)
    line = "---------------------- NODE OUTPUTS --------------------------------------------"
    push!(lines, line)
    line = string(formatword(string(adfile.BldNd_BladesOut);location="back",quotes=false), "   BldNd_BladesOut  - Blades to output")
    push!(lines, line)

    if adfile.BldNd_BladesOut>0
        line = formatvector(adfile.BldNd_BlOutNd)
    else
        line = " "^11
    end
     line = string(line, "   - Blade nodes on each blade (currently unused)")
     push!(lines, line)

     line = "                   OutList             - The next line(s) contains a list of output parameters.  See s for a listing of available output channels, (-)"

     push!(lines, line)
     for i=1:length(adfile.NodeOutlist)
        line = string("\"", adfile.NodeOutlist[i], "\"")
        push!(lines,line)
     end
     line = "END of input file (the word \"END\" must appear in the first 3 columns of this last OutList line)"
     push!(lines,line)

    #Write lines to file
    fi = open(outputfile,"w+")
    i = 1
    for i = 1:length(lines)-1
         write(fi,lines[i])
         write(fi,"\n")
    end
    write(fi,lines[end])
    close(fi)
end

function ModifyADFile()
    #Probably going to need this
end

"""
WriteEDFile(edfile, outputfile)

    This function takes an ElastoDyn structure and writes it to file.
"""
function WriteEDFile(edfile, outputfile)
    lines = String[]
    line = string("-"^7, " ELASTODYN v1.03.* INPUT FILE ", "-"^43)
    push!(lines, line)
    line = edfile.Notes
    push!(lines, line)
    line = string("-"^22, " SIMULATION CONTROL ", "-"^38)
    push!(lines, line)
    line = string(formatword(edfile.Echo;quotes=false),"   Echo        - Echo input data to \"<RootName>.ech\" (flag)")
    push!(lines, line)
    line = string(formatword(string(edfile.Method);location="back",quotes=false), "   Method      - Integration method: {1: RK4, 2: AB4, or 3: ABM4} (-)")
    push!(lines, line)
    line = string(formatword(edfile.DT;quotes=false),"   DT          - Integration time step (s)")
    push!(lines, line)
    line = string("-"^22, " ENVIRONMENTAL CONDITION ", "-"^33)
    push!(lines, line)
    line = string(formatword(string(edfile.Gravity);location="back",quotes=false),"   Gravity     - Gravitational acceleration (m/s^2)")
    push!(lines, line)
    line = string("-"^22, " DEGREES OF FREEDOM ", "-"^38)
    push!(lines, line)
    line = string(formatword(edfile.FlapDOF1;quotes=false),"   FlapDOF1    - First flapwise blade mode DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.FlapDOF2;quotes=false), "   FlapDOF2    - Second flapwise blade mode DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.EdgeDOF;quotes=false), "   EdgeDOF     - First edgewise blade mode DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.TeetDOF;quotes=false), "   TeetDOF     - Rotor-teeter DOF (flag) [unused for 3 blades]")
    push!(lines, line)
    line = string(formatword(edfile.DrTrDOF;quotes=false), "   DrTrDOF     - Drivetrain rotational-flexibility DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.GenDOF;quotes=false), "   GenDOF      - Generator DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.YawDOF;quotes=false), "   YawDOF      - Yaw DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.TwFADOF1;quotes=false), "   TwFADOF1    - First fore-aft tower bending-mode DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.TwFADOF2;quotes=false), "   TwFADOF2    - Second fore-aft tower bending-mode DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.TwSSDOF1;quotes=false), "   TwSSDOF1    - First side-to-side tower bending-mode DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.TwSSDOF2;quotes=false), "   TwSSDOF2    - Second side-to-side tower bending-mode DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.PtfmSgDOF;quotes=false), "   PtfmSgDOF   - Platform horizontal surge translation DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.PtfmSwDOF;quotes=false), "   PtfmSwDOF   - Platform horizontal sway translation DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.PtfmHvDOF;quotes=false), "   PtfmHvDOF   - Platform vertical heave translation DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.PtfmRDOF;quotes=false), "   PtfmRDOF    - Platform roll tilt rotation DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.PtfmPDOF;quotes=false), "   PtfmPDOF    - Platform pitch tilt rotation DOF (flag)")
    push!(lines, line)
    line = string(formatword(edfile.PtfmYDOF;quotes=false), "   PtfmYDOF    - Platform yaw rotation DOF (flag)")
    push!(lines, line)
    line = string("-"^22, " INITIAL CONDITIONS ", "-"^38)
    push!(lines, line)
    line = string(formatword(string(edfile.OoPDefl);location="back",quotes=false),"   OoPDefl     - Initial out-of-plane blade-tip displacement (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.IPDefl);location="back",quotes=false),"   IPDefl      - Initial in-plane blade-tip deflection (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.BlPitch1);location="back",quotes=false),"   BlPitch(1)  - Blade 1 initial pitch (degrees)")
    push!(lines, line)
    line = string(formatword(string(edfile.BlPitch2);location="back",quotes=false),"   BlPitch(2)  - Blade 2 initial pitch (degrees)")
    push!(lines, line)
    line = string(formatword(string(edfile.BlPitch3);location="back",quotes=false),"   BlPitch(3)  - Blade 3 initial pitch (degrees) [unused for 2 blades]")
    push!(lines, line)
    line = string(formatword(string(edfile.TeetDefl);location="back",quotes=false),"   TeetDefl    - Initial or fixed teeter angle (degrees) [unused for 3 blades]")
    push!(lines, line)
    line = string(formatword(string(edfile.Azimuth);location="back",quotes=false),"   Azimuth     - Initial azimuth angle for blade 1 (degrees)")
    push!(lines, line)
    line = string(formatword(string(edfile.RotSpeed);location="back",quotes=false),"   RotSpeed    - Initial or fixed rotor speed (rpm)")
    push!(lines, line)
    line = string(formatword(string(edfile.NacYaw);location="back",quotes=false),"   NacYaw      - Initial or fixed nacelle-yaw angle (degrees)")
    push!(lines, line)
    line = string(formatword(string(edfile.TTDspFA);location="back",quotes=false),"   TTDspFA     - Initial fore-aft tower-top displacement (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.TTDspSS);location="back",quotes=false),"   TTDspSS     - Initial side-to-side tower-top displacement (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmSurge);location="back",quotes=false),"   PtfmSurge   - Initial or fixed horizontal surge translational displacement of platform (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmSway);location="back",quotes=false),"   PtfmSway    - Initial or fixed horizontal sway translational displacement of platform (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmHeave);location="back",quotes=false),"   PtfmHeave   - Initial or fixed vertical heave translational displacement of platform (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmRoll);location="back",quotes=false),"   PtfmRoll    - Initial or fixed roll tilt rotational displacement of platform (degrees)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmPitch);location="back",quotes=false),"   PtfmPitch   - Initial or fixed pitch tilt rotational displacement of platform (degrees)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmYaw);location="back",quotes=false),"   PtfmYaw     - Initial or fixed yaw rotational displacement of platform (degrees)")
    push!(lines, line)
    line = string("-"^22, " TURBINE CONFIGURATION ", "-"^35)
    push!(lines, line)
    line = string(formatword(string(edfile.NumBl);location="back",quotes=false),"   NumBl       - Number of blades (-)")
    push!(lines, line)
    line = string(formatword(string(edfile.TipRad);location="back",quotes=false),"   TipRad      - The distance from the rotor apex to the blade tip (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.HubRad);location="back",quotes=false),"   HubRad      - The distance from the rotor apex to the blade root (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.PreCone1);location="back",quotes=false),"   PreCone(1)  - Blade 1 cone angle (degrees)")
    push!(lines, line)
    line = string(formatword(string(edfile.PreCone2);location="back",quotes=false),"   PreCone(2)  - Blade 2 cone angle (degrees)")
    push!(lines, line)
    line = string(formatword(string(edfile.PreCone3);location="back",quotes=false),"   PreCone(3)  - Blade 3 cone angle (degrees) [unused for 2 blades]")
    push!(lines, line)
    line = string(formatword(string(edfile.HubCM);location="back",quotes=false),"   HubCM       - Distance from rotor apex to hub mass [positive downwind] (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.UndSling);location="back",quotes=false),"   UndSling    - Undersling length [distance from teeter pin to the rotor apex] (meters) [unused for 3 blades]")
    push!(lines, line)
    line = string(formatword(string(edfile.Delta3);location="back",quotes=false),"   Delta3      - Delta-3 angle for teetering rotors (degrees) [unused for 3 blades]")
    push!(lines, line)
    line = string(formatword(string(edfile.AzimB1Up);location="back",quotes=false),"   AzimB1Up    - Azimuth value to use for I/O when blade 1 points up (degrees)")
    push!(lines, line)
    line = string(formatword(string(edfile.OverHang);location="back",quotes=false),"   OverHang    - Distance from yaw axis to rotor apex [3 blades] or teeter pin [2 blades] (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.ShftGagL);location="back",quotes=false),"   ShftGagL    - Distance from rotor apex [3 blades] or teeter pin [2 blades] to shaft strain gages [positive for upwind rotors] (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.ShftTilt);location="back",quotes=false),"   ShftTilt    - Rotor shaft tilt angle (degrees)")
    push!(lines, line)
    line = string(formatword(string(edfile.NacCMxn);location="back",quotes=false),"   NacCMxn     - Downwind distance from the tower-top to the nacelle CM (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.NacCMyn);location="back",quotes=false),"   NacCMyn     - Lateral  distance from the tower-top to the nacelle CM (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.NacCMzn);location="back",quotes=false),"   NacCMzn     - Vertical distance from the tower-top to the nacelle CM (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.NcIMUxn);location="back",quotes=false),"   NcIMUxn     - Downwind distance from the tower-top to the nacelle IMU (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.NcIMUyn);location="back",quotes=false),"   NcIMUyn     - Lateral  distance from the tower-top to the nacelle IMU (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.NcIMUzn);location="back",quotes=false),"   NcIMUzn     - Vertical distance from the tower-top to the nacelle IMU (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.Twr2Shft);location="back",quotes=false),"   Twr2Shft    - Vertical distance from the tower-top to the rotor shaft (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.TowerHt);location="back",quotes=false),"   TowerHt     - Height of tower above ground level [onshore] or MSL [offshore] (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.TowerBsHt);location="back",quotes=false),"   TowerBsHt   - Height of tower base above ground level [onshore] or MSL [offshore] (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmCMxt);location="back",quotes=false),"   PtfmCMxt    - Downwind distance from the ground level [onshore] or MSL [offshore] to the platform CM (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmCMyt);location="back",quotes=false),"   PtfmCMyt    - Lateral distance from the ground level [onshore] or MSL [offshore] to the platform CM (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmCMzt);location="back",quotes=false),"   PtfmCMzt    - Vertical distance from the ground level [onshore] or MSL [offshore] to the platform CM (meters)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmRefzt);location="back",quotes=false),"   PtfmRefzt   - Vertical distance from the ground level [onshore] or MSL [offshore] to the platform reference point (meters)")
    push!(lines, line)
    line = string("-"^22, " MASS AND INERTIA ", "-"^40)
    push!(lines, line)
    line = string(formatword(string(edfile.TipMass1);location="back",quotes=false),"   TipMass(1)  - Tip-brake mass, blade 1 (kg)")
    push!(lines, line)
    line = string(formatword(string(edfile.TipMass2);location="back",quotes=false),"   TipMass(2)  - Tip-brake mass, blade 2 (kg)")
    push!(lines, line)
    line = string(formatword(string(edfile.TipMass3);location="back",quotes=false),"   TipMass(3)  - Tip-brake mass, blade 3 (kg) [unused for 2 blades]")
    push!(lines, line)
    line = string(formatword(string(edfile.HubMass);location="back",quotes=false),"   HubMass     - Hub mass (kg)")
    push!(lines, line)
    line = string(formatword(string(edfile.HubIner);location="back",quotes=false),"   HubIner     - Hub inertia about rotor axis [3 blades] or teeter axis [2 blades] (kg m^2)")
    push!(lines, line)
    line = string(formatword(string(edfile.GenIner);location="back",quotes=false),"   GenIner     - Generator inertia about HSS (kg m^2)")
    push!(lines, line)
    line = string(formatword(string(edfile.NacMass);location="back",quotes=false),"   NacMass     - Nacelle mass (kg)")
    push!(lines, line)
    line = string(formatword(string(edfile.NacYIner);location="back",quotes=false),"   NacYIner    - Nacelle inertia about yaw axis (kg m^2)")
    push!(lines, line)
    line = string(formatword(string(edfile.YawBrMass);location="back",quotes=false),"   YawBrMass   - Yaw bearing mass (kg)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmMass);location="back",quotes=false),"   PtfmMass    - Platform mass (kg)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmRIner);location="back",quotes=false),"   PtfmRIner   - Platform inertia for roll tilt rotation about the platform CM (kg m^2)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmPIner);location="back",quotes=false),"   PtfmPIner   - Platform inertia for pitch tilt rotation about the platform CM (kg m^2)")
    push!(lines, line)
    line = string(formatword(string(edfile.PtfmYIner);location="back",quotes=false),"   PtfmYIner   - Platform inertia for yaw rotation about the platform CM (kg m^2)")
    push!(lines, line)
    line = string("-"^22, " BLADE ", "-"^51)
    push!(lines, line)
    line = string(formatword(string(edfile.BldNodes);location="back",quotes=false),"   BldNodes    - Number of blade nodes (per blade) used for analysis (-)")
    push!(lines, line)
    line = string(formatword(edfile.BldFile1;quotes=false,desiredlength=35), "   BldFile(1)  - Name of file containing properties for blade 1 (quoted string)")
    push!(lines, line)
    line = string(formatword(edfile.BldFile2;quotes=false,desiredlength=35), "   BldFile(2)  - Name of file containing properties for blade 2 (quoted string)")
    push!(lines, line)
    line = string(formatword(edfile.BldFile3;quotes=false,desiredlength=35), "   BldFile(3)  - Name of file containing properties for blade 3 (quoted string) [unused for 2 blades]")
    push!(lines, line)
    line = string("_"^22, " ROTOR-TEETER ", "-"^44)
    push!(lines, line)
    line = string(formatword(string(edfile.TeetMod);location="back",quotes=false),"   TeetMod     - Rotor-teeter spring/damper model {0: none, 1: standard, 2: user-defined from routine UserTeet} (switch) [unused for 3 blades]")
    push!(lines, line)
    line = string(formatword(string(edfile.TeetDmpP);location="back",quotes=false),"   TeetDmpP    - Rotor-teeter damper position (degrees) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)
    line = string(formatword(string(edfile.TeetDmp);location="back",quotes=false),"   TeetDmp     - Rotor-teeter damping constant (N-m/(rad/s)) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)
    line = string(formatword(string(edfile.TeetCDmp);location="back",quotes=false),"   TeetCDmp    - Rotor-teeter rate-independent Coulomb-damping moment (N-m) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)
    line = string(formatword(string(edfile.TeetSStP);location="back",quotes=false),"   TeetSStP    - Rotor-teeter soft-stop position (degrees) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)
    line = string(formatword(string(edfile.TeetHStP);location="back",quotes=false),"   TeetHStP    - Rotor-teeter hard-stop position (degrees) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)
    line = string(formatword(string(edfile.TeetSSSp);location="back",quotes=false),"   TeetSSSp    - Rotor-teeter soft-stop linear-spring constant (N-m/rad) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)
    line = string(formatword(string(edfile.TeetHSSp);location="back",quotes=false),"   TeetHSSp    - Rotor-teeter hard-stop linear-spring constant (N-m/rad) [used only for 2 blades and when TeetMod=1]")
    push!(lines, line)
    line = string("-"^22, " DRIVETRAIN ", "-"^46)
    push!(lines, line)
    line = string(formatword(string(edfile.GBoxEff);location="back",quotes=false),"   GBoxEff     - Gearbox efficiency (%)")
    push!(lines, line)
    line = string(formatword(string(edfile.GBRatio);location="back",quotes=false),"   GBRatio     - Gearbox ratio (-)")
    push!(lines, line)
    line = string(formatword(string(edfile.DTTorSpr);location="back",quotes=false),"   DTTorSpr    - Drivetrain torsional spring (N-m/rad)")
    push!(lines, line)
    line = string(formatword(string(edfile.DTTorDmp);location="back",quotes=false),"   DTTorDmp    - Drivetrain torsional damper (N-m/(rad/s))")
    push!(lines, line)
    line = string("-"^22, " FURLING ", "-"^49)
    push!(lines, line)
    line = string(formatword(string(edfile.Furling);location="back",quotes=false),"   Furling     - Read in additional model properties for furling turbine (flag) [must currently be FALSE)")
    push!(lines, line)
    line = string(formatword(edfile.FurlFile;quotes=false,desiredlength=35),"   FurlFile    - Name of file containing furling properties (quoted string) [unused when Furling=False]")
    push!(lines, line)
    line = string("-"^22, " TOWER ", "-"^51)
    push!(lines,line)
    line = string(formatword(string(edfile.TwrNodes);location="back",quotes=false),"   TwrNodes    - Number of tower nodes used for analysis (-)")
    push!(lines, line)
    line = string(formatword(edfile.TwrFile;quotes=false,desiredlength=35),"   TwrFile     - Name of file containing tower properties (quoted string)")
    push!(lines, line)
    line = string("-"^22, " OUTPUT ", "-"^50)
    push!(lines, line)
    line = string(formatword(edfile.SumPrint;quotes=false), "   SumPrint    - Print summary data to \"<RootName>.sum\" (flag)")
    push!(lines, line)
    line = string(formatword(string(edfile.OutFile);location="back",quotes=false),"   OutFile     - Switch to determine where output will be placed: {1: in module output file only; 2: in glue code output file only; 3: both} (currently unused)")
    push!(lines, line)
    line = string(formatword(edfile.TabDelim;quotes=false), "  TabDelim    - Use tab delimiters in text tabular output file? (flag) (currently unused)")
    push!(lines, line)
    line = string(formatword(edfile.OutFmt;quotes=false), "   OutFmt      - Format used for text tabular output (except time).  Resulting field should be 10 characters. (quoted string) (currently unused)")
    push!(lines, line)
    line = string(formatword(string(edfile.TStart);location="back",quotes=false),"   TStart      - Time to begin tabular output (s) (currently unused)")
    push!(lines, line)
    line = string(formatword(string(edfile.DecFact);location="back",quotes=false),"   DecFact     - Decimation factor for tabular output {1: output every time step} (-) (currently unused)")
    push!(lines, line)
    line = string(formatword(string(edfile.NTwGages);location="back",quotes=false),"   NTwGages    - Number of tower nodes that have strain gages for output [0 to 9] (-)")
    push!(lines, line)
    if edfile.NTwGages>0
       line = formatvector(edfile.TwrGagNd)
    else
       line = " "^11
    end
    line = string(line, "   TwrGagNd    - List of tower nodes that have strain gages [1 to TwrNodes] (-) [unused if NTwGages=0]")
    push!(lines, line)
    line = string(formatword(string(edfile.NBlGages);location="back",quotes=false),"   NBlGages    - Number of blade nodes that have strain gages for output [0 to 9] (-)")
    push!(lines, line)
    if edfile.NBlGages>0
       line = formatvector(edfile.BldGagNd)
    else
       line = " "^11
    end
    line = string(line, "   BldGagNd    - List of blade nodes that have strain gages [1 to BldNodes] (-) [unused if NBlGages=0]")
    push!(lines, line)
    line = "              OutList     - The next line(s) contains a list of output parameters.  See OutListParameters.xlsx for a listing of available output channels, (-)"
    push!(lines, line)
    for i=1:length(edfile.Outlist)
       line = string("\"",edfile.Outlist[i],"\"")
       push!(lines,line)
    end
    line = "END of input file (the word \"END\" must appear in the first 3 columns of this last OutList line)"
    push!(lines, line)
    line = "---------------------- NODE OUTPUTS --------------------------------------------"
    push!(lines, line)
    line = string(formatword(string(edfile.BldNd_BladesOut);location="back",quotes=false), "   BldNd_BladesOut  - Blades to output")
    push!(lines, line)

    if edfile.BldNd_BladesOut>0
        line = formatvector(edfile.BldNd_BlOutNd)
    else
        line = " "^11
    end
     line = string(line, "   - Blade nodes on each blade (currently unused)")
     push!(lines, line)

     line = "                   OutList             - The next line(s) contains a list of output parameters.  See s for a listing of available output channels, (-)"

     push!(lines, line)
     for i=1:length(edfile.NodeOutlist)
        line = string("\"", edfile.NodeOutlist[i], "\"")
        push!(lines,line)
     end
     line = "END of input file (the word \"END\" must appear in the first 3 columns of this last OutList line)"

    #Write lines to file
    fi = open(outputfile,"w+")
    i = 1
    for i = 1:length(lines)-1
         write(fi,lines[i])
         write(fi,"\n")
    end
    write(fi,lines[end])
    close(fi)
end

function WriteADBlade(adblade, outputfile)
    lines = String[]
    line = string("-"^7, " AERODYN v15.00.* BLADE DEFINITION INPUT FILE ", "-"^37)
    push!(lines, line)
    line = adblade.Notes
    push!(lines, line)
    line = string("="^6, "  Blade Properties ", "="^65)
    push!(lines, line)
    line = string(formatword(string(adblade.NumBlNds);location="back", quotes=false),"   NumBlNds           - Number of blade nodes used in the analysis (-)")
    push!(lines, line)
    line = "  BlSpn        BlCrvAC        BlSwpAC        BlCrvAng       BlTwist        BlChord          BlAFID"
    push!(lines, line)
    line = "   (m)           (m)            (m)            (deg)         (deg)           (m)              (-)"
    push!(lines, line)
    line = formatmatrix(adblade.BldProps[:,1:end-1])
    newcolumn = formatwidecolumn(Int.(adblade.BldProps[:,end]))
    line = formatmatrix_appendcolumn(line, newcolumn)
    append!(lines, line)

    #Write lines to file
    fi = open(outputfile,"w+")
    i = 1
    for i = 1:length(lines)-1
         write(fi,lines[i])
         write(fi,"\n")
    end
    write(fi,lines[end])
    close(fi)
end

"""
WriteAirfoilCoordinates(airfoilcoords, outputfile)

    Writes a file for the OpenFAST airfoil coordinates file.
"""
function WriteAirfoilCoordinates(airfoilcoords, outputfile)
    lines = String[]
    line = string(formatword(string(airfoilcoords.NumCoords);location="back", quotes=false),"   NumCoords         ! The number of coordinates in the airfoil shape file (including an extra coordinate for airfoil reference).  Set to zero if coordinates not included." )
    push!(lines, line)
    line = "! ......... x-y coordinates are next if NumCoords > 0 ............."
    push!(lines, line)
    line = "! x-y coordinate of airfoil reference"
    push!(lines, line)
    line = "!  x/c        y/c"
    push!(lines, line)
    line = formatcoordinates(airfoilcoords.AirfoilReference)
    append!(lines, line)
    line = "! Airfoil Coordinates"
    push!(lines, line)
    line = "! x/c     y/c"
    push!(lines, line)
    line = formatcoordinates(airfoilcoords.Coordinates)
    append!(lines, line)


    ### Write lines to file
    fi = open(outputfile,"w+")
    i = 1
    for i = 1:length(lines)-1
         write(fi,lines[i])
         write(fi,"\n")
    end
    write(fi,lines[end])
    close(fi)
end

"""
WriteAirfoilInput(airfoilinput, outputfile)
"""
function WriteAirfoilInput(airfoilinput, outputfile)
    lines = String[]
    line = "! ------------ AirfoilInfo v1.01.x Input File ----------------------------------"
    push!(lines, line)
    line = string(formatword(string(airfoilinput.InterpOrd);location="front", quotes=true),"   InterpOrd         ! Interpolation order to use for quasi-steady table lookup {1=linear; 3=cubic spline; \"default\"} [default=1]" )
    push!(lines, line)
    line = string(formatword(string(airfoilinput.NonDimArea);location="back", quotes=false),"   NonDimArea        ! The non-dimensional area of the airfoil (area/chord^2) (set to 1.0 if unsure or unneeded)")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.NumCoords);location="front", quotes=false, desiredlength=27),"   NumCoords         ! The number of coordinates in the airfoil shape file.  Set to zero if coordinates not included.")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.NumTabs);location="back", quotes=false),"   NumTabs           ! Number of airfoil tables in this file.")
    push!(lines, line)
    line = "! ------------------------------------------------------------------------------"
    push!(lines, line)
    line = "! data for table 1"
    push!(lines, line)
    line = "! ------------------------------------------------------------------------------"
    push!(lines, line)
    line = string(formatword(string(airfoilinput.Re);location="back", quotes=false),"   Re                ! Reynolds number in millions")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.UserProp);location="back", quotes=false),"   UserProp          ! User property (control) setting")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.InclUAdata);location="back", quotes=false),"   InclUAdata        ! Is unsteady aerodynamics data included in this table? If TRUE, then include 30 UA coefficients below this line")
    push!(lines, line)
    line = "!........................................"
    push!(lines, line)
    line = string(formatword(string(airfoilinput.alpha0);location="back", quotes=false),"   alpha0            ! 0-lift angle of attack, depends on airfoil.")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.alpha1);location="back", quotes=false),"   alpha1            ! Angle of attack at f=0.7, (approximately the stall angle) for AOA>alpha0. (deg)")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.alpha2);location="back", quotes=false),"   alpha2            ! Angle of attack at f=0.7, (approximately the stall angle) for AOA<alpha0. (deg)")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.eta_e);location="back", quotes=false),"   eta_e             ! Recovery factor in the range [0.85 - 0.95] used only for UAMOD=1, it is set to 1 in the code when flookup=True. (-)")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.C_nalpha);location="back", quotes=false),"   C_nalpha          ! Slope of the 2D normal force coefficient curve. (1/rad)")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.T_f0);location="back", quotes=false),"   T_f0              ! Initial value of the time constant associated with Df in the expression of Df and f''. [default = 3]")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.T_V0);location="back", quotes=false),"   T_V0              ! Initial value of the time constant associated with the vortex lift decay process; it is used in the expression of Cvn. It depends on Re,M, and airfoil class. [default = 6]")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.T_p);location="back", quotes=false),"   T_p               ! Boundary-layer,leading edge pressure gradient time constant in the expression of Dp. It should be tuned based on airfoil experimental data. [default = 1.7]")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.T_VL);location="back", quotes=false),"   T_VL              ! Initial value of the time constant associated with the vortex advection process; it represents the non-dimensional time in semi-chords, needed for a vortex to travel from LE to trailing edge (TE); it is used in the expression of Cvn. It depends on Re, M (weakly), and airfoil. [valid range = 6 - 13, default = 11]")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.b1);location="back", quotes=false),"   b1                ! Constant in the expression of phi_alpha^c and phi_q^c.  This value is relatively insensitive for thin airfoils, but may be different for turbine airfoils. [from experimental results, defaults to 0.14]")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.b2);location="back", quotes=false),"   b2                ! Constant in the expression of phi_alpha^c and phi_q^c.  This value is relatively insensitive for thin airfoils, but may be different for turbine airfoils. [from experimental results, defaults to 0.53]")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.b5);location="back", quotes=false),"   b5                ! Constant in the expression of K'''_q,Cm_q^nc, and k_m,q.  [from  experimental results, defaults to 5]")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.A1);location="back", quotes=false),"   A1                ! Constant in the expression of phi_alpha^c and phi_q^c.  This value is relatively insensitive for thin airfoils, but may be different for turbine airfoils. [from experimental results, defaults to 0.3]")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.A2);location="back", quotes=false),"   A2                ! Constant in the expression of phi_alpha^c and phi_q^c.  This value is relatively insensitive for thin airfoils, but may be different for turbine airfoils. [from experimental results, defaults to 0.7]")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.A5);location="back", quotes=false),"   A5                ! Constant in the expression of K'''_q,Cm_q^nc, and k_m,q. [from experimental results, defaults to 1]")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.S1);location="back", quotes=false),"   S1                ! Constant in the f curve best-fit for alpha0<=AOA<=alpha1; by definition it depends on the airfoil. [ignored if UAMod<>1]")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.S2);location="back", quotes=false),"   S2                ! Constant in the f curve best-fit for         AOA> alpha1; by definition it depends on the airfoil. [ignored if UAMod<>1]")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.S3);location="back", quotes=false),"   S3                ! Constant in the f curve best-fit for alpha2<=AOA< alpha0; by definition it depends on the airfoil. [ignored if UAMod<>1]")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.S4);location="back", quotes=false),"   S4                ! Constant in the f curve best-fit for         AOA< alpha2; by definition it depends on the airfoil. [ignored if UAMod<>1]")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.Cn1);location="back", quotes=false),"   Cn1               ! Critical value of C0n at leading edge separation. It should be extracted from airfoil data at a given Mach and Reynolds number. It can be calculated from the static value of Cn at either the break in the pitching moment or the loss of chord force at the onset of stall. It is close to the condition of maximum lift of the airfoil at low Mach numbers.")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.Cn2);location="back", quotes=false),"   Cn2               ! As Cn1 for negative AOAs.")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.St_sh);location="back", quotes=false),"   St_sh             ! Strouhal's shedding frequency constant.  [default = 0.19]")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.Cd0);location="back", quotes=false),"   Cd0               ! 2D drag coefficient value at 0-lift.")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.Cm0);location="back", quotes=false),"   Cm0               ! 2D pitching moment coefficient about 1/4-chord location, at 0-lift, positive if nose up. [If the aerodynamics coefficients table does not include a column for Cm, this needs to be set to 0.0]")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.k0);location="back", quotes=false),"   k0                ! Constant in the hat(x)_cp curve best-fit; = (hat(x)_AC-0.25).  [ignored if UAMod<>1]")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.k1);location="back", quotes=false),"   k1                ! Constant in the hat(x)_cp curve best-fit.  [ignored if UAMod<>1]")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.k2);location="back", quotes=false),"   k2                ! Constant in the hat(x)_cp curve best-fit.  [ignored if UAMod<>1]")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.k3);location="back", quotes=false),"   k3                ! Constant in the hat(x)_cp curve best-fit.  [ignored if UAMod<>1]")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.k1_hat);location="back", quotes=false),"   k1_hat            ! Constant in the expression of Cc due to leading edge vortex effects.  [ignored if UAMod<>1]")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.x_cp_bar);location="back", quotes=false),"   x_cp_bar          ! Constant in the expression of hat(x)_cp^v. [ignored if UAMod<>1, default = 0.2]")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.UACutout);location="front", quotes=false),"   UACutout          ! Angle of attack above which unsteady aerodynamics are disabled (deg). [Specifying the string \"Default\" sets UACutout to 45 degrees]")
    push!(lines, line)
    line = string(formatword(string(airfoilinput.filtCutOff);location="front", quotes=false),"   filtCutOff        ! Cut-off frequency (-3 dB corner frequency) for low-pass filtering the AoA input to UA, as well as the 1st and 2nd derivatives (Hz) [default = 20]")
    push!(lines, line)
    line = "!........................................"
    push!(lines, line)
    line = "! Table of aerodynamics coefficients"
    push!(lines, line)
    line = string(formatword(string(airfoilinput.NumAlf);location="back", quotes=false),"   NumAlf            ! Number of data lines in the following table")
    push!(lines, line)
    line = "!    Alpha      Cl      Cd        Cm"
    push!(lines, line)
    line = "!    (deg)      (-)     (-)       (-)"
    push!(lines, line)
    line = formatcoordinates(airfoilinput.Polar)
    append!(lines, line)

    ### Write lines to file
    fi = open(outputfile,"w+")
    i = 1
    for i = 1:length(lines)-1
         write(fi,lines[i])
         write(fi,"\n")
    end
    write(fi,lines[end])
    close(fi)
end

"""
WriteAerodata(aerodata, outputfile)
This function takes an aerodata structure and writes an output file for it.
"""
function WriteAerodata(aerodata, outputfile)
    lines = String[]
    line = aerodata.Notes1
    push!(lines, line)
    line = aerodata.Notes2
    push!(lines, line)
    line = string(formatword(string(aerodata.NumAirfoils);location="back", quotes=false),"   Number of airfoil tables in this file")
    push!(lines, line)
    line = string(formatword(string(aerodata.TableID);location="back", quotes=false),"   Table ID parameter")
    push!(lines, line)
    line = string(formatword(string(aerodata.Aoa_stall);location="back", quotes=false),"   Stall angle (deg)")
    push!(lines, line)
    line = string(formatword(string(aerodata.z1);location="back", quotes=false),"   No longer used, enter zero")
    push!(lines, line)
    line = string(formatword(string(aerodata.z2);location="back", quotes=false),"   No longer used, enter zero")
    push!(lines, line)
    line = string(formatword(string(aerodata.z3);location="back", quotes=false),"   No longer used, enter zero")
    push!(lines, line)
    line = string(formatword(string(aerodata.Aoa_0Cn);location="back", quotes=false),"   Zero Cn angle of attack (deg)")
    push!(lines, line)
    line = string(formatword(string(aerodata.dCn_0L);location="back", quotes=false),"   Cn slope for zero lift (dimensionless)")
    push!(lines, line)
    line = string(formatword(string(aerodata.Cn_stall_positive);location="back", quotes=false),"   Cn extrapolated to value at positive stall angle of attack")
    push!(lines, line)
    line = string(formatword(string(aerodata.Cn_stall_negative);location="back", quotes=false),"   Cn at stall value for negative angle of attack")
    push!(lines, line)
    line = string(formatword(string(aerodata.Aoa_minCd);location="back", quotes=false),"   Angle of attack for minimum CD (deg)")
    push!(lines, line)
    line = string(formatword(string(aerodata.Cd_min);location="back", quotes=false),"   Minimum CD value")
    push!(lines, line)
    line = formatcoordinates(aerodata.Polar)
    append!(lines, line)

    ### Write lines to file
    fi = open(outputfile,"w+")
    i = 1
    for i = 1:length(lines)-1
         write(fi,lines[i])
         write(fi,"\n")
    end
    write(fi,lines[end])
    close(fi)
end

"""
    WriteBDFile(bdfile, outputfile; outputpath=pwd())

Writes a BeamDyn struct to file. 

**Arguments**
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


"""
WriteEDBlade(edblade, outputfile)

Takes an edblade structure and prints it to file.

"""
function WriteEDBlade(edblade, outputfile)
    lines = String[]
    line = string("-"^7, "  ELASTODYN V1.00.* INDIVIDUAL BLADE INPUT FILE  ", "-"^26)
    push!(lines, line)
    line = edblade.Notes
    push!(lines, line)
    line = string("-"^22, " BLADE PARAMETERS ", "-"^40)
    push!(lines, line)
    line = string(formatword(string(edblade.NBlInpSt);location="back", quotes=false),"   NBlInpSt    - Number of blade input stations (-)")
    push!(lines, line)
    line = string(formatword(string(edblade.BldFlDmp1);location="back", quotes=false),"   BldFlDmp(1) - Blade flap mode #1 structural damping in percent of critical (%)")
    push!(lines, line)
    line = string(formatword(string(edblade.BldFlDmp2);location="back", quotes=false),"   BldFlDmp(2) - Blade flap mode #2 structural damping in percent of critical (%)")
    push!(lines, line)
    line = string(formatword(string(edblade.BldEdDmp1);location="back", quotes=false),"   BldEdDmp(1) - Blade edge mode #1 structural damping in percent of critical (%)")
    push!(lines, line)
    line = string("-"^22, " BLADE ADJUSTMENT FACTORS ", "-"^32)
    push!(lines, line)
    line = string(formatword(string(edblade.FlStTunr1);location="back", quotes=false),"   FlStTunr(1) - Blade flapwise modal stiffness tuner, 1st mode (-)")
    push!(lines, line)
    line = string(formatword(string(edblade.FlStTunr2);location="back", quotes=false),"   FlStTunr(2) - Blade flapwise modal stiffness tuner, 2nd mode (-)")
    push!(lines, line)
    line = string(formatword(string(edblade.AdjBlMs);location="back", quotes=false),"   AdjBlMs     - Factor to adjust blade mass density (-)  !bjj: value for AD14=1.04536; value for AD15=1.057344 (it would be nice to enter the requested blade mass instead of a factor here)")
    push!(lines, line)
    line = string(formatword(string(edblade.AdjFlSt);location="back", quotes=false),"   AdjFlSt     - Factor to adjust blade flap stiffness (-)")
    push!(lines, line)
    line = string(formatword(string(edblade.AdjEdSt);location="back", quotes=false),"   AdjEdSt     - Factor to adjust blade edge stiffness (-)")
    push!(lines, line)
    line = string("-"^22, " DISTRIBUTED BLADE PROPERTIES ", "-"^28)
    push!(lines, line)
    line = "    BlFract      PitchAxis      StrcTwst       BMassDen        FlpStff        EdgStff"
    push!(lines, line)
    line = "      (-)           (-)          (deg)          (kg/m)         (Nm^2)         (Nm^2)"
    push!(lines, line)
    line = formatmatrix(edblade.BldProps)
    append!(lines, line)
    line = string("-"^22, " BLADE MODE SHAPES ", "-"^39)
    push!(lines, line)
    line = string(formatword(string(edblade.BldFl1Sh2);location="back", quotes=false),"   BldFl1Sh(2) - Flap mode 1, coeff of x^2")
    push!(lines, line)
    line = string(formatword(string(edblade.BldFl1Sh3);location="back", quotes=false),"   BldFl1Sh(3) -            , coeff of x^3")
    push!(lines, line)
    line = string(formatword(string(edblade.BldFl1Sh4);location="back", quotes=false),"   BldFl1Sh(4) -            , coeff of x^4")
    push!(lines, line)
    line = string(formatword(string(edblade.BldFl1Sh5);location="back", quotes=false),"   BldFl1Sh(5) -            , coeff of x^5")
    push!(lines, line)
    line = string(formatword(string(edblade.BldFl1Sh6);location="back", quotes=false),"   BldFl1Sh(6) -            , coeff of x^6")
    push!(lines, line)
    line = string(formatword(string(edblade.BldFl2Sh2);location="back", quotes=false),"   BldFl2Sh(2) - Flap mode 2, coeff of x^2")
    push!(lines, line)
    line = string(formatword(string(edblade.BldFl2Sh3);location="back", quotes=false),"   BldFl2Sh(3) -            , coeff of x^3")
    push!(lines, line)
    line = string(formatword(string(edblade.BldFl2Sh4);location="back", quotes=false),"   BldFl2Sh(4) -            , coeff of x^4")
    push!(lines, line)
    line = string(formatword(string(edblade.BldFl2Sh5);location="back", quotes=false),"   BldFl2Sh(5) -            , coeff of x^5")
    push!(lines, line)
    line = string(formatword(string(edblade.BldFl2Sh6);location="back", quotes=false),"   BldFl2Sh(6) -            , coeff of x^6")
    push!(lines, line)
    line = string(formatword(string(edblade.BldEdgSh2);location="back", quotes=false),"   BldEdgSh(2) - Edge mode 1, coeff of x^2")
    push!(lines, line)
    line = string(formatword(string(edblade.BldEdgSh3);location="back", quotes=false),"   BldEdgSh(3) -            , coeff of x^3")
    push!(lines, line)
    line = string(formatword(string(edblade.BldEdgSh4);location="back", quotes=false),"   BldEdgSh(4) -            , coeff of x^4")
    push!(lines, line)
    line = string(formatword(string(edblade.BldEdgSh5);location="back", quotes=false),"   BldEdgSh(5) -            , coeff of x^5")
    push!(lines, line)
    line = string(formatword(string(edblade.BldEdgSh6);location="back", quotes=false),"   BldEdgSh(6) -            , coeff of x^6")
    push!(lines, line)

    ### Write lines to file
    fi = open(outputfile,"w+")
    i = 1
    for i = 1:length(lines)-1
         write(fi,lines[i])
         write(fi,"\n")
    end
    write(fi,lines[end])
    close(fi)
end

function ModifyEDFile()
end

function WriteInflowFile()
end

function ModifyInflowFile()
end
