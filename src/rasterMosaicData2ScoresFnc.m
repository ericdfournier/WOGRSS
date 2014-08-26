function [ scoreRasterMosaicData ] = rasterMosaicData2ScoresFnc( ...
                                                inputRasterMosaicData, ...
                                                gridMask, ...
                                                gridMaskGeoRasterRef )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

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
    categoricalDataFlag = input(['1. Is the ',...
        currentRasterName, ...
        ' dataset of categorical type (0 = No, 1 = Yes)? ']);
    
    switch categoricalDataFlag
        
        case 0
            
        breakCount = ...
            input(['2. How many breaks would you like to create ', ...
            'for the ',currentRasterName,' dataset? ']);
        
        currentRasterBreaks = rasterDataHist2BreaksFnc( ...
            currentRasterData, ...
            categoricalDataFlag, ...
            breakCount, ...
            gridMask, ...
            gridMaskGeoRasterRef);
        
        case 1
            
            uniqueValues = unique(currentRasterData(logical(gridMask)));
            uniqueCount = numel(uniqueValues);
            reclassKey = zeros(uniqueCount,1);
            
            if uniqueCount < 10
               
                disp('**Begin manual reclassification**');
                
                for j = 1:uniqueCount
                    
                    reclassKey(j,1) = input([num2str(j),'Convert ', ...
                        uniqueCount(j,1),' to: ']);
                    
                end
                
            elseif uniqueCount >= 10
                
                disp('**Begin automatic reclassification**');
                
                breakCount = ...
                    input(['2. How many breaks would you like to create ', ...
                    'for the ', ...
                    currentRasterName,' dataset? ']);
                
                currentRasterBreaks = rasterDataHist2BreaksFnc( ...
                    currentRasterData, ...
                    categoricalDataFlag, ...
                    breakCount, ...
                    gridMask, ...
                    gridMaskGeoRasterRef);
                
            end  
            
    end
            
    
end

end