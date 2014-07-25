function [ outputRaster ] = vector2RasterDataFnc( ...
                                                inputShapeStruct, ...
                                                attributeField, ...
                                                gridMask, ...
                                                gridMaskGeoRasterRef )
%% Parse Inputs

P = inputParser;

addRequired(P,'nargin',@(x) ...
    x == 4);
addRequired(P,'nargout',@(x) ...
    x == 1);
addRequired(P,'inputShapeStruct',@(x) ...
    isstruct(x) && ...
    ~isempty(x));
addRequired(P,'attributeField',@(x) ...
    ischar(x) && ...
    ~isempty(x));
addRequired(P,'gridMask',@(x) ...
    isnumeric(x) && ...
    ismatrix(x) && ...
    ~isempty(x));
addRequired(P,'gridMaskGeoRasterRef',@(x) ...
    isa(x,'spatialref.GeoRasterReference'));

parse(P,nargin,nargout,inputShapeStruct,attributeField,gridMask, ...
    gridMaskGeoRasterRef);

%% Function Parameters

refMat = ones(size(gridMask));
[gridLat, gridLon] = findm(refMat,gridMaskGeoRasterRef);
featureCount = numel(inputShapeStruct);
outputRaster = zeros(size(gridMask));
attributeVec = extractfield(inputShapeStruct,attributeField)';

%% Validate Attribute Field

if isnumeric(attributeVec) == 0
    
    error('Attribute Field Must Be Numeric');
    
end
    
%% Check Feature Containment

for i = 1:featureCount
    
    curPolyLat = [inputShapeStruct(i,1).Lat]';
    curPolyLon = [inputShapeStruct(i,1).Lon]';
    gridIntersect = inpolygon(gridLat,gridLon,curPolyLat,curPolyLon);
    gridIntersectMask = reshape(gridIntersect,size(gridMask));
    outputRaster(logical(gridIntersectMask)) = attributeVec(i,1);
    
end

end