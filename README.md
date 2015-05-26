#WOSS

A GIS data preprocessing toolset for multi-criteria weighted overlay analyses involving the discovery of suitable sites for a given landuse application. 
For more read the documentation at: http://ericdfournier.github.io/WOSS

## INSTALLATION

- Clone Git Repository:
 at the terminal, cd into a working directory of choice and clone the git repository via the following bash shell commands (on mac)

````bash
$ cd ~
$ git clone https://github.com/ericdfournier/WOSS.git
````

- Download and Unpack Zipped Git Repository: 
 at the terminal, cd into a working directory of choice and unzip the zipped version of the repository downloaded from the project github page via the following bash shell commands (on mac)

````bash
$ mkdir ~/WOSS
$ cd ~/WOSS
$ unzip WOSS.zip
````

## DESCRIPTION

(WOSS) Weighted Overlay Site Selection GIS Data Preprocessing Toolset

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

- The discovery of one or more sites which are suitable for a given application can be accomplished through a cartographic modeling technique known as weighted overlay analysis. The application of this technique involves the  superposition of multiple spatially referenced data layers, each of which has been interpreted to represent some dimension of site suitability for the application in question. The WOSS toolset provides a number of routines which enable the automated preprocessing of vector and raster GIS datasets into 
  a consistent raster format for later use in another MATLAB based modeling 
  workflow. 