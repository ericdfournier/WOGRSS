function [ rasterMosaicData ] = rasterMosaicList2Data( ...
                                                    rasterMosaicList,...
                                                    gridMaskGeoRasterRef )
% rasterMosaicList2Data.m Function to extract and compile data values from
% a mosaic of possibly multiple images spanning a given bounding box 
% spatial extent corresponding to the input gridMaskGeoRasterRef.
%
% DESCRIPTION:
%
%   Function which generates an output mosaic raster data layer with same
%   spatial raster reference characteristics of the gridMaskGeoRasterRef
%   but with the data values contained in the files listed in the
%   rasterMosaicList. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ rasterMosaicData ] =  hucCode2GridMaskFnc(    rasterMosaicList, ...
%                                                   gridMaskGeoRasterRef )
%
% INPUTS: 
%
%   rasterMosaicList =  {g x 1} cell array containing the text string file
%                       names for each raster data file within the input 
%                       raster directory whose spatial extent either 
%                       contains or intersects the spatial extent of the 
%                       data file described in the geoRasterRef
%

%
% OUTPUTS:
%
%   gridMask =          [j x k] binary array with valid pathway grid cells 
%                       labeled as ones and invalid pathway grid cells 
%                       labeled as zero placeholders
%
%   geoRasterRef =      {q} cell orientated geo raster reference object
%                       providing spatial reference information for the
%                       input gridMask data layer
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

addRequired('nargin',@(x) ...
    x == 2);
addRequired('nargout',@(x) ...
    x == 1);
addRequired('rasterMosaicList',@(x) ...
    iscell(x) && ...
    ~isempty(x));
addRequired('gridMaskGeoRasterRef',@(x) ...
    isa(x,'spatialref.GeoRasterReference'));

parse(P,nargin,nargout,rasterMosaicList,gridMaskGeoRasterRef);

%% Function Parameters

listSize = numel(rasterMosaicList);
[refLon, refLat] = meshgrid( ...
    (gridMaskGeoRasterRef.Lonlim(1,1): ...
    abs(gridMaskGeoRasterRef.DeltaLon): ...
    gridMaskGeoRasterRef.Lonlim(1,2)), ...
    (gridMaskGeoRasterRef.Latlim(1,1): ...
    abs(gridMaskGeoRasterRef.DeltaLat): ...
    gridMaskGeoRasterRef.Latlim(1,2)));
refLon = refLon(1:end-1,1:end-1);
refLat = refLat(1:end-1,1:end-1);
refLatVec = reshape(refLat,(size(refLat,1)*size(refLat,2)),1);
refLonVec = reshape(refLon,(size(refLon,1)*size(refLon,2)),1);
rasterMosaicData = nan(gridMaskGeoRasterRef.RasterSize(1,1),...
    gridMaskGeoRasterRef.RasterSize(1,2));

%% Iteratively Construct Mosaic Raster Data from Individual Rasters

for i = 1:listSize
        
        [currentRaster, currentGeoRasterRef] = ...
            geotiffread(rasterMosaicList{i,1});
        
        currentValVec = ltln2val(currentRaster,currentGeoRasterRef,...
            refLatVec,refLonVec);
        currentValMask = reshape(currentValVec,...
            gridMaskGeoRasterRef.RasterSize(1,1),...
            gridMaskGeoRasterRef.RasterSize(1,2));        
        
        nanTest = isnan(currentValVec);
        nanMask = reshape(~nanTest,gridMaskGeoRasterRef.RasterSize(1,1),...
            gridMaskGeoRasterRef.RasterSize(1,2));        
        
        rasterMosaicData(nanMask) = currentValMask(nanMask);
        
        if any(nanTest) == 0
            
            break
            
        end
        
end

rasterMosaicData = flipud(rasterMosaicData);

end