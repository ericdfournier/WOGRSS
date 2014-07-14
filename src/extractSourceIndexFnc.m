function [ sourceIndex ] = extractSourceIndexFnc(   sourceShapeStruct, ...
                                                    geoRasterRef )
% extractSourceIndexFnc.m Function which automatically extracts the
% location of the source index which will be used to initiate the MOGADOR
% corridor location procedure from a user specified overlay shape structure
% spatial dataset
%
% DESCRIPTION:
%
%   Function which takes as an input a grid mask layer, the grid mask's
%   spatial reference information, and an source shapefile structure
%   dataset and returns the source index with reference to the input
%   grid mask layer. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ sourceIndex ] =  extractSourceIndexFnc(   sourceShapeStruct, ...
%                                               geoRasterRef ); 
%
% INPUTS: 
%
%
% OUTPUTS:
%
%   sourceShapeStruct = sourceShapeStruct = {1 x 1} shapefile structure 
%                       dataset in the single point element corresponds to
%                       the location of the desired source location for
%                       which a source index is to be extracted
%
%   geoRasterRef =      {q} cell orientated geo raster reference object
%                       providing spatial reference information for the
%                       input gridMask data layer
%
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
    x == 2);
addRequired(P,'nargout',@(x)...
    x == 1);
addRequired(P,'sourceShapeStruct',@(x)...
    isstruct(x) &&...
    size(x,1) == 1 &&...
    ~isempty(x));
addRequired(P,'geoRasterRef',@(x)...
    isa(x,'spatialref.GeoRasterReference'));

parse(P,nargin,nargout,sourceShapeStruct,geoRasterRef);

%% Function Parameters

gS = geoRasterRef.RasterSize;

%% Extract Source Coordinates From Shapefile Structure Dataset 

sourceLat = sourceShapeStruct(1,1).Lat;
sourceLon = sourceShapeStruct(1,1).Lon;

%% Generate Source Index Value

indices = 1:1:(gS(1,1)*gS(1,2));
indexMask = reshape(indices,gS);
indexVal = ltln2val(indexMask,geoRasterRef,sourceLat,sourceLon);
[rowInd, colInd] = find(indexMask == indexVal);
sourceIndex = [rowInd colInd];
 
end