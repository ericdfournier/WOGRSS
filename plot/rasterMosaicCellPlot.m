function [ plotHandle ] = rasterMosaicCellPlot( rasterMosaicCell, ...
                                                hucCodeShapeStruct, ...
                                                hucIndex, ...
                                                gridMaskGeoRasterRef )
% vectorMosaicCellPlot.m Function to provide a panel of subplots for each
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
%   [ plotHandle ] =    vectorMosaicCellPlot(   inputRasterData, ...
%                                               gridMaskGeoRasterRef )
%
% INPUTS: 
%
%   vectorMosaicCell =  {j x 2} cell array containing the input vector
%                       mosaic datasets to be plotted
%
%   hucCodeShapeStruct = {f x 1} shapefile structure array containing the
%                       polygonal boundary data for each hucCode region 
%                       within the state
%   
%   hucIndex =          [w] scalara value containing the reference index
%                       value for the desired huc boundary shape data 
%                       relative to the elements in the input 
%                       hucCodeShapeStruct
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
    x == 4);
addRequired(P,'nargout',@(x) ...
    x >= 0);
addRequired(P,'rasterMosaicCell',@(x) ...
    iscell(x));
addRequired(P,'hucCodeShapeStruct',@(x) ...
    isstruct(x) && ...
    ~isempty(x));
addRequired(P,'hucIndex',@(x) ...
    isscalar(x) && ...
    ~isempty(x));
addRequired(P,'gridMaskGeoRasterRef',@(x) ...
    isa(x,'spatialref.GeoRasterReference'));

parse(P,nargin,nargout,rasterMosaicCell,hucCodeShapeStruct,hucIndex,...
    gridMaskGeoRasterRef);

%% Function Parameters

fullCells = ~cellfun(@isempty,rasterMosaicCell(:,1));
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
rasterBasinOutlinePlot( ...
    rasterMosaicCell{currentInd,1}, ...
    hucCodeShapeStruct, ...
    hucIndex, ...
    gridMaskGeoRasterRef );
title(['Data Source: ',rasterMosaicCell{currentInd,2}]);

end

end