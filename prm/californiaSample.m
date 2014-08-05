%% Initialize Parameter Structure

p = struct;

%% Spatial Data Filepaths

p.hucCodeShapePath = '/Users/ericfournier/Repositories/WOGRSS/data/vector/hydrologicUnitCode/huc10.shp';
p.overlayShapePath = '/Users/ericfournier/Repositories/WOGRSS/data/vector/counties/counties.shp';

%% Create Spatial Data Structure Objects

p.hucCodeShapeStruct = shaperead(p.hucCodeShapePath,'UseGeoCoords',true);
p.overlayShapeStruct = shaperead(p.overlayShapePath,'UseGeoCoords',true);

%% Input Raster Data File Paths

p.topLevelRasterDir = '/Users/ericfournier/Repositories/WOGRSS/data/raster';
p.topLevelVectorDir = '/Users/ericfournier/Repositories/WOGRSS/data/vector';

%% Grid Mask Generation Parameters

p.gridDensity = 1116.99;

%% Raster Mosaic Generation Parameters

p.rasterNanFloors = -9999;

%% Shape Struct Attribute Field Parameters

p.attributeFieldCell = {'CRA_NUM'; ...  % Common Resource Areas
                        'FIPS'; ...     % Counties
                        'GEOL_DD1'; ... % Geology
                        'AreaAcres';... % Hydrologic Unit Code
                                        % Roads
                        'GIS_Acres';... % State Parks
                                        % Stream Delineations
                                        % Streets
                                        % Surface Water Impoundments
                        'FCODE'};       % Surface Water Storage