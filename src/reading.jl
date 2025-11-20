
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

function nospaces(line)
    line = replace(line, "\t" => "")
    # println("line: ", line)
    while occursin(" ", line)
        line = replace(line, " "=>"")
        # println("line: ", line)
    end
    # println("\"", line, "\"")
    return line
end



function cleanfile!(lines)
    comment_idxs = Int[]
    for i = 1:length(lines) #Iterate through lines and clean everything up. 
        if occursin("---", lines[i]) #Flag title lines to get rid of them later. I can't get rid of them now, otherwise that'll throw of the iteration. 
            push!(comment_idxs, i)
            continue

        elseif occursin("===", lines[i])
            push!(comment_idxs, i)
            continue

        # elseif lines[i][1]=="!" #Get rid of lines that are just comments
        #     push!(comment_idxs, i)
        #     continue

        # elseif lines[i][1]=="#" #Get rid of lines that are just comments
        #     push!(comment_idxs, i)
        #     continue

        # elseif lines[i][1]=="%" #Get rid of lines that are just comments
        #     push!(comment_idxs, i)
        #     continue
        end

        if occursin("!", lines[i]) #Remove comments 
            cidx = findfirst("!", lines[i])[1]
            lines[i] = lines[i][1:cidx-1]

        elseif occursin("#", lines[i])
            cidx = findfirst("#", lines[i])[1]
            lines[i] = lines[i][1:cidx-1]

        elseif occursin("%", lines[i])
            cidx = findfirst("%", lines[i])[1]
            lines[i] = lines[i][1:cidx-1]
        end

        lines[i] = rmspaces(lines[i]) #Remove tabs and double spaces. 
        lines[i] = strip(lines[i]) #Remove leading and trailing whitespace

        # if lines[i]=="" #Get rid of empty lines
        #     push!(comment_idxs, i)
        #     continue
        # end
    end

    for idx in reverse(comment_idxs) #Get rid of title lines
        popat!(lines, idx)
    end
    return lines
end

function deepcleanfile!(lines)
    comment_idxs = Int[]
    for i = eachindex(lines) #Iterate through lines and clean everything up. 
        if occursin("---", lines[i]) #Flag title lines to get rid of them later. I can't get rid of them now, otherwise that'll throw of the iteration. 
            push!(comment_idxs, i)
            continue

        elseif occursin("===", lines[i])
            push!(comment_idxs, i)
            continue

        elseif lines[i][1]=='!' #flag the lines that are just comments
            push!(comment_idxs, i)
            continue

        elseif lines[i][1]=='#' #flag the lines that are just comments
            push!(comment_idxs, i)
            continue

        elseif lines[i][1]=='%' #flag the lines that are just comments
            push!(comment_idxs, i)
            continue
        end

        if lines[i]=="" #flag the empty lines
            push!(comment_idxs, i)
            continue
        end
    end

    for idx in reverse(comment_idxs) #Get rid of title lines
        popat!(lines, idx)
    end

    ### Now that we've gotten rid of the comments, we can clean up the lines.
    new_comment_idxs = Int[]
    for i in eachindex(lines)
        if occursin("!", lines[i]) #Remove comments 
            cidx = findfirst("!", lines[i])[1]
            lines[i] = lines[i][1:cidx-1]

        elseif occursin("#", lines[i])
            cidx = findfirst("#", lines[i])[1]
            lines[i] = lines[i][1:cidx-1]

        elseif occursin("%", lines[i])
            cidx = findfirst("%", lines[i])[1]
            lines[i] = lines[i][1:cidx-1]
        end

        lines[i] = rmspaces(lines[i]) #Remove tabs and double spaces. 
        lines[i] = strip(lines[i]) #Remove leading and trailing whitespace

        if lines[i]=="" #Get rid of empty lines
            push!(new_comment_idxs, i)
            continue
        end
    end

    for idx in reverse(new_comment_idxs) #Get rid of the empty lines
        popat!(lines, idx)
    end

    return lines
