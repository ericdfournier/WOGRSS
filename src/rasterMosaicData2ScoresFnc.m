function [ scoreRasterMosaicData ] = rasterMosaicData2ScoresFnc( ...
                                                inputRasterMosaicData, ...
                                                gridMask, ...
                                                gridMaskGeoRasterRef )
% rasterMosaicData2ScoresFnc.m Function to walk the user through the
% process of generating manual or automated reclassifications of multiple 
% raw raster datasets generated from previous automated data extraction
% routines
%
% DESCRIPTION:
%
%   Function to return a normalized score based reclassification of
%   multiple input raw raster data sources. These reclassifications are
%   guided by incremental user inputs to the command line relating to
%   questions about the reclassification parameters as well as direct
%   inputs operating on the raster data value histograms. 
%
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ scoreRasterMosaicData ] = rasterMosaicData2ScoreesFnc( ...
%                                           inputRasterMosaicData, ...
%                                           gridMask, ...
%                                           gridMaskGeoRasterRef )
%
% INPUTS: 
%
%   inputRasterMosaicData = {j x 2} cell array in which each element in the
%                       first column is an [n x m] array of raw raster data
%                       to be reclassified into scores and each element in 
%                       the second column is the character string 
%                       representation of the name for each input raster 
%                       dataset. 
%
%   gridMask =          [n x m] binary matrix where grid cells coded with a
%                       value of 1 are contained within the basin of
%                       interest and grid cells with a value of 0 are
%                       outside the boundary of the basin of interest
%
%   gridMaskGeoRasterRef = spatialref.GeoRasterReference object containing
%                       the spatial reference information for the raster
%                       representation of the spatial search domain 
%                       'gridMask'
%
% OUTPUTS:
%
%   scoreRasterMosaicData = {j x 2} cell array in which each element in the
%                       first column in as [n x m] array of reclassified
%                       scores that have been arrived from the
%                       corresponding input raw raster data values taken
%                       from the inputRasterMosaicData cell array.
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
addRequired(P,'inputRasterMosaicData',@(x) ...
    iscell(x) && ...
    all(any(~cellfun(@isempty,x))));
addRequired(P,'gridMask',@(x) ...
    isnumeric(x) && ...
    isarray(x) && ...
    ~isempty(x));
addRequired(P,'gridMaskGeoRasterRef',@(x) ...
    isa(x,'spatialref.GeoRasterReference'));

parse(P,nargin,nargout,inputRasterMosaicData,gridMask,...
    gridMaskGeoRasterRef);

%% Function Parameters

mosaicSize = size(inputRasterMosaicData,1);
rasterCount = mosaicSize(1,1);
scoreRasterMosaicData = cell(mosaicSize);

%% Iteratively Perform Reclassification with User Inputs

for i = 1:rasterCount 
   
    currentRasterData = inputRasterMosaicData{i,1};
    currentRasterName = inputRasterMosaicData{i,2};    
    categoricalDataFlag = input([num2str(i),...
        '-1. Is the ',currentRasterName, ...
        ' dataset of categorical type (0 = No, 1 = Yes)? ']);
    
    switch categoricalDataFlag
        
        case 0
            
        breakCount = ...
            input([num2str(i),...
            '-2. How many breaks would you like to create ', ...
            'for the ',currentRasterName,' dataset? ']);
        
        currentRasterBreaks = rasterDataHist2BreaksFnc( ...
            currentRasterData, ...
            categoricalDataFlag, ...
            breakCount, ...
            gridMask, ...
            gridMaskGeoRasterRef);
        
        directionality = ...
            input([num2str(i),...
            '-3. What is the directionality of this ', ...
            'reclassification (0 = Ascending, 1 = Descending)? ']);
        
        currentReclassRasterData = reclassifyRasterDataFnc( ...
            currentRasterData, ...
            currentRasterBreaks, ...
            directionality, ...
            gridMask);
        
        case 1
            
            uniqueValues = unique(currentRasterData(logical(gridMask)));
            uniqueCount = numel(uniqueValues);
            reclassKey = zeros(uniqueCount,1);
            
            % Initiate Manual Reclassification if Few Enough Categories
            
            if uniqueCount < 10
                
                for j = 1:uniqueCount
                    
                    reclassKey(j,1) = input([num2str(j),'Convert ', ...
                        uniqueCount(j,1),' to: ']);
                    
                end
                
            % Initiate Automated Reclassification if Too Many Categories    
                
            elseif uniqueCount >= 10
                
                breakCount = ...
                    input([num2str(i),...
                    '-2. How many breaks would you like ', ...
                    'to create for the ',currentRasterName,' dataset? ']);
                
                currentRasterBreaks = rasterDataHist2BreaksFnc( ...
                    currentRasterData, ...
                    categoricalDataFlag, ...
                    breakCount, ...
                    gridMask, ...
                    gridMaskGeoRasterRef);
                
                directionality = ...
                    input([num2str(i),...
                    '-3: What is the directionality of this ',...
                    'reclassification (0 = Ascending, 1 = Descending)? ']);
                
                currentReclassRasterData = reclassifyRasterDataFnc( ...
                    currentRasterData, ...
                    currentRasterBreaks, ...
                    directionality, ...
                    gridMask);
                
            end  
            
    end
    
    scoreRasterMosaicData{i,1} = currentReclassRasterData;
    scoreRasterMosaicData{i,2} = currentRasterName;
    
end

end