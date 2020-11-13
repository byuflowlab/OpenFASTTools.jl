module OpenFASTsr

greet() = print("Hello World!")

# This wrapper just calls openFAST from the command line.

using Printf
using FLOWMath
using DelimitedFiles

include("AeroDyn.jl")
inlcude("BeamDyn.jl")
include("ElastoDyn.jl")
include("reading.jl")
include("writing.jl")
include("processor.jl")
include("caller.jl")

# include("structures.jl")
# include("internalfunctions.jl")
# include("reader.jl")
# include("writer.jl")
# include("creator.jl")
# include("processor.jl")
# include("caller.jl")



end # module
