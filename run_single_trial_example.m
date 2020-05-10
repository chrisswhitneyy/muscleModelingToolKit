% close all; clear;
warning('off','all');
% adds all dependencies to search path
addpath(genpath('.'));
close all;

disp('running single trial...');

% loads data
load ('../Data/Bl3_converted/DF/Bl3d2_r02_3p8_Lev_Cal.mat');

% Expect R^2 = 0.94
params.T_act=118;
params.penation_angle=20/57.2958;
params.Po= 26.07;
params.Lo= 0.017;
params.M= 0.002;
params.kss=4229.875;
params.kts=2287.85;
params.Cts=  2.184;
params.Cce_S=1.25106932;
params.Cce_L= 10.46001715;
params.act_factor= 0.314560837;

%constraints
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

disp('model called');
% model call
stim = wfm9(data,params);

disp('model evaluation ended');

% is_constraint(stim,constraints,'display');

wfm_rsqr = Rsquared(stim.forces.Fm(1000:length(stim.forces.Fm)) ,data.force(1000:length(data.force)));
wfm_rmse = RMSE(stim.forces.Fm(1000:length(stim.forces.Fm)),data.force(1000:length(data.force)));
wfm_rmse_norm = RMSE(stim.forces.Fm(1000:length(stim.forces.Fm)),data.force(1000:length(data.force)));

disp (['WFM R^2 ' num2str(wfm_rsqr)]);
disp (['WFM RMSE ' num2str(wfm_rmse)]);
disp(['wfm_rmse_norm ' num2str(wfm_rmse_norm)]);
disp (['WFM RMSE % Max Force ' num2str(wfm_rmse/max(data.force))]);

% post_flight_visualizer(stim,data,params);
% save_all_plots('.');

figure; hold on; title('Bl3 DF r01 Force vs. Time'); xlabel('Time (s)'); ylabel('Force (N)');
plot(data.time(50000:75000),data.force(50000:75000));
plot(data.time(50000:75000),stim.forces.Fm(50000:75000));
legend('Measured','Predicted');
axis tight;
saveas(gcf,'fig3.png');

pause

% norm = {};
% norm.time = data.time(1000:length(stim.forces.Fce));
% norm.Fce = stim.forces.Fce(1000:length(stim.forces.Fce)) ./ max( stim.forces.Fce(1000:length(stim.forces.Fce)) );
% norm.Fm = stim.forces.Fm(1000:length(stim.forces.Fm)) ./ max( stim.forces.Fm(1000:length(stim.forces.Fm)) );
% norm.Fts = stim.forces.Fts(1000:length(stim.forces.Fts)) ./ max( stim.forces.Fts(1000:length(stim.forces.Fts)) );
% norm.Ftd = stim.forces.Ftd(1000:length(stim.forces.Ftd)) ./ max( stim.forces.Ftd(1000:length(stim.forces.Ftd)) );
% norm.Thetap = stim.positions.Thetap(1000:length(data.length))*(params.Lo/2);
% norm.Thetap = norm.Thetap ./ max( norm.Thetap );
% norm.Xp = stim.positions.Xp(1000:length(data.length)) ./ max( stim.positions.Xp(1000:length(data.length)) );
% norm.Xts = stim.positions.Xts(1000:length(data.length)) ./ max( stim.positions.Xts(1000:length(data.length)) );

% norm = {};
% norm.time = data.time(1000:length(stim.forces.Fce));
% norm.Fce = stim.forces.Fce(1000:length(stim.forces.Fce));
% norm.Fcd = stim.forces.Fm(1000:length(stim.forces.Fcd));
% norm.Fts = stim.forces.Fts(1000:length(stim.forces.Fts));
% norm.Ftd = stim.forces.Ftd(1000:length(stim.forces.Ftd));
% norm.Thetap = stim.positions.Thetap(1000:length(data.length))*(params.Lo/2);
% norm.Xp = stim.positions.Xp(1000:length(data.length));
% norm.Xts = stim.positions.Xts(1000:length(data.length));
%
% figure; hold on;
% subplot(2,1,1); hold on; title('Post Flight'); xlabel('Time (s)'); ylabel('Force (N)');
% plot(norm.time,norm.Fce);
% plot(norm.time,norm.Fcd,'linestyle',':');
% plot(norm.time,norm.Fts,'linestyle','--');
% plot(norm.time,norm.Ftd,'linestyle','-.');
% legend('Fce','Fcd','Fts','Ftd');
% axis tight;
%
% subplot(2,1,2); hold on; xlabel('Time (s)'); ylabel('Length (cm)'); title('Length');
% plot(norm.time, norm.Thetap);
% plot(norm.time, norm.Xp,'linestyle',':');
% plot(norm.time, norm.Xts,'linestyle','-.');
% %legend('Thetap*R','Xp','Xts');
% axis tight;
%
% saveas(gcf,'fig6.png');
%
% pause

% figure
% hold on
% title('Measured and Predicted Force','fontsize',20);
% plot(data.time(1000:length(stim.forces.Fm)),data.force(1000:length(stim.forces.Fm)));
% plot(data.time(1000:length(stim.forces.Fm)),stim.forces.Fm(1000:length(stim.forces.Fm)),'linestyle',':','color','r');
% xlabel('Time (s)','fontsize',20);
% ylabel('Force (N)','fontsize',20);
% legend('Measured','Predicted');
% text(0,25, ['RMSE % Max Force ','fontsize',20 num2str(num2str(wfm_rmse/max(data.force)))]);
% text(0,35,['R^2 ' num2str(wfm_rsqr)]);
%
% figure; hold on; title('Bl3-r04-5cm Force, Act and Length');
%
% subplot(3,1,1); hold on; title('Predicted and Observed Forces'); xlabel('Time (s)'); ylabel('Force (N)');
% plot(data.time(1000:length(stim.forces.Fm)),data.force(1000:length(stim.forces.Fm)));
% plot(data.time(1000:length(stim.forces.Fm)),stim.forces.Fm(1000:length(stim.forces.Fm)),'linestyle',':','color','r');
%
% axis([min(data.time(1000:length(stim.forces.Fm))) max(data.time(1000:length(stim.forces.Fm))) 0 max(data.force(1000:length(stim.forces.Fm)))]);
%
% subplot(3,1,2); hold on; xlabel('Time (s)'); ylabel('Length (cm)'); title('Length');
% plot(data.time(1000:length(data.time)), data.length(1000:length(data.length)));
% axis([min(data.time(1000:length(stim.forces.Fm))) max(data.time(1000:length(stim.forces.Fm))) min(data.length(1000:length(data.length))) max(data.length(1000:length(data.length)))])
%
% subplot(3,1,3); hold on; xlabel('Time (s)'); ylabel('% Activation'); title('Activation and Raw EMG');
% plot(data.time(1000:length(data.time)),data.act(1000:length(data.act)));
% axis([min(data.time(1000:length(data.time))) max(data.time(1000:length(data.time))) 0 max(data.act(1000:length(data.act)))])

%load('/Users/cdubs/Research/gfmm_data/Bl3/Bl3d2_r12_4p5_7cm_Cal.mat');
%plot(data.time(1000:length(data.time)),abs(data.mV_EMG(1000:length(data.mV_EMG(:,1)),1)) ./ max(abs(data.mV_EMG(1000:length(data.mV_EMG(:,1)),1))));
