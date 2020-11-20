

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
    cd(filepath)
    fi = open(filename, "r")
    lines = readlines(fi)
    close(fi)

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