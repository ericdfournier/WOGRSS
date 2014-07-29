function [ plotHandle ] = rasterDataPlot(   inputRasterData, ...
                                            gridMaskGeoRasterRef )
% rasterDataPlot.m Function to map a given raster dataset relative
% to the outline of the gridMask reference basin to provide a visual
% illustration of its spatial context
% 
% Note: The routine assumes that all of the spatial data files involved
% have been previously been projected into the same geographic coordinate
% system
%
% DESCRIPTION:
%
%   Function to return the plot handle of a map figure containing a visual
%   representation of an input raster dataset with the outline of the
%   gridMask reference basin for visual context. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ plotHandle ] =    rasterDataPlot( inputRasterData, ...
%                                       gridMaskGeoRasterRef )
%
% INPUTS: 
%
%   inputRasterData =   [n x m] matrix containing the values for some data
%                       source that is to be displayed as a texture map
%                       relative to the outline of the reference basin
%
%   gridMaskGeoRasterRef = {struct} the geo raster reference object struct
%                       describing the spatial characteristics of the 
%                       raster data layer from which the spatial extent of
%                       the display map will be derived
%
% OUTPUTS:
%
%   plotHandle =        [s] scalar plot handle variable referencing the
%                       generated output map plot 
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
    x == 2);
addRequired(P,'nargout',@(x) ...
    x <= 1);
addRequired(P,'inputRasterData',@(x) ...
    isnumeric(x) && ...
    ismatrix(x) && ...
    ~isempty(x));
addRequired(P,'gridMaskGeoRasterRef',@(x) ...
    isa(x,'spatialref.GeoRasterReference'));

parse(P,nargin,nargout,inputRasterData, ....
    gridMaskGeoRasterRef);

%% Function Parameters

latLim = gridMaskGeoRasterRef.Latlim;
lonLim = gridMaskGeoRasterRef.Lonlim;
[cmapRasterData, ~] = cmunique(inputRasterData);

%% Generate Output Plot

usamap(latLim,lonLim);
plotHandle = geoshow(cmapRasterData,gridMaskGeoRasterRef,...
    'DisplayType','texturemap');
colorbar;

end