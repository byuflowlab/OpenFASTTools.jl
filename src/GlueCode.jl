###########################################################
################### Structures ############################
###########################################################

abstract type Flag end

struct True <:Flag end

struct False <:Flag end

struct Default <:Flag end

abstract type Blade end

mutable struct BladeA{TS, TF, TI} <: Blade
    notes::TS
    numnds::TI
    hubrad::TF
    tiprad::TF
    span::Array{TF, 1} #Measured from the hub
    frac::Array{TF, 1} #Measured from the hub
    radii::Array{TF, 1} #Measured from the center of rotation
    rhat::Array{TF, 1} #Measured from the center of rotation
    chord::Array{TF, 1}
    twist::Array{TF, 1}
    sweep::Array{TF, 1}
    curve::Array{TF, 1}
    curveangle::Array{TF, 1}
    airfoils::Array{TS, 1}
    afid::Array{TI, 1}
    airfoillist::Array{TS, 1}
    # airfoilfiles::Array{AirfoilInput, 1} # I don't know if I want to include the airfoil input files here. I don't really know if I need them. Maybe. 

    ### Base Constructor
    function BladeA(notes::TS, numnds::TI, hubrad::TF, tiprad::TF, span::Array{TF, 1}, radii::Array{TF, 1}, chord::Array{TF, 1}, twist::Union{Array{TF, 1}, TF}, sweep::Union{Array{TF, 1}, TF}, curve::Union{Array{TF, 1}, TF}, curveangle::Union{Array{TF, 1}, TF}, airfoils::Union{Array{TS, 1}, TS}) where {TS, TF, TI}
        ### for scalar inputs
        if length(twist) == 1
            twist = ones(length(radii)).*twist[1]
        end

        if length(sweep) == 1
            sweep = ones(length(radii)).*sweep[1]
        end

        if length(curve) == 1
            curve = ones(length(radii)).*curve[1]
        end

        if length(curveangle) == 1
            curveangle = ones(length(radii)).*curveangle[1]
        end

        if (length(airfoils) == 1) || (typeof(airfoils)==String)
            newairfoils = String[]
            while length(newairfoils) < length(radii)
                push!(newairfoils, airfoils)
            end
            airfoils = newairfoils
        end

        if length(span) != length(radii) != length(chord) != length(twist) != length(sweep) != length(curve) != length(curveangle) != length(airfoils) != length(afid)
            error("Number of blade properties do not match. - GlueCode.")
        end

        if length(span) != numnds
            warning("Number of blade properties does not match number of nodes specified. - GlueCode")
            numnds = length(span)
        end

        if any(x -> x>tiprad, radii)
            warning("Specified radii larger than specified tip radius. - GlueCode")
            tiprad = radii[end]
        end

        rhat = radii./tiprad
        frac = span./span[end]

        airfoillist = unique(airfoils)
        afid = zeros(TI, length(airfoils))
        for i = 1:length(airfoils)
            afid[i] = findfirst(isequal(airfoils[i]), airfoillist)
        end

        return new{TS, TF, TI}(notes, numnds, hubrad, tiprad, span, frac, radii, rhat, chord, twist, sweep, curve, curveangle, airfoils, afid, airfoillist)
    end

    ### no radii constructor
    function BladeA(notes::TS, hubrad::TF, tiprad::TF, span::Array{TF, 1}, chord::Array{TF, 1}, twist::Union{Array{TF, 1}, TF}, sweep::Union{Array{TF, 1}, TF}, curve::Union{Array{TF, 1}, TF}, curveangle::Union{Array{TF, 1}, TF}, airfoils::Union{Array{TS, 1}, TS}) where {TS, TF}

        numnds = length(span)
        radii = span .+ hubrad

        return BladeA(notes, numnds, hubrad, tiprad, span, radii, chord, twist, sweep, curve, curveangle, airfoils)
    end

    ### no span and tiprad constructor
    function BladeA(notes::TS, hubrad::TF, radii::Array{TF, 1}, chord::Array{TF, 1}, twist::Union{Array{TF, 1}, TF}, sweep::Union{Array{TF, 1}, TF}, curve::Union{Array{TF, 1}, TF}, curveangle::Union{Array{TF, 1}, TF}, airfoils::Union{Array{TS, 1}, TS}) where {TS, TF}

        numnds = length(radii)
        tiprad = radii[end]
        span = filter(x -> x>=0, radii .- hubrad) 

        return BladeA(notes, numnds, hubrad, tiprad, span, radii, chord, twist, sweep, curve, curveangle, airfoils)
    end
end

