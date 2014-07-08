function [ gridMask ] = basinCode2GridMaskFnc(  basinCodeGeoTiff, ...
                                                basinCode )

% basinCode2GridMaskFnc.m Function to generate a binary gridMask from a scalar
% basin code.
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
%   [ basinCode ] =  basinCode2GridMaskFnc( basinCodeGeoTiff, ...
%                                           basinCode );
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
%   basinCode =         [s] scalar value indicating the basin
%                       identification code for the study region selected 
%                       by the user.
%
% OUTPUTS:
%
%   gridMask =          [j x k] binary array with valid pathway grid cells 
%                       labeled as ones and invalid pathway grid cells 
%                       labeled as zero placeholders
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
addRequired(P,'basinCodeGeoTiff',@(x)...
    ischar(x) &&...
    ~isempty(x));
addRequired(P,'basinCode',@(x)...
    isscalar(x) &&...
    ~isempty(x));

parse(P,nargin,nargout,basinCodeGeoTiff,basinCode);

end

