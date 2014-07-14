function [ sourceIndex ] = getSourceIndexFnc(   gridMask, ...
                                                overlayShapeStruct, ...
                                                geoRasterRef )
% getSourceIndex.m Function which prompts the user to manually select the
% location of the source index which will be used to initiate the MOGADOR
% corridor location procedure
%
% DESCRIPTION:
%
%   Function which provides the user with a map of the gridMask region and
%   prompts the user to manually click on the map to generate the row
%   column indices of the source location to be used in a following
%   corridor location procedure. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ sourceIndex ] =  hucCode2GridMaskFnc( gridMask, 
%
% INPUTS (REQUIRED): 
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
    x == 2);
addRequired(P,'nargout',@(x)...
    x == 1);
addRequired(P,'gridMask',@(x)...
    isstruct(x) &&...
    ~isempty(x));
addRequired(P,'geoRasterRef',@(x)...
    isstruct(
addRequired(P,'gridDensity',@(x)...
    isscalar(x) &&...
    x > 0 && ...
    ~isempty(x));

parse(P,nargin,nargout,hucCodeShapeStruct,hucIndex,gridDensity);


end

