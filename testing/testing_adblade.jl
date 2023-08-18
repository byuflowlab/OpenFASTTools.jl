using OpenFASTTools, Revise, DelimitedFiles

of = OpenFASTTools

localdir = @__DIR__

filepath = localdir*"/../example"
filename = "ad_blade_example.dat"


# fi = open(filepath*"/"*filename, "r")
# lines = readlines(fi)
# close(fi)

# lines = of.cleanfile!(lines)

# adblade = Dict()
# adblade["Notes"] = lines[1]

# key, entry = of.parseline(lines[2])
# adblade[key] = entry

# bladenames, bladedata = of.parsematrix(lines[3:3+2+Int(adblade["NumBlNds"])-1])

# for i = 1:length(bladenames)
#     adblade[bladenames[i]] = bladedata[:,i]
# end

adblade = of.read_adblade(filename, filepath)

of.write_adblade(adblade, "test_writeADblade.dat"; outputpath=localdir*"/test_writefiles")