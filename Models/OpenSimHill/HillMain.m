%{
This script will intialize and call the Thelen2003 model for mouse
modelling.

Written by Dan Rivera NAU ME 6/15/2018

%}
close all; clear all
%% OS initialization - Guinea fowl's hate OpenSim and prefer it commented out.
%Import opensim language
%import org.opensim.modeling.*

%load the model
%osimModel = Model('551_MetersModel.osim');
%osimModel = Model('551_ThelenModel.osim');


%% Load mouse data (Or Guinea Fowl Data, if you're totally awesome)

%fileName = 'ttn39_exp1TA.mat' ; %you might have to add +params.R to length data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% [ [ T A H I R    D A T A ] ]  %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Tetanus %%
%fileName = '356B_tet.mat';
%fileName = '5_24_13_355AL_Tetanus_24.mat';
%fileName = '71113_369B_tet_5.mat';
%fileName = '73013_366_exp.mat';

%% Isovelocity%%
%fileName = 'ttn413_10TA.mat' ;
%fileName = '415_exp25.mat';
%fileName = '434_exp15.mat';

%% Workloop %%
fileName = '551_stim100_10%TA.mat' ;
%fileName = 'ttn683_wl25.mat';
%fileName = 'ttn676WL23.mat'; %13-37
%fileName = 'ttn683_wl15.mat';%


load(fileName);

%% Define params and constants

  hillParams = getHillMouseParams(fileName); %%Included for reference, should be an easy edit to store Guinea Fowl params

  %% Convert everything into meters (mouse data is in mm).

  data.length = 1*data.length/1000;

  data.length = smooth(data.length,10); %inputs need to be really smooth, otherwise Hill model will explode
  hillParams.Lts = hillParams.Lts/1000;
  hillParams.Lm0 = hillParams.Lm0/1000;
  hillParams.MTUlength0 = hillParams.MTUlength0/1000;
  %data.length(1:end) = hillParams.MTUlength0;

  %% Find hill model activation and/or run an experiment.
  stepSizeTime = 0.01; %in seconds
  stepSizeVec = find(data.time <= stepSizeTime);%floor(length(data.length)/10) - 2;
  stepSize = stepSizeVec(end);

  %hillActivation = findHillActivationOS(osimModel,data,stepSize,hillParams);

  hillSimulated = hillModel(data,hillParams);

 %% Plot some stuff

 %nothing special here, just used to see outputs.
plot(data.time,hillActMinStruct.Fm,'m','LineWidth',2);
hold on
plot(data.time,data.forces,':k');

 AwrSkwared = Rsquared(hillActMinStruct.Fm',data.forces);
