function [ sourceIndex ] = getSourceIndexFnc(   gridMask, ...
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
%   [ sourceIndex ] =  hucCode2GridMaskFnc( gridMask, ...
%                                           geoRasterRef);
%
% INPUTS: 
%
%
% OUTPUTS:
%
%   gridMask =          [n x m] binary array with valid pathway grid cells 
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
    ismatrix(x) &&...
    ~isempty(x));
addRequired(P,'geoRasterRef',@(x)...
    isa(x,'spatialref.GeoRasterReference'));

parse(P,nargin,nargout,gridMask,geoRasterRef);

%% Function Parameters

gS = size(gridMask);

%% Generate Interactive Map Plot

scrn = get(0,'ScreenSize');
fig1 = figure();
set(fig1,'Position',scrn);

axesm(  'MapProjection','mercator',...
        'Grid','On',...
        'MapLatLimit',geoRasterRef.Latlim,...
        'MapLonLimit',geoRasterRef.Lonlim,...
        'FLatLimit',geoRasterRef.Latlim,...
        'FLonLimit',geoRasterRef.Lonlim);
geoshow(gridMask, geoRasterRef);
[sourceLat, sourceLon] = inputm(1);
close(fig1);

%% Generate Index Value Grid Mask

indices = 1:1:(gS(1,1)*gS(1,2));
indexMask = reshape(indices,gS);
indexVal = ltln2val(indexMask,geoRasterRef,sourceLat,sourceLon);
[rowInd, colInd] = find(indexMask == indexVal);
sourceIndex = [rowInd colInd];

end