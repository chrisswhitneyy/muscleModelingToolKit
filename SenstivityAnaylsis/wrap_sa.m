function [error_value] = wrap_sa ( InitVar )
  load ('../../Data/Ye3_converted/Ye3d1_t11_3p5_7cm_Cal.mat');

  params.T_act=34;
  params.penation_angle=0.47124;
  params.Po= 105.4;
  params.Lo= 0.017;
  params.M= 0.0085;
  
  params.kss= InitVar (1);
  params.kts= InitVar (2);
  params.Cts= InitVar (3);
  params.Cce_L= InitVar (4);
  params.Cce_S= InitVar (5);
  params.act_factor=InitVar (6);

  stim = wfm9( data, params);

  error_value =  RMSE(stim.forces.Fm(1000:length(stim.forces.Fm)),data.force(1000:length(data.force)));
  disp(["RMSE "  num2str(error_value)]);

end
