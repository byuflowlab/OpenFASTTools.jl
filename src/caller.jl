"""
Module : OpenFASTTools

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

    #run(`openfast 20kWturbine.fst`) worked. So maybe I just need to change to the outputpath, then run the file? I dunno? The caller might not like the $outputpath dealio. 

end

function HelloWord()
    println("Hello World")
end


function OpenFAST()
end
