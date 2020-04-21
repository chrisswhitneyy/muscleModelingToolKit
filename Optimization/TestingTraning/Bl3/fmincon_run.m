function [p] = fmincon_run(wraper_name)
warning('off','all');
disp(wraper_name);
% Add depend dirs
addpath(genpath('../../../../'));

% Wrapper name
free_params.kss= 1879.5;
free_params.kts= 140.53;
free_params.Cts= 0.45093;
free_params.Cce_L= 35.154;
free_params.Cce_S=9.6252;

free_params.act_factor =  0;

% Initial values
InitVar = [free_params.kss,free_params.kts,free_params.Cts,free_params.Cce_L,free_params.Cce_S,free_params.act_factor ];

% Bounds on the free params
lb = [0,       0,  0,    0,   0, 0];
ub = [4000, 1000  10, 1000, 100, 1];

%lb = [ 0 ];
%ub = [ 1 ];

options = optimoptions('fmincon','Display','iter','UseParallel',true);

%parpool('local')

f = str2func(wraper_name);
p = fmincon(f ,InitVar, [], [],[],[],lb,ub);

data.p = p; 
data.wrapper_name = wraper_name;
data.intial_params = free_params;
data.bounds = {lb,ub};

disp('Optimial params');
disp(p);

save(['./Results/Params/' wraper_name '_params' ],'data');

end

