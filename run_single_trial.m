%% Example of a run script
%% File loads a single muscle trial and runs the simulation then evaluated 

% Setups dependencies 
addpath(genpath('.'));
close all;

% Loads data
load ('../Data/Bl3_converted_wavelet/LG/Bl3d2_r12_4p5_7cm_Cal.mat');

% Model parameters
params.T_act=118;
params.penation_angle=24/57.2958;
params.Po= 101.4;
params.Lo= 0.018;
params.M= 0.008;
params.kss=2369.7;
params.kts=3754.5;
params.Cts= 20.99;
params.Cce_L=17.899;
params.Cce_S= 0.0010137;
params.act_factor= 0.1;

% Defines model constraints
constraints.positions.Thetap.lb = -270/57.2958;
constraints.positions.Thetap.ub = 270/57.2958;
constraints.positions.Xp.lb = -min(data.length);
constraints.positions.Xp.ub = max(data.length);
constraints.positions.Xts.lb = -min(data.length);
constraints.positions.Xts.ub = max(data.length);
constraints.positions.Xss.lb = -min(data.length);
constraints.positions.Xss.ub = max(data.length);
constraints.positions.Xm.lb = -min(data.length);
constraints.positions.Xm.ub = max(data.length);
constraints.positions.Xce.lb = -min(data.length);
constraints.positions.Xce.ub = max(data.length);

% Calls model
stim = wfm9(data,params);

% Checks constraints
is_constraint(stim,constraints,'display');

% Evaluates Results
wfm_rsqr = Rsquared(stim.forces.Fm(1000:length(stim.forces.Fm)) ,data.force(1000:length(data.force)));
wfm_rmse = RMSE(stim.forces.Fm(1000:length(stim.forces.Fm)),data.force(1000:length(data.force)));
wfm_rmse_norm = RMSE(stim.forces.Fm(1000:length(stim.forces.Fm)),data.force(1000:length(data.force)));

disp (['WFM R^2 ' num2str(wfm_rsqr)]);
disp (['WFM RMSE ' num2str(wfm_rmse)]);
disp(['wfm_rmse_norm ' num2str(wfm_rmse_norm)]);
disp (['WFM RMSE % Max Force ' num2str(wfm_rmse/max(data.force))]);

% Post flight visualizer
% post_flight_visualizer(stim,data,params);
% save_all_plots('.');

% Example of ploting results
figure; hold on; 
title('Bl3 r03 Force vs. Length'); 
xlabel('Time (s)');
ylabel('Force (N)');
plot(data.time(50000:75000),data.force(50000:75000));
plot(data.time(50000:75000),stim.forces.Fm(50000:75000));
legend('Measured','Predicted');
axis tight;

