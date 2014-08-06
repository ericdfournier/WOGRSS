function [ rasterDataBreaks ] = rasterDataHist2BreaksFnc( ...
                                                inputRasterData , ...
                                                categoricalDataFlag, ...
                                                breakCount, ...
                                                gridMask )
% rasterDataHist2BreaksFnc.m Function to solicit from the user a set of
% breakpoints within a raster data histogram to be used for a subsequent
% raster reclassification procedure. The function is generally only
% applicable to ordered numerical raster datasets. A warning will be issued
% if categorical data is used. 
%
% DESCRIPTION:
%
%   Function to return an ordered set of break points derived from an input
%   raster data frequency histogram. The output rasterDataBreaks vector is
%   to be used as an input to subsequent raster data reclassification
%   routines. If the input raster dataset is of categorical type than a
%   warning will be issued as the production of an ordered set of breaks 
%   may or may not be logically valid.
%
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ plotHandle ] =    rasterDataHist2BreaksFnc( ...
%                                               inputRasterData, ...
%                                               categoricalDataFlag, ...
%                                               breakCount, ...
%                                               gridMask )
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
%   breakCount =        [r] scalar value indicating the number of breaks to
%                       be solicited from the user in the form of mouse
%                       clicks on the raster data histogram plot
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
    x == 1);
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

parse(nargin,nargout,inputRasterData,categoricalDataFlag,gridMask);

%% Categorical Data Warning

if categoricalDataFlag == 1
    
    warning(['Are you sure you want to generate ordered breaks ', ...
        'for a categorical dataset?']);
    
end

%% Generate Figure and Solicit User Inputs

rasterDataHistPlot(inputRasterData,categoricalDataFlag,gridMask);
[x, ~] = ginput(breakCount);
close(fig1);
rasterDataBreaks = round(x);

end