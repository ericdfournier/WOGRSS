function [ mosaicList ] = getRasterMosaicListFnc( ...
                                                inputRasterDirectory, ...
                                                geoRasterRef )
% getRasterMosaicList.m Function to return a cell array of filenames for
% the set of raster data files that share the same spatial extent as the
% file associated with a user specified input geo raster reference object.
% 
% Note: The routine assumes that all of the spatial data files involved
% have been previously been projected into the same geographic coordinate
% system and are stored as geotiff files with the file extension .tif
%
% DESCRIPTION:
%
%   Function to return a cell array of filenames corresponding to the set
%   of raster data files sharing the same spatial extent as the file
%   described by the input geo raster reference object. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ mosaicList ] =    getRasterMosaicListFnc( inputRasterDirectory, ...
%                                               geoRasterRef )
%
% INPUTS: 
%
%   inputRasterDirectory = {filepath} a character string input describing
%                       the location on the users computer where multiple
%                       raster datasets which represent the subdivision of
%                       a large spatial domain, have been stored. 
%
%   geoRasterRef =      {struct} the geo raster reference object structure
%                       describing the spatial characteristics of the 
%                       raster data layer for which a list of contiguous 
%                       filepaths is to be generated. 
%
% OUTPUTS:
%
%   mosaicList =        {g x 1} cell array containing the text string file
%                       names for each raster data file within the input 
%                       raster directory whose spatial extent either 
%                       contains or intersects the spatial extent of the 
%                       data file described in the geoRasterRef
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
    x == 2);
addRequired(P,'nargout',@(x) ...
    x == 1);
addRequired(P,'inputRasterDirectory',@(x) ...
    isdir(x) && ...
    ~isempty(x));
addRequired(P,'geoRasterRef',@(x) ...
    isa(x,'spatialref.GeoRasterReference'));

parse(P,nargin,nargout,inputRasterDirectory,geoRasterRef);

%% Function Parameters

files = dir(fullfile(inputRasterDirectory,'*.tif'));
files = {files.name}';

rasterInfo = cell(numel(files),1);

for i = 1:numel(files)
    
    fileName = fullfile(inputRasterDirectory,files{i});
    rasterInfo{i,1} = geotiffinfo(fileName);
    
end

referenceLatLim = geoRasterRef.Latlim;
referenceLonLim = geoRasterRef.Lonlim;
referenceLatBox = referenceLatLim([1 1 2 2 1]);
referenceLonBox = referenceLonLim([1 2 2 1 1]);

%% Find Bounding Box Intersections 

intersectionCheck = zeros(numel(rasterInfo),1);
containmentCheck = zeros(numel(rasterInfo),1);

for i = 1:numel(rasterInfo)
    
    currentBoundingBox = rasterInfo{i,1}.BoundingBox;
    currentLatLim = currentBoundingBox(1:2,2)';
    currentLonLim = currentBoundingBox(1:2,1)';
    currentLatBox = currentLatLim([1 1 2 2 1]);
    currentLonBox = currentLonLim([1 2 2 1 1]);
    intersectionCheck(i,1) = any(polyxpoly(...
        referenceLatBox,referenceLonBox,...
        currentLatBox,currentLonBox));
    containmentCheck(i,1) = all(inpolygon(...
        referenceLatBox',referenceLonBox',...
        currentLatBox,currentLonBox));
        
end

%% Parse Containmnent Cases

if nnz(containmentCheck) == 1
    
    containRasterInfo = rasterInfo{logical(containmentCheck),1};
    mosaicList{1,1} = containRasterInfo.Filename;
    
elseif nnz(containmentCheck) == 0 && nnz(intersectionCheck > 0)
    
    intersectRasterInfo = rasterInfo(logical(intersectionCheck),1);
    mosaicList = cell(numel(intersectRasterInfo),1);
    
    for i = 1:numel(intersectRasterInfo)
        
        mosaicList{i,1} = intersectRasterInfo{i,1}.Filename;
    
    end
    
elseif nnz(containmentCheck) == 0 && nnz(intersectionCheck == 0)
    
    error('No Mosaic List Can Be Constructed from Input Raster Data');
    
end

end