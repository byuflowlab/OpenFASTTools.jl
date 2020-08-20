"""
Module : OpenFASTsr
Summary: functions to call openfast using the command line, including
    - WriteInputFile()
    - CallFAST()
    - ReadOutputFile()
    - OpenFAST()

Author: Adam Cardoza
Start Date: 5/22/2020

Notes:

"""

function CallFAST(inputfile,inputpath, outputpath)

    #TODO: check that inputfile is a .fst file

    run(`cd $outputpath`)

    #TODO: Check the input formatting
    file = inputpath*'/'*inputfile

    run(`openfast $file`)

end

function HelloWord()
    println("Hello World")
end


function OpenFAST()
end
