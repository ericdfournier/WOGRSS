function [  hucId, ...
            hucIndex, ...
            gridMask, ...
            gridMaskGeoRasterRef ] = extractGridMaskFnc( ...
                                                    hucCodeShapeStruct, ...
                                                    hucCodeFieldName,...
                                                    overlayShapeStruct, ...
                                                    gridDensity )
% extractGridMaskFnc.m Function to extract a rasterized version of a user
% selected basin extent through the interaction with an overlay map
% display. Also returned are the basin feature indices and the spatial
% extent information for the output gridMask basin layer.
%
% DESCRIPTION:
%
%   Function which provides an interactive user interface for generating a 
%   gridMask raster data layer for a desired study region by preseting the 
%   user with a contextually meaninful map. The function assumes that both 
%   the input spatial data layers have been preprocessed such that they 
%   have the same coordinate system and map projection. Failure to perform 
%   these preprocessing steps will result in a runtime error for the 
%   function. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [   hucCode, ...
%       hucIndex, ...
%       gridMask, ...
%       gridMaskGeoRasterRef ] =  getHucCodeFnc(    hucCodeShapeStruct, ...
%                                                   hucCodeFieldName,...
%                                                   overlayShapeStruct, ...
%                                                   gridDensity );
%
% INPUTS: 
%
%   hucCodeShapeStruct = {g x 1} shapefile structure dataset in which each 
%                       polygon corresponds to a delineated HUC basin.
%
%   hucCodeFieldName =  'String' attribute field name corresponding to the 
%                       huc region boundary geometries desired to be used
%
%   overlayShapeStruct = {h x 1} shapefile structure dataset which will be 
%                       overlaid over the spatial extent to 
%                       provide contextual reference for the user to be
%                       able to locate the desired location for the study
%                       analysis.
%
%   gridDensity =       [p] scalar value indicating the desired number of 
%                       grid cells per unit of latitude and longitude 
%                       (a value of 10 indicates 10 cells per degree, for 
%                       example)
%
% OUTPUTS:
%
%
%   hucCode =           [s] scalar value indicating the basin
%                       identification code for the study region selected 
%                       by the user.
%
%   hucIndex =          [r] scalar hucIndex value of the hucCodeShape data
%                       structure element corresponding to the basiCode 
%                       selected by the user
%
%   gridMask =          [j x k] binary array with valid pathway grid cells 
%                       labeled as ones and invalid pathway grid cells 
%                       labeled as zero placeholders
%
%   gridMaskGeoRasterRef = {q} cell orientated geo raster reference object
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

addRequired(P,'nargin',@(x) ...
    x == 4);
addRequired(P,'nargout',@(x) ...
    x == 4);
addRequired(P,'hucCodeShapeStruct',@(x) ...
    isstruct(x) && ...
    ~isempty(x));
addRequired(P,'hucCodeFieldName',@(x) ...
    isa(x,'char') && ...
    ~isempty(x));
addRequired(P,'overlayShapeStruct',@(x) ...
    isstruct(x) && ...
    ~isempty(x));
addRequired(P,'gridDensity',@(x) ...
    isscalar(x) && ...
    ~isempty(x));

parse(P,nargin,nargout,hucCodeShapeStruct,hucCodeFieldName,...
    overlayShapeStruct,gridDensity);

%% User Select Location

[hucId, hucIndex] = getHucCodeFnc( ...
    hucCodeShapeStruct, ...
    hucCodeFieldName,...
    overlayShapeStruct);

%% Generate Grid Mask

[gridMask, gridMaskGeoRasterRef] = hucCode2GridMaskFnc( ...
    hucCodeShapeStruct, ...
    hucIndex, ...
    gridDensity );

end