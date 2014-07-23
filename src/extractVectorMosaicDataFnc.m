function [ vectorMosaicCell ] = extractVectorMosaicDataFnc( ...
                                                topLevelVectorDir, ...
                                                hucCodeShapeStruct, ...
                                                hucIndex, ...
                                                gridMaskGeoRasterRef )
%% Parse Inputs

P = inputParser;

addRequired(P,'nargin',@(x) ...
    x == 4);
addRequired(P,'nargout',@(x) ...
    x == 1);
addRequired(P,'topLevelVectorDir',@(x) ...
    isdir(x) && ...
    ischar(x) && ...
    ~isempty(x));
addRequired(P,'gridMaskGeoRasterRef',@(x) ...
    isa(x,'spatialref.GeoRasterReference'));

parse(P,nargin,nargout,topLevelVectorDir,gridMaskGeoRasterRef);

%% Function Parameters

topLevelDirProps = dir(topLevelVectorDir);
subDirInd = logical(([topLevelDirProps.isdir] .* ...
    ~[topLevelDirProps.bytes])');
subDirInd(1:2) = 0;
subDirProps = topLevelDirProps(subDirInd);
subDirCount = sum(subDirInd);
subDirName = {subDirProps.name}';
vectorMosaicCell = cell(subDirCount,2);

%% Iteratively Generate Vector Mosaic Data for Each Sub Directory

for i = 1:subDirCount   
    
    subDirString = [topLevelVectorDir,'/',subDirName{i,1}];
    inputShapefileInfo = dir([subDirString,'/*.shp']);
    inputShapefileName = inputShapefileInfo.name;
    inputShapeStruct = shaperead([subDirString,'/',inputShapefileName], ...
        'UseGeoCoords',true);
    vectorMosaicCell{i,1} = vectorIntersectDataFnc( inputShapeStruct, ...
        hucCodeShapeStruct, hucIndex, gridMaskGeoRasterRef);
    vectorMosaicCell{i,2} = subDirName{i,1};

end

end                                               