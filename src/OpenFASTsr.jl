module OpenFASTsr

greet() = print("Hello World!")

# This wrapper just calls openFAST from the command line.

using Printf

include("structures.jl")
include("internalfunctions.jl")
include("reader.jl")
include("writer.jl")
include("processor.jl")
include("caller.jl")



end # module
