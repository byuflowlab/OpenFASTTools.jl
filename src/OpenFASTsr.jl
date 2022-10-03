module OpenFASTsr


# This wrapper just calls openFAST from the command line. 

#Todo: I need to add the example files to the repo. 

using Printf, FLOWMath, DelimitedFiles, GXBeam, StaticArrays, LinearAlgebra, DynamicStallModels

DS = DynamicStallModels

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
