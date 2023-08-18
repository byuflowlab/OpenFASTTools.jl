using OpenFASTTools, Revise, DelimitedFiles

of = OpenFASTTools

localdir = @__DIR__

filepath = localdir*"/../example"
filename = "bd_blade_example.dat"

# fi = open(filepath*"/"*filename, "r")
# lines = readlines(fi)
# close(fi)

# lines = of.cleanfile!(lines)

# bdblade = Dict()
# bdblade["Notes"] = lines[1]

# for i = 2:3
#     key, entry = of.parseline(lines[i])
#     bdblade[key] = entry
# end

# munames, mus = of.parsematrix(lines[4:6])

# bdblade["mu"] = mus

# rfracvec = zeros(Int(bdblade["station_total"]))

# for i = 1:Int(bdblade["station_total"])
#     idx = (i-1) + 6 + 14*(i-1)
#     # @show lines[idx+1]
#     rfracvec[i] = of.parseentry(lines[idx+1])

#     bdblade["K$i"] = of.parsematrix(lines[idx+2:idx+7]; nameheader=false)
#     bdblade["M$i"] = of.parsematrix(lines[idx+9:idx+14]; nameheader=false)
# end

# bdblade["rfrac"] = rfracvec





bdblade = of.read_bdblade(filename, filepath)

of.write_bdblade(bdblade, "test_writebdblade.dat"; outputpath=localdir*"/test_writefiles")