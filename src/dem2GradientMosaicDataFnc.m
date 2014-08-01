function [ demGradientMosaicData ] = dem2GradientMosaicDataFnc( ...
                                                    demData, ...
                                                    gridDensity, ...
                                                    gridMask, ...
                                                    gridMaskGeoRasterRef )
% dem2GradientMosaicDataFnc.m Function to automatically generate derived
% gradient data layers from an input digital elevation model for a basin of
% interest.
%
% DESCRIPTION:
%
%   Function to produce the following set of derived gradient data products
%   from a given input raster digital elevation model: aspect, slope,
%   gradientNorth, gradientWest
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ demGradientMosaicData ] =  hucCode2GridMaskFnc( ...
%                                                   demData, ...
%                                                   gridDensity, ...
%                                                   gridMask, ...
%                                                   gridMaskGeoRasterRef )
%
% INPUTS: 
%
%   demData =           [n x m] array in which each grid cell contains the
%                       elevation z value for the basin of interest
%
%   gridDensity =       [s] scalar value indicating the number of cells per
%                       decimal degree of latitude and longitude
%
%   gridMask =          [n x m] binary array indicating the boundaries of
%                       the study site basin
%
%   gridMaskGeoRasterRef = {struct} spatialref.GeoRasterReference object
%                       containing the spatial reference information for 
%                       the raster data input arguments
%
% OUTPUTS:
%
%   demGradientMosaicData = {4 x 2} cell array in which the first column
%                       elements are derived gradient raster datasets and 
%                       in which the second column elements are the name 
%                       character strings corresponding to each raster 
%                       dataset
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
addRequired(P,'demData',@(x) ...
    isnumeric(x) && ...
    ismatrix(x) && ...
    ~isempty(x));
addRequired(P,'gridDensity',@(x) ...
    isscalar(x) && ...
    ~isempty(x));
addRequired(P,'gridMask',@(x) ...
    isnumeric(x) && ...
    ismatrix(x) && ...
    ~isempty(x));
addRequired(P,'gridMaskGeoRasterRef',@(x) ...
    isa(x,'spatialref.GeoRasterReference'));

parse(P,nargin,nargout,demData,gridDensity,gridMask,gridMaskGeoRasterRef);

%% Function Parameters

demGradientMosaicData = cell(4,2);
names = {'aspect'; 'slope'; 'gradientNorth'; 'gradientSouth'};
latLim = gridMaskGeoRasterRef.Latlim;
lonLim = gridMaskGeoRasterRef.Lonlim;
referenceVec = [gridDensity max(latLim) min(lonLim)];

%% Generate Ouputs

[demGradientMosaicData{1,1}, ...
    demGradientMosaicData{2,1}, ...
    demGradientMosaicData{3,1}, ...
    demGradientMosaicData{4,1}] = gradientm(demData,referenceVec);

demGradientMosaicData(:,2) = names(:,1);

for i = 1:4
    
    demGradientMosaicData{i,1} = demGradientMosaicData{i,1} .* gridMask;
    
end

end