end



function removecomment(line)
    return strip(chopsuffix(line, line[findfirst("- ", line)[1]:end]))
end

function parseentry(word; tryint=false)
    out = nothing
    if tryint
        out = tryparse(Int, word)
    end

    if isnothing(out)
        out = tryparse(Float64, word)
    end

    if isnothing(out)
        out = tryparse(Bool, word)
    end

    if isnothing(out)
        if contains(word, ",")
            try
                out = vec(readdlm(IOBuffer(word), ','))
            catch
                out = nothing
            end
        else
            out = nothing
        end
    end

    if isnothing(out)
        out = word
    end

    return out
end



function parseline(line_initial)
    # @show line_initial
    line = removecomment(line_initial)
    # println("\"", line, "\"")
    entryend = findlast(" ", line)[1]-1 #Todo. This will cause problem if the requested line is a vector. -> I'll make a function that does this functionality. Inside that it'll see if this space occurs before or after a comma. -> Or just use findlast().... because I've used strip(), then the last space that occurs, should be just before the key. 
    entry = parseentry(line[1:entryend])
    key = nospaces(line[entryend+1:end])
    # println("\"", key, "\"")

    return key, entry
end

function parseentry(word, linetype::Symbol; tryint=false)
    out = nothing
    if linetype == :int
        out = tryparse(Int, word)
    end

    if linetype == :float
        out = tryparse(Float64, word)
    end

    if linetype == :bool
        out = tryparse(Bool, word)
    end

    if linetype == :vector
        if contains(word, ",")
            try
                out = vec(readdlm(IOBuffer(word), ','))
            catch
                out = nothing
            end
        else
            try
                out = [tryparse(Float64, word)]
            catch
                println("errored on: ", word)
                out = nothing
            end
        end
    end

    if linetype == :string
        out = word
    end

    return out
end

function parseline(line_initial, linetype)
    line = removecomment(line_initial)
    # println("\"", line, "\"")
    entryend = findlast(" ", line)[1]-1 #Todo. This will cause problem if the requested line is a vector. -> I'll make a function that does this functionality. Inside that it'll see if this space occurs before or after a comma. -> Or just use findlast().... because I've used strip(), then the last space that occurs, should be just before the key. 
    entry = parseentry(line[1:entryend], linetype)
    key = nospaces(line[entryend+1:end])
    # println("\"", key, "\"")

    return key, entry
end

function parsematrix(lines; nameheader=true, unitheader=true)
    if nameheader
        names = vec(readdlm(IOBuffer(strip(lines[1])),' '))
        idx = 2
    else
        return cat(readdlm.(IOBuffer.(lines),' ')...,dims=1)
    end

    if unitheader
        idx += 1
    end

    mat = cat(readdlm.(IOBuffer.(lines[idx:end]),' ')...,dims=1)

    return names, mat
end

function parsepairs(lines)
    nl = length(lines)

    lines[1] = removecomment(lines[1])

    pairs = cat(readdlm.(IOBuffer.(lines),' ')...,dims=1)

    return pairs
end

function findlistbounds(lines)
    for i = 1:length(lines)
        if occursin("end", lowercase.(lines[i]))
            # println("Got here")
            return 1:i
        end
    end

    return 1:length(lines)
end

function readlist(lines)
    
    nl = length(lines)

    # @show nl
    blacklist = ["AFNames", "OutList"] 
    for i = 1:length(blacklist), j = 1:nl
        if occursin(blacklist[i], lines[j])
            # @show j
            startidx = findfirst(blacklist[i], lines[j])[1]
            lines[j] = strip(lines[j][1:startidx-1])
            break
        end
    end

    outvec = String[]
    for i = 1:nl
        lines[i] = strip(lines[i], '\"')
        if length(lines[i])<1
            # println("Option a")
            continue
        elseif occursin("end", lowercase(lines[i]))
            # println("Option b")
            continue
        elseif occursin(",", lines[i])
            # println("Option c")
            veci = readdlm.(IOBuffer.(lines[i]),',')
            for i in eachindex(veci)
                veci[i] = replace(veci[i], " " => "")
            end
            append!(outvec, veci)
        else
            # println("Option d")
            push!(outvec, lines[i])
        end
    end

    return outvec
