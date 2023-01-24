using OpenFASTsr, Revise, DelimitedFiles

of = OpenFASTsr

localdir = @__DIR__

filepath = localdir*"/../example"
filename = "inputfile_example.dat"

# fi = open(filepath*"/"*filename, "r")
# lines = readlines(fi)
# close(fi)

# lines = of.cleanfile!(lines)

# inputfile = Dict()
# inputfile["Notes"] = lines[1]

# for i = eachindex(lines)[2:end]
#     key, entry = of.parseline(lines[i])
#     inputfile[key] = entry
# end






inputfile = of.read_inputfile(filename, filepath)


of.write_inputfile(inputfile, "test_writeinputfile.dat"; outputpath=localdir*"/test_writefiles")