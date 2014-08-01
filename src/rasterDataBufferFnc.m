function [ rasterBufferData ] = rasterDataBufferFnc( ...
                                                    inputRasterData, ...
                                                    bufferType, ...
                                                    bufferBoundary, ...
                                                    gridMask, ...
                                                    gridMaskGeoRasterRef )
% rasterDataBufferFnc.m Function to automatically generate a distance based
% raster buffer around a binary raster feature object layer. Function
% requires the user to be aware of the conversion between grid cell units
% and map distance units. 
%
% DESCRIPTION:
%
%   Function to generate a euclidean distance based raster buffer around a
%   binary input raster feature set containing one or more objects to be
%   buffered. The user is required to provide a bufferType which indicates
%   whether the return raster dataset will have a value of one for
%   locations which are greater than (0) less than (1) the input
%   variable bufferBoundary or (2) between some bufferBoundary interval. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ rasterBufferData ] =  rasterDataBufferFnc( ...
%                                                   inputRasterData, ...
%                                                   bufferType, ...
%                                                   bufferBoundary, ...
%                                                   gridMask, ...
%                                                   gridMaskGeoRasterRef )
%
% INPUTS: 
%
%   inputRasterData =   [n x m] binary array in which the raster features
%                       which are to be buffered are coded as ones and in 
%                       which all other grid cells are coded as zeros
%
%   bufferType =        [ 0 | 1 | 2 ] scalar flag value:
%                           0 : Buffer zone contains all cells that are
%                               further from the input raster objects than 
%                               the provided buffer distance
%                           1 : Buffer zone contains all cells that are
%                               closer to the input raster objects than the
%                               provided buffer distance
%                           2 : Buffer zone comprises the band of cells 
%                               that are contained within the dsitance 
%                               interval provided by the user
%
%   bufferBoundary:     if bufferType = [0, 1]:
%                           [s] scalar value indicating the distance buffer
%                           threshold (measured in grid cell units)
%                       if bufferType = [2]:
%                           [1 x 2] array containing the ordered distance
%                           interval pair (measured in grid cell units) 
%
%   gridMask =          [n x m] binary array in which grid cells contained
%                       within the basin of interest are coded as 1 and 
%                       grid cells outside the basin of interest are coded
%                       as zero
%
%   gridMaskGeoRasterRef = {q} cell orientated geo raster reference object
%                       providing spatial reference information for the
%                       input gridMask data layer
% 
% OUTPUTS:
%
%   rasterBufferData =  [n x m] array in which each cell contained within
%                       the desired buffer region is coded as a 1 
%                       (including the original input buffer features) and
%                       where all other cells are coded as zero. 
%                       
%                       To exclude the original buffer raster features from
%                       the output buffer use BufferType flag 0 with the
%                       first bufferBoundary parameter set to 0.1.
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
    x == 5);
addRequired(P,'nargout',@(x) ...
    x == 1);
addRequired(P,'inputRasterData',@(x) ...
    isnumeric(x) && ...
    ismatrix(x) && ...
    ~isempty(x));
addRequired(P,'bufferType',@(x) ...
    isscalar(x) && ...
    ~isempty(x));
addRequired(P,'bufferBoundary',@(x) ...
    isnumeric(x) && ...
    ~isempty(x));
addRequired(P,'gridMask',@(x) ...
    isnumeric(x) && ...
    ismatrix(x) && ...
    ~isempty(x));
addRequired(P,'gridMaskGeoRasterRef',@(x) ...
    isa(x,'spatialref.GeoRasterReference'));

parse(P,nargin,nargout,inputRasterData,bufferType,bufferBoundary, ...
    gridMask,gridMaskGeoRasterRef);

%% Function Parameters

if bufferType == 0 || bufferType == 1 && numel(bufferBoundary) > 1 
    
    error('Buffer Distance Must be a Scalar Value for this Buffer Type');
    
elseif bufferType == 2 && numel(bufferBoundary) < 2
    
    error('Buffer Distance Must be a [1 x 2] Array for this Buffer Type');
    
end

rasterBufferData = zeros(size(gridMask));

%% Generate Output

rawDist = bwdist(inputRasterData);
distMask = rawDist .* gridMask;

switch bufferType
    
    case 0 
    
        bufferInd = distMask >= bufferBoundary;
        rasterBufferData(bufferInd) = 1;
        
    case 1
        
        bufferInd = distMask <= bufferBoundary;
        rasterBufferData(bufferInd) = 1;
        
    case 2
        
        bufferInd = distMask >= bufferBoundary(1,1) & ...
            distMask <= bufferBoundary(1,2);
        rasterBufferData(bufferInd) = 1;
        
end

rasterBufferData = rasterBufferData .* gridMask;

end