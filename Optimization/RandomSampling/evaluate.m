function [p] = evaluate(wraper_name,param_file)

addpath(genpath('../../../../'));

disp ('Evaluating samples ...');
disp (['  Wraper: ' wraper_name ]);
disp (['  Paramfile: ' param_file ]);

load (param_file);

Y = model_evaluation_par(wraper_name,X) ; 
save(['Errors/e_' param_file '.mat' ],'Y');
save('-append',['Errors/e_' param_file '.mat' ],'X');
disp('Saved new param file and error.');

end
