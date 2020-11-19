
@testset "BeamDyn" begin
    @testset "Read BeamDyn File" begin
    file = "NREL5MWrefBD.dat"
    path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine"
    bdfile = of.ReadBDFile(file, path)

    @test lowercase(bdfile.Echo)=="false"
    @test lowercase(bdfile.QuasiStaticInit)=="true"
    @test isapprox(bdfile.rhoinf, 0, atol=1e-5)
    @test bdfile.quadrature==2
    @test lowercase(bdfile.refine)=="\"default\"" #TODO: All of these next things need to be reevaluated, because they could be default or a value. I need something that is either or. Maybe I'll change the reader to change it to a 0 or something, maybe infinity to model default. 
    @test lowercase(bdfile.n_fract)=="\"default\""
    @test lowercase(bdfile.DTBeam)=="\"default\""
    @test lowercase(bdfile.load_retries)=="\"default\""
    @test lowercase(bdfile.NRMax)=="\"default\""
    @test lowercase(bdfile.stop_tol)=="\"default\""
    @test lowercase(bdfile.tngt_stf_fd)=="\"default\""
    @test lowercase(bdfile.tngt_stf_comp)=="\"default\""
    @test lowercase(bdfile.tngt_stf_pert)=="\"default\""
    @test lowercase(bdfile.tngt_stf_difftol)=="\"default\""
    @test lowercase(bdfile.RotStates)=="true"
    @test bdfile.member_total==1
    @test bdfile.kp_total==49
    @test bdfile.membernumber==[(1,49)]
    geoparams = [
        0.0000000E+00  0.0000000E+00  0.0000000E+00  1.3308000E+01
0.0000000E+00  0.0000000E+00  1.9987500E-01  1.3308000E+01
0.0000000E+00  0.0000000E+00  1.1998650E+00  1.3308000E+01
0.0000000E+00  0.0000000E+00  2.1998550E+00  1.3308000E+01
0.0000000E+00  0.0000000E+00  3.1998450E+00  1.3308000E+01
0.0000000E+00  0.0000000E+00  4.1998350E+00  1.3308000E+01
0.0000000E+00  0.0000000E+00  5.1998250E+00  1.3308000E+01
0.0000000E+00  0.0000000E+00  6.1998150E+00  1.3308000E+01
0.0000000E+00  0.0000000E+00  7.1998050E+00  1.3308000E+01
0.0000000E+00  0.0000000E+00  8.2010250E+00  1.3308000E+01
0.0000000E+00  0.0000000E+00  9.1997850E+00  1.3308000E+01
0.0000000E+00  0.0000000E+00  1.0199775E+01  1.3308000E+01
0.0000000E+00  0.0000000E+00  1.1199765E+01  1.3181000E+01
0.0000000E+00  0.0000000E+00  1.2199755E+01  1.2848000E+01
0.0000000E+00  0.0000000E+00  1.3200975E+01  1.2192000E+01
0.0000000E+00  0.0000000E+00  1.4199735E+01  1.1561000E+01
0.0000000E+00  0.0000000E+00  1.5199725E+01  1.1072000E+01
0.0000000E+00  0.0000000E+00  1.6199715E+01  1.0792000E+01
0.0000000E+00  0.0000000E+00  1.8200925E+01  1.0232000E+01
0.0000000E+00  0.0000000E+00  2.0200290E+01  9.6720000E+00
0.0000000E+00  0.0000000E+00  2.2200270E+01  9.1100000E+00
0.0000000E+00  0.0000000E+00  2.4200250E+01  8.5340000E+00
0.0000000E+00  0.0000000E+00  2.6200230E+01  7.9320000E+00
0.0000000E+00  0.0000000E+00  2.8200825E+01  7.3210000E+00
0.0000000E+00  0.0000000E+00  3.0200190E+01  6.7110000E+00
0.0000000E+00  0.0000000E+00  3.2200170E+01  6.1220000E+00
0.0000000E+00  0.0000000E+00  3.4200150E+01  5.5460000E+00
0.0000000E+00  0.0000000E+00  3.6200130E+01  4.9710000E+00
0.0000000E+00  0.0000000E+00  3.8200725E+01  4.4010000E+00
0.0000000E+00  0.0000000E+00  4.0200090E+01  3.8340000E+00
0.0000000E+00  0.0000000E+00  4.2200070E+01  3.3320000E+00
0.0000000E+00  0.0000000E+00  4.4200050E+01  2.8900000E+00
0.0000000E+00  0.0000000E+00  4.6200030E+01  2.5030000E+00
0.0000000E+00  0.0000000E+00  4.8201240E+01  2.1160000E+00
0.0000000E+00  0.0000000E+00  5.0199990E+01  1.7300000E+00
0.0000000E+00  0.0000000E+00  5.2199970E+01  1.3420000E+00
0.0000000E+00  0.0000000E+00  5.4199950E+01  9.5400000E-01
0.0000000E+00  0.0000000E+00  5.5199940E+01  7.6000000E-01
0.0000000E+00  0.0000000E+00  5.6199930E+01  5.7400000E-01
0.0000000E+00  0.0000000E+00  5.7199920E+01  4.0400000E-01
0.0000000E+00  0.0000000E+00  5.7699915E+01  3.1900000E-01
0.0000000E+00  0.0000000E+00  5.8201140E+01  2.5300000E-01
0.0000000E+00  0.0000000E+00  5.8699905E+01  2.1600000E-01
0.0000000E+00  0.0000000E+00  5.9199900E+01  1.7800000E-01
0.0000000E+00  0.0000000E+00  5.9699895E+01  1.4000000E-01
0.0000000E+00  0.0000000E+00  6.0199890E+01  1.0100000E-01
0.0000000E+00  0.0000000E+00  6.0699885E+01  6.2000000E-02
0.0000000E+00  0.0000000E+00  6.1199880E+01  2.3000000E-02
0.0000000E+00  0.0000000E+00  6.1500000E+01  0.0000000E+00
    ]
    @test isapprox(bdfile.geoparams, geoparams, atol=1e-5 )
    @test bdfile.order_elem == 5
    @test bdfile.BldFile == "NREL5MWrefBD_Blade.dat"
    @test lowercase(bdfile.UsePitchAct)=="false"
    @test isapprox(bdfile.PitchJ, 200, atol=1e-5)
    @test isapprox(bdfile.PitchK, 2e7, atol=1)
    @test isapprox(bdfile.PitchC, 500000, atol=1)
    @test lowercase(bdfile.SumPrint)=="true"
    @test bdfile.OutFmt=="\"ES10.3E2\""
    @test bdfile.NNodeOuts==0
    @test bdfile.OutNd==[1, 2, 3, 4, 5, 6]
    outlist = [
        "RootFxr, RootFyr, RootFzr"
"RootMxr, RootMyr, RootMzr"
"TipTDxr, TipTDyr, TipTDzr"
"TipRDxr, TipRDyr, TipRDzr"
    ]
    @test bdfile.Outlist==outlist
    outlist = ["FxL", "FyL", "FzL"]
    @test bdfile.NodeOutlist==outlist
    end #End testing read BeamDyn File

    @testset "Write BeamDyn File" begin
    file = "NREL5MWrefBD.dat"
    path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine"
    bdfiletemp = of.ReadBDFile(file, path)
    of.WriteBDFile(bdfiletemp, "testingbdfile.dat")
    bdfile = of.ReadBDFile("testingbdfile.dat", path)

    @test lowercase(bdfile.Echo)=="false"
    @test lowercase(bdfile.QuasiStaticInit)=="true"
    @test isapprox(bdfile.rhoinf, 0, atol=1e-5)
    @test bdfile.quadrature==2
    @test lowercase(bdfile.refine)=="\"default\"" #TODO: All of these next things need to be reevaluated, because they could be default or a value. I need something that is either or. Maybe I'll change the reader to change it to a 0 or something, maybe infinity to model default. 
    @test lowercase(bdfile.n_fract)=="\"default\""
    @test lowercase(bdfile.DTBeam)=="\"default\""
    @test lowercase(bdfile.load_retries)=="\"default\""
    @test lowercase(bdfile.NRMax)=="\"default\""
    @test lowercase(bdfile.stop_tol)=="\"default\""
    @test lowercase(bdfile.tngt_stf_fd)=="\"default\""
    @test lowercase(bdfile.tngt_stf_comp)=="\"default\""
    @test lowercase(bdfile.tngt_stf_pert)=="\"default\""
    @test lowercase(bdfile.tngt_stf_difftol)=="\"default\""
    @test lowercase(bdfile.RotStates)=="true"
    @test bdfile.member_total==1
    @test bdfile.kp_total==49
    @test bdfile.membernumber==[(1,49)]
    geoparams = [
        0.0000000E+00  0.0000000E+00  0.0000000E+00  1.3308000E+01
0.0000000E+00  0.0000000E+00  1.9987500E-01  1.3308000E+01
0.0000000E+00  0.0000000E+00  1.1998650E+00  1.3308000E+01
0.0000000E+00  0.0000000E+00  2.1998550E+00  1.3308000E+01
0.0000000E+00  0.0000000E+00  3.1998450E+00  1.3308000E+01
0.0000000E+00  0.0000000E+00  4.1998350E+00  1.3308000E+01
0.0000000E+00  0.0000000E+00  5.1998250E+00  1.3308000E+01
0.0000000E+00  0.0000000E+00  6.1998150E+00  1.3308000E+01
0.0000000E+00  0.0000000E+00  7.1998050E+00  1.3308000E+01
0.0000000E+00  0.0000000E+00  8.2010250E+00  1.3308000E+01
0.0000000E+00  0.0000000E+00  9.1997850E+00  1.3308000E+01
0.0000000E+00  0.0000000E+00  1.0199775E+01  1.3308000E+01
0.0000000E+00  0.0000000E+00  1.1199765E+01  1.3181000E+01
0.0000000E+00  0.0000000E+00  1.2199755E+01  1.2848000E+01
0.0000000E+00  0.0000000E+00  1.3200975E+01  1.2192000E+01
0.0000000E+00  0.0000000E+00  1.4199735E+01  1.1561000E+01
0.0000000E+00  0.0000000E+00  1.5199725E+01  1.1072000E+01
0.0000000E+00  0.0000000E+00  1.6199715E+01  1.0792000E+01
0.0000000E+00  0.0000000E+00  1.8200925E+01  1.0232000E+01
0.0000000E+00  0.0000000E+00  2.0200290E+01  9.6720000E+00
0.0000000E+00  0.0000000E+00  2.2200270E+01  9.1100000E+00
0.0000000E+00  0.0000000E+00  2.4200250E+01  8.5340000E+00
0.0000000E+00  0.0000000E+00  2.6200230E+01  7.9320000E+00
0.0000000E+00  0.0000000E+00  2.8200825E+01  7.3210000E+00
0.0000000E+00  0.0000000E+00  3.0200190E+01  6.7110000E+00
0.0000000E+00  0.0000000E+00  3.2200170E+01  6.1220000E+00
0.0000000E+00  0.0000000E+00  3.4200150E+01  5.5460000E+00
0.0000000E+00  0.0000000E+00  3.6200130E+01  4.9710000E+00
0.0000000E+00  0.0000000E+00  3.8200725E+01  4.4010000E+00
0.0000000E+00  0.0000000E+00  4.0200090E+01  3.8340000E+00
0.0000000E+00  0.0000000E+00  4.2200070E+01  3.3320000E+00
0.0000000E+00  0.0000000E+00  4.4200050E+01  2.8900000E+00
0.0000000E+00  0.0000000E+00  4.6200030E+01  2.5030000E+00
0.0000000E+00  0.0000000E+00  4.8201240E+01  2.1160000E+00
0.0000000E+00  0.0000000E+00  5.0199990E+01  1.7300000E+00
0.0000000E+00  0.0000000E+00  5.2199970E+01  1.3420000E+00
0.0000000E+00  0.0000000E+00  5.4199950E+01  9.5400000E-01
0.0000000E+00  0.0000000E+00  5.5199940E+01  7.6000000E-01
0.0000000E+00  0.0000000E+00  5.6199930E+01  5.7400000E-01
0.0000000E+00  0.0000000E+00  5.7199920E+01  4.0400000E-01
0.0000000E+00  0.0000000E+00  5.7699915E+01  3.1900000E-01
0.0000000E+00  0.0000000E+00  5.8201140E+01  2.5300000E-01
0.0000000E+00  0.0000000E+00  5.8699905E+01  2.1600000E-01
0.0000000E+00  0.0000000E+00  5.9199900E+01  1.7800000E-01
0.0000000E+00  0.0000000E+00  5.9699895E+01  1.4000000E-01
0.0000000E+00  0.0000000E+00  6.0199890E+01  1.0100000E-01
0.0000000E+00  0.0000000E+00  6.0699885E+01  6.2000000E-02
0.0000000E+00  0.0000000E+00  6.1199880E+01  2.3000000E-02
0.0000000E+00  0.0000000E+00  6.1500000E+01  0.0000000E+00
    ]
    @test isapprox(bdfile.geoparams, geoparams, atol=1e-5 )
    @test bdfile.order_elem == 5
    @test bdfile.BldFile == "NREL5MWrefBD_Blade.dat"
    @test lowercase(bdfile.UsePitchAct)=="false"
    @test isapprox(bdfile.PitchJ, 200, atol=1e-5)
    @test isapprox(bdfile.PitchK, 2e7, atol=1)
    @test isapprox(bdfile.PitchC, 500000, atol=1)
    @test lowercase(bdfile.SumPrint)=="true"
    @test bdfile.OutFmt=="\"ES10.3E2\""
    @test bdfile.NNodeOuts==0
    @test bdfile.OutNd==[1, 2, 3, 4, 5, 6]
    outlist = [
        "RootFxr, RootFyr, RootFzr"
"RootMxr, RootMyr, RootMzr"
"TipTDxr, TipTDyr, TipTDzr"
"TipRDxr, TipRDyr, TipRDzr"
    ]
    @test bdfile.Outlist==outlist
    outlist = ["FxL", "FyL", "FzL"]
    @test bdfile.NodeOutlist==outlist
    end #End testing write BeamDyn File

    @testset "Read BD Blade" begin
    file = "NREL5MWrefBD_Blade.dat"
    path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine"
    bdblade = of.ReadBDBlade(file, path)

    @test bdblade.station_total==49
    @test bdblade.damp_type==1
    dampcoefs = [1.0E-03, 1.0E-03, 1.0E-03, 1.0E-03, 1.0E-03, 1.0E-03]
    @test bdblade.dampcoef==dampcoefs
    frac = [0, 0.003250,  0.019510]
    stiffmat = zeros(6,6,3) # I am not going to test all of the matrices in the blade file. That's just ridiculous. 
    massmat = zeros(6,6,3)
    stiffmat[:,:,1] = [
        9.729480E+08    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
        0.000000E+00    9.729480E+08    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
        0.000000E+00    0.000000E+00    9.729480E+09    0.000000E+00    0.000000E+00    0.000000E+00
        0.000000E+00    0.000000E+00    0.000000E+00    1.811360E+10    0.000000E+00    0.000000E+00
        0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    1.811000E+10    0.000000E+00
        0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    5.564400E+09
    ]
    stiffmat[:,:,2] = [
        9.729480E+08    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00    9.729480E+08    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00    0.000000E+00    9.729480E+09    0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00    0.000000E+00    0.000000E+00    1.811360E+10    0.000000E+00    0.000000E+00
   0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    1.811000E+10    0.000000E+00
   0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    5.564400E+09
    ]
    stiffmat[:,:,3] = [
        1.078950E+09    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00    1.078950E+09    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00    0.000000E+00    1.078950E+10    0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00    0.000000E+00    0.000000E+00    1.955860E+10    0.000000E+00    0.000000E+00
   0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    1.942490E+10    0.000000E+00
   0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    5.431590E+09
    ]
    massmat[:,:,1] = [
        6.789350E+02    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00    6.789350E+02    0.000000E+00   -0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00    0.000000E+00    6.789350E+02    0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00   -0.000000E+00    0.000000E+00    9.730400E+02    0.000000E+00    0.000000E+00
   0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    9.728600E+02    0.000000E+00
   0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    1.945900E+03
    ]
    massmat[:,:,2] = [
        6.789350E+02    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00    6.789350E+02    0.000000E+00   -0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00    0.000000E+00    6.789350E+02    0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00   -0.000000E+00    0.000000E+00    9.730400E+02    0.000000E+00    0.000000E+00
   0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    9.728600E+02    0.000000E+00
   0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    1.945900E+03
    ]
    massmat[:,:,3] = [
        7.733630E+02    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00    7.733630E+02    0.000000E+00   -0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00    0.000000E+00    7.733630E+02    0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00   -0.000000E+00    0.000000E+00    1.066380E+03    0.000000E+00    0.000000E+00
   0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    1.091520E+03    0.000000E+00
   0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    2.157900E+03
    ]
    for i = 1:3
        @test isapprox(bdblade.nodes[i].frac,frac[i],atol=1e-8)
        @test isapprox(bdblade.nodes[i].massmatrix, massmat[:,:,i],atol=1)
        @test isapprox(bdblade.nodes[i].stiffmatrix, stiffmat[:,:,i], atol=1)
    end

    end #End testing read bd blade

    @testset "Write BD Blade" begin
    file = "NREL5MWrefBD_Blade.dat"
    path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine"
    bdbladetemp = of.ReadBDBlade(file, path)
    of.WriteBDBlade(bdbladetemp, "testingbdblade.dat")
    bdblade = of.ReadBDBlade("testingbdblade.dat", path)

    @test bdblade.station_total==49
    @test bdblade.damp_type==1
    dampcoefs = [1.0E-03, 1.0E-03, 1.0E-03, 1.0E-03, 1.0E-03, 1.0E-03]
    @test bdblade.dampcoef==dampcoefs
    frac = [0, 0.003250,  0.019510]
    stiffmat = zeros(6,6,3) # I am not going to test all of the matrices in the blade file. That's just ridiculous. 
    massmat = zeros(6,6,3)
    stiffmat[:,:,1] = [
        9.729480E+08    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
        0.000000E+00    9.729480E+08    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
        0.000000E+00    0.000000E+00    9.729480E+09    0.000000E+00    0.000000E+00    0.000000E+00
        0.000000E+00    0.000000E+00    0.000000E+00    1.811360E+10    0.000000E+00    0.000000E+00
        0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    1.811000E+10    0.000000E+00
        0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    5.564400E+09
    ]
    stiffmat[:,:,2] = [
        9.729480E+08    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00    9.729480E+08    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00    0.000000E+00    9.729480E+09    0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00    0.000000E+00    0.000000E+00    1.811360E+10    0.000000E+00    0.000000E+00
   0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    1.811000E+10    0.000000E+00
   0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    5.564400E+09
    ]
    stiffmat[:,:,3] = [
        1.078950E+09    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00    1.078950E+09    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00    0.000000E+00    1.078950E+10    0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00    0.000000E+00    0.000000E+00    1.955860E+10    0.000000E+00    0.000000E+00
   0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    1.942490E+10    0.000000E+00
   0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    5.431590E+09
    ]
    massmat[:,:,1] = [
        6.789350E+02    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00    6.789350E+02    0.000000E+00   -0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00    0.000000E+00    6.789350E+02    0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00   -0.000000E+00    0.000000E+00    9.730400E+02    0.000000E+00    0.000000E+00
   0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    9.728600E+02    0.000000E+00
   0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    1.945900E+03
    ]
    massmat[:,:,2] = [
        6.789350E+02    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00    6.789350E+02    0.000000E+00   -0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00    0.000000E+00    6.789350E+02    0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00   -0.000000E+00    0.000000E+00    9.730400E+02    0.000000E+00    0.000000E+00
   0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    9.728600E+02    0.000000E+00
   0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    1.945900E+03
    ]
    massmat[:,:,3] = [
        7.733630E+02    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00    7.733630E+02    0.000000E+00   -0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00    0.000000E+00    7.733630E+02    0.000000E+00    0.000000E+00    0.000000E+00
   0.000000E+00   -0.000000E+00    0.000000E+00    1.066380E+03    0.000000E+00    0.000000E+00
   0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    1.091520E+03    0.000000E+00
   0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    2.157900E+03
    ]
    for i = 1:3
        @test isapprox(bdblade.nodes[i].frac,frac[i],atol=1e-8)
        @test isapprox(bdblade.nodes[i].massmatrix, massmat[:,:,i],atol=1)
        @test isapprox(bdblade.nodes[i].stiffmatrix, stiffmat[:,:,i], atol=1)
    end

    end #End testing write BD Blade

end # End testing BeamDyn