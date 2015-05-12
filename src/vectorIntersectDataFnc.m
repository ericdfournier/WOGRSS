function [ outputShapeStruct ] = vectorIntersectDataFnc( ...
                                                    inputShapeStruct,...
                                                    hucCodeShapeStruct, ...
                                                    hucIndex, ...
                                                    gridMaskGeoRasterRef )
% vectorIntersectDataFnc.m Function to generate the intersection of an 
% input vector dataset (corresponding to the gridMask basin outline) and 
% some inputShapeStruct vector dataset. 
% 
% Note: The routine assumes that all of the spatial data files involved
% have been previously been projected into the same geographic coordinate
% system
%
% DESCRIPTION:
%
%   Function to extract the vector intersection of a given input basin
%   outline and an inputShapeStruct vector dataset. The outputShapeStruct 
%   which is returned retains the attribute fields for each of the
%   intersected polygonal components. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ outputShapeStruct ] = vectorIntersectDataFnc( ...
%                                               inputShapeStruct, ...
%                                               hucCodeShapeStruct, ...
%                                               hucIndex, ...
%                                               gridMaskGeoRasterRef )
%
% INPUTS: 
%
%   inputShapeStruct =  {n x 1} shapefile structure array containing the
%                       spatial data and attribute information for which
%                       the intersection is desired to be performed
%
%   hucCodeShapeStruct = {f x 1} shapefile structure array containing the
%                       polygonal boundary data for each hucCode region 
%                       within the state
%   
%   hucIndex =          [w] scalara value containing the reference index
%                       value for the desired huc boundary shape data 
%                       relative to the elements in the input 
%                       hucCodeShapeStruct.
%
%   gridMaskGeoRasterRef = {struct} the geo raster reference object struct
%                       describing the spatial characteristics of the 
%                       raster data layer from which the spatial extent of
%                       the display map will be derived
%
% OUTPUTS:
%
%   outputShapeStruct = {m x 1} shapefile structure array containing the
%                       spatial data and attribute information ofr the 
%                       intersection of the inputShapeStruct and the 
%                       referenceBasin outline. 
%
% EXAMPLES:
%   
%   Example 1 =
%
% CREDITS:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                      %%
%%%                          Eric Daniel Fournier                        %%
%%%                  Bren School of Environmental Science                %%
%%%                 University of California Santa Barbara               %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse Inputs

P = inputParser;

addRequired(P,'nargin',@(x) ...
    x == 4);
addRequired(P,'nargout',@(x) ...
    x == 1);
addRequired(P,'inputShapeStruct',@(x) ...
    isstruct(x) && ...
    ~isempty(x));
addRequired(P,'hucCodeShapeStruct',@(x) ...
    isstruct(x) && ...
    ~isempty(x));
addRequired(P,'hucIndex',@(x) ...
    isscalar(x) && ...
    ~isempty(x));
addRequired(P,'gridMaskGeoRasterRef',@(x) ...
    isa(x,'map.rasterref.GeographicCellsReference'));

parse(P,nargin,nargout,inputShapeStruct,hucCodeShapeStruct,hucIndex, ...
    gridMaskGeoRasterRef);

%% Function Parameters

basinOutline = hucCodeShapeStruct(hucIndex,1);
basinLat = basinOutline.Lat';
basinLon = basinOutline.Lon';

if ispolycw(basinLat,basinLon) == 0
    
    [basinLat, basinLon] = poly2cw(basinLat, basinLon);
    
end

inputLat = {inputShapeStruct.Lat}';
inputLon = {inputShapeStruct.Lon}';

for i = 1:numel(inputLat)
    
    if ispolycw(inputLat{i,1},inputLon{i,1}) == 0
        
        [inputLat{i,1}, inputLon{i,1}] = poly2cw(inputLat{i,1},...
            inputLon{i,1});
        
    end
    
end

%% Perform Spatial Intersect Operation with Input Data

intersectLat = cell(numel(inputLat),1);
intersectLon = cell(numel(inputLon),1);
validInd = zeros(numel(inputLat),1);

for i = 1:numel(inputLat)

    [intersectLat{i,1}, intersectLon{i,1}] = polybool('intersection', ...
        basinLat, basinLon, inputLat{i,1}, inputLon{i,1} );
    validInd(i,1) = ~isempty(intersectLat{i,1});

end

validInd = logical(validInd);

switch all(~validInd)
    
    % Valid Intersection Exists
    
    case 0
        
        intersectLat = intersectLat(validInd,1);
        intersectLon = intersectLon(validInd,1);
        
        % Extract Original Feature Data Elements
        
        outputShapeStruct = inputShapeStruct(validInd,1);
        
        % Overwrite Latitude Longitude Coordinates and Bounding Boxes
        
        boundingBox = zeros(2,2);
        
        for i = 1:numel(intersectLat)
            
            rawIntLat = intersectLat{i,1}';
            intLat = nan(1,size(rawIntLat,2)+1);
            intLat(1,1:end-1) = rawIntLat;
            
            rawIntLon = intersectLon{i,1}';
            intLon = nan(1,size(rawIntLon,2)+1);
            intLon(1,1:end-1) = rawIntLon;
            
            [intLat, intLon] = poly2ccw(intLat,intLon);
            
            outputShapeStruct(i,1).Lat = intLat;
            outputShapeStruct(i,1).Lon = intLon;
            
            boundingBox(1,1) = min(intLon);
            boundingBox(2,1) = max(intLon);
            boundingBox(1,2) = min(intLat);
            boundingBox(2,2) = max(intLat);
            
            outputShapeStruct(i,1).BoundingBox = boundingBox;
            
        end
        
    % No Valid Intersection Exists
        
    case 1
    
    outputShapeStruct = [];
    
end

end