function [ plotHandle ] = rasterBasinOutlinePlot( ...
                                                inputRasterData, ...
                                                gridMaskGeoRasterRef, ...
                                                hucCodeShapeStruct, ...
                                                hucIndex )
% rasterBasinOutlinePlot.m Function to map a given raster dataset relative
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
%   [ plotHandle ] =    rasterBasinOutlinePlot( inputRasterData, ...
%                                               gridMaskGeoRasterRef, ...
%                                               hucCodeShapeStruct, ...
%                                               hucIndex )
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
%   hucCodeShapeStruct = {f x 1} shapefile structure array containing the
%                       polygonal boundary data for each hucCode region 
%                       within the state
%   
%   hucIndex =          [w] scalara value containing the reference index
%                       value for the desired huc boundary shape data 
%                       relative to the elements in the input 
%                       hucCodeShapeStruct.
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
    x == 4);
addRequired(P,'nargout',@(x) ...
    x <= 1);
addRequired(P,'inputRasterData',@(x) ...
    isnumeric(x) && ...
    ismatrix(x) && ...
    ~isempty(x));
addRequired(P,'gridMaskGeoRasterRef',@(x) ...
    isa(x,'spatialref.GeoRasterReference'));
addRequired(P,'hucCodeShapeStruct',@(x) ...
    isstruct(x) && ...
    ~isempty(x));
addRequired(P,'hucIndex',@(x) ...
    isscalar(x) && ...
    ~isempty(x));

parse(P,nargin,nargout,inputRasterData,gridMaskGeoRasterRef, ...
    hucCodeShapeStruct,hucIndex);

%% Function Parameters

basinOutline = hucCodeShapeStruct(hucIndex,1);

%% Generate Output Plot

scrn = get(0,'ScreenSize');
fig1 = figure();
set(fig1,'Position',scrn);

usamap(gridMaskGeoRasterRef.Latlim,gridMaskGeoRasterRef.Lonlim);

hold on;
geoshow(inputRasterData,gridMaskGeoRasterRef,'DisplayType','texture');
colorbar;
geoshow(basinOutline,'DisplayType','polygon','FaceColor','none');
hold off;

end