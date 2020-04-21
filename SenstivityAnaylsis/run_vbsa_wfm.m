% This script runs a  Variance Based Sensitivity Analysis (VBSA) on the Winding
% Filament muscle model.
%
% METHODS
%
% We use two well established variance-based sensitivity indices:
% - the first-order sensitivity index (or 'main effects')
% - the total-order sensitivity index (or 'total effects')
% (see help of 'vbsa_indices' for more details and references)
%
% MODEL AND STUDY AREA
%
% The model under study is the winding filmanent muscle model version 9 which
% is used to predict muscle forces given time-varing muscle length and activation.
% The model depends on a number of parameters which are known to vary in sensitivity,
% the purpose of this study is determine which model parameters (factors) effect the
% objective function (R^2 or RSME / %Max force) of the models output.
%
% INDEX
%
% Steps:
% 1. Add paths to required directories
% 2. Define data file, define the model and generate wrapper
% 3. Compute first-order (main effects) and total-order (total effects)
%    variance-based indices which bounds and std.
% 4. Plot results and Y values (to check for skew)
%    Save plots (.eps) and results (.mat) file

% This script was created by Christopher D. Whitney at Northern Arizona University
% using the SAFE tool-box from the University of Bristol

warning("off","all"); % Turns off loading warnings

%% Step 1: set paths
addpath('../../Models');
addpath('../../Data');
addpath('../Optimization');
addpath('../Stats');
addpath('..');

% Set current directory to 'lib_dir' needed for SAFE lib
lib_dir = '../../Libs/safe_R1.1';
% Add path to sub-folders:
addpath([ lib_dir '/sampling'])
addpath([ lib_dir '/visualization'])
addpath([ lib_dir '/VBSA'])

%% Step 2: setup the model and define input ranges

% Model function
model_fn = 'wfm9' ;
% Data set
data_filename = 'bl_lg_7cm_subset.mat';
% Model wrapper function name
model_wrapper_fn = 'wraper_wfm_bl_7_vbsa_1';

% Models free and locked parameters
free_params.kss = 750;
free_params.kts =  299.82483;
free_params.Cts_L = 12.39717;
free_params.Cts_S = 2.71825;
free_params.Cce_L = 0.1;
free_params.Cce_S = 35.89993;
free_params.Po = 100; % N
free_params.Lo = 0.02267; % m
free_params.R = 0.025;
free_params.M = 0.0080137;
locked_params.penation_angle = 24/57.2958;

% Generate wraper
generate_wraper ( model_fn,model_wrapper_fn,data_filename,locked_params,free_params,'RMSE');

% Define input distribution::: and ranges:
M  = 10 ; % number of uncertain parameters [ Sm beta alfa Rs Rf ]
DistrFun  = 'unif'  ; % Parameter distribution
DistrPar  = { [ 500 1500 ]; [ 50 1500 ]; [ 5 50 ]; [ 5 50 ]; [ 0.1 10 ];  [1 10]; [50 120]; [0.017879 0.028567]; [0.017879 0.028567]; [0.001 1]} ; % Parameter ranges

%% Step 3: Compute first-order and total-order variance-based indices

% Sample parameter space using the resampling strategy proposed by
% (Saltelli, 2008; for reference and more details, see help of functions
% vbsa_resampling and vbsa_indices)
SampStrategy = 'lhs' ;
N = 3000; % Base sample size.
% Comment: the base sample size N is not the actual number of input
% samples that will be evaluated. In fact, because of the resampling
% strategy, the total number of model evaluations to compute the two
% variance-based indices is equal to N*(M+2)
X = AAT_sampling(SampStrategy,M,DistrFun,DistrPar,2*N);
[ XA, XB, XC ] = vbsa_resampling(X) ;

% Run the model and compute selected model output at sampled parameter
% sets:
YA = model_evaluation(model_wrapper_fn,XA) ; % size (N,1)
YB = model_evaluation(model_wrapper_fn,XB) ; % size (N,1)
YC = model_evaluation(model_wrapper_fn,XC) ; % size (N*M,1)

result.XA = XA;
result.XB = XB;
result.XC = XC;
result.YA = YA;
result.YB = YB;
result.YC = YC;
save("result.mat","result");

% Replace NaN and Inf in Y's to max error values besides Inf
YA(isinf(YA)) = max(YA(~isinf(YA)));
YB(isinf(YB)) = max(YB(~isinf(YB)));
YC(isinf(YC)) = max(YC(~isinf(YC)));

YA(isnan(YA)) = max(YA);
YB(isnan(YB)) = max(YB);
YC(isnan(YC)) = max(YC);

% Compute main (first-order) and total effects:
[ Si, STi,Si_sd, STi_sd, Si_lb, STi_lb, Si_ub, STi_ub  ] = vbsa_indices(YA,YB,YC);

%% 4. Plot and save results:
%Save results
result.model_fn = model_fn;
result.model_wrapper_fn = model_wrapper_fn;
result.free_params = free_params;
result.locked_params = locked_params;
result.data_filename = data_filename;
result.num_factors = M;
result.distr_fun = DistrFun;
result.distr_pars = DistrPar;
result.samp_strategy = SampStrategy;
result.n = N;
result.XA = XA;
result.XB = XB;
result.XC = XC;
result.YA = YA;
result.YB = YB;
result.YC = YC;
result.Si = Si;
result.STi = STi;
result.Si_sd = Si_sd;
result.STi_sd = STi_sd;
result.Si_lb = Si_lb;
result.STi_lb = STi_lb;
result.Si_ub = Si_ub;
result.STi_ub = STi_ub;
save("result.mat","result");

% Plot:
X_Labels = {'Kss','Kts','Cts_L','Cts_S','Cce_L','Cce_S','Po','Lo','R','M'} ;

figure % plot main and total separately
subplot(121); boxplot1(Si,X_Labels,'main effects');
subplot(122); boxplot1(STi,X_Labels,'total effects');
%print "figure1.eps";

figure % plot both in one plot:
boxplot2([Si; STi],X_Labels)
legend('main effects','total effects')
%print "figure3.eps";

% Check the model output distribution (if multi-modal or highly skewed, the
% variance-based approach may not be adequate):
Y = [ YA; YC ] ;
figure; plot_cdf(Y,'NSE');
%print "figure4.eps";
