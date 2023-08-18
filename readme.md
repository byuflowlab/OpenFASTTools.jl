# OpenFASTTools
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://byuflowlab.github.io/OpenFASTTools.jl/dev)

Author: Adam Cardoza  
Contact: adam@cardoza.one  

### Summary:
This package provides convinient methods to parse OpenFAST input files. OpenFAST is a multi-physics, multi-fidelity tool for simulating the coupled dynamic response of wind turbines created and maintained by the National Renewable Energy Labratory (NREL). OpenFAST is written in FORTRAN, and is typically operated from the command line via input and output text files. For further information about OpenFAST, consult the official [documentation](https://openfast.readthedocs.io/en/main/). 



Some additional notes:  
- Some additional features like an implementation of the rainflow counting algorithm have also been implemented here. 

### Installation:

##### Install OpenFAST
Follow the installation [instructions](https://openfast.readthedocs.io/en/main/source/install/index.html) from OpenFAST.


<!-- ##### Enable OpenFAST to run from the command line
In order to use OpenFAST (or AeroDyn by itself) anywhere you want, you will need to add the binaries to your path. On Mac can be done by adding similar lines to your .bash_profile. 

```julia
export PATH="$PATH:/Users/adamcardoza/repos/openfast/build/glue-codes/openfast"
export PATH="$PATH:/Users/adamcardoza/repos/openfast/build/modules/turbsim"
export PATH="$PATH:/Users/adamcardoza/repos/openfast/build/modules/aerodyn"
``` 


##### Install the OpenFASTTools package

Add the package via git:

```julia
pkg> add https://github.com/byuflowlab/OpenFASTTools.jl.git
```
-->

### Documentation:
- To start, check out the quick start tutorial. 
- Then take a look at the examples.
- If more information is required, checkout the API in the reference. 

