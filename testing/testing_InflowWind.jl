using OpenFASTTools, Revise, DelimitedFiles

of = OpenFASTTools

localdir = @__DIR__

filepath = localdir*"/../example"
filename = "inflowwind_example.dat"

# fi = open(filepath*"/"*filename, "r")
# lines = readlines(fi)
# close(fi)

# lines = of.cleanfile!(lines)

# inflowwind = Dict()
# inflowwind["Notes"] = lines[1]

# for i = 2:41
#     key, entry = of.parseline(lines[i])
#     inflowwind[key] = entry
# end



# ### Outputs section
# idx = 42

# outlist1idx = of.findlistbounds(lines[idx:end])

# # println("")
# # println("This list")
# if length(outlist1idx)>0 #Todo: Not reading empty... which means the other readers might have things wrong. :| Pain in my bottom. 
#     outputs = of.readlist(lines[idx:idx+outlist1idx[end]-1])
#     inflowwind["OutList"] = outputs
# else
#     inflowwind["OutList"] = nothing
# end






inflowwind = of.read_inflowwind(filename, filepath)

of.write_inflowwind(inflowwind, "test_writeinflowwind.dat"; outputpath=localdir*"/test_writefiles")