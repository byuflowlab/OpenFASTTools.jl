module OpenFASTsr

greet() = print("Hello World!")

# This wrapper just calls openFAST from the command line.

using Printf
using FLOWMath

include("structures.jl")
include("internalfunctions.jl")
include("reader.jl")
include("writer.jl")
include("creator.jl")
include("processor.jl")
include("caller.jl")



end # module
