function [ plotHandle ] = rasterDataHistPlot(   inputRasterData, ...
                                                categoricalData, ...
                                                gridMask )
                                                    
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
addRequired(P,'categoricalData',@(x) ...
    isscalar(x) && ...
    ~isempty(x));
addRequired(P,'gridMask',@(x) ...
    isnumeric(x) && ...
    ismatrix(x) && ...
    ~isempty(x));

parse(P,nargin,nargout,inputRasterData,categoricalData,gridMask);

%% Function Parameters

histDataVec = inputRasterData(logical(gridMask));

%% Generate Output Plot

switch categoricalData 
    
    case 0
        
        plotHandle = hist(histDataVec);

    case 1
            
        ordHistData = ordinal(histDataVec);
        hist(ordHistData);
        
end

end