
@testset "ElastoDyn" begin
    @testset "Read ElastoDyn File" begin
    file = "NREL5MWrefED.dat"
    path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine"
    edfile = of.ReadEDFile(file, path)

    @test lowercase(edfile.Echo)=="false"
    @test edfile.Method==3
    @test lowercase(edfile.DT)=="\"default\"" #TODO: this could be a number too!!!
    @test isapprox(edfile.Gravity, 9.80665, atol=1e-8)
    @test lowercase(edfile.FlapDOF1)=="true"
    @test lowercase(edfile.FlapDOF2)=="true"
    @test lowercase(edfile.EdgeDOF)=="true"
    @test lowercase(edfile.TeetDOF)=="false"
    @test lowercase(edfile.DrTrDOF)=="true"
    @test lowercase(edfile.GenDOF)=="true"
    @test lowercase(edfile.YawDOF)=="true"
    @test lowercase(edfile.TwFADOF1)=="true"
    @test lowercase(edfile.TwFADOF2)=="true"
    @test lowercase(edfile.TwSSDOF1)=="true"
    @test lowercase(edfile.TwSSDOF2)=="true"
    @test lowercase(edfile.PtfmSgDOF)=="false"
    @test lowercase(edfile.PtfmSwDOF)=="false"
    @test lowercase(edfile.PtfmHvDOF)=="false"
    @test lowercase(edfile.PtfmRDOF)=="false"
    @test lowercase(edfile.PtfmPDOF)=="false"
    @test lowercase(edfile.PtfmYDOF)=="false"

    @test isapprox(edfile.OoPDefl, 0.0, atol=1e-8)
    @test isapprox(edfile.IPDefl, 0.0, atol=1e-8)
    @test isapprox(edfile.BlPitch1, 0.0, atol=1e-8)
    @test isapprox(edfile.BlPitch2, 0.0, atol=1e-8)
    @test isapprox(edfile.BlPitch3, 0.0, atol=1e-8)
    @test isapprox(edfile.TeetDefl, 0.0, atol=1e-8)
    @test isapprox(edfile.Azimuth, 0.0, atol=1e-8)
    @test isapprox(edfile.RotSpeed, 12.1, atol=1e-8)
    @test isapprox(edfile.NacYaw, 0.0, atol=1e-8)
    @test isapprox(edfile.TTDspFA, 0.0, atol=1e-8)
    @test isapprox(edfile.TTDspSS, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmSurge, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmSway, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmHeave, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmRoll, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmPitch, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmYaw, 0.0, atol=1e-8)

    @test edfile.NumBl==3
    @test isapprox(edfile.TipRad, 63, atol=1e-8)
    @test isapprox(edfile.HubRad, 1.5, atol=1e-8)
    @test isapprox(edfile.PreCone1, -2.5, atol=1e-8)
    @test isapprox(edfile.PreCone2, -2.5, atol=1e-8)
    @test isapprox(edfile.PreCone3, -2.5, atol=1e-8)
    @test isapprox(edfile.HubCM, 0.0, atol=1e-8)
    @test isapprox(edfile.UndSling, 0.0, atol=1e-8)
    @test isapprox(edfile.Delta3, 0.0, atol=1e-8)
    @test isapprox(edfile.AzimB1Up, 0.0, atol=1e-8)
    @test isapprox(edfile.OverHang, -5.0191, atol=1e-8)
    @test isapprox(edfile.ShftGagL, 1.912, atol=1e-8)
    @test isapprox(edfile.ShftTilt, -5, atol=1e-8)
    @test isapprox(edfile.NacCMxn, 1.9, atol=1e-8)
    @test isapprox(edfile.NacCMyn, 0.0, atol=1e-8)
    @test isapprox(edfile.NacCMzn, 1.75, atol=1e-8)
    @test isapprox(edfile.NcIMUxn, -3.09528, atol=1e-8)
    @test isapprox(edfile.NcIMUyn, 0.0, atol=1e-8)
    @test isapprox(edfile.NcIMUzn, 2.23336, atol=1e-8)
    @test isapprox(edfile.Twr2Shft, 1.96256, atol=1e-8)
    @test isapprox(edfile.TowerHt, 87.6, atol=1e-8)
    @test isapprox(edfile.TowerBsHt, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmCMxt, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmCMyt, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmCMzt, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmRefzt, 0.0, atol=1e-8)

    @test isapprox(edfile.TipMass1, 0.0, atol=1e-8)
    @test isapprox(edfile.TipMass2, 0.0, atol=1e-8)
    @test isapprox(edfile.TipMass3, 0.0, atol=1e-8)
    @test isapprox(edfile.HubMass, 56780, atol=1)
    @test isapprox(edfile.HubIner, 115926, atol=1)
    @test isapprox(edfile.GenIner, 534.116, atol=1e-3)
    @test isapprox(edfile.NacMass, 240000, atol=1)
    @test isapprox(edfile.NacYIner, 2.60789E+06, atol=1e2)
    @test isapprox(edfile.YawBrMass, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmMass, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmRIner, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmPIner, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmYIner, 0.0, atol=1e-8)

    @test edfile.BldNodes==17
    @test edfile.BldFile1=="\"NREL5MWref_Blade.dat\""
    @test edfile.BldFile2=="\"NREL5MWref_Blade.dat\""
    @test edfile.BldFile3=="\"NREL5MWref_Blade.dat\""

    @test isapprox(edfile.TeetMod, 0.0, atol=1e-8)
    @test isapprox(edfile.TeetDmpP, 0.0, atol=1e-8)
    @test isapprox(edfile.TeetDmp, 0.0, atol=1e-8)
    @test isapprox(edfile.TeetCDmp, 0.0, atol=1e-8)
    @test isapprox(edfile.TeetSStP, 0.0, atol=1e-8)
    @test isapprox(edfile.TeetHStP, 0.0, atol=1e-8)
    @test isapprox(edfile.TeetSSSp, 0.0, atol=1e-8)
    @test isapprox(edfile.TeetHSSp, 0.0, atol=1e-8)

    @test isapprox(edfile.GBoxEff, 100, atol=1e-8)
    @test isapprox(edfile.GBRatio, 97, atol=1e-8)
    @test isapprox(edfile.DTTorSpr, 8.67637E+08, atol=1)
    @test isapprox(edfile.DTTorDmp, 6.215E+06, atol=1)

    @test lowercase(edfile.Furling)=="false"
    @test edfile.TwrFile=="\"NREL5MWrefED_Tower.dat\""

    @test lowercase(edfile.SumPrint)=="true"
    @test edfile.OutFile==1
    @test lowercase(edfile.TabDelim)=="true"
    @test edfile.OutFmt=="\"ES10.3E2\""
    @test isapprox(edfile.TStart, 0, atol=1e-5)
    @test isapprox(edfile.DecFact, 1, atol=1e-5)
    @test edfile.NTwGages==3
    twrgagnd = [5, 10, 15]
    @test edfile.TwrGagNd==twrgagnd
    @test edfile.NBlGages==6
    bldgagnd = [1, 4, 7, 10, 13, 16]
    @test edfile.BldGagNd==bldgagnd
    outlist = [ "RootMxb1", "RootMyb1", "RootMzb1"]
    @test edfile.Outlist==outlist

    @test edfile.BldNd_BladesOut==3
    outnd = [99]
    @test edfile.BldNd_BlOutNd==outnd 
    outlist = [ "ALx", "ALy", "ALz"]
    @test edfile.NodeOutlist==outlist

    end #End testing Read ED file

    @testset "Write ElastoDyn File" begin
    file = "NREL5MWrefED.dat"
    path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine"
    edfiletemp = of.ReadEDFile(file, path)
    of.WriteEDFile(edfiletemp, "testingEDFile.dat")
    edfile = of.ReadEDFile("testingEDfile.dat", path)

    @test lowercase(edfile.Echo)=="false"
    @test edfile.Method==3
    @test lowercase(edfile.DT)=="\"default\"" #TODO: this could be a number too!!!
    @test isapprox(edfile.Gravity, 9.80665, atol=1e-8)
    @test lowercase(edfile.FlapDOF1)=="true"
    @test lowercase(edfile.FlapDOF2)=="true"
    @test lowercase(edfile.EdgeDOF)=="true"
    @test lowercase(edfile.TeetDOF)=="false"
    @test lowercase(edfile.DrTrDOF)=="true"
    @test lowercase(edfile.GenDOF)=="true"
    @test lowercase(edfile.YawDOF)=="true"
    @test lowercase(edfile.TwFADOF1)=="true"
    @test lowercase(edfile.TwFADOF2)=="true"
    @test lowercase(edfile.TwSSDOF1)=="true"
    @test lowercase(edfile.TwSSDOF2)=="true"
    @test lowercase(edfile.PtfmSgDOF)=="false"
    @test lowercase(edfile.PtfmSwDOF)=="false"
    @test lowercase(edfile.PtfmHvDOF)=="false"
    @test lowercase(edfile.PtfmRDOF)=="false"
    @test lowercase(edfile.PtfmPDOF)=="false"
    @test lowercase(edfile.PtfmYDOF)=="false"

    @test isapprox(edfile.OoPDefl, 0.0, atol=1e-8)
    @test isapprox(edfile.IPDefl, 0.0, atol=1e-8)
    @test isapprox(edfile.BlPitch1, 0.0, atol=1e-8)
    @test isapprox(edfile.BlPitch2, 0.0, atol=1e-8)
    @test isapprox(edfile.BlPitch3, 0.0, atol=1e-8)
    @test isapprox(edfile.TeetDefl, 0.0, atol=1e-8)
    @test isapprox(edfile.Azimuth, 0.0, atol=1e-8)
    @test isapprox(edfile.RotSpeed, 12.1, atol=1e-8)
    @test isapprox(edfile.NacYaw, 0.0, atol=1e-8)
    @test isapprox(edfile.TTDspFA, 0.0, atol=1e-8)
    @test isapprox(edfile.TTDspSS, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmSurge, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmSway, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmHeave, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmRoll, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmPitch, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmYaw, 0.0, atol=1e-8)

    @test edfile.NumBl==3
    @test isapprox(edfile.TipRad, 63, atol=1e-8)
    @test isapprox(edfile.HubRad, 1.5, atol=1e-8)
    @test isapprox(edfile.PreCone1, -2.5, atol=1e-8)
    @test isapprox(edfile.PreCone2, -2.5, atol=1e-8)
    @test isapprox(edfile.PreCone3, -2.5, atol=1e-8)
    @test isapprox(edfile.HubCM, 0.0, atol=1e-8)
    @test isapprox(edfile.UndSling, 0.0, atol=1e-8)
    @test isapprox(edfile.Delta3, 0.0, atol=1e-8)
    @test isapprox(edfile.AzimB1Up, 0.0, atol=1e-8)
    @test isapprox(edfile.OverHang, -5.0191, atol=1e-8)
    @test isapprox(edfile.ShftGagL, 1.912, atol=1e-8)
    @test isapprox(edfile.ShftTilt, -5, atol=1e-8)
    @test isapprox(edfile.NacCMxn, 1.9, atol=1e-8)
    @test isapprox(edfile.NacCMyn, 0.0, atol=1e-8)
    @test isapprox(edfile.NacCMzn, 1.75, atol=1e-8)
    @test isapprox(edfile.NcIMUxn, -3.09528, atol=1e-8)
    @test isapprox(edfile.NcIMUyn, 0.0, atol=1e-8)
    @test isapprox(edfile.NcIMUzn, 2.23336, atol=1e-8)
    @test isapprox(edfile.Twr2Shft, 1.96256, atol=1e-8)
    @test isapprox(edfile.TowerHt, 87.6, atol=1e-8)
    @test isapprox(edfile.TowerBsHt, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmCMxt, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmCMyt, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmCMzt, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmRefzt, 0.0, atol=1e-8)

    @test isapprox(edfile.TipMass1, 0.0, atol=1e-8)
    @test isapprox(edfile.TipMass2, 0.0, atol=1e-8)
    @test isapprox(edfile.TipMass3, 0.0, atol=1e-8)
    @test isapprox(edfile.HubMass, 56780, atol=1)
    @test isapprox(edfile.HubIner, 115926, atol=1)
    @test isapprox(edfile.GenIner, 534.116, atol=1e-3)
    @test isapprox(edfile.NacMass, 240000, atol=1)
    @test isapprox(edfile.NacYIner, 2.60789E+06, atol=1e2)
    @test isapprox(edfile.YawBrMass, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmMass, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmRIner, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmPIner, 0.0, atol=1e-8)
    @test isapprox(edfile.PtfmYIner, 0.0, atol=1e-8)

    @test edfile.BldNodes==17
    @test edfile.BldFile1=="\"NREL5MWref_Blade.dat\""
    @test edfile.BldFile2=="\"NREL5MWref_Blade.dat\""
    @test edfile.BldFile3=="\"NREL5MWref_Blade.dat\""

    @test isapprox(edfile.TeetMod, 0.0, atol=1e-8)
    @test isapprox(edfile.TeetDmpP, 0.0, atol=1e-8)
    @test isapprox(edfile.TeetDmp, 0.0, atol=1e-8)
    @test isapprox(edfile.TeetCDmp, 0.0, atol=1e-8)
    @test isapprox(edfile.TeetSStP, 0.0, atol=1e-8)
    @test isapprox(edfile.TeetHStP, 0.0, atol=1e-8)
    @test isapprox(edfile.TeetSSSp, 0.0, atol=1e-8)
    @test isapprox(edfile.TeetHSSp, 0.0, atol=1e-8)

    @test isapprox(edfile.GBoxEff, 100, atol=1e-8)
    @test isapprox(edfile.GBRatio, 97, atol=1e-8)
    @test isapprox(edfile.DTTorSpr, 8.67637E+08, atol=1)
    @test isapprox(edfile.DTTorDmp, 6.215E+06, atol=1)

    @test lowercase(edfile.Furling)=="false"
    @test edfile.TwrFile=="\"NREL5MWrefED_Tower.dat\""

    @test lowercase(edfile.SumPrint)=="true"
    @test edfile.OutFile==1
    @test lowercase(edfile.TabDelim)=="true"
    @test edfile.OutFmt=="\"ES10.3E2\""
    @test isapprox(edfile.TStart, 0, atol=1e-5)
    @test isapprox(edfile.DecFact, 1, atol=1e-5)
    @test edfile.NTwGages==3
    twrgagnd = [5, 10, 15]
    @test edfile.TwrGagNd==twrgagnd
    @test edfile.NBlGages==6
    bldgagnd = [1, 4, 7, 10, 13, 16]
    @test edfile.BldGagNd==bldgagnd
    outlist = [ "RootMxb1", "RootMyb1", "RootMzb1"]
    @test edfile.Outlist==outlist

    @test edfile.BldNd_BladesOut==3
    outnd = [99]
    @test edfile.BldNd_BlOutNd==outnd 
    outlist = [ "ALx", "ALy", "ALz"]
    @test edfile.NodeOutlist==outlist

    end #End testing write ED file

    @testset "read ED Blade" begin
    file = "NREL5MWref_Blade.dat"
    path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine"
    edblade = of.ReadEDBlade(file, path)

    @test edblade.NBlInpSt==49
    @test isapprox(edblade.BldFlDmp1, 0.477465, atol=1e-8)
    @test isapprox(edblade.BldFlDmp2, 0.477465, atol=1e-8)
    @test isapprox(edblade.BldEdDmp1, 0.477465, atol=1e-8)

    @test isapprox(edblade.FlStTunr1, 1, atol=1e-8)
    @test isapprox(edblade.FlStTunr2, 1, atol=1e-8)
    @test isapprox(edblade.AdjBlMs, 1.057344, atol=1e-8)
    @test isapprox(edblade.AdjFlSt, 1, atol=1e-8)
    @test isapprox(edblade.AdjEdSt, 1, atol=1e-8)

    bldprops = [
        0.0000000E+00  2.5000000E-01  1.3308000E+01  6.7893500E+02  1.8110000E+10  1.8113600E+10
3.2500000E-03  2.5000000E-01  1.3308000E+01  6.7893500E+02  1.8110000E+10  1.8113600E+10
1.9510000E-02  2.5049000E-01  1.3308000E+01  7.7336300E+02  1.9424900E+10  1.9558600E+10
3.5770000E-02  2.5490000E-01  1.3308000E+01  7.4055000E+02  1.7455900E+10  1.9497800E+10
5.2030000E-02  2.6716000E-01  1.3308000E+01  7.4004200E+02  1.5287400E+10  1.9788800E+10
6.8290000E-02  2.7941000E-01  1.3308000E+01  5.9249600E+02  1.0782400E+10  1.4858500E+10
8.4550000E-02  2.9167000E-01  1.3308000E+01  4.5027500E+02  7.2297200E+09  1.0220600E+10
1.0081000E-01  3.0392000E-01  1.3308000E+01  4.2405400E+02  6.3095400E+09  9.1447000E+09
1.1707000E-01  3.1618000E-01  1.3308000E+01  4.0063800E+02  5.5283600E+09  8.0631600E+09
1.3335000E-01  3.2844000E-01  1.3308000E+01  3.8206200E+02  4.9800600E+09  6.8844400E+09
1.4959000E-01  3.4069000E-01  1.3308000E+01  3.9965500E+02  4.9368400E+09  7.0091800E+09
1.6585000E-01  3.5294000E-01  1.3308000E+01  4.2632100E+02  4.6916600E+09  7.1676800E+09
1.8211000E-01  3.6519000E-01  1.3181000E+01  4.1682000E+02  3.9494600E+09  7.2716600E+09
1.9837000E-01  3.7500000E-01  1.2848000E+01  4.0618600E+02  3.3865200E+09  7.0817000E+09
2.1465000E-01  3.7500000E-01  1.2192000E+01  3.8142000E+02  2.9337400E+09  6.2445300E+09
2.3089000E-01  3.7500000E-01  1.1561000E+01  3.5282200E+02  2.5689600E+09  5.0489600E+09
2.4715000E-01  3.7500000E-01  1.1072000E+01  3.4947700E+02  2.3886500E+09  4.9484900E+09
2.6341000E-01  3.7500000E-01  1.0792000E+01  3.4653800E+02  2.2719900E+09  4.8080200E+09
2.9595000E-01  3.7500000E-01  1.0232000E+01  3.3933300E+02  2.0500500E+09  4.5014000E+09
3.2846000E-01  3.7500000E-01  9.6720000E+00  3.3000400E+02  1.8282500E+09  4.2440700E+09
3.6098000E-01  3.7500000E-01  9.1100000E+00  3.2199000E+02  1.5887100E+09  3.9952800E+09
3.9350000E-01  3.7500000E-01  8.5340000E+00  3.1382000E+02  1.3619300E+09  3.7507600E+09
4.2602000E-01  3.7500000E-01  7.9320000E+00  2.9473400E+02  1.1023800E+09  3.4471400E+09
4.5855000E-01  3.7500000E-01  7.3210000E+00  2.8712000E+02  8.7580000E+08  3.1390700E+09
4.9106000E-01  3.7500000E-01  6.7110000E+00  2.6334300E+02  6.8130000E+08  2.7342400E+09
5.2358000E-01  3.7500000E-01  6.1220000E+00  2.5320700E+02  5.3472000E+08  2.5548700E+09
5.5610000E-01  3.7500000E-01  5.5460000E+00  2.4166600E+02  4.0890000E+08  2.3340300E+09
5.8862000E-01  3.7500000E-01  4.9710000E+00  2.2063800E+02  3.1454000E+08  1.8287300E+09
6.2115000E-01  3.7500000E-01  4.4010000E+00  2.0029300E+02  2.3863000E+08  1.5841000E+09
6.5366000E-01  3.7500000E-01  3.8340000E+00  1.7940400E+02  1.7588000E+08  1.3233600E+09
6.8618000E-01  3.7500000E-01  3.3320000E+00  1.6509400E+02  1.2601000E+08  1.1836800E+09
7.1870000E-01  3.7500000E-01  2.8900000E+00  1.5441100E+02  1.0726000E+08  1.0201600E+09
7.5122000E-01  3.7500000E-01  2.5030000E+00  1.3893500E+02  9.0880000E+07  7.9781000E+08
7.8376000E-01  3.7500000E-01  2.1160000E+00  1.2955500E+02  7.6310000E+07  7.0961000E+08
8.1626000E-01  3.7500000E-01  1.7300000E+00  1.0726400E+02  6.1050000E+07  5.1819000E+08
8.4878000E-01  3.7500000E-01  1.3420000E+00  9.8776000E+01  4.9480000E+07  4.5487000E+08
8.8130000E-01  3.7500000E-01  9.5400000E-01  9.0248000E+01  3.9360000E+07  3.9512000E+08
8.9756000E-01  3.7500000E-01  7.6000000E-01  8.3001000E+01  3.4670000E+07  3.5372000E+08
9.1382000E-01  3.7500000E-01  5.7400000E-01  7.2906000E+01  3.0410000E+07  3.0473000E+08
9.3008000E-01  3.7500000E-01  4.0400000E-01  6.8772000E+01  2.6520000E+07  2.8142000E+08
9.3821000E-01  3.7500000E-01  3.1900000E-01  6.6264000E+01  2.3840000E+07  2.6171000E+08
9.4636000E-01  3.7500000E-01  2.5300000E-01  5.9340000E+01  1.9630000E+07  1.5881000E+08
9.5447000E-01  3.7500000E-01  2.1600000E-01  5.5914000E+01  1.6000000E+07  1.3788000E+08
9.6260000E-01  3.7500000E-01  1.7800000E-01  5.2484000E+01  1.2830000E+07  1.1879000E+08
9.7073000E-01  3.7500000E-01  1.4000000E-01  4.9114000E+01  1.0080000E+07  1.0163000E+08
9.7886000E-01  3.7500000E-01  1.0100000E-01  4.5818000E+01  7.5500000E+06  8.5070000E+07
9.8699000E-01  3.7500000E-01  6.2000000E-02  4.1669000E+01  4.6000000E+06  6.4260000E+07
9.9512000E-01  3.7500000E-01  2.3000000E-02  1.1453000E+01  2.5000000E+05  6.6100000E+06
1.0000000E+00  3.7500000E-01  0.0000000E+00  1.0319000E+01  1.7000000E+05  5.0100000E+06
    ]
    @test isapprox(edblade.BldProps, bldprops, atol=1e-8)

    @test isapprox(edblade.BldFl1Sh2, 0.0622, atol=1e-8)
    @test isapprox(edblade.BldFl1Sh3, 1.7254, atol=1e-8)
    @test isapprox(edblade.BldFl1Sh4, -3.2452, atol=1e-8)
    @test isapprox(edblade.BldFl1Sh5, 4.7131, atol=1e-8)
    @test isapprox(edblade.BldFl1Sh6, -2.2555, atol=1e-8)
    @test isapprox(edblade.BldFl2Sh2, -0.5809, atol=1e-8)
    @test isapprox(edblade.BldFl2Sh3, 1.2067, atol=1e-8)
    @test isapprox(edblade.BldFl2Sh4, -15.5349, atol=1e-8)
    @test isapprox(edblade.BldFl2Sh5, 29.7347, atol=1e-8)
    @test isapprox(edblade.BldFl2Sh6, -13.8255, atol=1e-8)
    @test isapprox(edblade.BldEdgSh2, 0.3627, atol=1e-8)
    @test isapprox(edblade.BldEdgSh3, 2.5337, atol=1e-8)
    @test isapprox(edblade.BldEdgSh4, -3.5772, atol=1e-8)
    @test isapprox(edblade.BldEdgSh5, 2.376, atol=1e-8)
    @test isapprox(edblade.BldEdgSh6, -0.6952, atol=1e-8)

    end #end testing read ed blade

    @testset "Write EDBlade" begin
    file = "NREL5MWref_Blade.dat"
    path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine"
    edbladetemp = of.ReadEDBlade(file, path)
    of.WriteEDBlade(edbladetemp, "testingedblade.dat")
    edblade = of.ReadEDBlade("testingedblade.dat", path)

    @test edblade.NBlInpSt==49
    @test isapprox(edblade.BldFlDmp1, 0.477465, atol=1e-8)
    @test isapprox(edblade.BldFlDmp2, 0.477465, atol=1e-8)
    @test isapprox(edblade.BldEdDmp1, 0.477465, atol=1e-8)

    @test isapprox(edblade.FlStTunr1, 1, atol=1e-8)
    @test isapprox(edblade.FlStTunr2, 1, atol=1e-8)
    @test isapprox(edblade.AdjBlMs, 1.057344, atol=1e-8)
    @test isapprox(edblade.AdjFlSt, 1, atol=1e-8)
    @test isapprox(edblade.AdjEdSt, 1, atol=1e-8)

    bldprops = [
        0.0000000E+00  2.5000000E-01  1.3308000E+01  6.7893500E+02  1.8110000E+10  1.8113600E+10
3.2500000E-03  2.5000000E-01  1.3308000E+01  6.7893500E+02  1.8110000E+10  1.8113600E+10
1.9510000E-02  2.5049000E-01  1.3308000E+01  7.7336300E+02  1.9424900E+10  1.9558600E+10
3.5770000E-02  2.5490000E-01  1.3308000E+01  7.4055000E+02  1.7455900E+10  1.9497800E+10
5.2030000E-02  2.6716000E-01  1.3308000E+01  7.4004200E+02  1.5287400E+10  1.9788800E+10
6.8290000E-02  2.7941000E-01  1.3308000E+01  5.9249600E+02  1.0782400E+10  1.4858500E+10
8.4550000E-02  2.9167000E-01  1.3308000E+01  4.5027500E+02  7.2297200E+09  1.0220600E+10
1.0081000E-01  3.0392000E-01  1.3308000E+01  4.2405400E+02  6.3095400E+09  9.1447000E+09
1.1707000E-01  3.1618000E-01  1.3308000E+01  4.0063800E+02  5.5283600E+09  8.0631600E+09
1.3335000E-01  3.2844000E-01  1.3308000E+01  3.8206200E+02  4.9800600E+09  6.8844400E+09
1.4959000E-01  3.4069000E-01  1.3308000E+01  3.9965500E+02  4.9368400E+09  7.0091800E+09
1.6585000E-01  3.5294000E-01  1.3308000E+01  4.2632100E+02  4.6916600E+09  7.1676800E+09
1.8211000E-01  3.6519000E-01  1.3181000E+01  4.1682000E+02  3.9494600E+09  7.2716600E+09
1.9837000E-01  3.7500000E-01  1.2848000E+01  4.0618600E+02  3.3865200E+09  7.0817000E+09
2.1465000E-01  3.7500000E-01  1.2192000E+01  3.8142000E+02  2.9337400E+09  6.2445300E+09
2.3089000E-01  3.7500000E-01  1.1561000E+01  3.5282200E+02  2.5689600E+09  5.0489600E+09
2.4715000E-01  3.7500000E-01  1.1072000E+01  3.4947700E+02  2.3886500E+09  4.9484900E+09
2.6341000E-01  3.7500000E-01  1.0792000E+01  3.4653800E+02  2.2719900E+09  4.8080200E+09
2.9595000E-01  3.7500000E-01  1.0232000E+01  3.3933300E+02  2.0500500E+09  4.5014000E+09
3.2846000E-01  3.7500000E-01  9.6720000E+00  3.3000400E+02  1.8282500E+09  4.2440700E+09
3.6098000E-01  3.7500000E-01  9.1100000E+00  3.2199000E+02  1.5887100E+09  3.9952800E+09
3.9350000E-01  3.7500000E-01  8.5340000E+00  3.1382000E+02  1.3619300E+09  3.7507600E+09
4.2602000E-01  3.7500000E-01  7.9320000E+00  2.9473400E+02  1.1023800E+09  3.4471400E+09
4.5855000E-01  3.7500000E-01  7.3210000E+00  2.8712000E+02  8.7580000E+08  3.1390700E+09
4.9106000E-01  3.7500000E-01  6.7110000E+00  2.6334300E+02  6.8130000E+08  2.7342400E+09
5.2358000E-01  3.7500000E-01  6.1220000E+00  2.5320700E+02  5.3472000E+08  2.5548700E+09
5.5610000E-01  3.7500000E-01  5.5460000E+00  2.4166600E+02  4.0890000E+08  2.3340300E+09
5.8862000E-01  3.7500000E-01  4.9710000E+00  2.2063800E+02  3.1454000E+08  1.8287300E+09
6.2115000E-01  3.7500000E-01  4.4010000E+00  2.0029300E+02  2.3863000E+08  1.5841000E+09
6.5366000E-01  3.7500000E-01  3.8340000E+00  1.7940400E+02  1.7588000E+08  1.3233600E+09
6.8618000E-01  3.7500000E-01  3.3320000E+00  1.6509400E+02  1.2601000E+08  1.1836800E+09
7.1870000E-01  3.7500000E-01  2.8900000E+00  1.5441100E+02  1.0726000E+08  1.0201600E+09
7.5122000E-01  3.7500000E-01  2.5030000E+00  1.3893500E+02  9.0880000E+07  7.9781000E+08
7.8376000E-01  3.7500000E-01  2.1160000E+00  1.2955500E+02  7.6310000E+07  7.0961000E+08
8.1626000E-01  3.7500000E-01  1.7300000E+00  1.0726400E+02  6.1050000E+07  5.1819000E+08
8.4878000E-01  3.7500000E-01  1.3420000E+00  9.8776000E+01  4.9480000E+07  4.5487000E+08
8.8130000E-01  3.7500000E-01  9.5400000E-01  9.0248000E+01  3.9360000E+07  3.9512000E+08
8.9756000E-01  3.7500000E-01  7.6000000E-01  8.3001000E+01  3.4670000E+07  3.5372000E+08
9.1382000E-01  3.7500000E-01  5.7400000E-01  7.2906000E+01  3.0410000E+07  3.0473000E+08
9.3008000E-01  3.7500000E-01  4.0400000E-01  6.8772000E+01  2.6520000E+07  2.8142000E+08
9.3821000E-01  3.7500000E-01  3.1900000E-01  6.6264000E+01  2.3840000E+07  2.6171000E+08
9.4636000E-01  3.7500000E-01  2.5300000E-01  5.9340000E+01  1.9630000E+07  1.5881000E+08
9.5447000E-01  3.7500000E-01  2.1600000E-01  5.5914000E+01  1.6000000E+07  1.3788000E+08
9.6260000E-01  3.7500000E-01  1.7800000E-01  5.2484000E+01  1.2830000E+07  1.1879000E+08
9.7073000E-01  3.7500000E-01  1.4000000E-01  4.9114000E+01  1.0080000E+07  1.0163000E+08
9.7886000E-01  3.7500000E-01  1.0100000E-01  4.5818000E+01  7.5500000E+06  8.5070000E+07
9.8699000E-01  3.7500000E-01  6.2000000E-02  4.1669000E+01  4.6000000E+06  6.4260000E+07
9.9512000E-01  3.7500000E-01  2.3000000E-02  1.1453000E+01  2.5000000E+05  6.6100000E+06
1.0000000E+00  3.7500000E-01  0.0000000E+00  1.0319000E+01  1.7000000E+05  5.0100000E+06
    ]
    @test isapprox(edblade.BldProps, bldprops, atol=1e-8)

    @test isapprox(edblade.BldFl1Sh2, 0.0622, atol=1e-8)
    @test isapprox(edblade.BldFl1Sh3, 1.7254, atol=1e-8)
    @test isapprox(edblade.BldFl1Sh4, -3.2452, atol=1e-8)
    @test isapprox(edblade.BldFl1Sh5, 4.7131, atol=1e-8)
    @test isapprox(edblade.BldFl1Sh6, -2.2555, atol=1e-8)
    @test isapprox(edblade.BldFl2Sh2, -0.5809, atol=1e-8)
    @test isapprox(edblade.BldFl2Sh3, 1.2067, atol=1e-8)
    @test isapprox(edblade.BldFl2Sh4, -15.5349, atol=1e-8)
    @test isapprox(edblade.BldFl2Sh5, 29.7347, atol=1e-8)
    @test isapprox(edblade.BldFl2Sh6, -13.8255, atol=1e-8)
    @test isapprox(edblade.BldEdgSh2, 0.3627, atol=1e-8)
    @test isapprox(edblade.BldEdgSh3, 2.5337, atol=1e-8)
    @test isapprox(edblade.BldEdgSh4, -3.5772, atol=1e-8)
    @test isapprox(edblade.BldEdgSh5, 2.376, atol=1e-8)
    @test isapprox(edblade.BldEdgSh6, -0.6952, atol=1e-8)

    end


end #End testing ElastoDyn