@testset "InflowWind" begin
    @testset "Read InflowWind File" begin
    file = "NREL5MWref_InflowWind_12mps.dat"
    path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine"
    iwfile = of.ReadIWFile(file, path)

    @test lowercase(iwfile.Echo)=="false"
    @test iwfile.WindType==3
    @test isapprox(iwfile.PropagationDir, 0, atol=1e-5)
    @test iwfile.NWindVel==1
    windx = [0]
    windy = [0]
    windz = [90]
    @test isapprox(iwfile.WindVxiList, windx, atol=1e-5)
    @test isapprox(iwfile.WindVyiList, windy, atol=1e-5)
    @test isapprox(iwfile.WindVziList, windz, atol=1e-5)

    @test isapprox(iwfile.HWindSpeedSteady, 0, atol=1e-5)
    @test isapprox(iwfile.RefHtSteady, 90, atol=1e-5)
    @test isapprox(iwfile.PLexpSteady, 0.2, atol=1e-5)

    @test iwfile.FilenameUniform=="Wind/90m_12mps_twr.bts"
    @test isapprox(iwfile.RefHtUniform, 90, atol=1e-5)
    @test isapprox(iwfile.RefLengthUniform, 125.88, atol=1e-5)

    @test iwfile.FilenameTurbSim=="Wind/90m_12mps_twr.bts"

    @test iwfile.FilenameBinary=="Wind/90m_12mps_twr"
    @test lowercase(iwfile.TowerFile)=="false"

    @test iwfile.FileName_u=="wasp\\Output\\basic_5u.bin"
    @test iwfile.FileName_v=="wasp\\Output\\basic_5v.bin"
    @test iwfile.FileName_w=="wasp\\Output\\basic_5w.bin"
    @test iwfile.nx==64
    @test iwfile.ny==32
    @test iwfile.nz==32
    @test isapprox(iwfile.dx, 16, atol=1e-5)
    @test isapprox(iwfile.dy, 3, atol=1e-5)
    @test isapprox(iwfile.dz, 3, atol=1e-5)
    @test isapprox(iwfile.RefHtHAWC, 90, atol=1e-5)

    @test iwfile.ScaleMethod==2
    @test isapprox(iwfile.SFx, 1, atol=1e-5)
    @test isapprox(iwfile.SFy, 1, atol=1e-5)
    @test isapprox(iwfile.SFz, 1, atol=1e-5)
    @test isapprox(iwfile.SigmaFx, 1.2, atol=1e-5)
    @test isapprox(iwfile.SigmaFy, 0.8, atol=1e-5)
    @test isapprox(iwfile.SigmaFz, 0.2, atol=1e-5)

    @test isapprox(iwfile.URef, 12, atol=1e-5)
    @test iwfile.WindProfile==2
    @test isapprox(iwfile.PLexpHAWC, 0.2, atol=1e-5)
    @test isapprox(iwfile.Z0, 0.03, atol=1e-5)
    @test isapprox(iwfile.InitPositionx, 0.0, atol=1e-5)

    @test lowercase(iwfile.SumPrint)=="false"
    outlist = [ "Wind1VelX", "Wind1VelY", "Wind1VelZ"]
    @test iwfile.Outlist==outlist

    end #End testing read Inflow Wind file

    @testset "Write InflowWind file" begin
    file = "NREL5MWref_InflowWind_12mps.dat"
    path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine"
    iwfiletemp = of.ReadIWFile(file, path)
    of.WriteIWFile(iwfiletemp, "testingInflowWind.dat")
    iwfile = of.ReadIWFile("testingInflowWind.dat", path)

    @test lowercase(iwfile.Echo)=="false"
    @test iwfile.WindType==3
    @test isapprox(iwfile.PropagationDir, 0, atol=1e-5)
    @test iwfile.NWindVel==1
    windx = [0]
    windy = [0]
    windz = [90]
    @test isapprox(iwfile.WindVxiList, windx, atol=1e-5)
    @test isapprox(iwfile.WindVyiList, windy, atol=1e-5)
    @test isapprox(iwfile.WindVziList, windz, atol=1e-5)

    @test isapprox(iwfile.HWindSpeedSteady, 0, atol=1e-5)
    @test isapprox(iwfile.RefHtSteady, 90, atol=1e-5)
    @test isapprox(iwfile.PLexpSteady, 0.2, atol=1e-5)

    @test iwfile.FilenameUniform=="Wind/90m_12mps_twr.bts"
    @test isapprox(iwfile.RefHtUniform, 90, atol=1e-5)
    @test isapprox(iwfile.RefLengthUniform, 125.88, atol=1e-5)

    @test iwfile.FilenameTurbSim=="Wind/90m_12mps_twr.bts"

    @test iwfile.FilenameBinary=="Wind/90m_12mps_twr"
    @test lowercase(iwfile.TowerFile)=="false"

    @test iwfile.FileName_u=="wasp\\Output\\basic_5u.bin"
    @test iwfile.FileName_v=="wasp\\Output\\basic_5v.bin"
    @test iwfile.FileName_w=="wasp\\Output\\basic_5w.bin"
    @test iwfile.nx==64
    @test iwfile.ny==32
    @test iwfile.nz==32
    @test isapprox(iwfile.dx, 16, atol=1e-5)
    @test isapprox(iwfile.dy, 3, atol=1e-5)
    @test isapprox(iwfile.dz, 3, atol=1e-5)
    @test isapprox(iwfile.RefHtHAWC, 90, atol=1e-5)

    @test iwfile.ScaleMethod==2
    @test isapprox(iwfile.SFx, 1, atol=1e-5)
    @test isapprox(iwfile.SFy, 1, atol=1e-5)
    @test isapprox(iwfile.SFz, 1, atol=1e-5)
    @test isapprox(iwfile.SigmaFx, 1.2, atol=1e-5)
    @test isapprox(iwfile.SigmaFy, 0.8, atol=1e-5)
    @test isapprox(iwfile.SigmaFz, 0.2, atol=1e-5)

    @test isapprox(iwfile.URef, 12, atol=1e-5)
    @test iwfile.WindProfile==2
    @test isapprox(iwfile.PLexpHAWC, 0.2, atol=1e-5)
    @test isapprox(iwfile.Z0, 0.03, atol=1e-5)
    @test isapprox(iwfile.InitPositionx, 0.0, atol=1e-5)

    @test lowercase(iwfile.SumPrint)=="false"
    outlist = [ "Wind1VelX", "Wind1VelY", "Wind1VelZ"]
    @test iwfile.Outlist==outlist

    end #End testing Write Inflow Wind File

end #End testing InflowWind