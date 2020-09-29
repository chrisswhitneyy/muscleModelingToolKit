% Data cleaner is a script which "cleans" and converts the raw data from
% Monica Daley to approiate units and converts the raw EMG to activation
%
% Author: Christopher D. Whitney
% Date :  June 24th, 2017

warning('off','all'); restoredefaultpath;
clear;clc;close all; %clear all vars and close figs
addpath(genpath('../../'));

dirpath = 'PATH_TO_ORGINAL_DATA';
data_filenames = get_mat_dir(dirpath);

% Location to save cleaned data
save_loc = 'SAVE_CONVERTED_DATA_PATH';

% select muscle
colmnumN = 2; % 1 = LG , 2 = DF
% Loop through each file, clean and save
for i=1:numel(data_filenames)

  odata = load ([dirpath data_filenames{i}] ); % load data

  data.time = odata.data.time; % Assign time vector
  data.force = odata.data.tendonForceN(:,colmnumN); % Assigns forces
  data.act = RawEMGNormalizer(odata.data.mV_EMG(:,colmnumN)); % EMG2Act and assigns
  data.length = odata.data.muscleLength_mm(:,colmnumN) * 0.001;

  save([save_loc data_filenames{i}],'data') % save cleaned data
  
  disp(['Converted ' data_filenames{i}]);
  
end


