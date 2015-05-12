function [ output_args ] = parsePrjFnc( filepath )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% Parse Inputs

%% Function Parameters
fID = fopen(filepath);
rawTextCell = textscan(fID,'%s');
fclose(fID);
rawText = rawTextCell{1,1}{1,1};

%% Parse Text String Information

elementsRaw = regexp(rawText,'([A-Z])+\[','tokens');
paramsRaw = regexp(rawText, '"(.*?)"','tokens');

numElements = size(elementsRaw,2);
params = cell(1,numElements);
elements = cell(1,numElements);

for i = 1:size(elementsRaw,2)
    tmp = elementsRaw{1,i}(1,1);
    elements(1,i) = lower(tmp);
    params(1,i) = paramsRaw{1,i}(1,1);
end

%% Generate Ouput Structure

outputStruct = cell2struct(params,elements,2);

