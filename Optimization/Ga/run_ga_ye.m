% Add depend dirs
addpath(genpath('../../'));

% Wrapper name
wraper_name = "wraper_wfm_Ye3d2_t06_3p0_5cm_Cal";

params.kss= 3192.64;
params.kts= 2995.88;
params.Cts_S= 1.049;
params.Cce_L= 5.840;
params.Cce_S=0.1205;
params.act_factor=0.20;

% Initial values
InitVar = [params.kss,params.kts,params.Cts_S ...
           params.Cce_L,params.Cce_S, params.act_factor ];

% Bounds on the free params
lb = InitVar - (InitVar .* 2);
ub = InitVar + (InitVar .* 2);

opts = optimoptions(@ga, ...
    'PlotFcn',{@gaplotbestf,@gaplotstopping,@gaplotscorediversity,@gaplotscores,@gaplotselection,@gaplotdistance},...
    'FitnessScalingFcn',@fitscalingprop,'MutationFcn',{@mutationuniform, 0.75},'UseParallel',true);

%parpool('local');
%rng default; % For reproducibility

[optparams,Fval,exitFlag,Output] = ga(str2func(wraper_name),numel(lb),[],[],[],[],lb,ub,[],opts);

disp('Optimial params');
disp(optparams);

