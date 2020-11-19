"""
endofword(word; quotes=true)

endofword finds the end of the first word given, assuming that the first value is not a space.
It really finds the first space in the text string.

"""
function endofword(word; quotes=true)
    idx = 0
    if quotes
      q = 1
    else
      q = 0
    end
    for i = 1:length(word)
        if word[i]==' '
            idx = i-q #If quotes are real, then subtract the quote off the end
            break
        end
    end
    if idx==0
        idx=length(word)
    end
    return idx
end

function fetchmatrix(lines, widthofmatrix, numcolumns)
    matrix = zeros(length(lines), numcolumns)
    for i=1:length(lines)
        stops = zeros(Int64,numcolumns+1)
        stops[1] = 1
        idx = 2
        for j=1:widthofmatrix
            if lines[i][j]==' ' && lines[i][j+1]!=' '
                stops[idx]=j      #Store the index of the space between columns
                idx += 1
                if idx==numcolumns+1
                    stops[idx]=widthofmatrix
                    break
                end
            end
        end

        for k=1:numcolumns
            matrix[i,k] = parse(Float64, lines[i][stops[k]:stops[k+1]])
        end
    end
    return matrix
end

"""
Fetch one of the beginning words from a FAST File.
"""
function fetchword(line;lengthofword=11)
    return line[2:endofword(line[1:lengthofword])-1]
end

"""
Fetch one of the beginning words from a FAST File.
"""
function fetchword15(line;lengthofword=14, begword=1)
    return line[begword:endofword(line[1:lengthofword])]
end

"""
firstletter(line)
    firstletter finds the first character in a string that isn't a number (including floats)
    or a '+' or a '-'. or a space. So that should be the first letter or symbol.
"""
function firstletter(line)
    index = 0
    for i=1:length(line)
        #Check if the character is any of the things below
        if (!isanumber(line[i])) & (line[i]!=' ') & (line[i] != '-') & (line[i] != '+')
            if line[i] == '.' #Check to see if the period is part of a float
                if i>1
                    if !isanumber(line[i-1]) #The character before isn't a number, so it isn't a float
                        index = i
                        break
                    end
                else #The period is at the beginning of the line, thus it is not part of a float
                    index = i
                    break
                end
            else #The character is not a period, or any of the first check, thus is a letter or symbol
                index = i
                break
            end
        end
    end #End for loop
    if index ==0
        error("Letters or symbols not found in string given. - firstletterfunction")
    end
    return index
end #End function

"""
isanumber(character)
    This function returns a bool of whether or not the given character or string is a number
"""
function isanumber(character)
    if typeof(character) == String
        if length(character) == 1
            character = character[1]
        else
            error("isanumber function only works on characters and strings of length 1.")
        end
    end
    statement = false
    num = Int(character)
    if 47<num<58
        statement = true
    end
    return statement
end


"""
Find number of columns based on tabs between each column in one line.
"""
function numcolumns(line)
    m = 0
    for i = 1:length(line)-1
        if line[i] == '\t'
            m = m + 1
        end
    end
    return m + 1
end


function parsenames(line)
    idx = 1
    namesvec = String[]
    for i=2:length(line)
        if line[i] != ' ' && line[i-1] == ' '
            name = line[idx:i-1]
            name = replace(name, "\t" => "")
            name = replace(name, " " => "")
            push!(namesvec,name)
            idx = i
        end
    end
    name = line[idx:end]
    name = replace(name, "\t" => "")
    name = replace(name, " " => "")
    push!(namesvec,name)
    return namesvec
end

"""
readcoordinates(lines; type=Float64)

    This function reads a two column list of floats from strings to numbers.
    This function is needed when compared to readmatrix, because readmatrix couldn't
    read it without a space in front of the numbers, or something. It was only picking up
    the first column.
    Note that an array needs to be passed in, not a single string.

"""

function readcoordinates(lines; type=Float64)
    stops = []
    for i=1:length(lines[1])
        if lines[1][i]==' '
            if length(stops)==0 && i!=1
                stop = 1
                push!(stops,stop)
            end
            stop = i
            push!(stops,stop)
        end
    end

    matrix = zeros(length(lines), 2)

    for i=1:length(lines)
        number = parse(type, lines[i][stops[1]:stops[2]])
        # println(lines[i][1:stops[1]])
        matrix[i,1] = number
        number = parse(type, lines[i][stops[2]:end])
        # println(lines[i][stops[1]:stops[2]])
        matrix[i,2] = number
    end
    return matrix
end

"""
parse a matrix that is seperated by a single space, not distances
Overloaded function.
    This funcion uses the number of columns and the lines to read in
    a matrix from an array of strings.
"""
function readmatrix(lines;n=1)
    #TODO: Better than this function: cat(readdlm.(IOBuffer.(lines[24+member_total:idx-1]))...,dims=1)
    stops = []
    for i=1:length(lines[1])
        if lines[1][i]==' '
            if length(stops)==0 && i!=1
                stop = 1
                push!(stops,stop)
            end
            stop = i
            push!(stops,stop)
        end
    end

    matrix = zeros(length(lines), length(stops)-n) #What the heck did I do here?

    for i=1:length(lines)
        idx = 1
        spot = 1
        for j=1:length(lines[i])
            if lines[i][j]==' ' && lines[i][idx:j]!=" "
                number = parse(Float64,lines[i][idx:j])
                idx = j
                matrix[i,spot] = number
                spot = spot + 1
            end
        end
    end
    return matrix
