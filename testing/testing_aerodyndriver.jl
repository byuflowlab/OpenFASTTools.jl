using OpenFASTsr, Revise, DelimitedFiles

of = OpenFASTsr

localdir = @__DIR__

filepath = localdir*"/../example"
filename = "ad_driver_example.dvr"

# fi = open(filepath*"/"*filename, "r")
# lines = readlines(fi)
# close(fi)

# lines = of.cleanfile!(lines)

# addriver = Dict()
# addriver["notes"] = lines[1]
# for i = 2:38
#     key, entry = of.parseline(lines[i])
#     addriver[key] = entry
# end

# windnames, winddata = of.parsematrix(lines[39:41+Int(addriver["NumCases"])-1])

# for i = 1:length(windnames)
#     addriver[windnames[i]] = winddata[:,i]
# end



# idx = 41+Int(addriver["NumCases"])
# for i = idx:length(lines)
#     key, entry = of.parseline(lines[i])
#     addriver[key] = entry
# end

addriver = of.read_addriver(filename, filepath)

of.write_addriver(addriver, "test_writeADdriver.dvr"; outputpath=localdir*"/test_writefiles")