function formatword(word;location="front",quotes=true, desiredlength=11)
    if quotes
        word = "\""*word*"\""
    end

    if length(word)>desiredlength
        println("Word in formatted word is longer than desired length.")
        println("word: ", word)
    elseif length(word)<desiredlength && location == "front"
        addlength = desiredlength-length(word)
        word = word*" "^addlength
    elseif length(word)<desiredlength && location == "back"
        addlength = desiredlength-length(word)
        word = " "^addlength*word
    end
    return word
end

""" formatmatrix(matrix; cwidth, swidth)
    Format a matrix to a big old string in scientific notation
    decimals = how many decimals
    swidth = spacing width
"""
function formatmatrix(matrix;spacing=2)
        #I've wanted to modify the function to have a size aspect to it, but I haven't found a way.
    line = string()
    smatrix = String[]
    m, n = size(matrix)
    for i = 1:m
        for j = 1:n
            text = @sprintf "%.7E" matrix[i,j]
            space = " "^spacing
            if j<n
                if matrix[i,j+1]<0
                    space = " "^(spacing-1) #Have the spacing vary based on negative signs... I don't know if this is a good fix.
                end
            elseif j==n
                space=""
            end
            line = line*text*space
        end
        push!(smatrix,line)
        line = string()
    end
    return smatrix
end

function formatmatrix_appendcolumn(smat, appendcolumn)
    m = length(smat)
    if length(appendcolumn)!=m
        error("Appended column incorrect length.")
    end
    for i = 1:m
        smat[i]=smat[i]*appendcolumn[i]
    end
    return smat
end

"""
    formatpair(pair; desiredlength=11, delim=" ")

Formats a tuple for printing. 

**Arguments**
- pair::tuple - tuple pair to be written

**Returns**
- line::String - a formatted string for printing
"""
function formatpair(pair)
    return string(" "^5, pair[1], " "^5, pair[2], " "^10)
end

"""
    formatvector(vector;desiredlength=11, loc="back", delim=",")

Formats a vector for printing. 

**Arguments**
- vector::Array{Any,1} - vector to be formatted
- desiredlength::Int - length of desired string that each element is within, not yet integrated
- loc::String - position in the formatted string, not yet implemented
- delim:String - the deliminating character

**Returns**
- line::String - The formatted string of the vector. 
"""
function formatvector(vector;desiredlength=11, loc="back", delim=",")
    line = ""
    if length(vector)>0
        for i=1:length(vector)-1
           line = string(line,formatword(string(vector[i]);location=loc,quotes=false),delim)
        end
        line = string(line,formatword(string(vector[end]);location=loc,quotes=false))
    else
        line = "     "
    end
    return line
end

"""
formatwidecolumn(column; spacing=6, location="front")

This function takes a vector of numbers converts it to a vector of strings and tacks a
    set of spaces either on the front or end of the column.

"""

function formatwidecolumn(column; spacing=6, location="front")
    newcolumn = String[]
    for i=1:length(column)
        if location=="back"
            line = string(column[i], " "^spacing)
        else
            line = string(" "^spacing, column[i])
        end
        push!(newcolumn,line)
    end
    return newcolumn
end

"""
formatcoordinates(matrix; spacing)

    Takes a matrix and formats it with 5 floating decimals each column 2 spaces
    apart as a string.

    Hopefully this doesn't break anything, because it doesn't always align the columns
    if there is a negative. 
"""
function formatcoordinates(matrix; spacing=2)
    line = string()
    smatrix = String[]
    m, n = size(matrix)

    for i = 1:m
        for j = 1:n
            text = @sprintf "%.5f" matrix[i,j]
            space = " "^spacing
            if j<n
                if matrix[i,j+1]<0
                    space = " "^(spacing-1) #Have the spacing vary based on negative signs... I don't know if this is a good fix.
                end
            elseif j==n
                space = ""
            end
            line = line*text*space
        end
        # println(line)
        push!(smatrix,line)
        line = string()
    end
    # println(smatrix)
    return smatrix
end
