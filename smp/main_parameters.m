%% Initialize Parameter Structure

p = struct;

%% Spatial Data Filepaths

p.referenceShapePath = '/smp/data/reference/huc10/huc10.shp';
p.overlayShapePath = 'smp/data/reference/huc10/huc10.shp';

%% Create Spatial Data Structure Objects

p.referenceShapeStruct = shaperead(p.referenceShapePath,'UseGeoCoords',true);
p.overlayShapeStruct = shaperead(p.overlayShapePath,'UseGeoCoords',true);
p.attributeFieldName = 'HUC10';

%% Input Raster Data File Paths

p.topLevelRasterDir = '~/Repositories/WOSS/smp/data/raster/';
p.topLevelVectorDir = '~/Repositories/WOSS/smp/data/vector/';

%% Grid Mask Generation Parameters

p.gridDensity = 1116.99;

%% Raster Mosaic Generation Parameters

p.rasterNanFloors = -9999;

%% Shape Struct Attribute Field Parameter Cell

p.attributeFieldCell = { 'FIPS_NUM'; ...     % County FIPS Code
                         'GEOL_DD1'};        % Surface Geology Code