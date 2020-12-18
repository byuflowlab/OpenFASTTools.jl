"""
    DamageEquivalentLoad(loads; m=10)
Damage equivalent load from the MLife theory, using the goodman correction.
# Arguments
    loads - the an array of loads, whether they be forces, moments or stresses
    m - the Whöler exponent, which is typically 10 for composites
# Outputs
    DEL - Damage equivalent load
"""
function DamageEquivalentLoad(loads; m=10)
    peaks = get_peaks(loads) #Rainflow counting only cares about the turning points
    out = rainflow(peaks) 
    n = Int(length(out)/3)
    maxl, maxlidx = findmax(out[1,:])
    DEL = 0
    for i =1:n
        correctedloadrange = out[1,i]*(maxl/(maxl-abs(out[2,i]))) #Goodman correction
        DEL += out[3,i]*(correctedloadrange^m)
    end
    DEL = (DEL/sum(out[3,:]))^(1/m)
    return DEL
end

"""
    rainflow(array_ext,uc_mult=0.5)
Rainflow counting of a signal's turning points
# Arguments
        array_ext (numpy.ndarray): array of turning points
# Keyword Arguments
        uc_mult (float): partial-load scaling [opt, default=0.5]
# Returns
        array_out (numpy.ndarray): (3 x n_cycle) array of rainflow values:
                                    1) load range
                                    2) range mean
                                    3) cycle count
"""
function rainflow(array_ext,uc_mult=0.5)
    tot_num = length(array_ext)             # total size of input array
    array_out = zeros(typeof(array_ext[1]),(3, tot_num-1))        # initialize output array
    pr = 1                                  # index of input array
    po = 1                                  # index of output array
    j = 0                                   # index of temporary array "a"
    a  = zeros(typeof(array_ext[1]),tot_num)                     # temporary array for algorithm
    # loop through each turning point stored in input array
    for i = 1:tot_num
        j += 1                  # increment "a" counter
        a[j] = array_ext[pr]    # put turning point into temporary array
        pr += 1                 # increment input array pointer
        while j >= 3 && abs( a[j-1] - a[j-2]) <= abs(a[j] - a[j-1])
            lrange = abs( a[j-1] - a[j-2] )
            # partial range
            if j == 3
                mean      = ( a[1] + a[2] ) / 2.0
                a[1]=a[2]
                a[2]=a[3]
                j=2
                if lrange > 0
                    array_out[1,po] = lrange
                    array_out[2,po] = mean
                    array_out[3,po] = uc_mult
                    po += 1
                end
            # full range
            else
                mean      = ( a[j-1] + a[j-2] ) / 2.0
                a[j-2]=a[j]
                j=j-2
                if (lrange > 0)
                    array_out[1,po] = lrange
                    array_out[2,po] = mean
                    array_out[3,po] = 1.00
                    po += 1
                end
            end
        end
    end
    # partial range
    for i = 1:j-1
        lrange    = abs( a[i] - a[i+1] )
        mean      = ( a[i] + a[i+1] ) / 2.0
        if lrange > 0
            array_out[1,po] = lrange
            array_out[2,po] = mean
            array_out[3,po] = uc_mult
            po += 1
        end
    end
    # get rid of unused entries
    out = array_out[:,1:po-1]
    return out
end
"""
    get_peaks(array)
get the turning point values of a signal
# Arguments
- `array::Array{Float}`: the signal to find the turning points, or peaks
"""
function get_peaks(array)
    A = array[:]
    # get rid of any zero slope in the beginning
    while A[2] == A[1]
        A = A[2:length(A)]
    end
    peaks = [A[1]]
    if A[2] > A[1]
        slope = "p"
    elseif A[2] < A[1]
        slope = "m"
    end
    for i = 1:length(A)-2
        ind = i+1
        if slope == "p"
            if A[ind+1] < A[ind]
                peaks = append!(peaks,A[ind])
                slope = "m"
            end
        elseif slope == "m"
            if A[ind+1] > A[ind]
                peaks = append!(peaks,A[ind])
                slope = "p"
            end
        end
    end
    peaks = append!(peaks,A[length(A)])
    return peaks
end
"""
    get_peaks_indices(array)
return the indices of the signal peaks
# Arguments
- `array::Array{Float}`: the signal to find the turning points, or peaks
"""
function get_peaks_indices(array)
    A = array[:]
    # get rid of any zero slope in the beginning
    while A[2] == A[1]
        A = A[2:length(A)]
    end
    peaks = [1]
    if A[2] > A[1]
        slope = "p"
    elseif A[2] < A[1]
        slope = "m"
    end
    for i = 1:length(A)-2
        ind = i+1
        if slope == "p"
            if A[ind+1] < A[ind]
                peaks = append!(peaks,ind)
                slope = "m"
            end
        elseif slope == "m"
            if A[ind+1] > A[ind]
                peaks = append!(peaks,ind)
                slope = "p"
            end
        end
    end
    peaks = append!(peaks,length(A))
    return peaks
