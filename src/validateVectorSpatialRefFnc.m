function [ output ] = validateVectorSpatialRefFnc( ...
                                                    topLevelVectorDir, ...
                                                    referenceDataLayer )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Parse Inputs

P = inputParser;

addRequired(P,'nargin',@(x) ...
    x == 2);
addRequired(P,'nargout',@(x) ...
    x == 1);
addRequired(P,'topLevelVectorDir',@(x) ...
    isdir(x) && ...
    ischar(x) && ...
    ~isempty(x));
addRequired(P,'referenceDataLayer',@(x) ...
    isdir(x) && ...
    ischar(x) && ...
    ~isempty(x));

parse(P,nargin,nargout,topLevelVectorDir,referenceDataLayer);

%% Function Parameters

% Read in reference data layer information

referenceDataInfo = shapeinfo(referenceDataLayer);

% Extract directory structure information

topLevelDirProps = dir(topLevelVectorDir);
subDirInd = logical(([topLevelDirProps.isdir] .* ...
    ~[topLevelDirProps.bytes])');
subDirInd(1:2) = 0;
subDirProps = topLevelDirProps(subDirInd);
subDirCount = sum(subDirInd);
subDirName = {subDirProps.name}';
vectorMosaicData = cell(subDirCount,3);
boundingBox = referenceShapeStruct(hucIndex,1).BoundingBox;

%% 

disp('** Reading Vector Data Spatial Reference Information**');

for i = 1:subDirCount
    
    disp(subDirName{i,1});
    
    subDirString = [topLevelVectorDir,'/',subDirName{i,1}];
    inputShapefileInfo = dir([subDirString,'/*.shp']);
    inputShapefileName = inputShapefileInfo.name;
    inputShapeStruct = shaperead([subDirString,'/',inputShapefileName], ...
        'UseGeoCoords',true, ...
        'BoundingBox',boundingBox);
    inputShapeStructInfo = shapeinfo( ...
        [subDirString,'/',inputShapefileName]);
    
    if isempty(inputShapeStruct) == 1
        
        vectorMosaicData{i,1} = [];
        
    else 
        
        vectorMosaicData{i,1} = vectorIntersectDataFnc( ...
            inputShapeStruct, hucCodeShapeStruct, hucIndex, ...
            gridMaskGeoRasterRef);
        
    end
    
    vectorMosaicData{i,2} = subDirName{i,1};
    vectorMosaicData{i,3} = inputShapeStructInfo.ShapeType;

end

end