function [ gridMask, geoRasterRef ] = hucCode2GridMaskFnc( ...
                                                    hucCodeShapeStruct, ...
                                                    hucIndex, ...
                                                    gridDensity )

% hucCode2GridMaskFnc.m Function to generate a binary gridMask from a 
% scalar index value for a basin that has been selected from a 
% hucCodeShapeStruct.
%
% DESCRIPTION:
%
%   Function which extracts and formats a binary grid mask layer for use in
%   further analysis from an input basin code.
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ gridMask, geoRasterRef ] =  hucCode2GridMaskFnc( ...
%                                                   hucCodeShapeStruct, ...
%                                                   hucIndex, ...
%                                                   gridDensity);
%
% INPUTS: 
%
%   hucCodeShapeStruct = {g x 1} shapefile structure dataset in which each 
%                       polygon corresponds to a delineated HUC basin
%
%   hucIndex =          [s] scalar vector index referencing the
%                       hucCodeShapeStruct element corresponding to the 
%                       basin that has been selected by the user for the 
%                       production of the gridMask
%
%   gridDensity =       [p] scalar value indicating the desired number of 
%                       grid cells per unit of latitude and longitude 
%                       (a value of 10 indicates 10 cells per degree, for 
%                       example)
%
% OUTPUTS:
%
%   gridMask =          [j x k] binary array with valid pathway grid cells 
%                       labeled as ones and invalid pathway grid cells 
%                       labeled as zero placeholders
%
%   geoRasterRef =      {q} cell orientated geo raster reference object
%                       providing spatial reference information for the
%                       input gridMask data layer
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

addRequired(P,'nargin',@(x)...
    x == 3);
addRequired(P,'nargout',@(x)...
    x == 2);
addRequired(P,'hucCodeShapeStruct',@(x)...
    isstruct(x) &&...
    ~isempty(x));
addRequired(P,'hucIndex',@(x)...
    isscalar(x) &&...
    x > 0 && ...
    ~isempty(x));
addRequired(P,'gridDensity',@(x)...
    isscalar(x) &&...
    x > 0 && ...
    ~isempty(x));

parse(P,nargin,nargout,hucCodeShapeStruct,hucIndex,gridDensity);

%% Extract Basin Geometry Data

basinLon = hucCodeShapeStruct(hucIndex,1).Lon;
basinLat = hucCodeShapeStruct(hucIndex,1).Lat;

%% Generate Grid Mask Output

[gridMask, ~] = vec2mtx(basinLat,basinLon,gridDensity,'filled');
gridMask(gridMask <= 1) = 1;
gridMask(gridMask == 2) = 0;
gridMask = flipud(gridMask);

%% Spatial Reference Parameters

rasterSize = size(gridMask);
boundingBox = extractfield(hucCodeShapeStruct(hucIndex,1),'BoundingBox');
lonLim = boundingBox(1,1:2);
latLim = boundingBox(1,3:4);
colStart = 'North';
rowStart = 'West';
rasterInterp = 'Cells';

%% Generate Output GeoRasterReference Object

geoRasterRef = georasterref(...
    'RasterSize',rasterSize,...
    'LatLim',latLim,...
    'LonLim',lonLim,...
    'RasterInterpretation',rasterInterp,...
    'ColumnsStartFrom',colStart,...
    'RowsStartFrom',rowStart );

end