end





















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
    fetchname(line)

Fetches a name from a fast file. Similar to fetchword, but instead of using a set distance, it bases off of line length to guess how long the name you're trying to snag is. 
"""
function fetchname(line)
    return line[1:endofword(line[1:(length(line)-57)])]
end

"""
Fetch one of the beginning words from a FAST File.
"""
function fetchword(line;lengthofword=14, begword=1, adapt=false, keepquotes=false)
    word = line[begword:endofword(line[1:lengthofword])]
    if adapt
        if lowercase(word)=="true"
            word = true
        elseif lowercase(word)=="false" 
            word = false
        end
    end
    if !keepquotes & (word[1]=='\"')
        word = word[2:end-1]
    end
    return word
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
    for i=2:length(line) #Run along the string containing names until you run into something that is not a space, with a space before it. From idx til that point will contain a word. Remove the tabs and spaces. 
        if (line[i] != ' ' && line[i]!='\t') && (line[i-1] == ' ' || line[i-1] == '\t')
            name = line[idx:i-1]
            name = replace(name, "\t" => "")
            name = replace(name, " " => "")
            if name != ""
                push!(namesvec,name)
            end
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
    readflag(line::String)

Reads in a line (you'll need to chop off all the description portion) and determines what type of flag it is. 

**Inputs**: 
- line::String - A line from a OpenFAST file

**Outputs**:
- flag::Flag - one of the flag types. 
"""
function readflag(line)
    if contains(lowercase(line), "d")
        return Default()
    elseif contains(lowercase(line), "true")
        return True()
    else
        return False()
    end
end

"""
Parse a matrix that is seperated by a single space, not distances.
This function counts the number of columns and the lines to read 
in a matrix from an array of strings.

NOTE: use cat(readdlm.(IOBuffer.(lines))...,dims=1) instead. 

**Inputs**
- lines - an array of strings that contain the matrix
- n - the number of columns in the matrix


"""
function readmatrix(lines;n=1)
    #Note: Better than this function: cat(readdlm.(IOBuffer.(lines[24+member_total:idx-1]))...,dims=1)
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

function readinteger(line)
    if contains(lowercase(line[1:14]), "d")
        return 0
    else
        return parse(Int64, line[1:14])
    end
end

function readnumber(line)
    if contains(lowercase(line[1:14]), "d")
        return NaN
    else
        return parse(Float64, line[1:14])
    end
end

function readoutlist(lines) #Todo: This function needs to be upgraded to recognize words with or without quotation marks. 
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

**Inputs**
- line - a string containing two integers separated by spaces, text may follow the integers, but may not be between or before the integers

**Outputs**
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
   vector = Int64[]
   idx = 1
   count = 0
   for i=1:length(line)
      # println(line[i])
      if line[i]==',' && veclength!=0
         # println(line[idx:i])
         number = parse(Int64,line[idx:i-1])
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
         number = parse(Int64,line[idx:i])
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

**Inputs** 
- line::String - A string containing a vector of numbers separated by spaces or commas. characters can follow the vector

**Outputs**
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

# """
# removes tab characters and doublespaces
# """
# function rmspaces(line)
#     line = replace(line, "\t" => " ")
#     # println("line: ", line)
#     while occursin("  ", line)
#         line = replace(line, "  "=>" ")
#         # println("line: ", line)
#     end

#     return line
# end


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

# function cleanfile!(lines)

#     for i = 1:length(lines) #Get rid of comments
#         if occursin("--", lines[i][1:6])
#             popat!(lines, i)
#         end
#     end
#     return lines
# end

