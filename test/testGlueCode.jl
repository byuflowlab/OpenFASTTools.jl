# using OpenFASTTools

# of = OpenFASTTools

@testset "GlueCode" begin
    @testset "Overarching Structures" begin
        radii = Float64[1,2,3,4,5]
        hubrad = 1.0

        notes = "rar"
        tiprad = 5.0
        chord = ones(length(rads))*1.0
        twist = deepcopy(chord)
        sweep = 1.0
        curve = 1.0
        curveangle = 1.0
        airfoils = "ribbit.dat"

        blade = of.BladeA(notes, hubrad, radii, chord,      twist, sweep, curve, curveangle, airfoils)

        adblade = of.make_adblade(blade)
        ### Test adblade and BladeA
    end
end
