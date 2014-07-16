function [ plotHandle ] = rasterMosaicExtentPlot(   rasterMosaicList, ...
                                                    geoRasterRef )
% rasterMosaicExtentPlot.m Function which provides a visual plot of the
% spatial extent of a specified source dataset relative to those referenced
% by the filepaths contained in the input variable rasterMosaicList. 
% 
% Note: The routine assumes that all of the spatial data files involved
% have been previously been projected into the same geographic coordinate
% system and are stored as geotiff files with the file extension .tif
%
% DESCRIPTION:
%
%   Function to return the plothandle of a map plot of the overlapping
%   spatial extents of multiple input raster data files. The purpose of
%   this function is to provide a visual validation of the spatial extent
%   intersection procedure performed within the getRasterMosaicListFnc.m
%   routine. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ plotHandle ] =    rasterMosaicExtentPlot( rasterMosaicList, ...
%                                               geoRasterRef )
%
% INPUTS: 
%
%   mosaicList =        {g x 1} cell array containing the text string file
%                       names for each raster data file within the input 
%                       raster directory whose spatial extent either 
%                       contains or intersects the spatial extent of the 
%                       data file described in the geoRasterRef
%
%   geoRasterRef =      {struct} the geo raster reference object structure
%                       describing the spatial characteristics of the 
%                       raster data layer for which a list of contiguous 
%                       filepaths is to be generated. 
%
% OUTPUTS:
%
%   plotHandle =        [s] scalar plot handle variable referencing the
%                       generated output map plot. 
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
    x >= 0);
addRequired(P,'rasterMosaicList',@(x) ...
    iscell(x) && ...
    numel(x) >= 1 && ...
    ~isempty(x));
addRequired(P,'geoRasterRef',@(x) ...
    isa(x,'spatialref.GeoRasterReference'));

parse(P,nargin,nargout,rasterMosaicList,geoRasterRef);

%% Function Parameters

listSize = numel(rasterMosaicList);
referenceLatLim = geoRasterRef.Latlim;
referenceLonLim = geoRasterRef.Lonlim;
referenceLatBox = referenceLatLim([1 1 2 2 1]);
referenceLonBox = referenceLonLim([1 2 2 1 1]);

%% Generate Mosaic Plot

scrn = get(0,'ScreenSize');
fig1 = figure();
set(fig1,'Position',scrn);

hold on; 

for i = 1:listSize
    
    rasterInfo = geotiffinfo(rasterMosaicList{i,1});
    currentBoundingBox = rasterInfo.BoundingBox;
    currentLatLim = currentBoundingBox(1:2,2)';
    currentLonLim = currentBoundingBox(1:2,1)';
    currentLatBox = currentLatLim([1 1 2 2 1]);
    currentLonBox = currentLonLim([1 2 2 1 1]);
    geoshow(currentLatBox,currentLonBox);
    
end

plotHandle = geoshow(referenceLatBox,referenceLonBox,'r');

hold off;

end
