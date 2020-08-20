# LameOpenFAST
Author: Adam Cardoza
Contact: adam@cardoza.one
Summary:
  Call OpenFAST using the command line.

User Functions:
  - CallFAST()
  - ReadOutput(filename, filepath)
  - CreateAD15(Blades, Foils; ...)
  - ReadAD15File(filename, filepath)
  - WriteAD15File(adfile, outputfile)
  - CreateAD14(Foils, Nodes;...)
  - ReadAD14File(filename, filepath)
  - WriteAD14File(adfile,outputfile)
  - WritefstFile(filename) #Unfinished

Notes:
  - Functions for users are in CamelCase, internal functions are all lowercase.
  - This is a quick hack job so that I can start getting results.
  - This is an effort to recreate the works of Bryce Ingersol's Master's Thesis.


  Internal Functions:
  - formatword(word;)
  - formatmatrix(matrix;)
  - formatmatrix_appendcolumn(smat, appendcolumn)
  - formatvecotr(vector)
  - endofword(word;)
  - fetchword(line;)
  - fetchmatrix(lines, widthofmatrix, numcolumns)
  - numcolumns(line)
  - seprows(line, m)
  - rmspaces(line)
  - readmatrix(lines)
  - parsenames(line)
  - fetchword15(line;)
  - readvector(line, veclength)
  - readoutlist(lines)
  - rainflow(array_ext, uc_mult)
  - get_peaks(array)
  - get_peaks_indices(array)
  
