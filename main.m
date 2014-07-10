%% Add Directory Tree to MATLAB Path

addpath(genpath('~/Repositories/WOGRSS'));
cd ~/Repositories/WOGRSS

%% Read in Spatial Data Files

hucCodeShapePath = './data/huc10/huc10.shp';
overlayShapePath = './data/counties/caCounties.shp';
hucCodeShapeStruct = shaperead(hucCodeShapePath,'UseGeoCoords',true);
overlayShapeStruct = shaperead(overlayShapePath,'UseGeoCoords',true);

%% Select Study Site

stateName = 'California';
[hucID, hucIndex] = getHucCodeFnc(hucCodeShapeStruct,overlayShapeStruct,...
    stateName);

%% Generate Grid Mask

gridDensity = 1116.99;
[gridMask, spatialRef] = hucCode2GridMaskFnc(hucCodeShapeStruct,...
    hucIndex,gridDensity);

%% 