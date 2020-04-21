clear;
addpath(genpath('../../../../'));
% ----- Defines variables for model -----
data_filename = 'bl3_r08_5cm.mat';
wraper_name = 'wraper_wfm_bl3_r08_5cm';
model_fn = 'wfm9';

% Models free parameters
free_params.kss = 2000;
free_params.kts = 240;
free_params.Cts = 16;
free_params.Cce_L =  12.6;
free_params.Cce_S =  2.8;
free_params.act_factor = 0.256;

% Locked parameters
locked_params.T_act=118;
locked_params.penation_angle=24/57.2958;
locked_params.Po= 101.4;
locked_params.Lo= 0.018;
locked_params.M= 0.008;

% Generate model wrappers
generate_wraper ('wfm9',wraper_name,data_filename,locked_params,free_params,'Rsquared','');
