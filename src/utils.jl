function rotate_x(alpha_x)
    return [
        1.0     0.0             0.0;
        0.0     cos(alpha_x)   -sin(alpha_x);
        0.0     sin(alpha_x)    cos(alpha_x)]
end

function rotate_y(alpha_y)
    return [cos(alpha_y) 0 sin(alpha_y);
            0.0 1.0 0.0;
            -sin(alpha_y) 0 cos(alpha_y)]
end

function rotate_z(alpha_z)
    return [cos(alpha_z) -sin(alpha_z) 0.0;
            sin(alpha_z) cos(alpha_z) 0.0;
            0.0 0.0 1.0]
end


"""
    interpolate_matrix_symmetric(f1, f2, Kmat)
Interpolate a set of symmetric matrices from one vector of fractions to any number of new fractions.

### Inputs
- f1::Vector{Float64}: The fractional locations of the original stiffness matrices.
- f2::Vector{Float64}: The fractional locations of the new stiffness matrices.
- Kmat::Array{Float64, 3}: The stiffness matrices at the original locations.

### Outputs
- Kfit::Array{Float64, 3}: The stiffness matrices at the new locations.
"""
function interpolate_matrix_symmetric(f1, f2, Kmat; fit=Linear)
    if length(f1)!=size(Kmat, 3)
        error("interpolate_stiffness(): The number of f1 points and stiffness matrices must be the same.")
    end

    K11fit = fit(f1, Kmat[1,1,:])
    K12fit = fit(f1, Kmat[1,2,:])
    K13fit = fit(f1, Kmat[1,3,:])
    K14fit = fit(f1, Kmat[1,4,:])
    K15fit = fit(f1, Kmat[1,5,:])
    K16fit = fit(f1, Kmat[1,6,:])

    K22fit = fit(f1, Kmat[2,2,:])
    K23fit = fit(f1, Kmat[2,3,:])
    K24fit = fit(f1, Kmat[2,4,:])
    K25fit = fit(f1, Kmat[2,5,:])
    K26fit = fit(f1, Kmat[2,6,:])

    K33fit = fit(f1, Kmat[3,3,:])
    K34fit = fit(f1, Kmat[3,4,:])
    K35fit = fit(f1, Kmat[3,5,:])
    K36fit = fit(f1, Kmat[3,6,:])

    K44fit = fit(f1, Kmat[4,4,:])
    K45fit = fit(f1, Kmat[4,5,:])
    K46fit = fit(f1, Kmat[4,6,:])

    K55fit = fit(f1, Kmat[5,5,:])
    K56fit = fit(f1, Kmat[5,6,:])

    K66fit = fit(f1, Kmat[6,6,:])

    Kfit = zeros(6,6,length(f2))
    for i in eachindex(f2)
        Kfit[1,1,i] = K11fit(f2[i])
        Kfit[1,2,i] = K12fit(f2[i])
        Kfit[1,3,i] = K13fit(f2[i])
        Kfit[1,4,i] = K14fit(f2[i])
        Kfit[1,5,i] = K15fit(f2[i])
        Kfit[1,6,i] = K16fit(f2[i])

        Kfit[2,1,i] = K12fit(f2[i])
        Kfit[2,2,i] = K22fit(f2[i])
        Kfit[2,3,i] = K23fit(f2[i])
        Kfit[2,4,i] = K24fit(f2[i])
        Kfit[2,5,i] = K25fit(f2[i])
        Kfit[2,6,i] = K26fit(f2[i])

        Kfit[3,1,i] = K13fit(f2[i])
        Kfit[3,2,i] = K23fit(f2[i])
        Kfit[3,3,i] = K33fit(f2[i])
        Kfit[3,4,i] = K34fit(f2[i])
        Kfit[3,5,i] = K35fit(f2[i])
        Kfit[3,6,i] = K36fit(f2[i])

        Kfit[4,1,i] = K14fit(f2[i])
        Kfit[4,2,i] = K24fit(f2[i])
        Kfit[4,3,i] = K34fit(f2[i])
        Kfit[4,4,i] = K44fit(f2[i])
        Kfit[4,5,i] = K45fit(f2[i])
        Kfit[4,6,i] = K46fit(f2[i])

        Kfit[5,1,i] = K15fit(f2[i])
        Kfit[5,2,i] = K25fit(f2[i])
        Kfit[5,3,i] = K35fit(f2[i])
        Kfit[5,4,i] = K45fit(f2[i])
        Kfit[5,5,i] = K55fit(f2[i])
        Kfit[5,6,i] = K56fit(f2[i])

        Kfit[6,1,i] = K16fit(f2[i])
        Kfit[6,2,i] = K26fit(f2[i])
        Kfit[6,3,i] = K36fit(f2[i])
        Kfit[6,4,i] = K46fit(f2[i])
        Kfit[6,5,i] = K56fit(f2[i])
        Kfit[6,6,i] = K66fit(f2[i])
    end
    
    return Kfit
end
