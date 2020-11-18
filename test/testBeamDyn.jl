
@testset "BeamDyn" begin

file = "NREL5MWrefBD.dat"
path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine"
bdfile = of.ReadBDFile(file, path)

@test lowercase(bdfile.Echo)=="false"

end