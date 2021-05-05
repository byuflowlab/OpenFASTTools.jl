module OpenFASTsr

greet() = print("Hello World!")

# This wrapper just calls openFAST from the command line.

using Printf
using FLOWMath
using DelimitedFiles

include("GlueCode.jl")
include("reading.jl")
include("writing.jl")
include("processor.jl")
include("caller.jl")
include("AeroDyn.jl")
include("BeamDyn.jl")
include("ElastoDyn.jl")
include("InflowWind.jl")

end # module