end

"""
interpolate2dcurve(coords1, coords2, d1, d2, d3) 
    This function creates a new curve at d, betwen the two curves.  
Inputs:
- coords1 - a (n,2) Float array of the XY coordinates of curve 1
- coords2 = a (n,2) Float array of the XY coordinates of curve 2
- d - float (range 0 to 1) indicating the percentage of the distance between the two original curves that the interpolated curve is located.
        
Outputs:
- coords3

        Notes:
        Assume the function is defined (Only 1 Y value for a given X value)
"""
function interpolate2dcurve(coords1, coords2, d)
    m, n = size(coords1)
    if n>2
        error("interp2dcurve: curve 1 coordinates formatted incorrectly.")
    end
    if size(coords1) != size(coords2)
        error("interp2dcurve: curve coordinates of unequal size.")
    end

    coords3 = zeros(m,2)
    for i=1:m
        c1 = coords1[i,:]
        c2 = coords2[i,:]
        c3 = c1 + (d.*(c2-c1)) #Find the location of the new node using a distance vector
        coords3[i,:] = c3
    end
    return coords3
end

"""
#### integerfit(x, y, xnew)
Fit Integer values of Y.
### Inputs
- x = x values 
- y = y values (Integers)
- xnew = x values to be interpolated, single element or an array

### Outputs
- ynew = the fit integer values that correspond to xnew

### Notes
The function requires x and xnew to be increasing order. Xnew need not be within
    the range of of x, however, values outside of the range will interpolated to
    the first value if below the range and the last value if after the range. 
"""
function integerfit(x, y, xnew)
    ynew = zeros(Int, length(xnew))
    for i=1:length(xnew)
        for j=1:length(x)
            if xnew[i]<= x[j]
                ynew[i] = y[j]
                break
            end
        end
    end
    return ynew
end

"""
#### nametonumber(list)
Converts a list of names into a list of integers. The first name will appear as 1, the second name will appear as 2, etc. 

### Inputs
list - a 1D array of strings containing the names you wish to convert to numbers

### Outputs
numbers - a 1D array of integers that represent the names you converted

### Notes
Note that this function is not case sensitive. Thus Afoil and afoil will receive the same number assignment. 
"""
function nametonumber(list)
    n = length(list)
    numbers = zeros(Int, n)
    uniquelist = unique(lowercase.(list))
    m = length(uniquelist)
    for i = 1:n
        for j = 1:m
            if lowercase(list[i]) == uniquelist[j]
                numbers[i] = j
            end
        end
    end
    return numbers
end

function namefit(x, list, xnew)
    n = length(list)
    numbers = zeros(Int, n)
    uniquelist = unique(lowercase.(list))
    m = length(uniquelist)
    for i = 1:n
        for j = 1:m
            if lowercase(list[i]) == uniquelist[j]
                numbers[i] = j
            end
        end
    end
    newnums = integerfit(x, numbers, xnew)
    newnames = String[]
    for i=1:length(newnums)
        for j=1:length(uniquelist)
            if newnums[i]==j
                push!(newnames, uniquelist[j])
            end
        end
    end
    return newnames
end

"""
#### localtoroot(N*, T*, ϕ)
Converts from local blade reference (lbr) to blade root reference (brr)

### Inputs 
- Nstar = local force normal to chord (Flatwise loading)
- Tstar = local force tangent to chord (Edgewise loading)
- ϕ = Total twist (pitch + twist distro) in degrees

### Outputs 
- N = brr normal force
- T = brr tangent force

Notes: OpenFAST definition of normal and tangent
"""
function localtoroot(Nstar, Tstar, ϕ)
    T = Tstar*cosd(ϕ) + Nstar*sind(ϕ)
    N = Nstar*cosd(ϕ) - Tstar*sind(ϕ)
    return N, T
end

"""
#### roottolocal(N, T, ϕ)
Converts from blade root reference (BRR) to local blade reference (LBR).

### Inputs
- N = local force normal to blade root chord (Flapwise loading)
- T = local force tangent to blade root chord (Leadlag Loading)
- ϕ = Total twist (pitch + twist distribution) in degrees

### Outputs
- Nstar - lbr normal force
- Tstar - lbr tangent force

### Notes
OpenFAST definition of normal and tangent (increasing twist angle decreases local angle of attack.)
"""
function roottolocal(N, T, ϕ)
    Nstar = (T*tand(ϕ) + N)/(cosd(ϕ) + sind(ϕ)*tand(ϕ))
    Tstar = (T/cosd(ϕ)) - (tand(ϕ)*Nstar)
end