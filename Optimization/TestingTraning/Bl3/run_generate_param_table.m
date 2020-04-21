warning('off','all');
clear;clc;close all; %clear all vars and close figs

% Add depend dirs
addpath(genpath('../../../../'));

result_filepath = 'Results/Params';

filelist = get_mat_dir(result_filepath);
filelist = sort(filelist);

for i = 1:numel(filelist)
  disp(['Loading ' filelist{i} '...']);
  
  headers{i} = filelist{i};
  
  load (filelist{i});
  
   params(1,i) = data.p(1);
  params(2,i) = data.p(2);
  params(3,i) = data.p(3);
  params(4,i) = data.p(4);
  params(5,i) = data.p(5);
  params(6,i) = data.p(6);
  
end

data = [headers ; num2cell(params)];

disp( data );

filename = 'optimial_params.csv';

fid = fopen(filename, 'w') ;
fprintf(fid, '%s,', data{1,1:end-1});
fprintf(fid, '%s\n', data{1,end});
fclose(fid);

dlmwrite(filename, data(2:end,:), '-append') ;
