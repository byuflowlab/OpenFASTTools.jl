using OpenFASTsr
using Test

of = OpenFASTsr

include("testAeroDyn.jl")
include("testBeamDyn.jl")
include("testElastoDyn.jl")
include("testInflowWind.jl")

nothing