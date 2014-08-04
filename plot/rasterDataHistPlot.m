function [ plotHandle ] = rasterDataHistPlot(   inputRasterData, ...
                                                categoricalDataFlag, ...
                                                gridMask )
% rasterDataHistPlot.m Function to generate the cell value histogram for a 
% given input raster dataset. The function accepts input raster datasets
% with both nominal and categorical grid cell values. 
%
% DESCRIPTION:
%
%   Function to return the plot handle of a map figure containing a
%   histogram plot of the input raster dataset grid cell values. Function
%   is capable of generating raster dataset histogram plots for both
%   nominal and categorical raster dataset inputs. 
%
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ plotHandle ] =    rasterDataHistPlot( inputRasterData, ...
%                                           categoricalDataFlag, ...
%                                           gridMask )
%
% INPUTS: 
%
%   inputRasterData =   [n x m] matrix containing the values for some data
%                       source that is to be displayed as a texture map
%                       relative to the outline of the reference basin
%
%   categoricalDataFlag = [ 0 | 1 ] binary scalar value 
%                           0 : Raster data values are numeric
%                           1 : Raster data values are categorical
%
%   gridMask =          [n x m] binary matrix where grid cells coded with a
%                       value of 1 are contained within the basin of
%                       interest and grid cells with a value of 0 are
%                       outside the boundary of the basin of interest
%
% OUTPUTS:
%
%   plotHandle =        [s] scalar plot handle variable referencing the
%                       generated output map plot 
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
    x == 3);
addRequired(P,'nargout',@(x) ...
    x >= 0);
addRequired(P,'inputRasterData',@(x) ...
    isnumeric(x) && ...
    ismatrix(x) && ...
    ~isempty(x));
addRequired(P,'categoricalDataFlag',@(x) ...
    isscalar(x) && ...
    ~isempty(x));
addRequired(P,'gridMask',@(x) ...
    isnumeric(x) && ...
    ismatrix(x) && ...
    ~isempty(x));

parse(P,nargin,nargout,inputRasterData,categoricalDataFlag,gridMask);

%% Function Parameters

histDataVec = inputRasterData(logical(gridMask));

%% Generate Output Plot

plotHandle = figure('position',get(0,'screensize'));

switch categoricalDataFlag 
    
    case 0
        
        hist(histDataVec);

    case 1
            
        ordHistData = ordinal(histDataVec);
        hist(ordHistData);
        
end

end