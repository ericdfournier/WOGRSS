function [ hucCode, hucIndex ] = getHucCodeFnc( hucCodeShapeStruct, ...
                                                overlayShapeStruct )
% getHucCodeFnc.m Function which provides the user the capability to
% interactively select a location for the study analysis using meaningful
% geographic context from an input shapefile data layer and then return the
% basin code for the hydrologic basin containing the selected location.
%
% DESCRIPTION:
%
%   Function which provides an interactive user interface for selecting the
%   basin code for a desired study region by preseting the user with a
%   contextually meaninful map. The function assumes that both the input
%   spatial data layers have been preprocessed such that they have the same
%   coordinate system and map projection. Failure to perform these
%   preprocessing steps will result in a runtime error for the function. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ hucCode, hucIndex ] =  getHucCodeFnc( hucCodeShape, ...
%                                           overlayShape );
%
% INPUTS: 
%
%   hucCodeShapeStruct = {g x 1} shapefile structure dataset in which each 
%                       polygon corresponds to a delineated HUC basin. 
%
%   overlayShapeStruct = {h x 1} shapefile structure dataset which will be 
%                       overlaid over the spatial extent to 
%                       provide contextual reference for the user to be
%                       able to locate the desired location for the study
%                       analysis.
%
% OUTPUTS:
%
%
%   hucCode =           [s] scalar value indicating the basin
%                       identification code for the study region selected 
%                       by the user.
%
%   hucIndex =          [q] scalar hucIndex value of the hucCodeShape data
%                       structure element corresponding to the basiCode 
%                       selected by the user
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
    x == 2);
addRequired(P,'hucCodeShapeStruct',@(x)...
    isstruct(x) &&...
    ~isempty(x));
addRequired(P,'overlayShapeStruct',@(x)...
    isstruct(x) &&...
    ~isempty(x));

parse(P,nargin,nargout,hucCodeShapeStruct,overlayShapeStruct);

%% Function Parameters 

hucCodeRaw = extractfield(hucCodeShapeStruct,'HUC10')';
hucCodeList = zeros(size(hucCodeRaw));

for i = 1:size(hucCodeRaw,1)
    
    hucCodeList(i,1) = str2double(hucCodeRaw{i,1});
    
end

%% Generate User Map Interface

stateName = 'California';
mapFig = figure();
scrn = get(0,'ScreenSize');
set(mapFig,'Position',scrn);
usamap(stateName);
        
geoshow(overlayShapeStruct)

%% Prompt User to Select Desired Study Site

[latSelect, lonSelect] = inputm(1);
close(mapFig);

%% Determine Polygonal Intersection with Basin Code Boundaries

inPolyCheck = zeros(size(hucCodeShapeStruct));

for i = 1:size(hucCodeShapeStruct,1);
    
    polyLon = hucCodeShapeStruct(i,1).Lon';
    polyLat = hucCodeShapeStruct(i,1).Lat';
    inPolyCheck(i,1) = inpolygon(lonSelect,latSelect,polyLon,polyLat);

end

if any(inPolyCheck) == 0
    
    error('Invalid Selction: Out of Bounds');
    
end

%% Generate Output Data

hucIndex = find(inPolyCheck);
hucCode = hucCodeList(hucIndex);

end