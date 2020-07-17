## Partial application of cool surfaces
## Code for the work performed by Sen & Khazanovich

To run the code, you will require: 
- Gmsh version 4.3 or above (for generating the mesh)
- OpenFOAM v5 or v6 (note that v7 implements a new solver that will not work directly)

To generate the mesh, use Gmsh with the `2233.geo` file. Then use `gmshToFoam` to import the mesh into the OpenFOAM case, and use `changeDictionary changeDictionaryDict` to update the patch fields. 

For Validation results, using the command line, navigate to the directory folder and use `bash runthis` to for processing and post-processing (make sure to updae the number of processors as necessary).

For each case, navigate to the Case directory, modify the input file `0/T` for whatever case you want to run, and repeat the same steps as for Validation.