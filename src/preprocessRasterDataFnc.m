function [ outputRasterCell ] = preprocessRasterData( ...
                                                inputRasterDirectory, ...
                                                geoRasterRef )
% getSourceIndexFnc.m Function to interpolate a given input raster layer to
% the same grid cell density represented by the gridMask data layer and
% described by the spatial reference object geoRasterRef.
%
% DESCRIPTION:
%
%   Function which performs a resampling operation on a given input raster
%   to produce an output raster which possess the same grid cell resolution
%   as that of the gridMask which is specified by the spatial reference
%   object geoRasterRef. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ outputRaster ] =  resizeInputRaster(  inputRasterDirectory, ...
%                                           geoRasterRef );
%
% INPUTS: 
%
%   rasterDirectory =   {filepath} string filepath value indicating the
%                       location on the users machine in which the various
%                       raster data files to be used in the WOGRSS analysis
%                       are being stored. All data files must be stored in
%                       the geotiff format. 
%
%   geoRasterRef =      {q} cell orientated geo raster reference object
%                       providing spatial reference information for the
%                       input gridMask data layer
%
% OUTPUTS:
%
%   outputRaster =      {k x 1} cell array in which each element 'k' is a
%                       a preprocessed version of the raster data file
%                       contained in the rasterDirectory. Two preprocessing
%                       procedures are applied. First, a spatial subset of
%                       the raw raster data is extracted on the basis of
%                       the gridMask geoRasterRef spatial extent. Next, the
%                       subset is resized to match the grid cell resolution
%                       of the gridMask dataset. 
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
    nargin == 2);
addRequired(P,'nargout',@(x) ...
    nargout == 1);
addRequired(P,'inputRasterDirectory',@(x) ...
    ischar(x) && ...
    ~isempty(x));
addRequired(P,'geoRasterRef',@(x) ...
    isa(geoRasterRef,'map.rasterref.GeographicCellsReference'));

parse(P,nargin,nargout,inputRaster,geoRasterRef);

%% Function Parameters

gS = geoRasterRef.RasterSize;
contents = dir(inputRasterDirectory);

for i = 1:size(contents,1)
    
    

%% Resize Input Rasters

outputRaster = resizem(inputRaster,gS,geoRasterRef);

end

