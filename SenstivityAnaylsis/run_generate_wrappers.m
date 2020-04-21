
addpath(genpath('../../'));


model_wrapper_fn = 'wraper_wfm_af_bl3_r08_5cm';
data_filename = ''
% Params
free_params.kss = 3.6094e+03;
locked_params.kts = 1.1659e+03;
locked_params.Cts_S = 2.8581e+01;
locked_params.Cce_L = 4.3766e+01;
locked_params.Cce_S = 1.2230e+01;
locked_params.Cts_L = 0;
locked_params.Po = 101.4;
locked_params.Lo = 0.018;
locked_params.M = 0.008;
locked_params.act_factor = 0.256;

locked_params.T_act = 118;
locked_params.penation_angle = 24/57.2958;

% Generate wraper
generate_wraper ('wfm9',wraper_name,data_filename,locked_params,free_params,'RMSE');
