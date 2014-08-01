%% Add Directory Tree to MATLAB Path

addpath(genpath('~/Repositories/WOGRSS'));
cd ~/Repositories/WOGRSS

%% Generate Input Parameter Object

run ./prm/californiaSample.m

%% Select Study Site

[p.hucID, p.hucIndex] = getHucCodeFnc( ...
    p.hucCodeShapeStruct, ...
    p.overlayShapeStruct);

%% Generate Grid Mask

[gridMask, gridMaskGeoRasterRef] = hucCode2GridMaskFnc( ...
    p.hucCodeShapeStruct, ...
    p.hucIndex, ...
    p.gridDensity);

%% Generate Raster Mosaic Cell Dataset

rasterMosaicData = extractRasterMosaicDataFnc( ...
    p.topLevelRasterDir, ...
    p.rasterNanFloor, ...
    gridMask, ...
    gridMaskGeoRasterRef );

%% Generate Gradient Mosaic Dataset

gradientMosaicData = dem2GradientMosaicDataFnc( ...
    rasterMosaicData{2,1}, ...
    p.gridDensity, ...
    gridMask, ...
    gridMaskGeoRasterRef );

%% Generate Vector Mosaic Cell Dataset

vectorMosaicData = extractVectorMosaicDataFnc( ...
    p.topLevelVectorDir, ...
    p.hucCodeShapeStruct, ...
    p.hucIndex, ...
    gridMaskGeoRasterRef );

%% Rasterize Vector Mosaic Dataset

newRasterMosaicData = vector2RasterMosaicDataFnc( ...
    vectorMosaicData, ...
    p.attributeFieldCell, ...
    gridMask, ...
    gridMaskGeoRasterRef );

%% Combine Raster Mosaic Datasets

finalRasterMosaicData = vertcat( ...
    rasterMosaicData, ... 
    gradientMosaicData, ...
    newRasterMosaicData);

%% Visualize Combined Final Raster Mosaic Dataset

rasterMosaicDataPlot( ...
    finalRasterMosaicData, ...
    gridMask, ...
    gridMaskGeoRasterRef );
