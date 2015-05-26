%% Add Directory Tree to MATLAB Path

addpath(genpath('~/Repositories/WOSS'));
cd ~/Repositories/WOSS

%% Generate Input Parameter Object

run ./smp/main_parameters.m

%% Select Study Site

% Run this Cell

%   When the figure window appears you will be given a prompt asking for the 
% appropriate area that should be used to generate the map axes

% Select 'California' from the dropdown menu

%   Maximize the figure window so that you can see the full extent of the
%   reference area. You can select the desired reference polygon by simply
%   clicking on the map. 

[p.attributeId, p.attributeIndex, p.gridMask, p.gridMaskGeoRasterRef] = ...
    extractGridMaskFnc( ...
    p.referenceShapeStruct, ...
    p.attributeFieldName,...
    p.referenceShapeStruct, ...
    p.gridDensity );

%% Generate Raster Mosaic Datasets

% Run this cell

% The routine will automate the process of extracting and compiling the 
% spatial datasets referenced in the parameters structure 'p'

rawRasterMosaicData = extractRawRasterMosaicDataFnc( ...
    p.topLevelRasterDir, ...
    p.topLevelVectorDir, ...
    p.rasterNanFloors, ...
    p.gridDensity, ...
    p.attributeFieldCell, ...
    p.referenceShapeStruct, ...
    p.attributeIndex, ...
    p.gridMask, ...
    p.gridMaskGeoRasterRef );

%% Visualize Combined Final Raster Mosaic Datasets

% Run this cell

% A plot grid will be generated showing the values of all of the output 
% raster grids that have been generated and stored in the
% rawRasterMosaicData cell object

rasterMosaicDataPlot( ...
    rawRasterMosaicData, ...
    p.gridMask, ...
    p.gridMaskGeoRasterRef );