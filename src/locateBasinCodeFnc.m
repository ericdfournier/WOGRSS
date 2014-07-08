function [ basinCode ] = locateBasinCodeFnc(    basinCodeGeoTiff, ...
                                                overlayShapefile, ...
                                                varargin )

% locateBasinCodeFnc.m Function which provides the user the capability to
% interactively select a location for the study analysis using meaningful
% geographic context from an input shapefile data layer and then return the
% basin code for the hydrologic basin containing the selected location.
%
% DESCRIPTION:
%
%   Function which provides an interactive user interface for selecting the
%   basin code for a desired study region by preseting the user with a
%   contextually meaninful map.
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ basinCode ] =  locateBasinCodeFnc(    basinCodeGeoTiff, ...
%                                           overlayShapeFile, ...
%                                           varargin );
%
% INPUTS (REQUIRED): 
%
%   basinCodeGeoTiff =  {filename} for an [n x m] spatially referenced 
%                       raster data layer in which each pixel has been 
%                       encoded with the identification number of the basin
%                       in which it is contained. This scale of the basin 
%                       delineations can be defined by the user, however 
%                       the default extent of the map
%
%   overlayShapefile =  {filename} for an spatially reference vector 
%                       dataset which will be overlaid over the spatial 
%                       extent contained in the "basinCodeGeoTiff" layer to
%                       provide contextual reference for the user to be
%                       able to locate the desired location for the study
%                       analysis. 
% 
% INPUTS (OPTIONAL):
%
%   optionalExtent =    [1 4] array containing the following data elements
%                       [minLat maxLat minLon maxLon] which define the 
%                       latitude longitude extents of the bounding box area 
%                       to be used to constrain the map data presented to 
%                       the user for interaction. 
%
% OUTPUTS:
%
%   basinCode =         [s] scalar value indicating the basin
%                       identification code for the study region selected 
%                       by the user.
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
defaultExtent = [0 0 0 0];

addRequired(P,'nargin',@(x)...
    x >= 2);
addRequired(P,'nargout',@(x)...
    x == 1);
addRequired(P,'basinCodeGeoTiff',@(x)...
    ischar(x) &&...
    ~isempty(x));
addRequired(P,'overlayShapefile',@(x)...
    ischar(x) &&...
    ~isempty(x));
addOptional(P,'optionalExtent',defaultExtent,@(x)...
    isnumeric(x) &&...
    size(x,1) == 1 &&...
    size(x,2) == 4 &&...
    ~isempty(x));

parse(P,nargin,nargout,basinCodeGeoTiff,overlayShapefile,varargin{:});

%% Function Parameters

basinCode = 1;

end