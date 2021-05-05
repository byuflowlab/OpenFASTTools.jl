# using OpenFASTsr
# using Test

# of = OpenFASTsr


@testset "ElastoDyn" begin
    @testset "Read ElastoDyn File" begin
        file = "NREL5MWrefED.dat"
        path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine"
        edfile = of.read_edfile(file, path)

        @test edfile.echo==false
        @test edfile.method==3
        @test isnan(edfile.dt)
        @test isapprox(edfile.gravity, 9.80665, atol=1e-8)
        @test edfile.flapdof1==true
        @test edfile.flapdof2==true
        @test edfile.edgedof==true
        @test edfile.teetdof==false
        @test edfile.drtrdof==true
        @test edfile.gendof==true
        @test edfile.yawdof==true
        @test edfile.twfadof1==true
        @test edfile.twfadof2==true
        @test edfile.twssdof1==true
        @test edfile.twssdof2==true
        @test edfile.ptfmsgdof==false
        @test edfile.ptfmswdof==false
        @test edfile.ptfmhvdof==false
        @test edfile.ptfmrdof==false
        @test edfile.ptfmpdof==false
        @test edfile.ptfmydof==false
        

        @test isapprox(edfile.oopdefl, 0.0, atol=1e-8)
        @test isapprox(edfile.ipdefl, 0.0, atol=1e-8)
        blpitchs = zeros(3)
        @test isapprox(edfile.blpitchs, blpitchs, atol=1e-8)
        @test isapprox(edfile.teetdefl, 0.0, atol=1e-8)
        @test isapprox(edfile.azimuth, 0.0, atol=1e-8)
        @test isapprox(edfile.rotspeed, 12.1, atol=1e-8)
        @test isapprox(edfile.nacyaw, 0.0, atol=1e-8)
        @test isapprox(edfile.ttdspfa, 0.0, atol=1e-8)
        @test isapprox(edfile.ttdspss, 0.0, atol=1e-8)
        @test isapprox(edfile.ptfmsurge, 0.0, atol=1e-8)
        @test isapprox(edfile.ptfmsway, 0.0, atol=1e-8)
        @test isapprox(edfile.ptfmheave, 0.0, atol=1e-8)
        @test isapprox(edfile.ptfmroll, 0.0, atol=1e-8)
        @test isapprox(edfile.ptfmpitch, 0.0, atol=1e-8)
        @test isapprox(edfile.ptfmyaw, 0.0, atol=1e-8)

        @test edfile.numbl==3
        @test isapprox(edfile.tiprad, 63, atol=1e-8)
        @test isapprox(edfile.hubrad, 1.5, atol=1e-8)
        precones = -2.5.*ones(3)
        @test isapprox(edfile.precones, precones, atol=1e-8)
        @test isapprox(edfile.hubcm, 0.0, atol=1e-8)
        @test isapprox(edfile.undsling, 0.0, atol=1e-8)
        @test isapprox(edfile.delta3, 0.0, atol=1e-8)
        @test isapprox(edfile.azimb1up, 0.0, atol=1e-8)
        @test isapprox(edfile.overhang, -5.0191, atol=1e-8)
        @test isapprox(edfile.shftgagl, 1.912, atol=1e-8)
        @test isapprox(edfile.shfttilt, -5, atol=1e-8)
        naccmxyzn = [1.9, 0.0, 1.75]
        @test isapprox(edfile.naccmxyzn, naccmxyzn, atol=1e-8)
        ncimuxyzn = [-3.09528, 0.0, 2.23336]
        @test isapprox(edfile.ncimuxyzn, ncimuxyzn, atol=1e-8)
        @test isapprox(edfile.twr2shft, 1.96256, atol=1e-8)
        @test isapprox(edfile.towerht, 87.6, atol=1e-8)
        @test isapprox(edfile.towerbsht, 0.0, atol=1e-8)
        ptfmcmxyzt = zeros(3)
        @test isapprox(edfile.ptfmcmxyzt, ptfmcmxyzt, atol=1e-8)
        @test isapprox(edfile.ptfmrefzt, 0.0, atol=1e-8)
        @test isapprox(edfile.tipmasses, zeros(3), atol=1e-8)
        @test isapprox(edfile.hubmass, 56780, atol=1)
        @test isapprox(edfile.hubiner, 115926, atol=1)
        @test isapprox(edfile.geniner, 534.116, atol=1e-3)
        @test isapprox(edfile.nacmass, 240000, atol=1)
        @test isapprox(edfile.nacyiner, 2.60789e+06, atol=1e2)
        @test isapprox(edfile.yawbrmass, 0.0, atol=1e-8)
        @test isapprox(edfile.ptfmmass, 0.0, atol=1e-8)
        @test isapprox(edfile.ptfmriner, 0.0, atol=1e-8)
        @test isapprox(edfile.ptfmpiner, 0.0, atol=1e-8)
        @test isapprox(edfile.ptfmyiner, 0.0, atol=1e-8)

        @test edfile.bldnodes==17
        bldfiles = ["NREL5MWref_Blade.dat", "NREL5MWref_Blade.dat", "NREL5MWref_Blade.dat"]
        @test edfile.bldfiles==bldfiles

        @test isapprox(edfile.teetmod, 0.0, atol=1e-8)
        @test isapprox(edfile.teetdmpp, 0.0, atol=1e-8)
        @test isapprox(edfile.teetdmp, 0.0, atol=1e-8)
        @test isapprox(edfile.teetcdmp, 0.0, atol=1e-8)
        @test isapprox(edfile.teetsstp, 0.0, atol=1e-8)
        @test isapprox(edfile.teethstp, 0.0, atol=1e-8)
        @test isapprox(edfile.teetsssp, 0.0, atol=1e-8)
        @test isapprox(edfile.teethssp, 0.0, atol=1e-8)

        @test isapprox(edfile.gboxeff, 100, atol=1e-8)
        @test isapprox(edfile.gbratio, 97, atol=1e-8)
        @test isapprox(edfile.dttorspr, 8.67637e+08, atol=1)
        @test isapprox(edfile.dttordmp, 6.215e+06, atol=1)

        @test edfile.furling==false
        @test edfile.twrfile=="NREL5MWrefED_Tower.dat"

        @test edfile.sumprint==true
        @test edfile.outfile==1
        @test edfile.tabdelim==true
        @test edfile.outfmt=="ES10.3E2"
        @test isapprox(edfile.tstart, 0, atol=1e-5)
        @test isapprox(edfile.decfact, 1, atol=1e-5)
        @test edfile.ntwgages==3
        twrgagnd = [5, 10, 15]
        @test edfile.twrgagnd==twrgagnd
        @test edfile.nblgages==6
        bldgagnd = [1, 4, 7, 10, 13, 16]
        @test edfile.bldgagnd==bldgagnd
        outlist = [ "RootMxb1", "RootMyb1", "RootMzb1"]
        @test edfile.outlist==outlist

        @test edfile.bldnd_bladesout==3
        outnd = [99]
        @test edfile.bldnd_bloutnd==outnd 
        outlist = [ "ALx", "ALy", "ALz"]
        @test edfile.nodeoutlist==outlist
    end #End testing Read ED file

    @testset "Write ElastoDyn File" begin
        file = "NREL5MWrefED.dat"
        path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine"
        edfiletemp = of.read_edfile(file, path)
        of.write_edfile(edfiletemp, "testingEDFile.dat"; outputpath=path)
        edfile = of.read_edfile("testingEDfile.dat", path)

        @test edfile.echo==false
        @test edfile.method==3
        @test isnan(edfile.dt)
        @test isapprox(edfile.gravity, 9.80665, atol=1e-8)
        @test edfile.flapdof1==true
        @test edfile.flapdof2==true
        @test edfile.edgedof==true
        @test edfile.teetdof==false
        @test edfile.drtrdof==true
        @test edfile.gendof==true
        @test edfile.yawdof==true
        @test edfile.twfadof1==true
        @test edfile.twfadof2==true
        @test edfile.twssdof1==true
        @test edfile.twssdof2==true
        @test edfile.ptfmsgdof==false
        @test edfile.ptfmswdof==false
        @test edfile.ptfmhvdof==false
        @test edfile.ptfmrdof==false
        @test edfile.ptfmpdof==false
        @test edfile.ptfmydof==false

        @test isapprox(edfile.oopdefl, 0.0, atol=1e-8)
        @test isapprox(edfile.ipdefl, 0.0, atol=1e-8)
        blpitchs = zeros(3)
        @test isapprox(edfile.blpitchs, blpitchs, atol=1e-8)
        @test isapprox(edfile.teetdefl, 0.0, atol=1e-8)
        @test isapprox(edfile.azimuth, 0.0, atol=1e-8)
        @test isapprox(edfile.rotspeed, 12.1, atol=1e-8)
        @test isapprox(edfile.nacyaw, 0.0, atol=1e-8)
        @test isapprox(edfile.ttdspfa, 0.0, atol=1e-8)
        @test isapprox(edfile.ttdspss, 0.0, atol=1e-8)
        @test isapprox(edfile.ptfmsurge, 0.0, atol=1e-8)
        @test isapprox(edfile.ptfmsway, 0.0, atol=1e-8)
        @test isapprox(edfile.ptfmheave, 0.0, atol=1e-8)
        @test isapprox(edfile.ptfmroll, 0.0, atol=1e-8)
        @test isapprox(edfile.ptfmpitch, 0.0, atol=1e-8)
        @test isapprox(edfile.ptfmyaw, 0.0, atol=1e-8)

        @test edfile.numbl==3
        @test isapprox(edfile.tiprad, 63, atol=1e-8)
        @test isapprox(edfile.hubrad, 1.5, atol=1e-8)
        precones = -2.5.*ones(3)
        @test isapprox(edfile.precones, precones, atol=1e-8)
        @test isapprox(edfile.hubcm, 0.0, atol=1e-8)
        @test isapprox(edfile.undsling, 0.0, atol=1e-8)
        @test isapprox(edfile.delta3, 0.0, atol=1e-8)
        @test isapprox(edfile.azimb1up, 0.0, atol=1e-8)
        @test isapprox(edfile.overhang, -5.0191, atol=1e-8)
        @test isapprox(edfile.shftgagl, 1.912, atol=1e-8)
        @test isapprox(edfile.shfttilt, -5, atol=1e-8)
        naccmxyzn = [1.9, 0.0, 1.75]
        @test isapprox(edfile.naccmxyzn, naccmxyzn, atol=1e-8)
        ncimuxyzn = [-3.09528, 0.0, 2.23336]
        @test isapprox(edfile.ncimuxyzn, ncimuxyzn, atol=1e-8)
        @test isapprox(edfile.twr2shft, 1.96256, atol=1e-8)
        @test isapprox(edfile.towerht, 87.6, atol=1e-8)
        @test isapprox(edfile.towerbsht, 0.0, atol=1e-8)
        ptfmcmxyzt = zeros(3)
        @test isapprox(edfile.ptfmcmxyzt, ptfmcmxyzt, atol=1e-8)
        @test isapprox(edfile.ptfmrefzt, 0.0, atol=1e-8)
        @test isapprox(edfile.tipmasses, zeros(3), atol=1e-8)
        @test isapprox(edfile.hubmass, 56780, atol=1)
        @test isapprox(edfile.hubiner, 115926, atol=1)
        @test isapprox(edfile.geniner, 534.116, atol=1e-3)
        @test isapprox(edfile.nacmass, 240000, atol=1)
        @test isapprox(edfile.nacyiner, 2.60789e+06, atol=1e2)
        @test isapprox(edfile.yawbrmass, 0.0, atol=1e-8)
        @test isapprox(edfile.ptfmmass, 0.0, atol=1e-8)
        @test isapprox(edfile.ptfmriner, 0.0, atol=1e-8)
        @test isapprox(edfile.ptfmpiner, 0.0, atol=1e-8)
        @test isapprox(edfile.ptfmyiner, 0.0, atol=1e-8)

        @test edfile.bldnodes==17
        bldfiles = ["NREL5MWref_Blade.dat", "NREL5MWref_Blade.dat", "NREL5MWref_Blade.dat"]
        @test edfile.bldfiles==bldfiles

        @test isapprox(edfile.teetmod, 0.0, atol=1e-8)
        @test isapprox(edfile.teetdmpp, 0.0, atol=1e-8)
        @test isapprox(edfile.teetdmp, 0.0, atol=1e-8)
        @test isapprox(edfile.teetcdmp, 0.0, atol=1e-8)
        @test isapprox(edfile.teetsstp, 0.0, atol=1e-8)
        @test isapprox(edfile.teethstp, 0.0, atol=1e-8)
        @test isapprox(edfile.teetsssp, 0.0, atol=1e-8)
        @test isapprox(edfile.teethssp, 0.0, atol=1e-8)

        @test isapprox(edfile.gboxeff, 100, atol=1e-8)
        @test isapprox(edfile.gbratio, 97, atol=1e-8)
        @test isapprox(edfile.dttorspr, 8.67637e+08, atol=1)
        @test isapprox(edfile.dttordmp, 6.215e+06, atol=1)

        @test edfile.furling==false
        @test edfile.twrfile=="NREL5MWrefED_Tower.dat"

        @test edfile.sumprint==true
        @test edfile.outfile==1
        @test edfile.tabdelim==true
        @test edfile.outfmt=="ES10.3E2"
        @test isapprox(edfile.tstart, 0, atol=1e-5)
        @test isapprox(edfile.decfact, 1, atol=1e-5)
        @test edfile.ntwgages==3
        twrgagnd = [5, 10, 15]
        @test edfile.twrgagnd==twrgagnd
        @test edfile.nblgages==6
        bldgagnd = [1, 4, 7, 10, 13, 16]
        @test edfile.bldgagnd==bldgagnd
        outlist = [ "RootMxb1", "RootMyb1", "RootMzb1"]
        @test edfile.outlist==outlist

        @test edfile.bldnd_bladesout==3
        outnd = [99]
        @test edfile.bldnd_bloutnd==outnd 
        outlist = [ "ALx", "ALy", "ALz"]
        @test edfile.nodeoutlist==outlist

    end #End testing write ED file

    @testset "read ED Blade" begin
        file = "NREL5MWref_Blade.dat"
        path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine"
        edblade = of.read_edblade(file, path)

        @test edblade.numnds==49
        flapdamp = 0.477465.*ones(2)
        @test isapprox(edblade.flapdamp, flapdamp, atol=1e-8)
        @test isapprox(edblade.edgedamp, 0.477465, atol=1e-8)

        @test isapprox(edblade.flsttunr, ones(2), atol=1e-8)
        @test isapprox(edblade.adjblms, 1.057344, atol=1e-8)
        @test isapprox(edblade.adjflst, 1, atol=1e-8)
        @test isapprox(edblade.adjedst, 1, atol=1e-8)

        bldprops = [0.0000000E+00  2.5000000E-01  1.3308000E+01  6.7893500E+02  1.8110000E+10  1.8113600E+10
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
1.0000000E+00  3.7500000E-01  0.0000000E+00  1.0319000E+01  1.7000000E+05  5.0100000E+06]
        @test isapprox(edblade.frac, bldprops[:,1], atol=1e-8)
        @test isapprox(edblade.pitchaxis, bldprops[:,2], atol=1e-8)
        @test isapprox(edblade.twist, bldprops[:,3], atol=1e-8)
        @test isapprox(edblade.massdensity, bldprops[:,4], atol=1e-8)
        @test isapprox(edblade.flapstiff, bldprops[:,5], atol=1e-8)
        @test isapprox(edblade.edgestiff, bldprops[:,6], atol=1e-8)

        flapmode1 = [0.0622, 1.7254, -3.2452, 4.7131, -2.2555]
        @test isapprox(edblade.flapmode1, flapmode1, atol=1e-8)     
        flapmode2 = [-0.5809,  1.2067,  -15.5349,  29.7347, -13.8255]
        @test isapprox(edblade.flapmode2, flapmode2, atol=1e-8)     
        edgemode1 = [0.3627, 2.5337, -3.5772, 2.376, -0.6952]
        @test isapprox(edblade.edgemode1, edgemode1, atol=1e-8)

    end #end testing read ed blade

    @testset "Write EDBlade" begin
        file = "NREL5MWref_Blade.dat"
        path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine"
        edbladetemp = of.read_edblade(file, path)
        of.write_edblade(edbladetemp, "testingedblade.dat")
        edblade = of.read_edblade("testingedblade.dat", path)

        @test edblade.numnds==49
        flapdamp = 0.477465.*ones(2)
        @test isapprox(edblade.flapdamp, flapdamp, atol=1e-8)
        @test isapprox(edblade.edgedamp, 0.477465, atol=1e-8)

        @test isapprox(edblade.flsttunr, ones(2), atol=1e-8)
        @test isapprox(edblade.adjblms, 1.057344, atol=1e-8)
        @test isapprox(edblade.adjflst, 1, atol=1e-8)
        @test isapprox(edblade.adjedst, 1, atol=1e-8)

        bldprops = [0.0000000E+00  2.5000000E-01  1.3308000E+01  6.7893500E+02  1.8110000E+10  1.8113600E+10
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
1.0000000E+00  3.7500000E-01  0.0000000E+00  1.0319000E+01  1.7000000E+05  5.0100000E+06]
        @test isapprox(edblade.frac, bldprops[:,1], atol=1e-8)
        @test isapprox(edblade.pitchaxis, bldprops[:,2], atol=1e-8)
        @test isapprox(edblade.twist, bldprops[:,3], atol=1e-8)
        @test isapprox(edblade.massdensity, bldprops[:,4], atol=1e-8)
        @test isapprox(edblade.flapstiff, bldprops[:,5], atol=1e-8)
        @test isapprox(edblade.edgestiff, bldprops[:,6], atol=1e-8)

        flapmode1 = [0.0622, 1.7254, -3.2452, 4.7131, -2.2555]
        @test isapprox(edblade.flapmode1, flapmode1, atol=1e-8)     
        flapmode2 = [-0.5809,  1.2067,  -15.5349,  29.7347, -13.8255]
        @test isapprox(edblade.flapmode2, flapmode2, atol=1e-8)     
        edgemode1 = [0.3627, 2.5337, -3.5772, 2.376, -0.6952]
        @test isapprox(edblade.edgemode1, edgemode1, atol=1e-8)

    end


end #End testing ElastoDyn