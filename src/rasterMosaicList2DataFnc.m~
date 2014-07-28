function [ rasterMosaicData ] = rasterMosaicList2DataFnc( ...
                                                    rasterMosaicList,...
                                                    rasterNanFloor, ...
                                                    gridMask, ...
                                                    gridMaskGeoRasterRef )
% rasterMosaicList2DataFnc.m Function to extract and compile data values 
% from a mosaic of possibly multiple images spanning a given bounding box 
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
%   [ rasterMosaicData ] =  rasterMosaicList2DataFnc( ...
%                                                   rasterMosaicList, ...
%                                                   rasterNanFloor, ...
%                                                   gridMask, ...
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
%   rasterNanFloor =    [j] scalar value indicating the floor of all real
%                       valued data elements in the input raster data sets.
%                       All values below this floor with automatically be 
%                       set to a value of NAN during the execution of the 
%                       routine.
%
%   gridMask =          [n x m] binary array in which grid cells contained
%                       within the basin of interest are coded as 1 and 
%                       grid cells outside the basin of interest are coded
%                       as zero
%
%   gridMaskGeoRasterRef = {q} cell orientated geo raster reference object
%                       providing spatial reference information for the
%                       input gridMask data layer
% 
% OUTPUTS:
%
%   rasterMosaicData =  [n x m] raster dataset with the same spatial
%                       reference information as that contained in the 
%                       gridMaskGeoRasterRef but the values corresponding 
%                       to those contained within datafiles specified in
%                       the mosaicRasterList cell array
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
addRequired(P,'rasterMosaicList',@(x) ...
    iscell(x) && ...
    ~isempty(x));
addRequired(P,'rasterNanFloor',@(x) ...
    isscalar(x) && ...
    ~isempty(x));
addRequired(P,'gridMask',@(x) ...
    isnumeric(x) && ...
    ismatrix(x) && ...
    ~isempty(x));
addRequired(P,'gridMaskGeoRasterRef',@(x) ...
    isa(x,'spatialref.GeoRasterReference'));

parse(P,nargin,nargout,rasterMosaicList,rasterNanFloor,gridMask, ...
    gridMaskGeoRasterRef);

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
rasterMosaicData = nan(gridMaskGeoRasterRef.RasterSize(1,1), ...
    gridMaskGeoRasterRef.RasterSize(1,2));

%% Iteratively Construct Mosaic Raster Vector Stack from Individual Rasters

for i = 1:listSize
        
        [currentRaster, currentGeoRasterRef] = ...
            geotiffread(rasterMosaicList{i,1});
        currentRaster(currentRaster <= rasterNanFloor) = nan;
        
        currentValVec = ltln2val(currentRaster, ...
            currentGeoRasterRef,refLatVec,refLonVec);
        currentValRaster = reshape(currentValVec,size(rasterMosaicData));
        
        validInd = ~isnan(currentValVec);
        rasterMosaicData(validInd) = currentValRaster(validInd);
        
end

rasterMosaicData = flipud(rasterMosaicData);
rasterMosaicData = gridMask.*rasterMosaicData;

end