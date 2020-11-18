# using OpenFASTsr
# using Test

# of = OpenFASTsr

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
for i = 1:length(adfile.TwrNds)
    @test isapprox(adfile.TwrNds[i],twrnds[i],atol=1e-5)
end
@test lowercase(adfile.SumPrint)=="true"
@test adfile.NBlOuts==3
bloutnd = [1, 9, 19]
for i = 1:length(adfile.BlOutNd)
    @test adfile.BlOutNd[i]==bloutnd[i]
end
@test adfile.NTwOuts==0
twoutnd = [1, 2, 6]
for i = 1:length(adfile.TwOutNd)
    @test adfile.TwOutNd[i]==twoutnd[i]
end
outlist = ["RtAeroPwr"]
for i= 1:length(adfile.Outlist)
    @test adfile.Outlist[i]==outlist[i]
end
@test adfile.BldNd_BladesOut==3
outlist = ["VUndx", "VUndy", "VUndz"]
for i = 1:length(adfile.BldNd_BlOutNd)
    @test adfile.BldNd_BlOutNd[i]==99
end
for i = 1:length(outlist)
    @test adfile.NodeOutlist[i]==outlist[i]
end

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
for i = 1:length(adfile.TwrNds)
    @test isapprox(adfile.TwrNds[i],twrnds[i],atol=1e-5)
end
@test lowercase(adfile.SumPrint)=="true"
@test adfile.NBlOuts==3
bloutnd = [1, 9, 19]
for i = 1:length(adfile.BlOutNd)
    @test adfile.BlOutNd[i]==bloutnd[i]
end
@test adfile.NTwOuts==0
twoutnd = [1, 2, 6]
for i = 1:length(adfile.TwOutNd)
    @test adfile.TwOutNd[i]==twoutnd[i]
end
outlist = ["RtAeroPwr"]
for i= 1:length(adfile.Outlist)
    @test adfile.Outlist[i]==outlist[i]
end
@test adfile.BldNd_BladesOut==3
outlist = ["VUndx", "VUndy", "VUndz"]
for i = 1:length(adfile.BldNd_BlOutNd)
    @test adfile.BldNd_BlOutNd[i]==99
end
for i = 1:length(outlist)
    @test adfile.NodeOutlist[i]==outlist[i]
end

end