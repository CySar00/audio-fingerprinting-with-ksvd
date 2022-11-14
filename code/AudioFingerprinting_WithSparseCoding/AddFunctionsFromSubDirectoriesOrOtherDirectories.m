function []= AddFunctionsFromSubDirectoriesOrOtherDirectories()

    here= mfilename('fullpath'); 
    [path,~,~]= fileparts(here); 
    
    addpath(genpath(path)); 
end 