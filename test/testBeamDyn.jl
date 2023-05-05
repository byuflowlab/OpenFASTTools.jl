using OpenFASTsr, Test, GXBeam, DynamicStallModels, DelimitedFiles

of = OpenFASTsr

path = dirname(@__FILE__)
cd(path)

@testset "BeamDyn" begin
    # @testset "Read BeamDyn File" begin
    #     file = "NREL5MWrefBD.dat"
    #     path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine"
    #     bdfile = of.read_bdfile(file, path)

    #     @test bdfile.echo==false
    #     @test bdfile.quasistaticinit==true
    #     @test isapprox(bdfile.rhoinf, 0, atol=1e-5)
    #     @test bdfile.quadrature==2
    #     @test bdfile.refine==0  
    #     @test bdfile.n_fract==0
    #     @test isnan(bdfile.dtbeam)
    #     @test bdfile.load_retries==0
    #     @test bdfile.nrmax==0
    #     @test isnan(bdfile.stop_tol)
    #     @test bdfile.tngt_stf_fd==of.Default()
    #     @test bdfile.tngt_stf_comp==of.Default()
    #     @test isnan(bdfile.tngt_stf_pert)
    #     @test isnan(bdfile.tngt_stf_difftol)
    #     @test bdfile.rotstates==true
    #     @test bdfile.member_total==1
    #     @test bdfile.kp_total==49
    #     @test bdfile.membernumber==[(1,49)]
    #     geoparams = [0.0000000E+00  0.0000000E+00  0.0000000E+00  1.3308000E+01
    #             0.0000000E+00  0.0000000E+00  1.9987500E-01  1.3308000E+01
    #             0.0000000E+00  0.0000000E+00  1.1998650E+00  1.3308000E+01
    #             0.0000000E+00  0.0000000E+00  2.1998550E+00  1.3308000E+01
    #             0.0000000E+00  0.0000000E+00  3.1998450E+00  1.3308000E+01
    #             0.0000000E+00  0.0000000E+00  4.1998350E+00  1.3308000E+01
    #             0.0000000E+00  0.0000000E+00  5.1998250E+00  1.3308000E+01
    #             0.0000000E+00  0.0000000E+00  6.1998150E+00  1.3308000E+01
    #             0.0000000E+00  0.0000000E+00  7.1998050E+00  1.3308000E+01
    #             0.0000000E+00  0.0000000E+00  8.2010250E+00  1.3308000E+01
    #             0.0000000E+00  0.0000000E+00  9.1997850E+00  1.3308000E+01
    #             0.0000000E+00  0.0000000E+00  1.0199775E+01  1.3308000E+01
    #             0.0000000E+00  0.0000000E+00  1.1199765E+01  1.3181000E+01
    #             0.0000000E+00  0.0000000E+00  1.2199755E+01  1.2848000E+01
    #             0.0000000E+00  0.0000000E+00  1.3200975E+01  1.2192000E+01
    #             0.0000000E+00  0.0000000E+00  1.4199735E+01  1.1561000E+01
    #             0.0000000E+00  0.0000000E+00  1.5199725E+01  1.1072000E+01
    #             0.0000000E+00  0.0000000E+00  1.6199715E+01  1.0792000E+01
    #             0.0000000E+00  0.0000000E+00  1.8200925E+01  1.0232000E+01
    #             0.0000000E+00  0.0000000E+00  2.0200290E+01  9.6720000E+00
    #             0.0000000E+00  0.0000000E+00  2.2200270E+01  9.1100000E+00
    #             0.0000000E+00  0.0000000E+00  2.4200250E+01  8.5340000E+00
    #             0.0000000E+00  0.0000000E+00  2.6200230E+01  7.9320000E+00
    #             0.0000000E+00  0.0000000E+00  2.8200825E+01  7.3210000E+00
    #             0.0000000E+00  0.0000000E+00  3.0200190E+01  6.7110000E+00
    #             0.0000000E+00  0.0000000E+00  3.2200170E+01  6.1220000E+00
    #             0.0000000E+00  0.0000000E+00  3.4200150E+01  5.5460000E+00
    #             0.0000000E+00  0.0000000E+00  3.6200130E+01  4.9710000E+00
    #             0.0000000E+00  0.0000000E+00  3.8200725E+01  4.4010000E+00
    #             0.0000000E+00  0.0000000E+00  4.0200090E+01  3.8340000E+00
    #             0.0000000E+00  0.0000000E+00  4.2200070E+01  3.3320000E+00
    #             0.0000000E+00  0.0000000E+00  4.4200050E+01  2.8900000E+00
    #             0.0000000E+00  0.0000000E+00  4.6200030E+01  2.5030000E+00
    #             0.0000000E+00  0.0000000E+00  4.8201240E+01  2.1160000E+00
    #             0.0000000E+00  0.0000000E+00  5.0199990E+01  1.7300000E+00
    #             0.0000000E+00  0.0000000E+00  5.2199970E+01  1.3420000E+00
    #             0.0000000E+00  0.0000000E+00  5.4199950E+01  9.5400000E-01
    #             0.0000000E+00  0.0000000E+00  5.5199940E+01  7.6000000E-01
    #             0.0000000E+00  0.0000000E+00  5.6199930E+01  5.7400000E-01
    #             0.0000000E+00  0.0000000E+00  5.7199920E+01  4.0400000E-01
    #             0.0000000E+00  0.0000000E+00  5.7699915E+01  3.1900000E-01
    #             0.0000000E+00  0.0000000E+00  5.8201140E+01  2.5300000E-01
    #             0.0000000E+00  0.0000000E+00  5.8699905E+01  2.1600000E-01
    #             0.0000000E+00  0.0000000E+00  5.9199900E+01  1.7800000E-01
    #             0.0000000E+00  0.0000000E+00  5.9699895E+01  1.4000000E-01
    #             0.0000000E+00  0.0000000E+00  6.0199890E+01  1.0100000E-01
    #             0.0000000E+00  0.0000000E+00  6.0699885E+01  6.2000000E-02
    #             0.0000000E+00  0.0000000E+00  6.1199880E+01  2.3000000E-02
    #             0.0000000E+00  0.0000000E+00  6.1500000E+01  0.0000000E+00]
    #     @test isapprox(hcat(bdfile.kp_xr, bdfile.kp_yr, bdfile.kp_zr, bdfile.initial_twist), geoparams, atol=1e-5 )
    #     @test bdfile.order_elem == 5
    #     @test bdfile.bldfile == "NREL5MWrefBD_Blade.dat"
    #     @test bdfile.usepitchact==false
    #     @test isapprox(bdfile.pitchj, 200, atol=1e-5)
    #     @test isapprox(bdfile.pitchk, 2e7, atol=1)
    #     @test isapprox(bdfile.pitchc, 500000, atol=1)
    #     @test bdfile.sumprint==true
    #     @test bdfile.outfmt=="ES10.3E2"
    #     @test bdfile.nnodeouts==0
    #     @test bdfile.outnd==[1, 2, 3, 4, 5, 6]
    #     outlist =   ["RootFxr, RootFyr, RootFzr"
    #                 "RootMxr, RootMyr, RootMzr"
    #                 "TipTDxr, TipTDyr, TipTDzr"
    #                 "TipRDxr, TipRDyr, TipRDzr"]
    #     @test bdfile.outlist==outlist
    #     outlist = ["FxL", "FyL", "FzL"]
    #     @test bdfile.nodeoutlist==outlist
    # end #End testing read BeamDyn File

    # @testset "Write BeamDyn File" begin
    #     file = "NREL5MWrefBD.dat"
    #     path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine"
    #     bdfiletemp = of.read_bdfile(file, path)
    #     of.write_bdfile(bdfiletemp, "testingbdfile.dat")
    #     bdfile = of.read_bdfile("testingbdfile.dat", path)

    #     @test bdfile.echo==false
    #     @test bdfile.quasistaticinit==true
    #     @test isapprox(bdfile.rhoinf, 0, atol=1e-5)
    #     @test bdfile.quadrature==2
    #     @test bdfile.refine==0  
    #     @test bdfile.n_fract==0
    #     @test isnan(bdfile.dtbeam)
    #     @test bdfile.load_retries==0
    #     @test bdfile.nrmax==0
    #     @test isnan(bdfile.stop_tol)
    #     @test bdfile.tngt_stf_fd==of.Default()
    #     @test bdfile.tngt_stf_comp==of.Default()
    #     @test isnan(bdfile.tngt_stf_pert)
    #     @test isnan(bdfile.tngt_stf_difftol)
    #     @test bdfile.rotstates==true
    #     @test bdfile.member_total==1
    #     @test bdfile.kp_total==49
    #     @test bdfile.membernumber==[(1,49)]
    #     geoparams = [0.0000000E+00  0.0000000E+00  0.0000000E+00  1.3308000E+01
    #             0.0000000E+00  0.0000000E+00  1.9987500E-01  1.3308000E+01
    #             0.0000000E+00  0.0000000E+00  1.1998650E+00  1.3308000E+01
    #             0.0000000E+00  0.0000000E+00  2.1998550E+00  1.3308000E+01
    #             0.0000000E+00  0.0000000E+00  3.1998450E+00  1.3308000E+01
    #             0.0000000E+00  0.0000000E+00  4.1998350E+00  1.3308000E+01
    #             0.0000000E+00  0.0000000E+00  5.1998250E+00  1.3308000E+01
    #             0.0000000E+00  0.0000000E+00  6.1998150E+00  1.3308000E+01
    #             0.0000000E+00  0.0000000E+00  7.1998050E+00  1.3308000E+01
    #             0.0000000E+00  0.0000000E+00  8.2010250E+00  1.3308000E+01
    #             0.0000000E+00  0.0000000E+00  9.1997850E+00  1.3308000E+01
    #             0.0000000E+00  0.0000000E+00  1.0199775E+01  1.3308000E+01
    #             0.0000000E+00  0.0000000E+00  1.1199765E+01  1.3181000E+01
    #             0.0000000E+00  0.0000000E+00  1.2199755E+01  1.2848000E+01
    #             0.0000000E+00  0.0000000E+00  1.3200975E+01  1.2192000E+01
    #             0.0000000E+00  0.0000000E+00  1.4199735E+01  1.1561000E+01
    #             0.0000000E+00  0.0000000E+00  1.5199725E+01  1.1072000E+01
    #             0.0000000E+00  0.0000000E+00  1.6199715E+01  1.0792000E+01
    #             0.0000000E+00  0.0000000E+00  1.8200925E+01  1.0232000E+01
    #             0.0000000E+00  0.0000000E+00  2.0200290E+01  9.6720000E+00
    #             0.0000000E+00  0.0000000E+00  2.2200270E+01  9.1100000E+00
    #             0.0000000E+00  0.0000000E+00  2.4200250E+01  8.5340000E+00
    #             0.0000000E+00  0.0000000E+00  2.6200230E+01  7.9320000E+00
    #             0.0000000E+00  0.0000000E+00  2.8200825E+01  7.3210000E+00
    #             0.0000000E+00  0.0000000E+00  3.0200190E+01  6.7110000E+00
    #             0.0000000E+00  0.0000000E+00  3.2200170E+01  6.1220000E+00
    #             0.0000000E+00  0.0000000E+00  3.4200150E+01  5.5460000E+00
    #             0.0000000E+00  0.0000000E+00  3.6200130E+01  4.9710000E+00
    #             0.0000000E+00  0.0000000E+00  3.8200725E+01  4.4010000E+00
    #             0.0000000E+00  0.0000000E+00  4.0200090E+01  3.8340000E+00
    #             0.0000000E+00  0.0000000E+00  4.2200070E+01  3.3320000E+00
    #             0.0000000E+00  0.0000000E+00  4.4200050E+01  2.8900000E+00
    #             0.0000000E+00  0.0000000E+00  4.6200030E+01  2.5030000E+00
    #             0.0000000E+00  0.0000000E+00  4.8201240E+01  2.1160000E+00
    #             0.0000000E+00  0.0000000E+00  5.0199990E+01  1.7300000E+00
    #             0.0000000E+00  0.0000000E+00  5.2199970E+01  1.3420000E+00
    #             0.0000000E+00  0.0000000E+00  5.4199950E+01  9.5400000E-01
    #             0.0000000E+00  0.0000000E+00  5.5199940E+01  7.6000000E-01
    #             0.0000000E+00  0.0000000E+00  5.6199930E+01  5.7400000E-01
    #             0.0000000E+00  0.0000000E+00  5.7199920E+01  4.0400000E-01
    #             0.0000000E+00  0.0000000E+00  5.7699915E+01  3.1900000E-01
    #             0.0000000E+00  0.0000000E+00  5.8201140E+01  2.5300000E-01
    #             0.0000000E+00  0.0000000E+00  5.8699905E+01  2.1600000E-01
    #             0.0000000E+00  0.0000000E+00  5.9199900E+01  1.7800000E-01
    #             0.0000000E+00  0.0000000E+00  5.9699895E+01  1.4000000E-01
    #             0.0000000E+00  0.0000000E+00  6.0199890E+01  1.0100000E-01
    #             0.0000000E+00  0.0000000E+00  6.0699885E+01  6.2000000E-02
    #             0.0000000E+00  0.0000000E+00  6.1199880E+01  2.3000000E-02
    #             0.0000000E+00  0.0000000E+00  6.1500000E+01  0.0000000E+00]
    #     @test isapprox(hcat(bdfile.kp_xr, bdfile.kp_yr, bdfile.kp_zr, bdfile.initial_twist), geoparams, atol=1e-5 )
    #     @test bdfile.order_elem == 5
    #     @test bdfile.bldfile == "NREL5MWrefBD_Blade.dat"
    #     @test bdfile.usepitchact==false
    #     @test isapprox(bdfile.pitchj, 200, atol=1e-5)
    #     @test isapprox(bdfile.pitchk, 2e7, atol=1)
    #     @test isapprox(bdfile.pitchc, 500000, atol=1)
    #     @test bdfile.sumprint==true
    #     @test bdfile.outfmt=="ES10.3E2"
    #     @test bdfile.nnodeouts==0
    #     @test bdfile.outnd==[1, 2, 3, 4, 5, 6]
    #     outlist =   ["RootFxr, RootFyr, RootFzr"
    #                 "RootMxr, RootMyr, RootMzr"
    #                 "TipTDxr, TipTDyr, TipTDzr"
    #                 "TipRDxr, TipRDyr, TipRDzr"]
    #     @test bdfile.outlist==outlist
    #     outlist = ["FxL", "FyL", "FzL"]
    #     @test bdfile.nodeoutlist==outlist
    # end #End testing write BeamDyn File

    # @testset "Read BD Blade" begin
    #     file = "NREL5MWrefBD_Blade.dat"
    #     path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine"
    #     bdblade = of.read_bdblade(file, path)

    #     @test bdblade.station_total==49
    #     @test bdblade.damp_type==1
    #     dampcoefs = [1.0E-03, 1.0E-03, 1.0E-03, 1.0E-03, 1.0E-03, 1.0E-03]
    #     @test bdblade.dampcoef==dampcoefs
    #     frac = [0, 0.003250,  0.019510]
    #     stiffmat = zeros(6,6,3) # I am not going to test all of the matrices in the blade file. That's just ridiculous. 
    #     massmat = zeros(6,6,3)
    #     stiffmat[:,:,1] = [
    #         9.729480E+08    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
    #         0.000000E+00    9.729480E+08    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
    #         0.000000E+00    0.000000E+00    9.729480E+09    0.000000E+00    0.000000E+00    0.000000E+00
    #         0.000000E+00    0.000000E+00    0.000000E+00    1.811360E+10    0.000000E+00    0.000000E+00
    #         0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    1.811000E+10    0.000000E+00
    #         0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    5.564400E+09]
    #     stiffmat[:,:,2] = [
    #         9.729480E+08    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
    #     0.000000E+00    9.729480E+08    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
    #     0.000000E+00    0.000000E+00    9.729480E+09    0.000000E+00    0.000000E+00    0.000000E+00
    #     0.000000E+00    0.000000E+00    0.000000E+00    1.811360E+10    0.000000E+00    0.000000E+00
    #     0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    1.811000E+10    0.000000E+00
    #     0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    5.564400E+09]
    #     stiffmat[:,:,3] = [
    #         1.078950E+09    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
    #     0.000000E+00    1.078950E+09    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
    #     0.000000E+00    0.000000E+00    1.078950E+10    0.000000E+00    0.000000E+00    0.000000E+00
    #     0.000000E+00    0.000000E+00    0.000000E+00    1.955860E+10    0.000000E+00    0.000000E+00
    #     0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    1.942490E+10    0.000000E+00
    #     0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    5.431590E+09]
    #     massmat[:,:,1] = [
    #         6.789350E+02    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
    #     0.000000E+00    6.789350E+02    0.000000E+00   -0.000000E+00    0.000000E+00    0.000000E+00
    #     0.000000E+00    0.000000E+00    6.789350E+02    0.000000E+00    0.000000E+00    0.000000E+00
    #     0.000000E+00   -0.000000E+00    0.000000E+00    9.730400E+02    0.000000E+00    0.000000E+00
    #     0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    9.728600E+02    0.000000E+00
    #     0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    1.945900E+03]
    #     massmat[:,:,2] = [
    #         6.789350E+02    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
    #     0.000000E+00    6.789350E+02    0.000000E+00   -0.000000E+00    0.000000E+00    0.000000E+00
    #     0.000000E+00    0.000000E+00    6.789350E+02    0.000000E+00    0.000000E+00    0.000000E+00
    #     0.000000E+00   -0.000000E+00    0.000000E+00    9.730400E+02    0.000000E+00    0.000000E+00
    #     0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    9.728600E+02    0.000000E+00
    #     0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    1.945900E+03]
    #     massmat[:,:,3] = [
    #         7.733630E+02    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
    #     0.000000E+00    7.733630E+02    0.000000E+00   -0.000000E+00    0.000000E+00    0.000000E+00
    #     0.000000E+00    0.000000E+00    7.733630E+02    0.000000E+00    0.000000E+00    0.000000E+00
    #     0.000000E+00   -0.000000E+00    0.000000E+00    1.066380E+03    0.000000E+00    0.000000E+00
    #     0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    1.091520E+03    0.000000E+00
    #     0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    2.157900E+03]
    #     for i = 1:3
    #         @test isapprox(bdblade.nodes[i].frac,frac[i],atol=1e-8)
    #         @test isapprox(bdblade.nodes[i].massmatrix, massmat[:,:,i],atol=1)
    #         @test isapprox(bdblade.nodes[i].stiffmatrix, stiffmat[:,:,i], atol=1)
    #     end

    # end #End testing read bd blade

    # @testset "Write BD Blade" begin
    #     file = "NREL5MWrefBD_Blade.dat"
    #     path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine"
    #     bdbladetemp = of.read_bdblade(file, path)
    #     of.write_bdblade(bdbladetemp, "testingbdblade.dat")
    #     bdblade = of.read_bdblade("testingbdblade.dat", path)
        
    #     @test bdblade.station_total==49
    #     @test bdblade.damp_type==1
    #     dampcoefs = [1.0E-03, 1.0E-03, 1.0E-03, 1.0E-03, 1.0E-03, 1.0E-03]
    #     @test bdblade.dampcoef==dampcoefs
    #     frac = [0, 0.003250,  0.019510]
    #     stiffmat = zeros(6,6,3) # I am not going to test all of the matrices in the blade file. That's just ridiculous. 
    #     massmat = zeros(6,6,3)
    #     stiffmat[:,:,1] = [
    #         9.729480E+08    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
    #         0.000000E+00    9.729480E+08    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
    #         0.000000E+00    0.000000E+00    9.729480E+09    0.000000E+00    0.000000E+00    0.000000E+00
    #         0.000000E+00    0.000000E+00    0.000000E+00    1.811360E+10    0.000000E+00    0.000000E+00
    #         0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    1.811000E+10    0.000000E+00
    #         0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    5.564400E+09]
    #     stiffmat[:,:,2] = [
    #         9.729480E+08    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
    #         0.000000E+00    9.729480E+08    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
    #         0.000000E+00    0.000000E+00    9.729480E+09    0.000000E+00    0.000000E+00    0.000000E+00
    #         0.000000E+00    0.000000E+00    0.000000E+00    1.811360E+10    0.000000E+00    0.000000E+00
    #         0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    1.811000E+10    0.000000E+00
    #         0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    5.564400E+09]
    #     stiffmat[:,:,3] = [
    #         1.078950E+09    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
    #         0.000000E+00    1.078950E+09    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
    #         0.000000E+00    0.000000E+00    1.078950E+10    0.000000E+00    0.000000E+00    0.000000E+00
    #         0.000000E+00    0.000000E+00    0.000000E+00    1.955860E+10    0.000000E+00    0.000000E+00
    #         0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    1.942490E+10    0.000000E+00
    #         0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    5.431590E+09]
    #     massmat[:,:,1] = [
    #         6.789350E+02    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
    #         0.000000E+00    6.789350E+02    0.000000E+00   -0.000000E+00    0.000000E+00    0.000000E+00
    #         0.000000E+00    0.000000E+00    6.789350E+02    0.000000E+00    0.000000E+00    0.000000E+00
    #         0.000000E+00   -0.000000E+00    0.000000E+00    9.730400E+02    0.000000E+00    0.000000E+00
    #         0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    9.728600E+02    0.000000E+00
    #         0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    1.945900E+03]
    #     massmat[:,:,2] = [
    #         6.789350E+02    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
    #         0.000000E+00    6.789350E+02    0.000000E+00   -0.000000E+00    0.000000E+00    0.000000E+00
    #         0.000000E+00    0.000000E+00    6.789350E+02    0.000000E+00    0.000000E+00    0.000000E+00
    #         0.000000E+00   -0.000000E+00    0.000000E+00    9.730400E+02    0.000000E+00    0.000000E+00
    #         0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    9.728600E+02    0.000000E+00
    #         0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    1.945900E+03]
    #     massmat[:,:,3] = [7.733630E+02    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00
    #     0.000000E+00    7.733630E+02    0.000000E+00   -0.000000E+00    0.000000E+00    0.000000E+00
    #     0.000000E+00    0.000000E+00    7.733630E+02    0.000000E+00    0.000000E+00    0.000000E+00
    #     0.000000E+00   -0.000000E+00    0.000000E+00    1.066380E+03    0.000000E+00    0.000000E+00
    #     0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    1.091520E+03    0.000000E+00
    #     0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    0.000000E+00    2.157900E+03]
    #     for i = 1:3
    #         @test isapprox(bdblade.nodes[i].frac,frac[i],atol=1e-8)
    #         @test isapprox(bdblade.nodes[i].massmatrix, massmat[:,:,i],atol=1)
    #         @test isapprox(bdblade.nodes[i].stiffmatrix, stiffmat[:,:,i], atol=1)
    #     end

    # end #End testing write BD Blade







    @testset "Interface Functions - Simple Beam" begin
        ofpath = "./data/simplebeam"
        bdfile = of.read_bdfile("sb_BDfile.dat", ofpath)
        bdblade = of.read_bdblade("sb_BDblade.dat", ofpath)

        rhub = 0.0
        rtip = 100.0

        rx = bdfile["kp_xr"]
        ry = bdfile["kp_yr"]
        rz = bdfile["kp_zr"]
        twist = bdfile["initial_twist"].*(pi/180)
        precone = sweep = curve = 0.0

        assembly = of.make_assembly(rhub, rtip, rx, ry, rz, twist, precone, sweep, curve, bdblade)
        nelem = length(assembly.elements)

        @testset "Tip Load" begin
            ### Test the create assembly function (and everything contained therein) with a constant cross section beam and a tip load. 
        
            Fx = 1000.0

            prescribed_conditions = Dict(1 => GXBeam.PrescribedConditions(ux=0, uy=0, uz=0, theta_x=0, theta_y=0, theta_z=0),
            nelem+1 => GXBeam.PrescribedConditions(Fz = -Fx)) # root section is fixed, Note that the BeamDyn and GXBeam beams extend in different directions (I could probably fix that. )
        


            ### GXBeam  solution  
            system, converged = GXBeam.steady_state_analysis(assembly; prescribed_conditions = prescribed_conditions) 

            gxstate = AssemblyState(system, assembly; prescribed_conditions)


            def_x = [-gxstate.points[i].u[3] for i in eachindex(gxstate.points)]
            def_y = [gxstate.points[i].u[2] for i in eachindex(gxstate.points)]
            def_z = [gxstate.points[i].u[1] for i in eachindex(gxstate.points)]

            # def_x = [gxstate.points[i].u[1] for i in eachindex(gxstate.points)]
            # def_y = [gxstate.points[i].u[2] for i in eachindex(gxstate.points)]
            # def_z = [gxstate.points[i].u[3] for i in eachindex(gxstate.points)]


            bdread = readdlm("./data/simplebeam/sb_tipload_steady.out", skipstart=6)
            bdnames = bdread[1,:]
            bddata = Float64.(bdread[3:end,:])

            bdouts = Dict(bdnames[i] => bddata[:,i] for i in eachindex(bdnames))


            tiperr = 100*(def_x[end]-bdouts["TipTDxr"][end])/bdouts["TipTDxr"][end]
            println("simple beam Tip load Error: ", tiperr, " %")
            println("")
            @test abs(tiperr)<1
        end #End testing tip load

        @testset "Distributed Load" begin
            ### Test the create assembly function (and everything contained therein) with a constant cross section beam and a distributed load. 

            prescribed_conditions = Dict(1 => GXBeam.PrescribedConditions(ux=0, uy=0, uz=0, theta_x=0, theta_y=0, theta_z=0)) # root section is fixed

            q = 5.0
            distributed_loads = Dict(ielem => DistributedLoads(assembly, ielem; fz = (s) -> -q) for ielem in 1:nelem)



            ### GXBeam  solution  
            system, converged = GXBeam.steady_state_analysis(assembly; prescribed_conditions, distributed_loads) 

            gxstate = AssemblyState(system, assembly; prescribed_conditions)

            def_x = [-gxstate.points[i].u[3] for i in eachindex(gxstate.points)]
            def_y = [gxstate.points[i].u[2] for i in eachindex(gxstate.points)]
            def_z = [gxstate.points[i].u[1] for i in eachindex(gxstate.points)]

            # def_x = [gxstate.points[i].u[1] for i in eachindex(gxstate.points)]
            # def_y = [gxstate.points[i].u[2] for i in eachindex(gxstate.points)]
            # def_z = [gxstate.points[i].u[3] for i in eachindex(gxstate.points)]

            


            bdread = readdlm("./data/simplebeam/sb_distributedload_steady.out", skipstart=6)
            bdnames = bdread[1,:]
            bddata = Float64.(bdread[3:end,:])

            bdouts = Dict(bdnames[i] => bddata[:,i] for i in eachindex(bdnames))

            tiperr = 100*(def_x[end]-bdouts["TipTDxr"][end])/bdouts["TipTDxr"][end]
            println("simple beam distributed load error: ", tiperr, " %")
            println("")
            @test abs(tiperr)<1

        end #End distributed load

        @testset "Tip Load - Spinning" begin
            ### Test the create assembly function (and everything contained therein) with a constant cross section beam and a tip load. 
        
            Fx = 0.0

            prescribed_conditions = Dict(1 => GXBeam.PrescribedConditions(ux=0, uy=0, uz=0, theta_x=0, theta_y=0, theta_z=0),
            nelem+1 => GXBeam.PrescribedConditions(Fz = -Fx)) # root section is fixed, Note that the BeamDyn and GXBeam beams extend in different directions (I could probably fix that. )
        
            omega = 1.0


            ### GXBeam  solution  
            system, converged = GXBeam.steady_state_analysis(assembly; prescribed_conditions = prescribed_conditions, angular_velocity = [0, 0, -omega]) 

            gxstate = AssemblyState(system, assembly; prescribed_conditions)


            def_x = [-gxstate.points[i].u[3] for i in eachindex(gxstate.points)]
            def_y = [gxstate.points[i].u[2] for i in eachindex(gxstate.points)]
            def_z = [gxstate.points[i].u[1] for i in eachindex(gxstate.points)]

            # def_x = [gxstate.points[i].u[1] for i in eachindex(gxstate.points)]
            # def_y = [gxstate.points[i].u[2] for i in eachindex(gxstate.points)]
            # def_z = [gxstate.points[i].u[3] for i in eachindex(gxstate.points)]

            Vx = [gxstate.points[i].V[1] for i in eachindex(gxstate.points)]
            Vy = [gxstate.points[i].V[2] for i in eachindex(gxstate.points)]
            Vz = [gxstate.points[i].V[3] for i in eachindex(gxstate.points)]


            bdread = readdlm("./data/simplebeam/sb_tipload_spinning.out", skipstart=6)
            bdnames = bdread[1,:]
            bddata = Float64.(bdread[3:end,:])

            bdouts = Dict(bdnames[i] => bddata[:,i] for i in eachindex(bdnames))

            @show assembly.points[end]
            @show assembly.points[end]+gxstate.points[end].u

            @show bdouts["TipTDxr"][end], bdouts["TipTDyr"][end], bdouts["TipTDzr"][end]
            @show bdouts["TipTVxg"][end], bdouts["TipTVyg"][end], bdouts["TipTVzg"][end]
            bdvx = bdouts["N100_TVxl"][end]
            bdvy = bdouts["N100_TVyl"][end]
            bdvz = bdouts["N100_TVzl"][end]
            @show bdvx, bdvy, bdvz


            @show Vx[end], Vy[end], Vz[end]


            tiperr = 100*(def_x[end]-bdouts["TipTDxr"][end])/bdouts["TipTDxr"][end]
            println("simple beam spinning Tip load Error: ", tiperr, " %")
            println("")
            # @test abs(tiperr)<1
        end #End testing tip load spinning
    end #End testing simple beam










    @testset "Interface Functions - Medium Beam" begin
        ofpath = "./data/mediumbeam"
        bdfile = of.read_bdfile("mb_BDfile.dat", ofpath)
        bdblade = of.read_bdblade("mb_BDblade.dat", ofpath)

        rhub = 0.0
        rtip = 100.0

        rx = bdfile["kp_xr"]
        ry = bdfile["kp_yr"]
        rz = bdfile["kp_zr"]
        twist = bdfile["initial_twist"].*(pi/180)
        precone = sweep = curve = 0.0

        assembly = of.make_assembly(rhub, rtip, rx, ry, rz, twist, precone, sweep, curve, bdblade)
        nelem = length(assembly.elements)

        @testset "Tip Load" begin
            ### Test the create assembly function (and everything contained therein) with a constant cross section beam and a tip load. 
        
            Fx = 1000.0

            prescribed_conditions = Dict(1 => GXBeam.PrescribedConditions(ux=0, uy=0, uz=0, theta_x=0, theta_y=0, theta_z=0),
            nelem+1 => GXBeam.PrescribedConditions(Fz = -Fx)) # root section is fixed, Note that the BeamDyn and GXBeam beams extend in different directions (I could probably fix that. )
        


            ### GXBeam  solution  
            system, converged = GXBeam.steady_state_analysis(assembly; prescribed_conditions = prescribed_conditions) 

            gxstate = AssemblyState(system, assembly; prescribed_conditions)

            def_x = [-gxstate.points[i].u[3] for i in eachindex(gxstate.points)]
            def_y = [gxstate.points[i].u[2] for i in eachindex(gxstate.points)]
            def_z = [gxstate.points[i].u[1] for i in eachindex(gxstate.points)]

            # def_x = [gxstate.points[i].u[1] for i in eachindex(gxstate.points)]
            # def_y = [gxstate.points[i].u[2] for i in eachindex(gxstate.points)]
            # def_z = [gxstate.points[i].u[3] for i in eachindex(gxstate.points)]


            bdread = readdlm("./data/mediumbeam/mb_tipload_steady.out", skipstart=6) #Checked 3/13/23 4:21pm. 
            # bdread = readdlm("./data/mediumbeam/mb_bddriver.out", skipstart=6)
            bdnames = bdread[1,:]
            bddata = Float64.(bdread[3:end,:])

            bdouts = Dict(bdnames[i] => bddata[:,i] for i in eachindex(bdnames))


            tiperr = 100*(def_x[end]-bdouts["TipTDxr"][end])/bdouts["TipTDxr"][end]

            # println("GXBeam: ", def_x[end], ", ", def_y[end], ", ", def_z[end])
            # println("OpenFAST: ", bdouts["TipTDxr"][end], ", ", bdouts["TipTDyr"][end], ", ", bdouts["TipTDzr"][end])
            # Note: In order have beams that match between GXBeam and BeamDyn, the discretization has to be just right. I think that the way that I'm interpolating the stiffness and mass matrices is causing there too be discrepancies, even when both BeamDyn and GXBeam are converged... which makes sense, different inputs mean different outputs... So I guess at this point is change what interpolation I use... or use a turbine that is simpler... Apparently the turbine I created is quite floppy, so I should make a stiffer one.
            
            println("Tip medium beam load Error: ", tiperr, "%")
            println("")

            @test abs(tiperr)<1
        end #End testing tip load

        @testset "Distributed Load" begin
            ### Test the create assembly function (and everything contained therein) with a constant cross section beam and a distributed load. 

            prescribed_conditions = Dict(1 => GXBeam.PrescribedConditions(ux=0, uy=0, uz=0, theta_x=0, theta_y=0, theta_z=0)) # root section is fixed

            q = 5.0
            distributed_loads = Dict(ielem => DistributedLoads(assembly, ielem; fz = (s) -> -q) for ielem in 1:nelem)



            ### GXBeam  solution  
            system, converged = GXBeam.steady_state_analysis(assembly; prescribed_conditions, distributed_loads) 

            gxstate = AssemblyState(system, assembly; prescribed_conditions)

            def_x = [-gxstate.points[i].u[3] for i in eachindex(gxstate.points)]
            def_y = [gxstate.points[i].u[2] for i in eachindex(gxstate.points)]
            def_z = [gxstate.points[i].u[1] for i in eachindex(gxstate.points)]

            # def_x = [gxstate.points[i].u[1] for i in eachindex(gxstate.points)]
            # def_y = [gxstate.points[i].u[2] for i in eachindex(gxstate.points)]
            # def_z = [gxstate.points[i].u[3] for i in eachindex(gxstate.points)]


            bdread = readdlm("./data/mediumbeam/mb_distributedload_steady.out", skipstart=6) #Checked 3/13/23 4:24pm
            
            bdnames = bdread[1,:]
            bddata = Float64.(bdread[3:end,:])

            bdouts = Dict(bdnames[i] => bddata[:,i] for i in eachindex(bdnames))

            # println("GXBeam: ", def_x[end], ", ", def_y[end], ", ", def_z[end])
            # println("OpenFAST: ", bdouts["TipTDxr"][end], ", ", bdouts["TipTDyr"][end], ", ", bdouts["TipTDzr"][end])

            tiperr = 100*(def_x[end]-bdouts["TipTDxr"][end])/bdouts["TipTDxr"][end]

            println("medium beam distributed load error: ", tiperr, "%")
            println("")

            @test abs(tiperr)<1

        end #End distributed load
    end #End testing medium blade. 










    @testset "Interface Functions - Complex Beam" begin
        ofpath = "./data/complexbeam"
        bdfile = of.read_bdfile("cb_BDfile.dat", ofpath)
        bdblade = of.read_bdblade("cb_BDblade.dat", ofpath)

        rhub = 0.0
        rtip = 10.0

        rx = bdfile["kp_xr"]
        ry = bdfile["kp_yr"]
        rz = bdfile["kp_zr"]
        twist = bdfile["initial_twist"].*(pi/180)
        precone = sweep = curve = 0.0

        # @show twist

        assembly = of.make_assembly(rhub, rtip, rx, ry, rz, twist, precone, sweep, curve, bdblade)
        nelem = length(assembly.elements)

        @testset "Tip Load" begin
            ### Test the create assembly function (and everything contained therein) with a constant cross section beam and a tip load. 
        
            Fx = 10000.0
            # Fy = 1000.0

            prescribed_conditions = Dict(1 => GXBeam.PrescribedConditions(ux=0, uy=0, uz=0, theta_x=0, theta_y=0, theta_z=0),
            nelem+1 => GXBeam.PrescribedConditions(Fz = -Fx)) # root section is fixed, Note that the BeamDyn and GXBeam beams extend in different directions (I could probably fix that. )
        
            omega = 0.0

            ### GXBeam  solution  
            system, converged = GXBeam.steady_state_analysis(assembly; prescribed_conditions = prescribed_conditions, angular_velocity = [0, 0, -omega]) 

            gxstate = AssemblyState(system, assembly; prescribed_conditions)

            def_x = [-gxstate.points[i].u[3] for i in eachindex(gxstate.points)]
            def_y = [gxstate.points[i].u[2] for i in eachindex(gxstate.points)]
            def_z = [gxstate.points[i].u[1] for i in eachindex(gxstate.points)]

            # def_x = [gxstate.points[i].u[1] for i in eachindex(gxstate.points)]
            # def_y = [gxstate.points[i].u[2] for i in eachindex(gxstate.points)]
            # def_z = [gxstate.points[i].u[3] for i in eachindex(gxstate.points)]

            Vx = [gxstate.points[i].V[1] for i in eachindex(gxstate.points)]
            Vy = [gxstate.points[i].V[2] for i in eachindex(gxstate.points)]
            Vz = [gxstate.points[i].V[3] for i in eachindex(gxstate.points)]


            bdread = readdlm("./data/complexbeam/cb_tipload_steady.out", skipstart=6) #Checked 3/13/23 4:41pm. 
            # bdread = readdlm("./data/complexbeam/cb_bddriver.out", skipstart=6)
            bdnames = bdread[1,:]
            bddata = Float64.(bdread[3:end,:])

            bdouts = Dict(bdnames[i] => bddata[:,i] for i in eachindex(bdnames))

            t = bdouts["Time"][end]
            deg = omega*t

            # r = [bdouts["TipTDxr"][end], bdouts["TipTDyr"][end], bdouts["TipTDzr"][end]]
            # v = [bdouts["N400_TVxr"][end], bdouts["N400_TVyr"][end], bdouts["N400_TVzr"][end]]

            # rl = OpenFASTsr.rotate_x(-deg)*r
            # vl = OpenFASTsr.rotate_x(deg)*v
            # @show deg
            

            # @show def_x[end], def_y[end], def_z[end]
            # @show bdouts["TipTDxr"][end], bdouts["TipTDyr"][end], bdouts["TipTDzr"][end]
            # @show rl
            # @show bdouts["TipTDxr"]
            # @show bdouts["TipTDyr"]
            # @show bdouts["TipTDzr"]
            # println("")


            tiperr = 100*(def_x[end]-bdouts["TipTDxr"][end])/bdouts["TipTDxr"][end]

            # @show tiperr

            

            # @show length(rx)
            # @show length(bdouts["N400_TVxr"])
            # @show bdouts["N400_TVyr"]
            # @show Vx[end], bdouts["N400_TVxr"][end]
            # @show Vy[end], bdouts["N400_TVyr"][end]
            # @show Vz[end], bdouts["N400_TVzr"][end]
            # @show bdouts["N400_TVxl"][end], bdouts["N400_TVyl"][end], bdouts["N400_TVzl"][end]
            # @show bdouts["N400_TVxg"][end], bdouts["N400_TVyg"][end], bdouts["N400_TVzg"][end]
            # TVrr = sqrt(bdouts["N400_TVyr"][end].^2 + bdouts["N400_TVzr"][end].^2) + (bdouts["N400_TDzr"][end])*omega
            # Vr = sqrt(Vy[end].^2 + Vz[end].^2)

            # @show Vx[end], Vy[end], Vz[end]
            # @show vl
            # @show Vr, TVrr
            # @show tiperr

            # println("GXBeam: ", def_x[end], ", ", def_y[end], ", ", def_z[end])
            # println("OpenFAST: ", bdouts["TipTDxr"][end], ", ", bdouts["TipTDyr"][end], ", ", bdouts["TipTDzr"][end])
            ##### Note: In order have beams that match between GXBeam and BeamDyn, the discretization has to be just right. I think that the way that I'm interpolating the stiffness and mass matrices is causing there to be discrepancies, even when both BeamDyn and GXBeam are converged... which makes sense, different inputs mean different outputs... So I guess at this point is change what interpolation I use... or use a turbine that is simpler... Apparently the turbine I created is quite floppy, so I should make a stiffer one. 
            

            # @test abs(tiperr)<1
        end #End testing tip load

        # @testset "Distributed Load" begin
        #     ### Test the create assembly function (and everything contained therein) with a constant cross section beam and a distributed load. 

        #     prescribed_conditions = Dict(1 => GXBeam.PrescribedConditions(ux=0, uy=0, uz=0, theta_x=0, theta_y=0, theta_z=0)) # root section is fixed

        #     q = 5.0
        #     distributed_loads = Dict(ielem => DistributedLoads(assembly, ielem; fz = (s) -> -q) for ielem in 1:nelem)



        #     ### GXBeam  solution  
        #     system, converged = GXBeam.steady_state_analysis(assembly; prescribed_conditions, distributed_loads) 

        #     gxstate = AssemblyState(system, assembly; prescribed_conditions)

        #     def_x = [-gxstate.points[i].u[3] for i in eachindex(gxstate.points)]
        #     def_y = [gxstate.points[i].u[2] for i in eachindex(gxstate.points)]
        #     def_z = [gxstate.points[i].u[1] for i in eachindex(gxstate.points)]


        #     bdread = readdlm("./data/complexbeam/cb_distributedload_steady.out", skipstart=6) #Checked 3/13/23 4:42pm
        #     # bdread = readdlm("./data/complexbeam/cb_bddriver.out", skipstart=6)
        #     bdnames = bdread[1,:]
        #     bddata = Float64.(bdread[3:end,:])

        #     bdouts = Dict(bdnames[i] => bddata[:,i] for i in eachindex(bdnames))

        #     # println("GXBeam: ", def_x[end], ", ", def_y[end], ", ", def_z[end])
        #     # println("OpenFAST: ", bdouts["TipTDxr"][end], ", ", bdouts["TipTDyr"][end], ", ", bdouts["TipTDzr"][end])

        #     tiperr = 100*(def_x[end]-bdouts["TipTDxr"][end])/bdouts["TipTDxr"][end]
        #     @test abs(tiperr)<1

        # end #End distributed load
    end #End testing complex blade.

end # End testing BeamDyn