# Functions

### Processor.jl

##### DamageEquivalentLoad(loads; m=10 )

Damage equivalent load from the MLife theory, using the goodman correction.

\# Arguments

​    loads - the an array of loads, whether they be forces, moments or stresses

​    m - the Whöler exponent, which is typically 10 for composites

\# Outputs

​    DEL - Damage equivalent load

------

##### rainflow(array_ext,uc_mult=0.5)

Rainflow counting of a signal's turning points

\# Arguments

​        array_ext (numpy.ndarray): array of turning points

\# Keyword Arguments

​        uc_mult (float): partial-load scaling [opt, default=0.5]

\# Returns

​        array_out (numpy.ndarray): (3 x n_cycle) array of rainflow values:

​                                    1) load range

​                                    2) range mean

​                                    3) cycle count

------

### Reader.jl

##### ReadOutput(filename, filepath)

​    ReadOutput reads the .out file from OpenFASt and parses it into a dictionary.

​    A dictionary was chosen because the out file can have a lot of different

​    outputs, and it was easier to program a reactive function rather than a predictive

​    one.

​    filename - The name of the .out file to be read

​    filepath - The path to the .out file.

​    \# Returns

​    outputs - a dictionary of all of the arrays within the .out file

