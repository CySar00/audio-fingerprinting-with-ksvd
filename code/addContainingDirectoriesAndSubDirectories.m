function [ ] = addContainingDirectoriesAndSubDirectories ()
%   This function is used to add the containing directory of the function
%   and all subdirectories to the pathe 

    here = mfilename('fullpath'); 
    [path,~,~]=fileparts(here); 
    
    addpath(genpath(path));
end 