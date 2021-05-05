using BenchmarkTools

using OpenFASTsr
using Test

of = OpenFASTsr
println("Starting Testing...")
 
# include("testAeroDyn.jl")
include("testBeamDyn.jl")
# include("testElastoDyn.jl")
# include("testInflowWind.jl")
# include("testGlueCode.jl")

nothing