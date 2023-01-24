using OpenFASTsr, Revise, DelimitedFiles

of = OpenFASTsr

localdir = @__DIR__

filepath = localdir*"/../example"
filename = "ed_primary_example.dat"

# fi = open(filepath*"/"*filename, "r")
# lines = readlines(fi)
# close(fi)

# lines = of.cleanfile!(lines)

# edfile = Dict()
# edfile["Notes"] = lines[1]

# for i = 2:107 #Todo: I need to update parseline so that if there isn't an entry. Apparently that doesn't screw up OpenFAST. 
#     key, entry = of.parseline(lines[i])
#     edfile[key] = entry
# end


# idx = 108
# outlist1idx = of.findlistbounds(lines[idx:end])

# # # println("")
# # # println("This list")
# if length(outlist1idx)>0 #Todo: Add this check into the other readers. 
#     outputs = of.readlist(lines[idx:idx+outlist1idx[end]-1])
#     edfile["OutList"] = outputs
#     idx = idx+outlist1idx[end]
# else
#     edfile["OutList"] = nothing
#     idx = idx
# end



# ### Nodal outputs
# for i = idx:idx+1
#     key, entry = of.parseline(lines[i])
#     edfile[key] = entry
# end

# outlist2idx = of.findlistbounds(lines[idx+2:end])
# if length(outlist2idx)>0
#     outlist = of.readlist(lines[idx+2:idx+2+outlist2idx[end]-1])
#     edfile["SectionOutlist"] = outlist
# else
#     edfile["SectionOutlist"] = nothing
# end




edfile = of.read_edfile(filename, filepath)

of.write_edfile(edfile, "test_writeEDfile.dat"; outputpath=localdir*"/test_writefiles")