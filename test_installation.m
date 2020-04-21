% This script checks that all the depdencies for the tool kit are in the
% search path 
% Christopher D. Whitney (chrisswhitneyy@gmail.com) 


% Test for GA 
assert(exist('ga.m','file') == 2, 'Matlab Optimization Tool Kit is not installed properly');

% Test for SAFE 
assert(exist('model_evaluation_par.m','file') == 2, 'Unable to locate model_evaluation_par.m, insure SAFE is in search path'); 
assert(exist('model_evaluation.m','file') == 2, 'Unable to locate model_evaluation.m, insure SAFE is in search path');
assert(exist('AAT_sampling.m','file') == 2, 'Unable to locate AAT_sampling.m, insure SAFE is in search path');

disp ('Congrats the modelingToolkit and SAFE are proability installed'); 

