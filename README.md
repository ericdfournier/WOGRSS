#WOGRSS

Use a multi-criteria weighted overlay analysis technique to discover suitable sites for the implementation of groundwater recharge surface spreading basins or direct subsurface injection wells. 
For more read the documentation at: www.ericdfournier.com/WOGRSS

## INSTALLATION

- Clone Git Repository: cd into a working directory of choice and clone the git repository via the following shell commands (on mac)

````bash
$ cd ~
$ git clone https://github.com/ericdfournier/WOGRSS.git
````

- Download and Unpack Zipped Git Repository: cd into a working directory of choice and unzip the zipped version of the repository downloaded from the project github page via the following shell commands (on mac)

````bash
$ mkdir ~/WOGRSS
$ cd ~/WOGRSS
$ unzip WOGRSS.zip
````

## DESCRIPTION

(WOGRSS) Weighted Overlay model for Groundwater Recharge Site Selection

### PLATFORM

- MATLAB Version: 8.1.0.604 (R2013a)
- Operating System: Mac OS X  Version: 10.9.1 Build: 13B42 
- Java Version: Java 1.6.0_65-b14-462-11M4609 with Apple Inc. Java HotSpot(TM) 64-Bit Server VM mixed mode

### DEPENDENCIES

- Image Processing Toolbox                              Version 8.2
- Mapping Toolbox                                       Version 3.7
- Statistics Toolbox                                    Version 8.2

### REFERENCES

- Pedrero, F., Albuquerque, A., Marecos do Monte, H., Cavaleiro, V., & Alarcón, J. J. (2011). Application of GIS-based multi-criteria analysis for site selection of aquifer recharge with reclaimed water. Resources, Conservation and Recycling, 56(1), 105–116. doi:10.1016/j.resconrec.2011.08.003

### DETAILS

- The discovery of one or more sites which are suitable for a given application can be accomplished through a process cartographic modeling technique known as weighted overlay analysis. The application of this technique involves the  superposition of multiple spatially referenced data layers, each of which has been interpreted to represent some dimension of site suitability for a given application. This particular model uses the weighted overlay analysis technique to discover contiguous spatial regions which are suitable for the implementation of either surface spreading basins or subsurface injection wells to be used for the recharge of groundwater resources. 