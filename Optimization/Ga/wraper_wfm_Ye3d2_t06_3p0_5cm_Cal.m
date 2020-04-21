function [err] = wraper_wfm_Ye3d2_t06_3p0_5cm_Cal(InitVar)

load ('Ye3d2_t06_3p0_5cm_Cal.mat');

params.kss= InitVar(1);
params.kts= InitVar(2);
params.Cts_S= InitVar(3);
params.Cce_L= InitVar(4);
params.Cce_S= InitVar(5);
params.act_factor= InitVar(6);

params.T_act=50;
params.Cts_L= 0;
params.penation_angle=0.47124;
params.Po= 105.4;
params.Lo= 0.017;
params.M= 0.0085;

% model call
stim = wfm9(data,params);

err = RMSE(stim.forces.Fm(1000:length(stim.forces.Fm)),data.force(1000:length(data.force)));

if isnan(err) || isinf(err)
    err = 1e100;
end

disp (['WFM RMSE ' num2str(err)]);

end

