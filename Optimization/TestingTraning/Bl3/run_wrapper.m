function [err] = run_wrapper(wrapper_name)
    
   % Add depend dirs
    addpath(genpath('../../../../'));

    f = str2func(wrapper_name);
    err = f([ ]);
    
    save(['./Results/Errors/' strcat(wrapper_name,'_error.mat')],'err');
    
end

