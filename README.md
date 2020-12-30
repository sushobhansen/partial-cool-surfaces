## Partial application of cool surfaces
#### Code for urban ABL simulation with OpenFOAM

To run the code, you will require: 
- Gmsh version 4.3 or above (for generating the mesh), details and instructions [here](https://gmsh.info/)
- OpenFOAM [v5](https://openfoam.org/version/5-0/) or [v6](https://openfoam.org/version/6-0/) (note that v7/v8 implements a new solver that will not work directly, although a custom solver can be designed with the old one's functionality: please contact me for help with that if necessary). Make sure to install ParaView as well, see the links for instructions

The code was run and tested on a Linux computer running Ubuntu 18.04 LTS and a cluster running CentOS 8. Please contact me if you are running it on a different (especially non-Unix-like) machine and run into trouble.

The repository consists of two main sets of files: `Validation` and `Cases`. The former contains the case files used for validating the models and the latter consists of three cases:
- `HW1W` is a urban low-density (H/W = 1.0) case with wind blowing from the west
- `HW1NW` is a urban low-density (H/W = 1.0) case with wind blowing from the northwest
- `HW2W` is a urban high-density (H/W = 2.0) case with wind blowing from the west

For each case, to generate the mesh, use Gmsh with the command `gmsh *.geo -3`, where `*` should be replaced with the name of the corresponding `.geo` file in that directory. An `.msh` file containing the mesh in Gmsh format will be generated. Then use `gmshToFoam *.msh` to import the mesh into the OpenFOAM case, and use `changeDictionary changeDictionaryDict` to update the patch fields. You can optionally run `checkMesh` to verify that the mesh has no problems. Then, to run the case, simply use `bash runthis`. Once completed, simply call `paraFoam` to view the results on ParaView, which should have been installed with OpenFOAM.

**Note:** For each case, you will need to modify the `system/decomposeParDict` file with the number of cores that you want to use, which depends on the number of cores available on your machine. Similarly, change the `-np` tokens in `runthis` with the same number of cores: all of these values must be identical for the simulation to run. The simulation is very slow if you run it in serial, although you can by modifying the calls in `runthis` appropriately (I do not recommend doing this).

For each case (except Validation, of course), navigate to the Case directory, modify the input file `0/T` for whatever cool surface configuration you want to run. The surfaces are labeled based on direction: southwest is SW, northwest is NW, northeast is NE, and southeast is SE, and regular expressions are used to cover roofs, walls, and roads (you can change them individually if you want to as well). 

At the end of the simulation, a series of post-processing utilities are run, which will generate, among other things, VTK files for 2 m air temperature. This file can be found under `postProcessing/surfaces/3000/` (3000 corresponds to the `endTime` entry in `system/controlDict`, it can be changed if you want to). It will be named `T_canopy.vtk` (note that additional files for velocity and pressure fields at 2 m are also generated). You can process this file with any VTK parser, such as ParaView or custom code that uses the VTK library (such as with a Python implementation, which is what I used - please contact me for this).