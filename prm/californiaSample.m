%% Initialize Parameter Structure

p = struct;

%% Spatial Data Filepaths

p.hucCodeShapePath = './data/huc10.shp';
p.overlayShapePath = './data/caCounties.shp';

%% Create Spatial Data Structure Objects

p.hucCodeShapeStruct = shaperead(p.hucCodeShapePath,'UseGeoCoords',true);
p.overlayShapeStruct = shaperead(p.overlayShapePath,'UseGeoCoords',true);

%% Grid Mask Generation Parameters

p.gridDensity = 1116.99;
