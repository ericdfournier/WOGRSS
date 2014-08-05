function [ vectorMosaicData ] = extractVectorMosaicDataFnc( ...
                                                topLevelVectorDir, ...
                                                hucCodeShapeStruct, ...
                                                hucIndex, ...
                                                gridMaskGeoRasterRef )
% extractVectorMosaicDataFnc.m Function to iteratively generate vector
% mosaic datasets for all raster data files within a set of sub-directories
% stored beneath a top level vector data storage directory. The vector
% mosaic files are generated with respect to the spatial extent of the
% basin boundary described by the hucCodeShapeStruct element corresponding
% with the hucIndex provided. 
%
%
% DESCRIPTION:
%
%   Function which generates an output cell array of vector mosaic datasets
%   for each vector dataset contained in the subdirectories of a top level
%   vector data storage directory. In each case the vector mosaic dataset
%   is created by intersecting the disperate vector data files contained
%   within each subdirectory with the polygonal geometry of the huc
%   checking for any overlap with the spatial extent of the basin geometry
%   associated with the hucCodeShapeStruct element defined by the hucIndex.
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ vectorMosaicData ] =  extractVectorMosaicDataFnc( ...
%                                                   topLevelVectorDir, ...
%                                                   hucCodeShapeStruct, ...
%                                                   hucIndex, ...
%                                                   gridMaskGeoRasterRef )
%
% INPUTS: 
%
%   topLevelVectorDir = (1 x k) character array containing the text file
%                       names for the top level vector data directory
%                       containing a set of sub-directories storing all of
%                       the individual mosaic data files for each vector
%                       data category to be used in the analysis
%
%   hucCodeShapeStruct = {j x 1} shapefile structure array containing the
%                       shapefile data for the basin delineations
%
%   hucIndex =          [a] scalar value indicating the index of the
%                       hucCodeShapeStruct array corresponding to the 
%                       desired reference basin
%
%   gridMaskGeoRasterRef = {q} cell orientated geo raster reference object
%                       providing spatial reference information for the
%                       reference basin gridMask data layer
% 
% OUTPUTS:
%
%   vectorMosaicData =  {r x 1} cell array in which each cell element 
%                       contains a vector dataset with the same spatial
%                       reference information as that contained in the 
%                       gridMaskGeoRasterRef but the individual component
%                       geometries have been derived as the product of the
%                       intersection of the source vector data layers with
%                       the basin outline geometry
%
% EXAMPLES:
%   
%   Example 1 =
%
% CREDITS:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                      %%
%%%                          Eric Daniel Fournier                        %%
%%%                  Bren School of Environmental Science                %%
%%%                 University of California Santa Barbara               %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse Inputs

P = inputParser;

addRequired(P,'nargin',@(x) ...
    x == 4);
addRequired(P,'nargout',@(x) ...
    x == 1);
addRequired(P,'topLevelVectorDir',@(x) ...
    isdir(x) && ...
    ischar(x) && ...
    ~isempty(x));
addRequired(P,'hucCodeShapeStruct',@(x) ...
    isstruct(x) && ...
    ~isempty(x));
addRequired(P,'hucIndex',@(x) ...
    isscalar(x) && ...
    ~isempty(x));
addRequired(P,'gridMaskGeoRasterRef',@(x) ...
    isa(x,'spatialref.GeoRasterReference'));

parse(P,nargin,nargout,topLevelVectorDir,hucCodeShapeStruct,hucIndex, ...
    gridMaskGeoRasterRef);

%% Function Parameters

topLevelDirProps = dir(topLevelVectorDir);
subDirInd = logical(([topLevelDirProps.isdir] .* ...
    ~[topLevelDirProps.bytes])');
subDirInd(1:2) = 0;
subDirProps = topLevelDirProps(subDirInd);
subDirCount = sum(subDirInd);
subDirName = {subDirProps.name}';
vectorMosaicData = cell(subDirCount,2);
boundingBox = hucCodeShapeStruct(hucIndex,1).BoundingBox;

%% Iteratively Generate Vector Mosaic Data for Each Sub Directory

for i = 1:subDirCount
    
    disp(subDirName{i,1});
    
    subDirString = [topLevelVectorDir,'/',subDirName{i,1}];
    inputShapefileInfo = dir([subDirString,'/*.shp']);
    inputShapefileName = inputShapefileInfo.name;
    inputShapeStruct = shaperead([subDirString,'/',inputShapefileName], ...
        'UseGeoCoords',true, ...
        'BoundingBox',boundingBox);
    
    if isempty(inputShapeStruct) == 1
        
        vectorMosaicData{i,1} = [];
        
    else 
        
        vectorMosaicData{i,1} = vectorIntersectDataFnc( ...
            inputShapeStruct, hucCodeShapeStruct, hucIndex, ...
            gridMaskGeoRasterRef);
        
    end
    
    vectorMosaicData{i,2} = subDirName{i,1};

end

end                                               