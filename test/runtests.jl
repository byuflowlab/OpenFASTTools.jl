using BenchmarkTools

using OpenFASTTools
using Test

of = OpenFASTTools
println("Starting Testing...")
 
# include("testAeroDyn.jl")
include("testBeamDyn.jl")
# include("testElastoDyn.jl")
# include("testInflowWind.jl")
# include("testGlueCode.jl")

nothing