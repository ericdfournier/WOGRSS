function [ plotHandle ] = rasterDataPlot(   inputRasterData, ...
                                            gridMask, ...
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
%                                       gridMask, ...
%                                       gridMaskGeoRasterRef )
%
% INPUTS: 
%
%   inputRasterData =   [n x m] matrix containing the values for some data
%                       source that is to be displayed as a texture map
%                       relative to the outline of the reference basin
%
%   gridMask =          [n x m] binary array in which cells with a value of
%                       1 are located within the basin of interest and 
%                       cells with a value of 0 are located outside of the 
%                       basin of interest
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
    x == 3);
addRequired(P,'nargout',@(x) ...
    x >= 0);
addRequired(P,'inputRasterData',@(x) ...
    isnumeric(x) && ...
    ismatrix(x) && ...
    ~isempty(x));
addRequired(P,'gridMask',@(x) ...
    isnumeric(x) && ...
    ismatrix(x) && ...
    ~isempty(x));
addRequired(P,'gridMaskGeoRasterRef',@(x) ...
    isa(x,'map.rasterref.GeographicCellsReference'));

parse(P,nargin,nargout,inputRasterData,gridMask,gridMaskGeoRasterRef);

%% Function Parameters

latLim = gridMaskGeoRasterRef.Latlim;
lonLim = gridMaskGeoRasterRef.Lonlim;
[cmapRasterData, ~] = cmunique(inputRasterData);
cmapRasterData(~gridMask) = nan;

%% Generate Output Plot

usamap(latLim,lonLim);
hold on
plotHandle = geoshow(cmapRasterData,gridMaskGeoRasterRef,...
    'DisplayType','texturemap');
colorbar;

end