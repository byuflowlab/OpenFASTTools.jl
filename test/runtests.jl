using BenchmarkTools

using OpenFASTTools
using Test

#=
Note to user, the OpenFAST files must be run before running the tests. -> I think that might inhibit the ability of the tests to be run online if 
the files aren't also available online.
=#

of = OpenFASTTools
println("Starting Testing...")
 
# include("testAeroDyn.jl")
include("testBeamDyn.jl")
# include("testElastoDyn.jl")
include("testInflowWind.jl")
# include("testGlueCode.jl")

nothing