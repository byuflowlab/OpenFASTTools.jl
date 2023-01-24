using OpenFASTsr, Revise, DelimitedFiles

of = OpenFASTsr

localdir = @__DIR__

filepath = localdir*"/../example"
filename = "bd_primary_example.dat"

# fi = open(filepath*"/"*filename, "r")
# lines = readlines(fi)
# close(fi)

# lines = of.cleanfile!(lines)

# bdfile = Dict()
# bdfile["Notes"] = lines[1]

# for i = 2:18
#     key, entry = of.parseline(lines[i])
#     bdfile[key] = entry
# end

# idx = 18+Int(bdfile["member_total"])
# bdfile["KeyPairs"] = of.parsepairs(lines[19:idx])

# twrnames, twrdata = of.parsematrix(lines[idx+1:idx+Int(bdfile["kp_total"])+2])

# #Todo: The parsematrix function only works when there aren't comments interjected in the header of the function.... :| I might need to come up with an alternate function. :| ... At least when it comes to getting the length of the matrix I'm trying to read. 
# for i = eachindex(twrnames)
#     bdfile[twrnames[i]] = twrdata[:,i]
# end

# idx += Int(bdfile["kp_total"]) + 3

# for i = idx:idx+10
#     key, entry = of.parseline(lines[i])
#     bdfile[key] = entry
# end

# ### Outputs section
# outlist1idx = of.findlistbounds(lines[idx+11:end])

# outputs = of.readlist(lines[idx+11:idx+11+outlist1idx[end]-1])
# bdfile["OutList"] = outputs

# idx = idx+11+outlist1idx[end]

# for i = idx:idx+1
#     key, entry = of.parseline(lines[i])
#     bdfile[key] = entry
# end

# ### Nodal outputs
# outlist2idx = of.findlistbounds(lines[idx+2:end])
# outlist = of.readlist(lines[idx+2:idx+2+outlist2idx[end]-1])
# bdfile["SectionOutlist"] = outlist







bdfile = of.read_bdfile(filename, filepath)

of.write_bdfile(bdfile, "test_writeBDfile.dat"; outputpath=localdir*"/test_writefiles")