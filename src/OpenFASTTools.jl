module OpenFASTTools


# This wrapper just calls openFAST from the command line. 

#Todo: I need to add the example files to the repo. 
#Todo: Where do I use LinearAlgebra? 
#Todo: I'm not sure that OpenFAST is case sensitive. In that case, it would be good to make sure everything is lowercase.

#Todo: I think I'd like to rename this package OpenFASTTools (OFT)

#Todo: I'm not sure if OpenFAST is case sensitive for the input files. If so, I should make sure everything is lowercase.

using Printf, FLOWMath, DelimitedFiles, GXBeam, StaticArrays, LinearAlgebra, DynamicStallModels

DS = DynamicStallModels

include("utils.jl")
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