mutable struct BladeAE{TS, TF, TI} <: Blade
    notes::TS
    numnds::TI
    hubrad::TF
    tiprad::TF
    span::Array{TF, 1} #Measured from the hub
    frac::Array{TF, 1} #Measured from the hub
    radii::Array{TF, 1} #Measured from the center of rotation
    rhat::Array{TF, 1} #Measured from the center of rotation
    chord::Array{TF, 1}
    twist::Array{TF, 1}
    sweep::Array{TF, 1}
    curve::Array{TF, 1}
    curveangle::Array{TF, 1}
    airfoils::Array{TS, 1}
    afid::Array{TI, 1}
    airfoillist::Array{TS, 1}
    
    #flapdamp
    #edgedamp
    #pitchaxis
    #structural twist
    #blade mass density
    #Flap stiffness
    #edge stiffness

    ### Base Constructor
    # function BladeAE(notes::TS, numnds::TI, hubrad::TF, tiprad::TF, span::Array{TF, 1}, radii::Array{TF, 1}, chord::Array{TF, 1}, twist::Union{Array{TF, 1}, TF}, sweep::Union{Array{TF, 1}, TF}, curve::Union{Array{TF, 1}, TF}, curveangle::Union{Array{TF, 1}, TF}, airfoils::Union{Array{TS, 1}, TS}) where {TS, TF, TI}
    #     ### for scalar inputs
    #     if length(twist) == 1
    #         twist = ones(length(radii)).*twist[1]
    #     end

    #     if length(sweep) == 1
    #         sweep = ones(length(radii)).*sweep[1]
    #     end

    #     if length(curve) == 1
    #         curve = ones(length(radii)).*curve[1]
    #     end

    #     if length(curveangle) == 1
    #         curveangle = ones(length(radii)).*curveangle[1]
    #     end

    #     if (length(airfoils) == 1) || (typeof(airfoils)==String)
    #         newairfoils = String[]
    #         while length(newairfoils) < length(radii)
    #             push!(newairfoils, airfoils)
    #         end
    #         airfoils = newairfoils
    #     end

    #     if length(span) != length(radii) != length(chord) != length(twist) != length(sweep) != length(curve) != length(curveangle) != length(airfoils) != length(afid)
    #         error("Number of blade properties do not match. - GlueCode.")
    #     end

    #     if length(span) != numnds
    #         warning("Number of blade properties does not match number of nodes specified. - GlueCode")
    #         numnds = length(span)
    #     end

    #     if any(x -> x>tiprad, radii)
    #         warning("Specified radii larger than specified tip radius. - GlueCode")
    #         tiprad = radii[end]
    #     end

    #     rhat = radii./tiprad
    #     frac = span./span[end]

    #     airfoillist = unique(airfoils)
    #     afid = zeros(TI, length(airfoils))
    #     for i = 1:length(airfoils)
    #         afid[i] = findfirst(isequal(airfoils[i]), airfoillist)
    #     end

    #     return new{TS, TF, TI}(notes, numnds, hubrad, tiprad, span, frac, radii, rhat, chord, twist, sweep, curve, curveangle, airfoils, afid, airfoillist)
    # end

    # ### no radii constructor
    # function BladeAE(notes::TS, hubrad::TF, tiprad::TF, span::Array{TF, 1}, chord::Array{TF, 1}, twist::Union{Array{TF, 1}, TF}, sweep::Union{Array{TF, 1}, TF}, curve::Union{Array{TF, 1}, TF}, curveangle::Union{Array{TF, 1}, TF}, airfoils::Union{Array{TS, 1}, TS}) where {TS, TF}

    #     numnds = length(span)
    #     radii = span .+ hubrad

    #     return BladeA(notes, numnds, hubrad, tiprad, span, radii, chord, twist, sweep, curve, curveangle, airfoils)
    # end

    # ### no span and tiprad constructor
    # function BladeAE(notes::TS, hubrad::TF, radii::Array{TF, 1}, chord::Array{TF, 1}, twist::Union{Array{TF, 1}, TF}, sweep::Union{Array{TF, 1}, TF}, curve::Union{Array{TF, 1}, TF}, curveangle::Union{Array{TF, 1}, TF}, airfoils::Union{Array{TS, 1}, TS}) where {TS, TF}

    #     numnds = length(radii)
    #     tiprad = radii[end]
    #     span = filter(x -> x>=0, radii .- hubrad) 

    #     return BladeA(notes, numnds, hubrad, tiprad, span, radii, chord, twist, sweep, curve, curveangle, airfoils)
    # end
end

mutable struct BladeAEB{TS, TF, TI}<: Blade
    notes::TS
    numnds::TI
    hubrad::TF
    tiprad::TF
    span::Array{TF, 1} #Measured from the hub
    radii::Array{TF, 1} #Measured from the center of rotation
    chord::Array{TF, 1}
    twist::Array{TF, 1}
    sweep::Array{TF, 1}
    curve::Array{TF, 1}
    curveangle::Array{TF, 1}
    airfoils::Array{TS, 1}
end

mutable struct Turbine

end

abstract type OperationConditions end

mutable struct SteadyOp <: OperationConditions

end

mutable struct UnsteadyOp <: OperationConditions
end

function make_adblade(blade::Blade)

    #Todo: Something to make sure that the zero is added in, if it isn't already there. 
    
    return ADBlade(blade.notes, blade.numnds, blade.span, blade.curve, blade.sweep, blade.curveangle, blade.twist, blade.chord, blade.afid)
end



###########################################################
################### Reading Functions ###################
###########################################################


"""
    ReadOutput(filename, filepath)

ReadOutput reads the .out file from OpenFASt and parses it into a dictionary.

### Inputs
    filename - String of the .out file to be read
    filepath - String of the path to the .out file.

### Outputs
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