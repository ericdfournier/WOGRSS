function [ plotHandle ] = vectorMosaicDataPlot( vectorMosaicData, ...
                                                gridMaskGeoRasterRef )
% vectorMosaicDataPlot.m Function to provide a panel of subplots for each
% of the vector datasets contained within an input vectorMosaicData data
% structure.
%
% DESCRIPTION:
%
%   Function to return a panel of subplots for each of the vector datasets
%   contained within an input vectorMosaicData data structure. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ plotHandle ] =    vectorMosaicDataPlot(   inputRasterData, ...
%                                               gridMaskGeoRasterRef )
%
% INPUTS: 
%
%   vectorMosaicData =  {j x 2} cell array containing the input vector
%                       mosaic datasets to be plotted
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
    x >= 0);
addRequired(P,'vectorMosaicData',@(x) ...
    iscell(x));
addRequired(P,'gridMaskGeoRasterRef',@(x) ...
    isa(x,'map.rasterref.GeographicCellsReference'));

parse(P,nargin,nargout,vectorMosaicData,gridMaskGeoRasterRef);

%% Function Parameters

fullCells = ~cellfun(@isempty,vectorMosaicData(:,1));
plotCount = sum(fullCells);
plotInd = find(fullCells);
plotDimRaw = round(sqrt(plotCount));

if mod(plotDimRaw,2) == 0
    
    plotDim1 = plotDimRaw;
    plotDim2 = plotDimRaw;
    
elseif mod(plotDimRaw,2) == 1
    
    plotDim1 = plotDimRaw;
    plotDim2 = ceil(plotCount./plotDimRaw);
    
end

latLim = gridMaskGeoRasterRef.Latlim;
lonLim = gridMaskGeoRasterRef.Lonlim;

%% Generate Output Plot

scrn = get(0,'ScreenSize');
plotHandle = figure();
set(plotHandle,'Position',scrn);

for i = 1:plotCount
    
currentInd = plotInd(i);
subplot(plotDim1,plotDim2,i);
usamap(latLim, lonLim);
geoshow(vectorMosaicData{currentInd,1});
title(['Data Source: ',vectorMosaicData{currentInd,2}]);

end

end