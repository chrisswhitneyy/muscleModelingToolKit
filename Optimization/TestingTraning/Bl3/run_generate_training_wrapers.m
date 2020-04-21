warning('off','all');
clear;clc;close all; %clear all vars and close figs

% Add depend dirs
addpath(genpath('../../../'));

data_fp = '../../../../Data/Bl3_converted/';

data_filelist = get_mat_dir(data_fp);

for i = 1:numel(data_filelist)

      locked_params.T_act=35;
      locked_params.penation_angle=24/57.2958;
      locked_params.Po= 101.4;
      locked_params.Lo= 0.018;
      locked_params.M= 0.008;

      free_params.kss= 1879.5;
      free_params.kts= 140.53;
      free_params.Cts= 0.45093;
      free_params.Cce_L= 35.154;
      free_params.Cce_S=9.6252;

      free_params.act_factor =  0;
      
      data_filename = strsplit(data_filelist{i},'.');
      data_filename = strsplit(data_filename{1},'_');
      
      wraper_name = strcat(data_filename(1), '_' ,data_filename(2) ,'_' ,data_filename(3)) ;

      generate_wraper ('wfm9',wraper_name{1},data_filelist{i},locked_params,free_params,'RMSE','TrainingWrappers/');

      disp(['Wrapper generated for data:' num2str(i) '.' ]);
        
end

generate_filelist('TrainingWrappers','training_wrap_list');
