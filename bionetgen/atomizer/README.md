## Atomizer Demo

### Instructions

- Go to the BioModels website for BMD 569: https://www.ebi.ac.uk/biomodels-main/BIOMD0000000569
- Download the file by clicking on Download SBML -> SBML L2 V4 (curated)
- Open RuleBender and create an empty file inside your existing project
-  Put this instruction on that file:

readFile({file=>"/home/cell/Downloads/BIOMD0000000569.xml",atomize=>1})

- Execute the file
- Navigate to the results folder
- open the BIOMD0000000569.bngl file 
- Drag and drop to your project's top level  through the Project's explorer
