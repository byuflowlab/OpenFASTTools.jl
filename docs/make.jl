using Documenter, OpenFASTsr

makedocs(
        modules = [OpenFASTsr],
        format = Documenter.HTML(),
        pages = [
            "Introduction" => "index.md", 
            "Quick Start" => "quickstart.md",
            "Guided Examples" => "guidedexamples.md",
            "API Reference" => "reference.md"
        ],
        repo="https://github.com/byuflowlab/OpenFASTsr.jl/blob/{commit}{path}#L{line}",
        sitename="OpenFASTsr",
        authors = "Adam Cardoza <adam.cardoza.online@gmail.com>",
        )

# makedocs(
#     modules = [CCBlade],
#     format = Documenter.HTML(),
#     pages = [
#         "Intro" => "index.md",
#         "Quick Start" => "tutorial.md",
#         "Guided Examples" => "howto.md",
#         "API Reference" => "reference.md",
#         "Theory" => "theory.md"
#     ],
#     repo="https://github.com/byuflowlab/CCBlade.jl/blob/{commit}{path}#L{line}",
#     sitename="CCBlade.jl",
#     authors="Andrew Ning <aning@byu.edu>",
# )

deploydocs(
    repo = "github.com/byuflowlab/OpenFASTsr.jl.git",
)