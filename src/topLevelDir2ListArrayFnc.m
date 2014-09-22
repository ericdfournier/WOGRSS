function [ outputList ] = topLevelDir2ListArrayFnc( topLevelDir )

% topLevelDir2ListArrayFnc.m Function which generates a cell array list
% of string representations of the names of the various data
% subdirectories contained beneath a user supplied top level data
% directory filepath. This list is passed to graphic user interface
% callback functions during the process of user parameterization. 
%
% DESCRIPTION:
%
%   Function to generate a cell array list of string representations of the
%   names of the various data input sources contained as
%   subdirectories beneath the top level directory provided by the
%   user. 
%
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ cellArray ] =  topLevelDir2ListArrayFnc( topLevelDir )
%
% INPUTS:
%
%   topLevelDir =       (1 x k) character array containing the text file
%                       names for the top level data directory
%                       containing a set of sub-directories storing all of
%                       the individual data files for each
%                       data category to be used in the analysis.
%
% OUTPUTS:
%
%   outputList =        {n x 1} cell array structure containing the names
%                       of all of the inidividual data source 
%                       directories for use in conjunction with the 
%                       graphical user interface data import operations. 
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
    x == 1);
addRequired(P,'nargout',@(x) ...
    x == 1);
addRequired(P,'topLevelDir',@(x) ...
    isdir(x) && ...
    ischar(x) && ...
    ~isempty(x));

parse(P,nargin,nargout,topLevelDir);

%% Generate Output

topLevelDirProps = dir(topLevelDir);
subDirInd = logical(([topLevelDirProps.isdir] .* ...
    ~[topLevelDirProps.bytes])');
subDirInd(1:2) = 0;
subDirProps = topLevelDirProps(subDirInd);
outputList = {subDirProps.name}';

end