function [ outputRasterMosaicData ] = vector2RasterMosaicDataFnc( ...
                                                inputVectorMosaicData, ...
                                                attributeFieldCell, ...
                                                gridMask, ...
                                                gridMaskGeoRasterRef )
% vector2RasterMosaicDataFnc.m Function to convert a cell array of input 
% vector datasets, each in the form of a shape struct array to a set of 
% raster outputs using the raster spatial extent and data characteristics 
% contained in the gridMaskGeoRasterRef input data object.
%
% DESCRIPTION:
%
%   Function to automatically convert a cell array of vector spatial 
%   datasets to raster versions that have the same spatial characteristics 
%   of the input geoRasterReference object corresponding to the gridMask. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ outputRasterMosaicData ] =  vector2RasterDataFnc( ...
%                                               inputVectorMosaicData, ...
%                                               attributeFieldCell, ...
%                                               gridMask, ...
%                                               gridMaskGeoRasterRef )
%
% INPUTS: 
%
%   inputVectorMosaicData = {j x 2} cell array where each element in the 
%                       first column contains a shapefile structure array 
%                       corresponding to the shape geometry of the 
%                       attribute described in column two of the 
%                       corresponding row element
%
%   attributeFieldCell = {j x 1} cell array containing character strings 
%                       which reference the respective attribute fields 
%                       that are desired to be used to generate the grid 
%                       cell encodings for each of the output raster 
%                       datasets produced in the outputRasterMosaicData 
%                       cell array (valid attribute fields must contain
%                       only double precision floating point values)
%
%   gridMask =          [n x m] binary input raster corresponding to the
%                       outline of the basin to be used as the spatial 
%                       reference for the rest of the analysis
%
%   gridMaskGeoRasterRef = {q} cell orientated geo raster reference object
%                       providing spatial reference information for the
%                       reference basin gridMask data layer
% 
% OUTPUTS:
%
%   outputRasterMosaicData = {j x 2} cell array containing rasterized 
%                       versions of each inputShapeStruct spatial data 
%                       layers contained in each row (j) of the
%                       inputVectorMosaicData cell array. In each raster
%                       produced within the rows of the first column of the
%                       outputRasterMosaicData cell array, each 
%                       cell's value corresponds to the value of the 
%                       desired attribute field at the point location of 
%                       that grid cell's centroid latitude and longitude
%                       coordinates
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
addRequired(P,'inputVectorMosaicData',@(x) ...
    iscell(x) && ...
    ~isempty(x));
addRequired(P,'attributeFieldCell',@(x) ...
    iscell(x) && ...
    ~isempty(x));
addRequired(P,'gridMask',@(x) ...
    isnumeric(x) && ...
    ismatrix(x)  && ...
    ~isempty(x));
addRequired(P,'gridMaskGeoRasterRef',@(x) ...
    isa(x,'spatialref.GeoRasterReference'));

parse(P,nargin,nargout,inputVectorMosaicData,attributeFieldCell,...
    gridMask,gridMaskGeoRasterRef);

%% Function Parameters
    
shapeCount = numel(inputVectorMosaicData);
outputRasterMosaicData = cell(shapeCount,2);

%% Perform Data Type Conversion and Generate Final Output

for i = 1:shapeCount
   
    outputRasterMosaicData{i,1} = vector2RasterDataFnc( ...
        inputVectorMosaicData{i,1}, ...
        attributeFieldCell{i,1}, ...
        gridMask, ...
        gridMaskGeoRasterRef );
    outputRasterMosaicData{i,2} = inputVectorMosaicData{i,2};
    
end

end