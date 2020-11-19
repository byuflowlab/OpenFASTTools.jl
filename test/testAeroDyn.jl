# using OpenFASTsr
# using Test

# of = OpenFASTsr

@testset "AeroDyn" begin

    @testset "Read AeroDyn" begin

        file = "NREL5MWrefAD15.dat"
        path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine"
        adfile = of.ReadAD15File(file, path)

        @test lowercase(adfile.Echo)=="false"
        @test lowercase(adfile.DTAero)=="\"default\"" #Note that this guy is different than the others, maybe should change. 
        @test adfile.WakeMod==1
        @test adfile.AFAeroMod==2
        @test adfile.TwrPotent==1
        @test lowercase(adfile.TwrShadow)=="false"
        @test lowercase(adfile.TwrAero)=="true"
        @test lowercase(adfile.FrozenWake)=="false"
        @test lowercase(adfile.CavitCheck)=="false"
        @test lowercase(adfile.CompAA)=="false"
        @test adfile.AA_InputFile=="unused" #Should be case sensitive
        @test isapprox(adfile.AirDens,1.225,atol=1e-8)
        @test isapprox(adfile.KinVisc, 1.464e-5,atol=1e-10)
        @test isapprox(adfile.SpdSound, 335,atol=1e-5)
        @test isapprox(adfile.Patm, 103500, atol=1e-5)
        @test isapprox(adfile.Pvap, 1700, atol=1e-5)
        @test isapprox(adfile.FluidDepth, 0.5, atol=1e-5)
        @test adfile.SkewMod==2
        @test lowercase(adfile.SkewModFactor)=="default"
        @test lowercase(adfile.TipLoss)=="true"
        @test lowercase(adfile.HubLoss)=="true"
        @test lowercase(adfile.TanInd)=="true"
        @test lowercase(adfile.AIDrag)=="false"
        @test lowercase(adfile.TIDrag)=="false"
        @test lowercase(adfile.IndToler)=="default"
        @test adfile.MaxIter==100
        @test adfile.DBEMT_Mod==2
        @test isapprox(adfile.tau1_const, 4, atol=1e-5)
        @test adfile.OLAFInputFileName=="unused" #Should be case sensitive
        @test adfile.UAMod==3
        @test lowercase(adfile.FLookup)=="true"
        @test adfile.AFTabMod==1
        @test adfile.InCol_Alfa==1
        @test adfile.InCol_Cl==2
        @test adfile.InCol_Cd==3
        @test adfile.InCol_Cm==4
        @test adfile.InCol_Cpmin==0
        @test adfile.NumAFfiles==8
        @test adfile.Foils==["Airfoils/Cylinder1.dat"
        "Airfoils/Cylinder2.dat"
        "Airfoils/DU40_A17.dat"
        "Airfoils/DU35_A17.dat"
        "Airfoils/DU30_A17.dat"
        "Airfoils/DU25_A17.dat"
        "Airfoils/DU21_A17.dat"
        "Airfoils/NACA64_A17.dat"] #Should be case sensitive
        @test lowercase(adfile.UseBlCm)=="true"
        @test adfile.Blades==["NREL5MWrefAD_blade.dat", "NREL5MWrefAD_blade.dat", "NREL5MWrefAD_blade.dat"] #Should be case sensitive
        @test adfile.NumTwrNds==12

        twrnds = [0.0000000E+00  6.0000000E+00  1.0000000E+00
        8.5261000E+00  5.7870000E+00  1.0000000E+00
        1.7053000E+01  5.5740000E+00  1.0000000E+00
        2.5579000E+01  5.3610000E+00  1.0000000E+00
        3.4105000E+01  5.1480000E+00  1.0000000E+00
        4.2633000E+01  4.9350000E+00  1.0000000E+00
        5.1158000E+01  4.7220000E+00  1.0000000E+00
        5.9685000E+01  4.5090000E+00  1.0000000E+00
        6.8211000E+01  4.2960000E+00  1.0000000E+00
        7.6738000E+01  4.0830000E+00  1.0000000E+00
        8.5268000E+01  3.8700000E+00  1.0000000E+00
        8.7600000E+01  3.8700000E+00  1.0000000E+00]
        @test isapprox(adfile.TwrNds,twrnds,atol=1e-5)
        @test lowercase(adfile.SumPrint)=="true"
        @test adfile.NBlOuts==3

        bloutnd = [1, 9, 19]
        @test adfile.BlOutNd==bloutnd
        @test adfile.NTwOuts==0

        twoutnd = [1, 2, 6]
        @test adfile.TwOutNd==twoutnd

        outlist = ["RtAeroPwr"]
        @test adfile.Outlist==outlist
        @test adfile.BldNd_BladesOut==3

        outlist = ["VUndx", "VUndy", "VUndz"]
        bloutnd = [99]
        @test adfile.BldNd_BlOutNd==bloutnd
        @test adfile.NodeOutlist==outlist

    end

    ######################################
    ### WRITE AERODYN TEST SET
    ######################################

    @testset "Write AeroDyn" begin #I have no clue why this has 1 less test... It is a copy and paste. 
        println("Note that if there are any errors in the read test set, they will propogate to the write test set.")
        file = "NREL5MWrefAD15.dat"
        path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine"
        adfiletemp = of.ReadAD15File(file, path)
        of.WriteAD15File(adfiletemp, "testNREL5MWAD15.dat")
        adfile = of.ReadAD15File("testNREL5MWAD15.dat", path)

        @test lowercase(adfile.Echo)=="false"
        @test lowercase(adfile.DTAero)=="\"default\"" #Note that this guy is different than the others, maybe should change. 
        @test adfile.WakeMod==1
        @test adfile.AFAeroMod==2
        @test adfile.TwrPotent==1
        @test lowercase(adfile.TwrShadow)=="false"
        @test lowercase(adfile.TwrAero)=="true"
        @test lowercase(adfile.FrozenWake)=="false"
        @test lowercase(adfile.CavitCheck)=="false"
        @test lowercase(adfile.CompAA)=="false"
        @test adfile.AA_InputFile=="unused" #Should be case sensitive
        @test isapprox(adfile.AirDens,1.225,atol=1e-8)
        @test isapprox(adfile.KinVisc, 1.464e-5,atol=1e-10)
        @test isapprox(adfile.SpdSound, 335,atol=1e-5)
        @test isapprox(adfile.Patm, 103500, atol=1e-5)
        @test isapprox(adfile.Pvap, 1700, atol=1e-5)
        @test isapprox(adfile.FluidDepth, 0.5, atol=1e-5)
        @test adfile.SkewMod==2
        @test lowercase(adfile.SkewModFactor)=="default"
        @test lowercase(adfile.TipLoss)=="true"
        @test lowercase(adfile.HubLoss)=="true"
        @test lowercase(adfile.TanInd)=="true"
        @test lowercase(adfile.AIDrag)=="false"
        @test lowercase(adfile.TIDrag)=="false"
        @test lowercase(adfile.IndToler)=="default"
        @test adfile.MaxIter==100
        @test adfile.DBEMT_Mod==2
        @test isapprox(adfile.tau1_const, 4, atol=1e-5)
        @test adfile.OLAFInputFileName=="unused" #Should be case sensitive
        @test adfile.UAMod==3
        @test lowercase(adfile.FLookup)=="true"
        @test adfile.AFTabMod==1
        @test adfile.InCol_Alfa==1
        @test adfile.InCol_Cl==2
        @test adfile.InCol_Cd==3
        @test adfile.InCol_Cm==4
        @test adfile.InCol_Cpmin==0
        @test adfile.NumAFfiles==8
        @test adfile.Foils==["Airfoils/Cylinder1.dat"
        "Airfoils/Cylinder2.dat"
        "Airfoils/DU40_A17.dat"
        "Airfoils/DU35_A17.dat"
        "Airfoils/DU30_A17.dat"
        "Airfoils/DU25_A17.dat"
        "Airfoils/DU21_A17.dat"
        "Airfoils/NACA64_A17.dat"] #Should be case sensitive
        @test lowercase(adfile.UseBlCm)=="true"
        @test adfile.Blades==["NREL5MWrefAD_blade.dat", "NREL5MWrefAD_blade.dat", "NREL5MWrefAD_blade.dat"] #Should be case sensitive
        @test adfile.NumTwrNds==12

        twrnds = [0.0000000E+00  6.0000000E+00  1.0000000E+00
        8.5261000E+00  5.7870000E+00  1.0000000E+00
        1.7053000E+01  5.5740000E+00  1.0000000E+00
        2.5579000E+01  5.3610000E+00  1.0000000E+00
        3.4105000E+01  5.1480000E+00  1.0000000E+00
        4.2633000E+01  4.9350000E+00  1.0000000E+00
        5.1158000E+01  4.7220000E+00  1.0000000E+00
        5.9685000E+01  4.5090000E+00  1.0000000E+00
        6.8211000E+01  4.2960000E+00  1.0000000E+00
        7.6738000E+01  4.0830000E+00  1.0000000E+00
        8.5268000E+01  3.8700000E+00  1.0000000E+00
        8.7600000E+01  3.8700000E+00  1.0000000E+00]
        @test isapprox(adfile.TwrNds,twrnds,atol=1e-5)
        @test lowercase(adfile.SumPrint)=="true"
        @test adfile.NBlOuts==3

        bloutnd = [1, 9, 19]
        @test adfile.BlOutNd==bloutnd
        @test adfile.NTwOuts==0

        twoutnd = [1, 2, 6]
        @test adfile.TwOutNd==twoutnd

        outlist = ["RtAeroPwr"]
        @test adfile.Outlist==outlist
        @test adfile.BldNd_BladesOut==3

        outlist = ["VUndx", "VUndy", "VUndz"]
        bloutnd = [99]
        @test adfile.BldNd_BlOutNd==bloutnd
        @test adfile.NodeOutlist==outlist
        

    end

    ######################################
    ### READ ADBlade TEST SET
    ######################################

    @testset "Read ADBlade" begin
        file = "NREL5MWrefAD_blade.dat"
        path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine"
        adblade = of.ReadADBlade(file, path)
        
        @test adblade.NumBlNds==19
        bldprops = [
0.0000000E+00  0.0000000E+00  0.0000000E+00 0.0000000E+00  1.3308000E+01  3.5420000E+00        1
1.3667000E+00 -8.1531745E-04 -3.4468858E-03 0.0000000E+00  1.3308000E+01  3.5420000E+00        1
4.1000000E+00 -2.4839790E-02 -1.0501421E-01 0.0000000E+00  1.3308000E+01  3.8540000E+00        1
6.8333000E+00 -5.9469375E-02 -2.5141635E-01 0.0000000E+00  1.3308000E+01  4.1670000E+00        2
1.0250000E+01 -1.0909141E-01 -4.6120149E-01 0.0000000E+00  1.3308000E+01  4.5570000E+00        3
1.4350000E+01 -1.1573354E-01 -5.6986665E-01 0.0000000E+00  1.1480000E+01  4.6520000E+00        4
1.8450000E+01 -9.8316709E-02 -5.4850833E-01 0.0000000E+00  1.0162000E+01  4.4580000E+00        4
2.2550000E+01 -8.3186967E-02 -5.2457001E-01 0.0000000E+00  9.0110000E+00  4.2490000E+00        5
2.6650000E+01 -6.7933232E-02 -4.9624675E-01 0.0000000E+00  7.7950000E+00  4.0070000E+00        6
3.0750000E+01 -5.3393159E-02 -4.6544755E-01 0.0000000E+00  6.5440000E+00  3.7480000E+00        6
3.4850000E+01 -4.0899260E-02 -4.3583519E-01 0.0000000E+00  5.3610000E+00  3.5020000E+00        7
3.8950000E+01 -2.9722933E-02 -4.0591323E-01 0.0000000E+00  4.1880000E+00  3.2560000E+00        7
4.3050000E+01 -2.0511081E-02 -3.7569051E-01 0.0000000E+00  3.1250000E+00  3.0100000E+00        8
4.7150000E+01 -1.3980013E-02 -3.4521705E-01 0.0000000E+00  2.3190000E+00  2.7640000E+00        8
5.1250000E+01 -8.3819737E-03 -3.1463837E-01 0.0000000E+00  1.5260000E+00  2.5180000E+00        8
5.4666700E+01 -4.3546914E-03 -2.8909220E-01 0.0000000E+00  8.6300000E-01  2.3130000E+00        8
5.7400000E+01 -1.6838383E-03 -2.6074456E-01 0.0000000E+00  3.7000000E-01  2.0860000E+00        8
6.0133300E+01 -3.2815226E-04 -1.7737470E-01 0.0000000E+00  1.0600000E-01  1.4190000E+00        8
6.1499900E+01 -3.2815226E-04 -1.7737470E-01 0.0000000E+00  1.0600000E-01  1.4190000E+00        8
        ]
        
        @test isapprox(adblade.BldProps,bldprops,atol=1e-6)
        
    end #End testing ReadADBlade

    @testset "Write ADBlade" begin
        file = "NREL5MWrefAD_blade.dat"
        path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine"
        adbladetemp = of.ReadADBlade(file, path)
        of.WriteADBlade(adbladetemp, "testadblade.dat";outputpath=path)
        adblade = of.ReadADBlade("testadblade.dat", path)

        @test adblade.NumBlNds==19
        bldprops = [
    0.0000000E+00  0.0000000E+00  0.0000000E+00 0.0000000E+00  1.3308000E+01  3.5420000E+00        1
    1.3667000E+00 -8.1531745E-04 -3.4468858E-03 0.0000000E+00  1.3308000E+01  3.5420000E+00        1
    4.1000000E+00 -2.4839790E-02 -1.0501421E-01 0.0000000E+00  1.3308000E+01  3.8540000E+00        1
    6.8333000E+00 -5.9469375E-02 -2.5141635E-01 0.0000000E+00  1.3308000E+01  4.1670000E+00        2
    1.0250000E+01 -1.0909141E-01 -4.6120149E-01 0.0000000E+00  1.3308000E+01  4.5570000E+00        3
    1.4350000E+01 -1.1573354E-01 -5.6986665E-01 0.0000000E+00  1.1480000E+01  4.6520000E+00        4
    1.8450000E+01 -9.8316709E-02 -5.4850833E-01 0.0000000E+00  1.0162000E+01  4.4580000E+00        4
    2.2550000E+01 -8.3186967E-02 -5.2457001E-01 0.0000000E+00  9.0110000E+00  4.2490000E+00        5
    2.6650000E+01 -6.7933232E-02 -4.9624675E-01 0.0000000E+00  7.7950000E+00  4.0070000E+00        6
    3.0750000E+01 -5.3393159E-02 -4.6544755E-01 0.0000000E+00  6.5440000E+00  3.7480000E+00        6
    3.4850000E+01 -4.0899260E-02 -4.3583519E-01 0.0000000E+00  5.3610000E+00  3.5020000E+00        7
    3.8950000E+01 -2.9722933E-02 -4.0591323E-01 0.0000000E+00  4.1880000E+00  3.2560000E+00        7
    4.3050000E+01 -2.0511081E-02 -3.7569051E-01 0.0000000E+00  3.1250000E+00  3.0100000E+00        8
    4.7150000E+01 -1.3980013E-02 -3.4521705E-01 0.0000000E+00  2.3190000E+00  2.7640000E+00        8
    5.1250000E+01 -8.3819737E-03 -3.1463837E-01 0.0000000E+00  1.5260000E+00  2.5180000E+00        8
    5.4666700E+01 -4.3546914E-03 -2.8909220E-01 0.0000000E+00  8.6300000E-01  2.3130000E+00        8
    5.7400000E+01 -1.6838383E-03 -2.6074456E-01 0.0000000E+00  3.7000000E-01  2.0860000E+00        8
    6.0133300E+01 -3.2815226E-04 -1.7737470E-01 0.0000000E+00  1.0600000E-01  1.4190000E+00        8
    6.1499900E+01 -3.2815226E-04 -1.7737470E-01 0.0000000E+00  1.0600000E-01  1.4190000E+00        8
        ]
        
        @test isapprox(adblade.BldProps, bldprops, atol=1e-6)
        



    end #End testing WriteADBlade

    #### Testing ReadAerodata ##########
    ####################################

    @testset "Read Aerodata" begin
    file = "DU21_A17.dat"
    path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine/AeroData"
    aerodata = of.ReadAerodata(file, path)

    @test aerodata.NumAirfoils==1
    @test isapprox(aerodata.TableID,0.0,atol=1e-5)
    @test isapprox(aerodata.Aoa_stall,8.0, atol=1e-5)
    @test isapprox(aerodata.Aoa_0Cn, -5.0609, atol=1e-8)
    @test isapprox(aerodata.dCn_0L, 6.2047, atol=1e-8)
    @test isapprox(aerodata.Cn_stall_positive, 1.4144, atol=1e-5)
    @test isapprox(aerodata.Cn_stall_negative, -0.5324, atol=1e-5)
    @test isapprox(aerodata.Aoa_minCd, -1.50, atol=1e-5)
    @test isapprox(aerodata.Cd_min, 0.0057, atol=1e-5)

    polar = [
        -180.00    0.000   0.0185   0.0000
-175.00    0.394   0.0332   0.1978
-170.00    0.788   0.0945   0.3963
-160.00    0.670   0.2809   0.2738
-155.00    0.749   0.3932   0.3118
-150.00    0.797   0.5112   0.3413
-145.00    0.818   0.6309   0.3636
-140.00    0.813   0.7485   0.3799
-135.00    0.786   0.8612   0.3911
-130.00    0.739   0.9665   0.3980
-125.00    0.675   1.0625   0.4012
-120.00    0.596   1.1476   0.4014
-115.00    0.505   1.2206   0.3990
-110.00    0.403   1.2805   0.3943
-105.00    0.294   1.3265   0.3878
-100.00    0.179   1.3582   0.3796
 -95.00    0.060   1.3752   0.3700
 -90.00   -0.060   1.3774   0.3591
 -85.00   -0.179   1.3648   0.3471
 -80.00   -0.295   1.3376   0.3340
 -75.00   -0.407   1.2962   0.3199
 -70.00   -0.512   1.2409   0.3049
 -65.00   -0.608   1.1725   0.2890
 -60.00   -0.693   1.0919   0.2722
 -55.00   -0.764   1.0002   0.2545
 -50.00   -0.820   0.8990   0.2359
 -45.00   -0.857   0.7900   0.2163
 -40.00   -0.875   0.6754   0.1958
 -35.00   -0.869   0.5579   0.1744
 -30.00   -0.838   0.4405   0.1520
 -25.00   -0.791   0.3256   0.1262
 -24.00   -0.794   0.3013   0.1170
 -23.00   -0.805   0.2762   0.1059
 -22.00   -0.821   0.2506   0.0931
 -21.00   -0.843   0.2246   0.0788
 -20.00   -0.869   0.1983   0.0631
 -19.00   -0.899   0.1720   0.0464
 -18.00   -0.931   0.1457   0.0286
 -17.00   -0.964   0.1197   0.0102
 -16.00   -0.999   0.0940  -0.0088
 -15.00   -1.033   0.0689  -0.0281
 -14.50   -1.050   0.0567  -0.0378
 -12.01   -0.953   0.0271  -0.0349
 -11.00   -0.900   0.0303  -0.0361
  -9.98   -0.827   0.0287  -0.0464
  -8.12   -0.536   0.0124  -0.0821
  -7.62   -0.467   0.0109  -0.0924
  -7.11   -0.393   0.0092  -0.1015
  -6.60   -0.323   0.0083  -0.1073
  -6.50   -0.311   0.0089  -0.1083
  -6.00   -0.245   0.0082  -0.1112
  -5.50   -0.178   0.0074  -0.1146
  -5.00   -0.113   0.0069  -0.1172
  -4.50   -0.048   0.0065  -0.1194
  -4.00    0.016   0.0063  -0.1213
  -3.50    0.080   0.0061  -0.1232
  -3.00    0.145   0.0058  -0.1252
  -2.50    0.208   0.0057  -0.1268
  -2.00    0.270   0.0057  -0.1282
  -1.50    0.333   0.0057  -0.1297
  -1.00    0.396   0.0057  -0.1310
  -0.50    0.458   0.0057  -0.1324
   0.00    0.521   0.0057  -0.1337
   0.50    0.583   0.0057  -0.1350
   1.00    0.645   0.0058  -0.1363
   1.50    0.706   0.0058  -0.1374
   2.00    0.768   0.0059  -0.1385
   2.50    0.828   0.0061  -0.1395
   3.00    0.888   0.0063  -0.1403
   3.50    0.948   0.0066  -0.1406
   4.00    0.996   0.0071  -0.1398
   4.50    1.046   0.0079  -0.1390
   5.00    1.095   0.0090  -0.1378
   5.50    1.145   0.0103  -0.1369
   6.00    1.192   0.0113  -0.1353
   6.50    1.239   0.0122  -0.1338
   7.00    1.283   0.0131  -0.1317
   7.50    1.324   0.0139  -0.1291
   8.00    1.358   0.0147  -0.1249
   8.50    1.385   0.0158  -0.1213
   9.00    1.403   0.0181  -0.1177
   9.50    1.401   0.0211  -0.1142
  10.00    1.358   0.0255  -0.1103
  10.50    1.313   0.0301  -0.1066
  11.00    1.287   0.0347  -0.1032
  11.50    1.274   0.0401  -0.1002
  12.00    1.272   0.0468  -0.0971
  12.50    1.273   0.0545  -0.0940
  13.00    1.273   0.0633  -0.0909
  13.50    1.273   0.0722  -0.0883
  14.00    1.272   0.0806  -0.0865
  14.50    1.273   0.0900  -0.0854
  15.00    1.275   0.0987  -0.0849
  15.50    1.281   0.1075  -0.0847
  16.00    1.284   0.1170  -0.0850
  16.50    1.296   0.1270  -0.0858
  17.00    1.306   0.1368  -0.0869
  17.50    1.308   0.1464  -0.0883
  18.00    1.308   0.1562  -0.0901
  18.50    1.308   0.1664  -0.0922
  19.00    1.308   0.1770  -0.0949
  19.50    1.307   0.1878  -0.0980
  20.00    1.311   0.1987  -0.1017
  20.50    1.325   0.2100  -0.1059
  21.00    1.324   0.2214  -0.1105
  22.00    1.277   0.2499  -0.1172
  23.00    1.229   0.2786  -0.1239
  24.00    1.182   0.3077  -0.1305
  25.00    1.136   0.3371  -0.1370
  26.00    1.093   0.3664  -0.1433
  28.00    1.017   0.4246  -0.1556
  30.00    0.962   0.4813  -0.1671
  32.00    0.937   0.5356  -0.1778
  35.00    0.947   0.6127  -0.1923
  40.00    0.950   0.7396  -0.2154
  45.00    0.928   0.8623  -0.2374
  50.00    0.884   0.9781  -0.2583
  55.00    0.821   1.0846  -0.2782
  60.00    0.740   1.1796  -0.2971
  65.00    0.646   1.2617  -0.3149
  70.00    0.540   1.3297  -0.3318
  75.00    0.425   1.3827  -0.3476
  80.00    0.304   1.4202  -0.3625
  85.00    0.179   1.4423  -0.3763
  90.00    0.053   1.4512  -0.3890
  95.00   -0.073   1.4480  -0.4004
 100.00   -0.198   1.4294  -0.4105
 105.00   -0.319   1.3954  -0.4191
 110.00   -0.434   1.3464  -0.4260
 115.00   -0.541   1.2829  -0.4308
 120.00   -0.637   1.2057  -0.4333
 125.00   -0.720   1.1157  -0.4330
 130.00   -0.787   1.0144  -0.4294
 135.00   -0.836   0.9033  -0.4219
 140.00   -0.864   0.7845  -0.4098
 145.00   -0.869   0.6605  -0.3922
 150.00   -0.847   0.5346  -0.3682
 155.00   -0.795   0.4103  -0.3364
 160.00   -0.711   0.2922  -0.2954
 170.00   -0.788   0.0969  -0.3966
 175.00   -0.394   0.0334  -0.1978
 180.00    0.000   0.0185   0.0000
    ]
    @test isapprox(aerodata.Polar, polar, atol=1e-5)
    end #End testing ReadAerodata

    @testset "Write Aerodata" begin
    file = "DU21_A17.dat"
    path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine/AeroData"
    aerodatatemp = of.ReadAerodata(file, path)
    of.WriteAerodata(aerodatatemp, "testingaerodata.dat")
    aerodata = of.ReadAerodata("testingaerodata.dat", path)

    @test aerodata.NumAirfoils==1
    @test isapprox(aerodata.TableID,0.0,atol=1e-5)
    @test isapprox(aerodata.Aoa_stall,8.0, atol=1e-5)
    @test isapprox(aerodata.Aoa_0Cn, -5.0609, atol=1e-8)
    @test isapprox(aerodata.dCn_0L, 6.2047, atol=1e-8)
    @test isapprox(aerodata.Cn_stall_positive, 1.4144, atol=1e-5)
    @test isapprox(aerodata.Cn_stall_negative, -0.5324, atol=1e-5)
    @test isapprox(aerodata.Aoa_minCd, -1.50, atol=1e-5)
    @test isapprox(aerodata.Cd_min, 0.0057, atol=1e-5)

    polar = [
-180.00    0.000   0.0185   0.0000
-175.00    0.394   0.0332   0.1978
-170.00    0.788   0.0945   0.3963
-160.00    0.670   0.2809   0.2738
-155.00    0.749   0.3932   0.3118
-150.00    0.797   0.5112   0.3413
-145.00    0.818   0.6309   0.3636
-140.00    0.813   0.7485   0.3799
-135.00    0.786   0.8612   0.3911
-130.00    0.739   0.9665   0.3980
-125.00    0.675   1.0625   0.4012
-120.00    0.596   1.1476   0.4014
-115.00    0.505   1.2206   0.3990
-110.00    0.403   1.2805   0.3943
-105.00    0.294   1.3265   0.3878
-100.00    0.179   1.3582   0.3796
 -95.00    0.060   1.3752   0.3700
 -90.00   -0.060   1.3774   0.3591
 -85.00   -0.179   1.3648   0.3471
 -80.00   -0.295   1.3376   0.3340
 -75.00   -0.407   1.2962   0.3199
 -70.00   -0.512   1.2409   0.3049
 -65.00   -0.608   1.1725   0.2890
 -60.00   -0.693   1.0919   0.2722
 -55.00   -0.764   1.0002   0.2545
 -50.00   -0.820   0.8990   0.2359
 -45.00   -0.857   0.7900   0.2163
 -40.00   -0.875   0.6754   0.1958
 -35.00   -0.869   0.5579   0.1744
 -30.00   -0.838   0.4405   0.1520
 -25.00   -0.791   0.3256   0.1262
 -24.00   -0.794   0.3013   0.1170
 -23.00   -0.805   0.2762   0.1059
 -22.00   -0.821   0.2506   0.0931
 -21.00   -0.843   0.2246   0.0788
 -20.00   -0.869   0.1983   0.0631
 -19.00   -0.899   0.1720   0.0464
 -18.00   -0.931   0.1457   0.0286
 -17.00   -0.964   0.1197   0.0102
 -16.00   -0.999   0.0940  -0.0088
 -15.00   -1.033   0.0689  -0.0281
 -14.50   -1.050   0.0567  -0.0378
 -12.01   -0.953   0.0271  -0.0349
 -11.00   -0.900   0.0303  -0.0361
  -9.98   -0.827   0.0287  -0.0464
  -8.12   -0.536   0.0124  -0.0821
  -7.62   -0.467   0.0109  -0.0924
  -7.11   -0.393   0.0092  -0.1015
  -6.60   -0.323   0.0083  -0.1073
  -6.50   -0.311   0.0089  -0.1083
  -6.00   -0.245   0.0082  -0.1112
  -5.50   -0.178   0.0074  -0.1146
  -5.00   -0.113   0.0069  -0.1172
  -4.50   -0.048   0.0065  -0.1194
  -4.00    0.016   0.0063  -0.1213
  -3.50    0.080   0.0061  -0.1232
  -3.00    0.145   0.0058  -0.1252
  -2.50    0.208   0.0057  -0.1268
  -2.00    0.270   0.0057  -0.1282
  -1.50    0.333   0.0057  -0.1297
  -1.00    0.396   0.0057  -0.1310
  -0.50    0.458   0.0057  -0.1324
   0.00    0.521   0.0057  -0.1337
   0.50    0.583   0.0057  -0.1350
   1.00    0.645   0.0058  -0.1363
   1.50    0.706   0.0058  -0.1374
   2.00    0.768   0.0059  -0.1385
   2.50    0.828   0.0061  -0.1395
   3.00    0.888   0.0063  -0.1403
   3.50    0.948   0.0066  -0.1406
   4.00    0.996   0.0071  -0.1398
   4.50    1.046   0.0079  -0.1390
   5.00    1.095   0.0090  -0.1378
   5.50    1.145   0.0103  -0.1369
   6.00    1.192   0.0113  -0.1353
   6.50    1.239   0.0122  -0.1338
   7.00    1.283   0.0131  -0.1317
   7.50    1.324   0.0139  -0.1291
   8.00    1.358   0.0147  -0.1249
   8.50    1.385   0.0158  -0.1213
   9.00    1.403   0.0181  -0.1177
   9.50    1.401   0.0211  -0.1142
  10.00    1.358   0.0255  -0.1103
  10.50    1.313   0.0301  -0.1066
  11.00    1.287   0.0347  -0.1032
  11.50    1.274   0.0401  -0.1002
  12.00    1.272   0.0468  -0.0971
  12.50    1.273   0.0545  -0.0940
  13.00    1.273   0.0633  -0.0909
  13.50    1.273   0.0722  -0.0883
  14.00    1.272   0.0806  -0.0865
  14.50    1.273   0.0900  -0.0854
  15.00    1.275   0.0987  -0.0849
  15.50    1.281   0.1075  -0.0847
  16.00    1.284   0.1170  -0.0850
  16.50    1.296   0.1270  -0.0858
  17.00    1.306   0.1368  -0.0869
  17.50    1.308   0.1464  -0.0883
  18.00    1.308   0.1562  -0.0901
  18.50    1.308   0.1664  -0.0922
  19.00    1.308   0.1770  -0.0949
  19.50    1.307   0.1878  -0.0980
  20.00    1.311   0.1987  -0.1017
  20.50    1.325   0.2100  -0.1059
  21.00    1.324   0.2214  -0.1105
  22.00    1.277   0.2499  -0.1172
  23.00    1.229   0.2786  -0.1239
  24.00    1.182   0.3077  -0.1305
  25.00    1.136   0.3371  -0.1370
  26.00    1.093   0.3664  -0.1433
  28.00    1.017   0.4246  -0.1556
  30.00    0.962   0.4813  -0.1671
  32.00    0.937   0.5356  -0.1778
  35.00    0.947   0.6127  -0.1923
  40.00    0.950   0.7396  -0.2154
  45.00    0.928   0.8623  -0.2374
  50.00    0.884   0.9781  -0.2583
  55.00    0.821   1.0846  -0.2782
  60.00    0.740   1.1796  -0.2971
  65.00    0.646   1.2617  -0.3149
  70.00    0.540   1.3297  -0.3318
  75.00    0.425   1.3827  -0.3476
  80.00    0.304   1.4202  -0.3625
  85.00    0.179   1.4423  -0.3763
  90.00    0.053   1.4512  -0.3890
  95.00   -0.073   1.4480  -0.4004
 100.00   -0.198   1.4294  -0.4105
 105.00   -0.319   1.3954  -0.4191
 110.00   -0.434   1.3464  -0.4260
 115.00   -0.541   1.2829  -0.4308
 120.00   -0.637   1.2057  -0.4333
 125.00   -0.720   1.1157  -0.4330
 130.00   -0.787   1.0144  -0.4294
 135.00   -0.836   0.9033  -0.4219
 140.00   -0.864   0.7845  -0.4098
 145.00   -0.869   0.6605  -0.3922
 150.00   -0.847   0.5346  -0.3682
 155.00   -0.795   0.4103  -0.3364
 160.00   -0.711   0.2922  -0.2954
 170.00   -0.788   0.0969  -0.3966
 175.00   -0.394   0.0334  -0.1978
 180.00    0.000   0.0185   0.0000]
    @test isapprox(aerodata.Polar, polar, atol=1e-4)
    end # End testing write aerodata

    @testset "Read AirfoilInput" begin
        file = "DU25_A17.dat"
        path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine/Airfoils"
        input = of.ReadAirfoilInput(file, path)

        @test lowercase(input.InterpOrd)=="default"
        @test input.NonDimArea==1
        @test input.NumCoords=="@\"DU25_A17_coords.txt\""
        @test input.NumTabs==1
        @test isapprox(input.Re,0.75, atol=1e-5)
        @test input.UserProp==0
        @test lowercase(input.InclUAdata)=="true"
        @test isapprox(input.alpha0,-3.2,atol=1e-5)
        @test isapprox(input.alpha1,8.5, atol=1e-5)
        @test isapprox(input.alpha2,-8.5, atol=1e-5)
        @test isapprox(input.eta_e,1, atol=1e-5)
        @test isapprox(input.C_nalpha,6.4462, atol=1e-5)
        @test isapprox(input.T_f0,3,atol=1e-5)
        @test isapprox(input.T_V0,6, atol=1e-5)
        @test isapprox(input.T_p,1.7, atol=1e-5)
        @test isapprox(input.T_VL,11, atol=1e-5)
        @test isapprox(input.b1,0.14, atol=1e-5)
        @test isapprox(input.b2,0.53,atol=1e-5)
        @test isapprox(input.b5,5, atol=1e-5)
        @test isapprox(input.A1,0.3, atol=1e-5)
        @test isapprox(input.A2,0.7, atol=1e-5)
        @test isapprox(input.A5,1, atol=1e-5)
        @test isapprox(input.S1,0.0,atol=1e-5)
        @test isapprox(input.S2,0, atol=1e-5)
        @test isapprox(input.S3,0, atol=1e-5)
        @test isapprox(input.S4,0, atol=1e-5)
        @test isapprox(input.Cn1,1.4336, atol=1e-5)
        @test isapprox(input.Cn2,-0.6873,atol=1e-5)
        @test isapprox(input.St_sh,0.19, atol=1e-5)
        @test isapprox(input.Cd0,0.006, atol=1e-5)
        @test isapprox(input.Cm0,-0.12, atol=1e-5)
        @test isapprox(input.k0,0, atol=1e-5)
        @test isapprox(input.k1,0,atol=1e-5)
        @test isapprox(input.k2,0, atol=1e-5)
        @test isapprox(input.k3,0, atol=1e-5)
        @test isapprox(input.k1_hat,0, atol=1e-5)
        @test isapprox(input.x_cp_bar,0.2, atol=1e-5)
        @test lowercase(input.UACutout)=="\"default\""
        @test lowercase(input.filtCutOff)=="\"default\""
        @test input.NumAlf==140

        polar = [
            -180.00    0.000   0.0202   0.0000
            -175.00    0.368   0.0324   0.1845
            -170.00    0.735   0.0943   0.3701
            -160.00    0.695   0.2848   0.2679
            -155.00    0.777   0.4001   0.3046
            -150.00    0.828   0.5215   0.3329
            -145.00    0.850   0.6447   0.3540
            -140.00    0.846   0.7660   0.3693
            -135.00    0.818   0.8823   0.3794
            -130.00    0.771   0.9911   0.3854
            -125.00    0.705   1.0905   0.3878
            -120.00    0.624   1.1787   0.3872
            -115.00    0.530   1.2545   0.3841
            -110.00    0.426   1.3168   0.3788
            -105.00    0.314   1.3650   0.3716
            -100.00    0.195   1.3984   0.3629
             -95.00    0.073   1.4169   0.3529
             -90.00   -0.050   1.4201   0.3416
             -85.00   -0.173   1.4081   0.3292
             -80.00   -0.294   1.3811   0.3159
             -75.00   -0.409   1.3394   0.3017
             -70.00   -0.518   1.2833   0.2866
             -65.00   -0.617   1.2138   0.2707
             -60.00   -0.706   1.1315   0.2539
             -55.00   -0.780   1.0378   0.2364
             -50.00   -0.839   0.9341   0.2181
             -45.00   -0.879   0.8221   0.1991
             -40.00   -0.898   0.7042   0.1792
             -35.00   -0.893   0.5829   0.1587
             -30.00   -0.862   0.4616   0.1374
             -25.00   -0.803   0.3441   0.1154
             -24.00   -0.792   0.3209   0.1101
             -23.00   -0.789   0.2972   0.1031
             -22.00   -0.792   0.2730   0.0947
             -21.00   -0.801   0.2485   0.0849
             -20.00   -0.815   0.2237   0.0739
             -19.00   -0.833   0.1990   0.0618
             -18.00   -0.854   0.1743   0.0488
             -17.00   -0.879   0.1498   0.0351
             -16.00   -0.905   0.1256   0.0208
             -15.00   -0.932   0.1020   0.0060
             -14.00   -0.959   0.0789  -0.0091
             -13.00   -0.985   0.0567  -0.0243
             -12.01   -0.953   0.0271  -0.0349
             -11.00   -0.900   0.0303  -0.0361
              -9.98   -0.827   0.0287  -0.0464
              -8.98   -0.753   0.0271  -0.0534
              -8.47   -0.691   0.0264  -0.0650
              -7.45   -0.555   0.0114  -0.0782
              -6.42   -0.413   0.0094  -0.0904
              -5.40   -0.271   0.0086  -0.1006
              -5.00   -0.220   0.0073  -0.1107
              -4.50   -0.152   0.0071  -0.1135
              -4.00   -0.084   0.0070  -0.1162
              -3.50   -0.018   0.0069  -0.1186
              -3.00    0.049   0.0068  -0.1209
              -2.50    0.115   0.0068  -0.1231
              -2.00    0.181   0.0068  -0.1252
              -1.50    0.247   0.0067  -0.1272
              -1.00    0.312   0.0067  -0.1293
              -0.50    0.377   0.0067  -0.1311
               0.00    0.444   0.0065  -0.1330
               0.50    0.508   0.0065  -0.1347
               1.00    0.573   0.0066  -0.1364
               1.50    0.636   0.0067  -0.1380
               2.00    0.701   0.0068  -0.1396
               2.50    0.765   0.0069  -0.1411
               3.00    0.827   0.0070  -0.1424
               3.50    0.890   0.0071  -0.1437
               4.00    0.952   0.0073  -0.1448
               4.50    1.013   0.0076  -0.1456
               5.00    1.062   0.0079  -0.1445
               6.00    1.161   0.0099  -0.1419
               6.50    1.208   0.0117  -0.1403
               7.00    1.254   0.0132  -0.1382
               7.50    1.301   0.0143  -0.1362
               8.00    1.336   0.0153  -0.1320
               8.50    1.369   0.0165  -0.1276
               9.00    1.400   0.0181  -0.1234
               9.50    1.428   0.0211  -0.1193
              10.00    1.442   0.0262  -0.1152
              10.50    1.427   0.0336  -0.1115
              11.00    1.374   0.0420  -0.1081
              11.50    1.316   0.0515  -0.1052
              12.00    1.277   0.0601  -0.1026
              12.50    1.250   0.0693  -0.1000
              13.00    1.246   0.0785  -0.0980
              13.50    1.247   0.0888  -0.0969
              14.00    1.256   0.1000  -0.0968
              14.50    1.260   0.1108  -0.0973
              15.00    1.271   0.1219  -0.0981
              15.50    1.281   0.1325  -0.0992
              16.00    1.289   0.1433  -0.1006
              16.50    1.294   0.1541  -0.1023
              17.00    1.304   0.1649  -0.1042
              17.50    1.309   0.1754  -0.1064
              18.00    1.315   0.1845  -0.1082
              18.50    1.320   0.1953  -0.1110
              19.00    1.330   0.2061  -0.1143
              19.50    1.343   0.2170  -0.1179
              20.00    1.354   0.2280  -0.1219
              20.50    1.359   0.2390  -0.1261
              21.00    1.360   0.2536  -0.1303
              22.00    1.325   0.2814  -0.1375
              23.00    1.288   0.3098  -0.1446
              24.00    1.251   0.3386  -0.1515
              25.00    1.215   0.3678  -0.1584
              26.00    1.181   0.3972  -0.1651
              28.00    1.120   0.4563  -0.1781
              30.00    1.076   0.5149  -0.1904
              32.00    1.056   0.5720  -0.2017
              35.00    1.066   0.6548  -0.2173
              40.00    1.064   0.7901  -0.2418
              45.00    1.035   0.9190  -0.2650
              50.00    0.980   1.0378  -0.2867
              55.00    0.904   1.1434  -0.3072
              60.00    0.810   1.2333  -0.3265
              65.00    0.702   1.3055  -0.3446
              70.00    0.582   1.3587  -0.3616
              75.00    0.456   1.3922  -0.3775
              80.00    0.326   1.4063  -0.3921
              85.00    0.197   1.4042  -0.4057
              90.00    0.072   1.3985  -0.4180
              95.00   -0.050   1.3973  -0.4289
             100.00   -0.170   1.3810  -0.4385
             105.00   -0.287   1.3498  -0.4464
             110.00   -0.399   1.3041  -0.4524
             115.00   -0.502   1.2442  -0.4563
             120.00   -0.596   1.1709  -0.4577
             125.00   -0.677   1.0852  -0.4563
             130.00   -0.743   0.9883  -0.4514
             135.00   -0.792   0.8818  -0.4425
             140.00   -0.821   0.7676  -0.4288
             145.00   -0.826   0.6481  -0.4095
             150.00   -0.806   0.5264  -0.3836
             155.00   -0.758   0.4060  -0.3497
             160.00   -0.679   0.2912  -0.3065
             170.00   -0.735   0.0995  -0.3706
             175.00   -0.368   0.0356  -0.1846
             180.00    0.000   0.0202   0.0000         
        ]
        @test input.Polar==polar
    end # End testing Read AirfoilInput

    @testset "Write AirfoilInput" begin
    file = "DU25_A17.dat"
    path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine/Airfoils"
    inputtemp = of.ReadAirfoilInput(file, path)
    of.WriteAirfoilInput(inputtemp, "testingwriteairfoilinput.dat")
    input = of.ReadAirfoilInput("testingwriteairfoilinput.dat", path)

    @test lowercase(input.InterpOrd)=="default"
    @test input.NonDimArea==1
    @test input.NumCoords=="@\"DU25_A17_coords.txt\""
    @test input.NumTabs==1
    @test isapprox(input.Re,0.75, atol=1e-5)
    @test input.UserProp==0
    @test lowercase(input.InclUAdata)=="true"
    @test isapprox(input.alpha0,-3.2,atol=1e-5)
    @test isapprox(input.alpha1,8.5, atol=1e-5)
    @test isapprox(input.alpha2,-8.5, atol=1e-5)
    @test isapprox(input.eta_e,1, atol=1e-5)
    @test isapprox(input.C_nalpha,6.4462, atol=1e-5)
    @test isapprox(input.T_f0,3,atol=1e-5)
    @test isapprox(input.T_V0,6, atol=1e-5)
    @test isapprox(input.T_p,1.7, atol=1e-5)
    @test isapprox(input.T_VL,11, atol=1e-5)
    @test isapprox(input.b1,0.14, atol=1e-5)
    @test isapprox(input.b2,0.53,atol=1e-5)
    @test isapprox(input.b5,5, atol=1e-5)
    @test isapprox(input.A1,0.3, atol=1e-5)
    @test isapprox(input.A2,0.7, atol=1e-5)
    @test isapprox(input.A5,1, atol=1e-5)
    @test isapprox(input.S1,0.0,atol=1e-5)
    @test isapprox(input.S2,0, atol=1e-5)
    @test isapprox(input.S3,0, atol=1e-5)
    @test isapprox(input.S4,0, atol=1e-5)
    @test isapprox(input.Cn1,1.4336, atol=1e-5)
    @test isapprox(input.Cn2,-0.6873,atol=1e-5)
    @test isapprox(input.St_sh,0.19, atol=1e-5)
    @test isapprox(input.Cd0,0.006, atol=1e-5)
    @test isapprox(input.Cm0,-0.12, atol=1e-5)
    @test isapprox(input.k0,0, atol=1e-5)
    @test isapprox(input.k1,0,atol=1e-5)
    @test isapprox(input.k2,0, atol=1e-5)
    @test isapprox(input.k3,0, atol=1e-5)
    @test isapprox(input.k1_hat,0, atol=1e-5)
    @test isapprox(input.x_cp_bar,0.2, atol=1e-5)
    @test lowercase(input.UACutout)=="\"default\""
    @test lowercase(input.filtCutOff)=="\"default\""
    @test input.NumAlf==140

    polar = [
        -180.00    0.000   0.0202   0.0000
        -175.00    0.368   0.0324   0.1845
        -170.00    0.735   0.0943   0.3701
        -160.00    0.695   0.2848   0.2679
        -155.00    0.777   0.4001   0.3046
        -150.00    0.828   0.5215   0.3329
        -145.00    0.850   0.6447   0.3540
        -140.00    0.846   0.7660   0.3693
        -135.00    0.818   0.8823   0.3794
        -130.00    0.771   0.9911   0.3854
        -125.00    0.705   1.0905   0.3878
        -120.00    0.624   1.1787   0.3872
        -115.00    0.530   1.2545   0.3841
        -110.00    0.426   1.3168   0.3788
        -105.00    0.314   1.3650   0.3716
        -100.00    0.195   1.3984   0.3629
         -95.00    0.073   1.4169   0.3529
         -90.00   -0.050   1.4201   0.3416
         -85.00   -0.173   1.4081   0.3292
         -80.00   -0.294   1.3811   0.3159
         -75.00   -0.409   1.3394   0.3017
         -70.00   -0.518   1.2833   0.2866
         -65.00   -0.617   1.2138   0.2707
         -60.00   -0.706   1.1315   0.2539
         -55.00   -0.780   1.0378   0.2364
         -50.00   -0.839   0.9341   0.2181
         -45.00   -0.879   0.8221   0.1991
         -40.00   -0.898   0.7042   0.1792
         -35.00   -0.893   0.5829   0.1587
         -30.00   -0.862   0.4616   0.1374
         -25.00   -0.803   0.3441   0.1154
         -24.00   -0.792   0.3209   0.1101
         -23.00   -0.789   0.2972   0.1031
         -22.00   -0.792   0.2730   0.0947
         -21.00   -0.801   0.2485   0.0849
         -20.00   -0.815   0.2237   0.0739
         -19.00   -0.833   0.1990   0.0618
         -18.00   -0.854   0.1743   0.0488
         -17.00   -0.879   0.1498   0.0351
         -16.00   -0.905   0.1256   0.0208
         -15.00   -0.932   0.1020   0.0060
         -14.00   -0.959   0.0789  -0.0091
         -13.00   -0.985   0.0567  -0.0243
         -12.01   -0.953   0.0271  -0.0349
         -11.00   -0.900   0.0303  -0.0361
          -9.98   -0.827   0.0287  -0.0464
          -8.98   -0.753   0.0271  -0.0534
          -8.47   -0.691   0.0264  -0.0650
          -7.45   -0.555   0.0114  -0.0782
          -6.42   -0.413   0.0094  -0.0904
          -5.40   -0.271   0.0086  -0.1006
          -5.00   -0.220   0.0073  -0.1107
          -4.50   -0.152   0.0071  -0.1135
          -4.00   -0.084   0.0070  -0.1162
          -3.50   -0.018   0.0069  -0.1186
          -3.00    0.049   0.0068  -0.1209
          -2.50    0.115   0.0068  -0.1231
          -2.00    0.181   0.0068  -0.1252
          -1.50    0.247   0.0067  -0.1272
          -1.00    0.312   0.0067  -0.1293
          -0.50    0.377   0.0067  -0.1311
           0.00    0.444   0.0065  -0.1330
           0.50    0.508   0.0065  -0.1347
           1.00    0.573   0.0066  -0.1364
           1.50    0.636   0.0067  -0.1380
           2.00    0.701   0.0068  -0.1396
           2.50    0.765   0.0069  -0.1411
           3.00    0.827   0.0070  -0.1424
           3.50    0.890   0.0071  -0.1437
           4.00    0.952   0.0073  -0.1448
           4.50    1.013   0.0076  -0.1456
           5.00    1.062   0.0079  -0.1445
           6.00    1.161   0.0099  -0.1419
           6.50    1.208   0.0117  -0.1403
           7.00    1.254   0.0132  -0.1382
           7.50    1.301   0.0143  -0.1362
           8.00    1.336   0.0153  -0.1320
           8.50    1.369   0.0165  -0.1276
           9.00    1.400   0.0181  -0.1234
           9.50    1.428   0.0211  -0.1193
          10.00    1.442   0.0262  -0.1152
          10.50    1.427   0.0336  -0.1115
          11.00    1.374   0.0420  -0.1081
          11.50    1.316   0.0515  -0.1052
          12.00    1.277   0.0601  -0.1026
          12.50    1.250   0.0693  -0.1000
          13.00    1.246   0.0785  -0.0980
          13.50    1.247   0.0888  -0.0969
          14.00    1.256   0.1000  -0.0968
          14.50    1.260   0.1108  -0.0973
          15.00    1.271   0.1219  -0.0981
          15.50    1.281   0.1325  -0.0992
          16.00    1.289   0.1433  -0.1006
          16.50    1.294   0.1541  -0.1023
          17.00    1.304   0.1649  -0.1042
          17.50    1.309   0.1754  -0.1064
          18.00    1.315   0.1845  -0.1082
          18.50    1.320   0.1953  -0.1110
          19.00    1.330   0.2061  -0.1143
          19.50    1.343   0.2170  -0.1179
          20.00    1.354   0.2280  -0.1219
          20.50    1.359   0.2390  -0.1261
          21.00    1.360   0.2536  -0.1303
          22.00    1.325   0.2814  -0.1375
          23.00    1.288   0.3098  -0.1446
          24.00    1.251   0.3386  -0.1515
          25.00    1.215   0.3678  -0.1584
          26.00    1.181   0.3972  -0.1651
          28.00    1.120   0.4563  -0.1781
          30.00    1.076   0.5149  -0.1904
          32.00    1.056   0.5720  -0.2017
          35.00    1.066   0.6548  -0.2173
          40.00    1.064   0.7901  -0.2418
          45.00    1.035   0.9190  -0.2650
          50.00    0.980   1.0378  -0.2867
          55.00    0.904   1.1434  -0.3072
          60.00    0.810   1.2333  -0.3265
          65.00    0.702   1.3055  -0.3446
          70.00    0.582   1.3587  -0.3616
          75.00    0.456   1.3922  -0.3775
          80.00    0.326   1.4063  -0.3921
          85.00    0.197   1.4042  -0.4057
          90.00    0.072   1.3985  -0.4180
          95.00   -0.050   1.3973  -0.4289
         100.00   -0.170   1.3810  -0.4385
         105.00   -0.287   1.3498  -0.4464
         110.00   -0.399   1.3041  -0.4524
         115.00   -0.502   1.2442  -0.4563
         120.00   -0.596   1.1709  -0.4577
         125.00   -0.677   1.0852  -0.4563
         130.00   -0.743   0.9883  -0.4514
         135.00   -0.792   0.8818  -0.4425
         140.00   -0.821   0.7676  -0.4288
         145.00   -0.826   0.6481  -0.4095
         150.00   -0.806   0.5264  -0.3836
         155.00   -0.758   0.4060  -0.3497
         160.00   -0.679   0.2912  -0.3065
         170.00   -0.735   0.0995  -0.3706
         175.00   -0.368   0.0356  -0.1846
         180.00    0.000   0.0202   0.0000         
    ]
    @test input.Polar==polar

    end #End testing write airfoilInput

    @testset "Read Airfoil Coordinate" begin
    file = "DU35_A17_coords.txt"
    path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine/Airfoils"
    coords = of.ReadAirfoilCoordinates(file, path)

    @test coords.NumCoords==400
    afref = [0.25 0]
    @test isapprox(coords.AirfoilReference, afref, atol=1e-5)
    coordinates = [
1.00000   0.00283
0.99660   0.00378
0.99314   0.00477
0.98961   0.00578
0.98601   0.00683
0.98235   0.00789
0.97863   0.00897
0.97484   0.01006
0.97098   0.01116
0.96706   0.01228
0.96307   0.01342
0.95902   0.01456
0.95490   0.01571
0.95072   0.01688
0.94647   0.01806
0.94216   0.01926
0.93778   0.02046
0.93333   0.02169
0.92882   0.02292
0.92425   0.02419
0.91961   0.02547
0.91490   0.02675
0.91013   0.02807
0.90529   0.02941
0.90039   0.03077
0.89542   0.03214
0.89039   0.03353
0.88529   0.03495
0.88013   0.03638
0.87490   0.03782
0.86961   0.03929
0.86425   0.04079
0.85882   0.04230
0.85333   0.04383
0.84778   0.04538
0.84216   0.04694
0.83647   0.04853
0.83072   0.05013
0.82490   0.05176
0.81902   0.05340
0.81307   0.05506
0.80706   0.05673
0.80098   0.05842
0.79484   0.06013
0.78863   0.06184
0.78235   0.06358
0.77601   0.06531
0.76961   0.06708
0.76314   0.06885
0.75660   0.07064
0.75000   0.07244
0.74333   0.07426
0.73667   0.07606
0.73000   0.07786
0.72333   0.07966
0.71667   0.08144
0.71000   0.08322
0.70333   0.08498
0.69667   0.08674
0.69000   0.08849
0.68333   0.09022
0.67667   0.09196
0.67000   0.09368
0.66333   0.09539
0.65667   0.09708
0.65000   0.09876
0.64333   0.10044
0.63667   0.10210
0.63000   0.10375
0.62333   0.10538
0.61667   0.10699
0.61000   0.10859
0.60333   0.11017
0.59667   0.11174
0.59000   0.11330
0.58333   0.11483
0.57667   0.11634
0.57000   0.11784
0.56333   0.11931
0.55667   0.12077
0.55000   0.12220
0.54333   0.12363
0.53667   0.12502
0.53000   0.12639
0.52333   0.12775
0.51667   0.12907
0.51000   0.13037
0.50333   0.13165
0.49667   0.13289
0.49000   0.13411
0.48333   0.13531
0.47667   0.13648
0.47000   0.13761
0.46333   0.13873
0.45667   0.13980
0.45000   0.14086
0.44333   0.14189
0.43667   0.14288
0.43000   0.14384
0.42333   0.14477
0.41667   0.14566
0.41000   0.14653
0.40333   0.14736
0.39667   0.14814
0.39000   0.14889
0.38333   0.14960
0.37667   0.15028
0.37000   0.15091
0.36333   0.15151
0.35667   0.15207
0.35000   0.15258
0.34333   0.15306
0.33667   0.15351
0.33000   0.15391
0.32333   0.15426
0.31667   0.15457
0.31000   0.15482
0.30333   0.15502
0.29667   0.15516
0.29000   0.15524
0.28333   0.15525
0.27667   0.15520
0.27000   0.15507
0.26333   0.15486
0.25667   0.15457
0.25000   0.15419
0.24342   0.15372
0.23693   0.15316
0.23053   0.15250
0.22421   0.15175
0.21798   0.15094
0.21184   0.15002
0.20579   0.14904
0.19982   0.14798
0.19395   0.14686
0.18816   0.14566
0.18245   0.14439
0.17684   0.14308
0.17131   0.14169
0.16587   0.14025
0.16052   0.13875
0.15526   0.13721
0.15008   0.13561
0.14499   0.13396
0.13999   0.13226
0.13508   0.13052
0.13026   0.12873
0.12552   0.12689
0.12087   0.12502
0.11631   0.12311
0.11183   0.12115
0.10745   0.11917
0.10315   0.11715
0.09893   0.11509
0.09481   0.11299
0.09077   0.11087
0.08683   0.10871
0.08297   0.10652
0.07919   0.10430
0.07551   0.10207
0.07191   0.09979
0.06840   0.09750
0.06498   0.09517
0.06164   0.09284
0.05840   0.09048
0.05524   0.08809
0.05217   0.08569
0.04918   0.08327
0.04629   0.08084
0.04348   0.07839
0.04076   0.07592
0.03812   0.07345
0.03558   0.07096
0.03312   0.06847
0.03075   0.06597
0.02847   0.06348
0.02627   0.06097
0.02417   0.05847
0.02215   0.05596
0.02022   0.05344
0.01837   0.05091
0.01662   0.04841
0.01495   0.04589
0.01337   0.04339
0.01187   0.04088
0.01047   0.03840
0.00915   0.03591
0.00792   0.03343
0.00678   0.03096
0.00572   0.02845
0.00476   0.02592
0.00388   0.02329
0.00309   0.02056
0.00238   0.01774
0.00177   0.01503
0.00124   0.01240
0.00080   0.00990
0.00044   0.00733
0.00018   0.00465
0.00000   0.00000
0.00018  -0.00461
0.00044  -0.00726
0.00080  -0.00990
0.00124  -0.01246
0.00177  -0.01509
0.00238  -0.01776
0.00309  -0.02049
0.00388  -0.02317
0.00476  -0.02585
0.00572  -0.02848
0.00678  -0.03112
0.00792  -0.03376
0.00915  -0.03642
0.01047  -0.03911
0.01187  -0.04178
0.01337  -0.04450
0.01495  -0.04721
0.01662  -0.04995
0.01837  -0.05269
0.02022  -0.05547
0.02215  -0.05825
0.02417  -0.06105
0.02627  -0.06386
0.02847  -0.06670
0.03075  -0.06955
0.03312  -0.07244
0.03558  -0.07536
0.03812  -0.07828
0.04076  -0.08125
0.04348  -0.08422
0.04629  -0.08720
0.04918  -0.09020
0.05217  -0.09321
0.05524  -0.09622
0.05840  -0.09925
0.06164  -0.10225
0.06498  -0.10528
0.06840  -0.10829
0.07191  -0.11131
0.07551  -0.11431
0.07919  -0.11730
0.08297  -0.12028
0.08683  -0.12325
0.09077  -0.12619
0.09481  -0.12914
0.09893  -0.13205
0.10315  -0.13494
0.10745  -0.13780
0.11183  -0.14065
0.11631  -0.14345
0.12087  -0.14624
0.12552  -0.14898
0.13026  -0.15169
0.13508  -0.15435
0.13999  -0.15697
0.14499  -0.15954
0.15008  -0.16207
0.15526  -0.16454
0.16052  -0.16696
0.16587  -0.16932
0.17131  -0.17163
0.17684  -0.17387
0.18245  -0.17603
0.18816  -0.17814
0.19395  -0.18015
0.19982  -0.18207
0.20579  -0.18391
0.21184  -0.18564
0.21798  -0.18727
0.22421  -0.18877
0.23053  -0.19015
0.23693  -0.19140
0.24342  -0.19250
0.25000  -0.19343
0.25667  -0.19420
0.26333  -0.19481
0.27000  -0.19525
0.27667  -0.19552
0.28333  -0.19562
0.29000  -0.19556
0.29667  -0.19535
0.30333  -0.19498
0.31000  -0.19448
0.31667  -0.19383
0.32333  -0.19303
0.33000  -0.19211
0.33667  -0.19107
0.34333  -0.18991
0.35000  -0.18864
0.35667  -0.18725
0.36333  -0.18577
0.37000  -0.18418
0.37667  -0.18251
0.38333  -0.18074
0.39000  -0.17889
0.39667  -0.17695
0.40333  -0.17496
0.41000  -0.17288
0.41667  -0.17074
0.42333  -0.16855
0.43000  -0.16631
0.43667  -0.16402
0.44333  -0.16167
0.45000  -0.15929
0.45667  -0.15684
0.46333  -0.15436
0.47000  -0.15185
0.47667  -0.14930
0.48333  -0.14671
0.49000  -0.14410
0.49667  -0.14147
0.50333  -0.13881
0.51000  -0.13613
0.51667  -0.13342
0.52333  -0.13071
0.53000  -0.12797
0.53667  -0.12522
0.54333  -0.12247
0.55000  -0.11970
0.55667  -0.11692
0.56333  -0.11413
0.57000  -0.11133
0.57667  -0.10853
0.58333  -0.10573
0.59000  -0.10293
0.59667  -0.10014
0.60333  -0.09734
0.61000  -0.09456
0.61667  -0.09178
0.62333  -0.08901
0.63000  -0.08624
0.63667  -0.08348
0.64333  -0.08074
0.65000  -0.07801
0.65667  -0.07529
0.66333  -0.07257
0.67000  -0.06987
0.67667  -0.06719
0.68333  -0.06452
0.69000  -0.06186
0.69667  -0.05922
0.70333  -0.05661
0.71000  -0.05401
0.71667  -0.05144
0.72333  -0.04889
0.73000  -0.04637
0.73667  -0.04386
0.74333  -0.04140
0.75000  -0.03896
0.75660  -0.03658
0.76314  -0.03425
0.76961  -0.03199
0.77601  -0.02979
0.78235  -0.02765
0.78863  -0.02557
0.79484  -0.02357
0.80098  -0.02162
0.80706  -0.01974
0.81307  -0.01794
0.81902  -0.01621
0.82490  -0.01454
0.83072  -0.01294
0.83647  -0.01142
0.84216  -0.00996
0.84778  -0.00858
0.85333  -0.00727
0.85882  -0.00604
0.86425  -0.00487
0.86961  -0.00377
0.87490  -0.00276
0.88013  -0.00182
0.88529  -0.00095
0.89039  -0.00014
0.89542   0.00061
0.90039   0.00128
0.90529   0.00189
0.91013   0.00243
0.91490   0.00293
0.91961   0.00335
0.92425   0.00370
0.92882   0.00401
0.93333   0.00425
0.93778   0.00441
0.94216   0.00452
0.94647   0.00455
0.95072   0.00451
0.95490   0.00439
0.95902   0.00420
0.96307   0.00394
0.96706   0.00358
0.97098   0.00315
0.97484   0.00264
0.97863   0.00206
0.98235   0.00141
0.98601   0.00069
0.98961  -0.00011
0.99314  -0.00097
0.99660  -0.00190
1.00000  -0.00283
    ]
    @test isapprox(coords.Coordinates, coordinates, atol=1e-8)

    end #End testing read airfoil coordinates

    @testset "Write airfoil coordinates" begin
    file = "DU35_A17_coords.txt"
    path = joinpath(dirname(pathof(OpenFASTsr)))[1:end-3]*"test/data/5MWturbine/Airfoils"
    coordstemp = of.ReadAirfoilCoordinates(file, path)
    of.WriteAirfoilCoordinates(coordstemp, "testingairfoilcoords.txt")
    coords = of.ReadAirfoilCoordinates("testingairfoilcoords.txt", path)

    @test coords.NumCoords==400
    afref = [0.25 0]
    @test isapprox(coords.AirfoilReference, afref, atol=1e-5)
    coordinates = [
1.00000   0.00283
0.99660   0.00378
0.99314   0.00477
0.98961   0.00578
0.98601   0.00683
0.98235   0.00789
0.97863   0.00897
0.97484   0.01006
0.97098   0.01116
0.96706   0.01228
0.96307   0.01342
0.95902   0.01456
0.95490   0.01571
0.95072   0.01688
0.94647   0.01806
0.94216   0.01926
0.93778   0.02046
0.93333   0.02169
0.92882   0.02292
0.92425   0.02419
0.91961   0.02547
0.91490   0.02675
0.91013   0.02807
0.90529   0.02941
0.90039   0.03077
0.89542   0.03214
0.89039   0.03353
0.88529   0.03495
0.88013   0.03638
0.87490   0.03782
0.86961   0.03929
0.86425   0.04079
0.85882   0.04230
0.85333   0.04383
0.84778   0.04538
0.84216   0.04694
0.83647   0.04853
0.83072   0.05013
0.82490   0.05176
0.81902   0.05340
0.81307   0.05506
0.80706   0.05673
0.80098   0.05842
0.79484   0.06013
0.78863   0.06184
0.78235   0.06358
0.77601   0.06531
0.76961   0.06708
0.76314   0.06885
0.75660   0.07064
0.75000   0.07244
0.74333   0.07426
0.73667   0.07606
0.73000   0.07786
0.72333   0.07966
0.71667   0.08144
0.71000   0.08322
0.70333   0.08498
0.69667   0.08674
0.69000   0.08849
0.68333   0.09022
0.67667   0.09196
0.67000   0.09368
0.66333   0.09539
0.65667   0.09708
0.65000   0.09876
0.64333   0.10044
0.63667   0.10210
0.63000   0.10375
0.62333   0.10538
0.61667   0.10699
0.61000   0.10859
0.60333   0.11017
0.59667   0.11174
0.59000   0.11330
0.58333   0.11483
0.57667   0.11634
0.57000   0.11784
0.56333   0.11931
0.55667   0.12077
0.55000   0.12220
0.54333   0.12363
0.53667   0.12502
0.53000   0.12639
0.52333   0.12775
0.51667   0.12907
0.51000   0.13037
0.50333   0.13165
0.49667   0.13289
0.49000   0.13411
0.48333   0.13531
0.47667   0.13648
0.47000   0.13761
0.46333   0.13873
0.45667   0.13980
0.45000   0.14086
0.44333   0.14189
0.43667   0.14288
0.43000   0.14384
0.42333   0.14477
0.41667   0.14566
0.41000   0.14653
0.40333   0.14736
0.39667   0.14814
0.39000   0.14889
0.38333   0.14960
0.37667   0.15028
0.37000   0.15091
0.36333   0.15151
0.35667   0.15207
0.35000   0.15258
0.34333   0.15306
0.33667   0.15351
0.33000   0.15391
0.32333   0.15426
0.31667   0.15457
0.31000   0.15482
0.30333   0.15502
0.29667   0.15516
0.29000   0.15524
0.28333   0.15525
0.27667   0.15520
0.27000   0.15507
0.26333   0.15486
0.25667   0.15457
0.25000   0.15419
0.24342   0.15372
0.23693   0.15316
0.23053   0.15250
0.22421   0.15175
0.21798   0.15094
0.21184   0.15002
0.20579   0.14904
0.19982   0.14798
0.19395   0.14686
0.18816   0.14566
0.18245   0.14439
0.17684   0.14308
0.17131   0.14169
0.16587   0.14025
0.16052   0.13875
0.15526   0.13721
0.15008   0.13561
0.14499   0.13396
0.13999   0.13226
0.13508   0.13052
0.13026   0.12873
0.12552   0.12689
0.12087   0.12502
0.11631   0.12311
0.11183   0.12115
0.10745   0.11917
0.10315   0.11715
0.09893   0.11509
0.09481   0.11299
0.09077   0.11087
0.08683   0.10871
0.08297   0.10652
0.07919   0.10430
0.07551   0.10207
0.07191   0.09979
0.06840   0.09750
0.06498   0.09517
0.06164   0.09284
0.05840   0.09048
0.05524   0.08809
0.05217   0.08569
0.04918   0.08327
0.04629   0.08084
0.04348   0.07839
0.04076   0.07592
0.03812   0.07345
0.03558   0.07096
0.03312   0.06847
0.03075   0.06597
0.02847   0.06348
0.02627   0.06097
0.02417   0.05847
0.02215   0.05596
0.02022   0.05344
0.01837   0.05091
0.01662   0.04841
0.01495   0.04589
0.01337   0.04339
0.01187   0.04088
0.01047   0.03840
0.00915   0.03591
0.00792   0.03343
0.00678   0.03096
0.00572   0.02845
0.00476   0.02592
0.00388   0.02329
0.00309   0.02056
0.00238   0.01774
0.00177   0.01503
0.00124   0.01240
0.00080   0.00990
0.00044   0.00733
0.00018   0.00465
0.00000   0.00000
0.00018  -0.00461
0.00044  -0.00726
0.00080  -0.00990
0.00124  -0.01246
0.00177  -0.01509
0.00238  -0.01776
0.00309  -0.02049
0.00388  -0.02317
0.00476  -0.02585
0.00572  -0.02848
0.00678  -0.03112
0.00792  -0.03376
0.00915  -0.03642
0.01047  -0.03911
0.01187  -0.04178
0.01337  -0.04450
0.01495  -0.04721
0.01662  -0.04995
0.01837  -0.05269
0.02022  -0.05547
0.02215  -0.05825
0.02417  -0.06105
0.02627  -0.06386
0.02847  -0.06670
0.03075  -0.06955
0.03312  -0.07244
0.03558  -0.07536
0.03812  -0.07828
0.04076  -0.08125
0.04348  -0.08422
0.04629  -0.08720
0.04918  -0.09020
0.05217  -0.09321
0.05524  -0.09622
0.05840  -0.09925
0.06164  -0.10225
0.06498  -0.10528
0.06840  -0.10829
0.07191  -0.11131
0.07551  -0.11431
0.07919  -0.11730
0.08297  -0.12028
0.08683  -0.12325
0.09077  -0.12619
0.09481  -0.12914
0.09893  -0.13205
0.10315  -0.13494
0.10745  -0.13780
0.11183  -0.14065
0.11631  -0.14345
0.12087  -0.14624
0.12552  -0.14898
0.13026  -0.15169
0.13508  -0.15435
0.13999  -0.15697
0.14499  -0.15954
0.15008  -0.16207
0.15526  -0.16454
0.16052  -0.16696
0.16587  -0.16932
0.17131  -0.17163
0.17684  -0.17387
0.18245  -0.17603
0.18816  -0.17814
0.19395  -0.18015
0.19982  -0.18207
0.20579  -0.18391
0.21184  -0.18564
0.21798  -0.18727
0.22421  -0.18877
0.23053  -0.19015
0.23693  -0.19140
0.24342  -0.19250
0.25000  -0.19343
0.25667  -0.19420
0.26333  -0.19481
0.27000  -0.19525
0.27667  -0.19552
0.28333  -0.19562
0.29000  -0.19556
0.29667  -0.19535
0.30333  -0.19498
0.31000  -0.19448
0.31667  -0.19383
0.32333  -0.19303
0.33000  -0.19211
0.33667  -0.19107
0.34333  -0.18991
0.35000  -0.18864
0.35667  -0.18725
0.36333  -0.18577
0.37000  -0.18418
0.37667  -0.18251
0.38333  -0.18074
0.39000  -0.17889
0.39667  -0.17695
0.40333  -0.17496
0.41000  -0.17288
0.41667  -0.17074
0.42333  -0.16855
0.43000  -0.16631
0.43667  -0.16402
0.44333  -0.16167
0.45000  -0.15929
0.45667  -0.15684
0.46333  -0.15436
0.47000  -0.15185
0.47667  -0.14930
0.48333  -0.14671
0.49000  -0.14410
0.49667  -0.14147
0.50333  -0.13881
0.51000  -0.13613
0.51667  -0.13342
0.52333  -0.13071
0.53000  -0.12797
0.53667  -0.12522
0.54333  -0.12247
0.55000  -0.11970
0.55667  -0.11692
0.56333  -0.11413
0.57000  -0.11133
0.57667  -0.10853
0.58333  -0.10573
0.59000  -0.10293
0.59667  -0.10014
0.60333  -0.09734
0.61000  -0.09456
0.61667  -0.09178
0.62333  -0.08901
0.63000  -0.08624
0.63667  -0.08348
0.64333  -0.08074
0.65000  -0.07801
0.65667  -0.07529
0.66333  -0.07257
0.67000  -0.06987
0.67667  -0.06719
0.68333  -0.06452
0.69000  -0.06186
0.69667  -0.05922
0.70333  -0.05661
0.71000  -0.05401
0.71667  -0.05144
0.72333  -0.04889
0.73000  -0.04637
0.73667  -0.04386
0.74333  -0.04140
0.75000  -0.03896
0.75660  -0.03658
0.76314  -0.03425
0.76961  -0.03199
0.77601  -0.02979
0.78235  -0.02765
0.78863  -0.02557
0.79484  -0.02357
0.80098  -0.02162
0.80706  -0.01974
0.81307  -0.01794
0.81902  -0.01621
0.82490  -0.01454
0.83072  -0.01294
0.83647  -0.01142
0.84216  -0.00996
0.84778  -0.00858
0.85333  -0.00727
0.85882  -0.00604
0.86425  -0.00487
0.86961  -0.00377
0.87490  -0.00276
0.88013  -0.00182
0.88529  -0.00095
0.89039  -0.00014
0.89542   0.00061
0.90039   0.00128
0.90529   0.00189
0.91013   0.00243
0.91490   0.00293
0.91961   0.00335
0.92425   0.00370
0.92882   0.00401
0.93333   0.00425
0.93778   0.00441
0.94216   0.00452
0.94647   0.00455
0.95072   0.00451
0.95490   0.00439
0.95902   0.00420
0.96307   0.00394
0.96706   0.00358
0.97098   0.00315
0.97484   0.00264
0.97863   0.00206
0.98235   0.00141
0.98601   0.00069
0.98961  -0.00011
0.99314  -0.00097
0.99660  -0.00190
1.00000  -0.00283
    ]
    @test isapprox(coords.Coordinates, coordinates, atol=1e-8)
    end #End testing Write Airfoil Coordinates
end #End testing AeroDyn

nothing