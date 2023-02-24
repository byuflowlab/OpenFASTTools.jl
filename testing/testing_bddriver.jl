using OpenFASTsr, Revise, DelimitedFiles

of = OpenFASTsr

localdir = @__DIR__

filepath = localdir*"/../example"
filename = "bd_driver_example.inp"

# fi = open(filepath*"/"*filename, "r")
# lines = readlines(fi)
# close(fi)

# lines = of.cleanfile!(lines)

# bddriver = Dict()
# bddriver["Notes"] = lines[1]

# for i = 2:11
#     key, entry = of.parseline(lines[i])
#     bddriver[key] = entry
# end

# idx = 12

# bddriver["GlbDCM"] = of.parsematrix(lines[idx:idx+2]; nameheader=false)

# idx += 3

# for i = idx:idx+16
#     key, entry = of.parseline(lines[i])
#     bddriver[key] = entry
# end

# # pointnames, pointdata = of.parsematrix(lines[idx+17:idx+Int(bddriver["kp_total"])+2]) #Todo: This isn't going to work. 

# keyi, entryi = of.parseline(lines[idx+Int(bddriver["NumPointLoads"])+19])
# bddriver[keyi] = entryi





bddriver = of.read_bddriver(filename, filepath)

of.write_bddriver(bddriver, "test_writebddriver.dat"; outputpath=localdir*"/test_writefiles")