end

"""
readmatrix(lines, numcolumns::Int64; type=Float64)
    Overloaded function.
        This funcion uses the number of columns and the lines to read in
        a matrix from an array of strings.
"""
function readmatrix(lines, numcolumns::Int64; type=Float64)
    #Remove the spaces to one
    for i=1:length(lines)
        lines[i] = rmspaces(lines[i])
    end

    matrix = zeros(length(lines), numcolumns)

    for i=1:length(lines)
        idx = 1 # set the initial stop at the beginning
        spot = 1
        for j=1:length(lines[i])
            if lines[i][j]==' ' && j>1 #Stops at spaces
                number = parse(type,lines[i][idx:j]) #from the last stop to this one
                idx = j #Set this stop in memory
                matrix[i,spot] = number
                spot += 1
            end
        end
        if spot<numcolumns+1 #If there isn't a space after the last number,
            #we need to attach the last number in every row. If the last number
            #was appended, then the spot will be increased to be more than the number
            #of columns.
            number = parse(type, lines[i][idx:end])
            matrix[i,spot] = number
        end
    end
    # for i=1:length(lines)
    #     println(matrix[i,:])
    # end
    return matrix
end

function readoutlist(lines)
    count = 0
    outlist = String[]
    for i =1:length(lines)
       if lines[i][1:3]=="END"
          break
       end
       for j=1:length(lines[i])
          if lines[i][j]=='\"'
             count +=1
          end
          if count == 2
             count = 0
             word = lines[i][2:j-1]
             push!(outlist,word)
             break
          end
 
       end
    end
     return outlist
 end

 """
#### readpair(line)
Reads a line to find the first two integers separated by spaces, and returns them as a tuple. Note that the second integer must be followed by a space

### Inputs
- line - a string containing two integers separated by spaces, text may follow the integers, but may not be between or before the integers

### Outputs
- pair - a tuple of the pair of integers
"""
function readpair(line)
    #TODO: Fix me if there isn't a space after the final number. 
    vec = []
    idx = 1
    for i = 1:length(line)-1
        if line[i]!=' ' && line[i+1]==' '
            temp = parse(Int, line[idx:i])
            push!(vec, temp)
            idx = i+1
        elseif length(vec) == 2
            break
        end
    end
    return (vec[1], vec[2])
end

"""readvector(line, veclength, type)
readvector takes a string that includes a comma delimited vector and ends with text and
finds the values in the vector.
"""
function readvector(line,veclength)
   vector = []
   idx = 1
   count = 0
   for i=1:length(line)
      # println(line[i])
      if line[i]==',' && veclength!=0
         # println(line[idx:i])
         number = parse(Int,line[idx:i-1])
         # println("Number: ", number)
         push!(vector,number)
         idx = i+1
         count += 1
      end
      if count>= veclength-1
         break
      end
   end

   for i=idx:length(line)-1
      if line[i]!=' ' && line[i+1]==' ' && veclength!=0
         number = parse(Int,line[idx:i])
         # println("Number: ", number)
         push!(vector,number)
         break
      end
   end
   # println("Vector: ", vector, " Type: ", typeof(vector))
   return vector
end
"""
    readvector(line)

An improved version of readvector that doesn't require the number of elements. It chops off the trailing characters and returns a vector of numbers. 

### Inputs 
- line::String - A string containing a vector of numbers separated by spaces or commas. characters can follow the vector

### Outputs
- vector::Array{inferred} - an array of the numbers you sent to be read. 
"""
function readvector(line)
    stop = 1
    strings = " 1234567890.,"
    line = rmspaces(line)
    for i=1:length(line)
        if !occursin(line[i],strings)
            stop = i-1
            break
        end
    end
    line = replace(line[1:stop], "," => "") #Remove the commas so readdlm will parse it as numbers instead of strings. 
    if line[end]==' ' #Remove the rando entry at the end. 
        line = line[1:end-1]
    end 

    return cat(readdlm.(IOBuffer.(line))...,dims=1)
end

"""
removes tab characters and doublespaces
"""
function rmspaces(line)
    line = replace(line, "\t" => " ")
    # println("line: ", line)
    while occursin("  ", line)
        line = replace(line, "  "=>" ")
        # println("line: ", line)
    end

    return line
end


"""
Seperate the rows of a matrix that is one big string line.
line = long string of a line that has all the rows
m = number of columns in the matrix
"""
function seprows(line, m)
    m = m - 1
    count = 0
    lastindex = 1
    index = 1
    rownum = 1
    rows = String[]
    for i=1:length(line)
        if line[i]=='\t'
            count = count + 1
            if count>=m && rownum<3
                idx = findfirst(' ',line[i:end])
                i = i + idx
                # println("i: ", i)
                row = line[index:i-1]
                push!(rows,row)
                index = i
                count = 0
                rownum = rownum + 1
            elseif count>=m && rownum>=3
                # println("i before: ", i)
                i = i + 2
                # println("i after: ", i)
                idx = findfirst(' ',line[i:end])
                if idx == nothing
                    idx = 0
                end
                i = i + idx
                # println("i: ", i)
                row = line[index:i-1]
                push!(rows,row)
                lastindex = index
                index = i
                count = 0
                rownum = rownum + 1
            end
        end
    end
    row = line[lastindex:end]
    rows[end]=row
    # println("lastindex: ", lastindex)
    # println("index: ", index)
    # println("length: ", length(line))
    return rows
end