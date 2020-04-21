warning('off','all');
clear;clc;close all; %clear all vars and close figs

% Add depend dirs
addpath(genpath('../../../'));

data_fp = '../../../../Data/Bl3_converted/';
param_fp = './Results/Params';

data_filelist = get_mat_dir(data_fp);
param_filelist = get_mat_dir(param_fp);

for i = 1:numel(data_filelist)
    for j = 1:numel(param_filelist)
      load(param_filelist{j});
      
      free_params = {};
      
      locked_params.kss = data.p(1);
      locked_params.kts =  data.p(2);
      locked_params.Cts =  data.p(3);
      locked_params.Cce_L = data.p(4);
      locked_params.Cce_S =  data.p(5);
      locked_params.act_factor =  data.p(6);
      
      locked_params.Cts_L = 0;
      locked_params.T_act=34;
      locked_params.penation_angle=24/57.2958;
      locked_params.Po= 101.4;
      locked_params.Lo= 0.018;
      locked_params.M= 0.008;
      
      data_filename = strsplit(data_filelist{i},'.');
      data_filename = strsplit(data_filename{1},'_');
      
      testing_name = strcat(data_filename(1), '_' ,data_filename(2) ,'_' ,data_filename(3) ) ;
        
      param_filename = strsplit(param_filelist{j},'.');
      param_filename = strsplit(param_filename{1},'_');
      
      training_name = strcat( param_filename(1),'_' , param_filename(2), '_' ,param_filename(3) ) ;
      
      wrapper_name = strcat(testing_name, '_' , training_name);
     
      generate_wraper ('wfm9',wrapper_name{1},data_filelist{i},locked_params,free_params,'Rsquared','TestWrappers/');

      disp(['Wrapper generated for data:' num2str(i) ' and params:' num2str(j) ]);
            
    end
end

generate_filelist('TestWrappers','testing_wrap_list');
