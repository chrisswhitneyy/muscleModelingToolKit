warning('off','all');
clear;clc;close all; %clear all vars and close figs

% Add depend dirs
addpath(genpath('../../../../'));

result_filepath = 'Results/Errors';

filelist = get_mat_dir(result_filepath);
filelist = sort(filelist);

result = [];
n = 13;

for i = 1:numel(filelist)
  disp(['Loading ' filelist{i} '...']);

  load (filelist{i});
  result(i) = err;     
   
  tt = strsplit(filelist{i},'.');

  filename{i} = [ tt{1} ];
   
end

result = reshape(result,n,n);
filename = reshape(filename,n,n);

disp ( filename );

csvwrite('testing_traing_table.csv',result);

figure(1); hold on;
ylabel('Error');
xlabel('Training');
title('Traing vs. Testing Sets');
plot(result);
