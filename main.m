%% Add Directory Tree to MATLAB Path

addpath(genpath('~/Repositories/WOGRSS'));
cd ~/Repositories/WOGRSS

%% Generate Input Parameter Object

run ./prm/californiaSample.m

%% Select Study Site

[hucID, hucIndex] = getHucCodeFnc( ...
    p.hucCodeShapeStruct, ...
    p.overlayShapeStruct);

%% Generate Grid Mask

[gridMask, geoRasterRef] = hucCode2GridMaskFnc( ...
    p.hucCodeShapeStruct, ...
    hucIndex, ...
    p.gridDensity);

%% Extract Source Index

sourceIndex = getSourceIndexFnc( ...
    geoRasterRef, ...
    gridMask);

%% Generate Raster Mosaic List

rasterMosaicList = getRasterMosaicListFnc( ...
    p.inputRasterDirectory, ...
    geoRasterRef );

%% View Mosaic Extent

plotHandle = rasterMosaicExtentPlot( ...
    p.overlayShapeStruct, ...
    rasterMosaicList, ...
    geoRasterRef );
