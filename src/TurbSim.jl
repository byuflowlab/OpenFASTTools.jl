

function read_hubhtwind(filename, filepath)
    fi = open(filepath*"/"*filename, "r")
    lines = readlines(fi)
    close(fi)

    lines = cleanfile!(lines)

    hubht = Dict()
    hubht["Notes"] = lines[1]

    # This function isn't really needed, cause you can just readdlm the file. 

    # @show length(lines)

    # @show lines[7]

    # for i = 2:7
    #     key, entry = parseline(lines[i])
    #     hubht[key] = entry
    # end

    # for i = 8:10
    #     key, entry = parseline(lines[i], :vector)
    #     hubht[key] = entry
    # end


    # for i = 11:54
    #     key, entry = parseline(lines[i])
    #     hubht[key] = entry
    # end



    # ### Outputs section
    # idx = 55
    # # @show lines[54]

    # outlist1idx = findlistbounds(lines[idx:end])

    # # println("")
    # # println("This list")
    # if length(outlist1idx)>0 #Todo: Not reading empty... which means the other readers might have things wrong. :|  Pain in my bottom. 
    #     outputs = readlist(lines[idx:idx+outlist1idx[end]-1])
    #     hubht["OutList"] = outputs
    # else
    #     hubht["OutList"] = nothing
    # end

    return hubht
end