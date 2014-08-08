function [ outputRasterData ] = reclassifyRasterDataFnc( ...
													inputRasterData, ...
													rasterDataBreaks, ...
                                                    directionality, ...
													gridMask )
% reclassifyRasterDataFnc.m Function to reclassify an input raster dataset
% on the basis of a given set of data element breakpoint values. The number
% of input rasterDataBreaks should be equal to one less than the desired
% number of unique classification values in the output raster dataset. 
%
% DESCRIPTION:
%
%   Function to return a reclassified version of the input raster data set
%   using a user supplied input of rasterDataBreaks to define an ordered
%   classification scheme. In addition to these break values the user must 
%   supply a character string indicating the desired directionality of the
%   output reclassification. 
%
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ outputRasterData ] = reclassifyRasterDataFnc( ...
%                                               inputRasterData, ...
%                                               rasterDataBreaks, ...
%                                               directionality, ...
%                                               gridMask )
%
% INPUTS: 
%
%   inputRasterData =   [n x m] matrix containing the values for some data
%                       source that is to be displayed as a texture map
%                       relative to the outline of the reference basin
%
%   inputRasterDataBreaks = [r x 1] array in which each value indicates the
%                       division point for a reclassification bin within
%                       the input raster dataset. The size of this array's 
%                       first value 'r' should be equal to one less than
%                       the desired number of categories in the output
%                       raster dataset
%
%   directionality =    {char} character string which can take one of two
%                       values:
%                           'ascending': reclassify on the breaks in
%                           ascending order (starting at 1)
%                           'descendig': reclassify on the breaks in
%                           descending order (ending at 1)
%
%   gridMask =          [n x m] binary matrix where grid cells coded with a
%                       value of 1 are contained within the basin of
%                       interest and grid cells with a value of 0 are
%                       outside the boundary of the basin of interest
%
% OUTPUTS:
%
%   outputRasterData =  [n x m] array in which in which each grid cell
%                       value from the input raster dataset has been 
%                       reclassified to be an integer value ranging from 1
%                       to the to total number of breaks plus one
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
 	x == 1);
	addRequired(P,'inputRasterData',@(x) ...
	isnumeric(x) && ...
    ismatrix(x) && ...
    ~isempty(x));
addRequired(P,'rasterDataBreaks',@(x) ...
    isnumeric(x) && ...
    size(x,2) == 1 && ...
    ~isempty(x));
addRequired(P,'directionality',@(x) ...
    ischar(x) && ...
    ~isempty(x));
addRequired(P,'gridMask',@(x) ...
    isnumeric(x) && ...
    ismatrix(x) && ...
    ~isempty(x));

parse(P,nargin,nargout,inputRasterData,rasterDataBreaks,directionality, ...
    gridMask);

%% Function Parameters

breakCount = numel(rasterDataBreaks);
outputRasterData = zeros(size(gridMask));

%% Execute Reclassification Depending Upon Directionality Switch

if strcmp(directionality,'ascending') == 1;

    for i = 1:breakCount
        
        if i == 1
            
            currentBreakInd = ...
                inputRasterData <= rasterDataBreaks(i,1);
            outputRasterData(currentBreakInd) = 1;
            
        elseif i > 1 && i < breakCount
            
            currentBreakInd = ...
                inputRasterData <= rasterDataBreaks(i,1) & ...
                inputRasterData > rasterDataBreaks(i-1,1);
            outputRasterData(currentBreakInd) = i;

        else
            
            currentBreakInd = ...
                inputRasterData > rasterDataBreaks(i,1);
            outputRasterData(currentBreakInd) = breakCount+1;
            
        end
        
    end
    
    outputRasterData(gridMask == 0) = 0;
    
elseif strcmp(directionality,'descending') == 1;
    
    for i = 1:breakCount
        
        if i == 1
            
            currentBreakInd = ...
                inputRasterData <= rasterDataBreaks(i,1);
            outputRasterData(currentBreakInd) = breakCount+1;
            
        elseif i > 1 && i < breakCount
            
            currentBreakInd = ...
                inputRasterData <= rasterDataBreaks(i,1) & ...
                inputRasterData > rasterDataBreaks(i-1,1);
            outputRasterData(currentBreakInd) = breakCount-i;

        else
            
            currentBreakInd = ...
                inputRasterData > rasterDataBreaks(i,1);
            outputRasterData(currentBreakInd) = 1;
            
        end
        
    end
    
    outputRasterData(gridMask == 0) = 0;
    
elseif any(strcmp(directionality,{'ascending';'descending'})) == 0

    error('Directionality Input Character String Not Recognized');
    
end

end        