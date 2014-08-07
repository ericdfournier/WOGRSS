function [ plotHandle ] = rasterMosaicDataPlot( rasterMosaicData, ...
                                                gridMask, ...
                                                gridMaskGeoRasterRef )
% rasterMosaicDataPlot.m Function to provide a panel of subplots for each
% of the vector datasets contained within an input vectorMosaicCell data
% structure.
%
% DESCRIPTION:
%
%   Function to return a panel of subplots for each of the vector datasets
%   contained within an input vectorMosaicCell data structure. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ plotHandle ] =    rasterMosaicDataPlot(   inputRasterData, ...
%                                               gridMask, ...
%                                               gridMaskGeoRasterRef )
%
% INPUTS: 
%
%   rasterMosaicData =  {j x 2} cell array containing the input raster
%                       mosaic datasets to be plotted
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
addRequired(P,'rasterMosaicData',@(x) ...
    iscell(x));
addRequired(P,'gridMask',@(x) ...
    isnumeric(x) && ...
    ismatrix(x) && ...
    ~isempty(x)) 
addRequired(P,'gridMaskGeoRasterRef',@(x) ...
    isa(x,'spatialref.GeoRasterReference'));

parse(P,nargin,nargout,rasterMosaicData,gridMask,gridMaskGeoRasterRef);

%% Function Parameters

fullCells = ~cellfun(@isempty,rasterMosaicData(:,1));
plotCount = sum(fullCells);
plotInd = find(fullCells);
plotDimRaw = sqrt(plotCount);

if mod(plotDimRaw,2) == 0
    
    plotDim1 = plotDimRaw;
    plotDim2 = plotDimRaw;
    
else
    
    plotDim1 = ceil(plotDimRaw);
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
    rasterDataPlot(rasterMosaicData{currentInd,1},gridMask,...
        gridMaskGeoRasterRef);
    title(['Data Source: ',rasterMosaicData{currentInd,2}]);

end

end