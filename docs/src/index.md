# OpenFASTsr Documentation

Adam Cardoza 

### Summary:
OpenFAST is a multi-physics, multi-fidelity tool for simulating the coupled dynamic response of wind turbines created and maintained by the National Renewable Energy Labratory (NREL). OpenFAST is written in FORTRAN, and is typically operated from the command line via input and output text files. This wrapper, OpenFASTsr.jl, simply provides a convinient way to interact with the input and output files. For further information about OpenFAST, consult the official [documentation](https://openfast.readthedocs.io/en/main/).

I wrote this package to support work for an ARPA-E project we were working on here at BYU, as such, I have not wrapped all of the many modules from OpenFAST. Modules currently supported are:
- AeroDyn - An unsteady aerodynamic solver for turbines. Contains two models for calculating the effect of wind turbine wakes: the blade element momentum theory and the generalized dynamic-wake theory.
- ElastoDyn - an elastic structural dynamics solver (I really don't know much more about it).
- BeamDyn - a Legendre-spectral-finite-element implementation of geometrically exact beam theory (GEBT).
- InflowWind - a program to generate wind files which OpenFAST will use. 

Some additional notes:
- You can run either run OpenFAST or AeroDyn by itself. I'm not sure if you can run the other modules by themselves, I imagine so, but I don't know for certain.
- Note that you may need to search the web for additional documentation for OpenFAST. I found individual documentation for AeroDyn and BeamDyn that was extermely useful. Also, there are some excel spreadsheets that have a collection of the inputs and outputs for each of the modules.  
- Some additional features like an implementation of the rainflow counting algorithm have also been implemented here. 

### Installation:

##### Install OpenFAST
Follow the installation [instructions](https://openfast.readthedocs.io/en/main/source/install/index.html) from OpenFAST.

- A note on installation, I followed the compile it yourself route. There were several packages that I needed to install on my computer to successfully compile the program. Specifically, I had to add one of the compilers to my .bash_profile so my computer could find it during compilation. (```source /opt/intel/bin/compilervars.sh intel64```)


##### Enable OpenFAST to run from the command line
In order to use OpenFAST (or AeroDyn by itself) anywhere you want, you will need to add the binaries to your path. On Mac can be done by adding similar lines to your .bash_profile. 

```julia
export PATH="$PATH:/Users/adamcardoza/repos/openfast/build/glue-codes/openfast"
export PATH="$PATH:/Users/adamcardoza/repos/openfast/build/modules/turbsim"
export PATH="$PATH:/Users/adamcardoza/repos/openfast/build/modules/aerodyn"
```

##### Install the OpenFASTsr package

Add the package via git:

```julia
pkg> add https://github.com/byuflowlab/OpenFASTsr.jl.git
```


### Documentation:
- To start, check out the quick start tutorial. 
- Then take a look at the examples.
- If more information is required, checkout the API in the reference. 