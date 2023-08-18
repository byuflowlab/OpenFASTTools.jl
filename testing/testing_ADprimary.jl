using OpenFASTTools, Revise, DelimitedFiles

of = OpenFASTTools

localdir = @__DIR__

filepath = localdir*"/../example"
filename = "ad_primary_example.dat"

# fi = open(filepath*"/"*filename, "r")
# lines = readlines(fi)
# close(fi)

# lines = of.cleanfile!(lines)

# adfile = Dict()
# adfile["Notes"] = lines[1]

# for i = 2:41
#     key, entry = of.parseline(lines[i])
#     adfile[key] = entry
# end

# adfile["AFNames"] = of.readlist(lines[42:42+Int(adfile["NumAFfiles"])-1]) 

# idx = 42+Int(adfile["NumAFfiles"])
# # @show idx

# for i = idx:idx+8
#     key, entry = of.parseline(lines[i])
#     adfile[key] = entry
# end

# # @show idx+4

# twrnames, twrdata = of.parsematrix(lines[idx+9:idx+9+2+Int(adfile["NumTwrNds"])-1])

# #Todo: The parsematrix function only works when there aren't comments interjected in the header of the function.... :| I might need to come up with an alternate function. :| ... At least when it comes to getting the length of the matrix I'm trying to read. 
# for i = 1:5 #length(twrnames)
#     adfile[twrnames[i]] = twrdata[:,i]
# end


# ### Outputs section
# idx = idx+9+2+Int(adfile["NumTwrNds"])
# # @show idx

# for i = idx:idx+4
#     key, entry = of.parseline(lines[i])
#     adfile[key] = entry
# end

# outlist1idx = of.findlistbounds(lines[idx+5:end])

# # println("")
# # println("This list")
# outputs = of.readlist(lines[idx+5:idx+5+outlist1idx[end]-1])
# adfile["OutList"] = outputs

# idx = idx+5+outlist1idx[end]

# ### Nodal outputs
# for i = idx:idx+1
#     key, entry = of.parseline(lines[i])
#     adfile[key] = entry
# end

# outlist2idx = of.findlistbounds(lines[idx+2:end])
# outlist = of.readlist(lines[idx+2:idx+2+outlist2idx[end]-1])
# adfile["SectionOutlist"] = outlist




adfile = of.read_adfile(filename, filepath)

of.write_adfile(adfile, "test_writeADfile.dat"; outputpath=localdir*"/test_writefiles")
