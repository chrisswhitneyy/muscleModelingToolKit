clear;close all; %clear all vars and close figs

% Add depend dirs
addpath(genpath('../../../../'));

% Wrapper name
wraper_name = 'wraper_wfm_bl3_r11_7cm';

params.kss= 685.6030;
params.kts= 888.5841;
params.Cts_S= 0.2893;
params.Cts_L=0.0001;
params.Cce_L= 33.2875;
params.Cce_S=6.2155;
params.act_factor=0.7139;

% Initial values
InitVar = [params.kss params.kts,params.Cts_S,params.Cts_L, ...
           params.Cce_L,params.Cce_S, params.act_factor ];

% Bounds on the free params
lb = [3000,       0,    0,     0,    0,   0, 0];
ub = [10000, 8000, 8000,  8000, 8000,8000, 1];

%lb = [ 0 ];
%ub = [ 1 ];

options = optimoptions('fmincon','Display','iter','UseParallel',true);

%parpool('local')

p = fmincon(str2func(wraper_name) ,InitVar, [], [],[],[],lb,ub);

disp('Optimial params');
disp(p);
