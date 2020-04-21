function [err] = wraper_wfm_ye3_r08_5cm(InitVar)

odata = load ('Ye3d1_t06_3p0_5cm_Cal.mat');
colmnumN = 1;
data.time = odata.data.time; % Assign time vector
data.force = odata.data.tendonForceN(:,colmnumN); % Assigns forces
data.act = RawEMGNormalizerYe(odata.data.mV_EMG(:,colmnumN) ); % EMG2Act and assigns
data.length = odata.data.muscleLength_mm(:,colmnumN) * 0.001;
  
params.T_act=2;
params.penation_angle=0.47124;
params.Po= 105.4;
params.Lo= 0.017;
params.M= 0.0085;
  
params.kss= InitVar(1);
params.kts= InitVar(2);
params.Cts_S= InitVar(3);
params.Cts_L=InitVar(4);
params.Cce_L= InitVar(5);
params.Cce_S= InitVar(6);
params.act_factor= InitVar(7);

% model call
stim = wfm9(data,params);

err = RMSE(stim.forces.Fm(1000:length(stim.forces.Fm)),data.force(1000:length(data.force)));

disp (['WFM RMSE ' num2str(err)]);

end

