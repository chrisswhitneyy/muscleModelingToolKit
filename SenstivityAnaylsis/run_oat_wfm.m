close all; clear;
warning('off','all');
addpath(genpath('../../'));

model_wrapper_fn = 'wrap_sa';

% Models free and locked parameters
kss= 1815.9;
kts= 102.59;
Cts= 4.0379;
Cce_L= 6.4963;
Cce_S=2.6884;
act_factor= 0.20786;

% Define input distribution and ranges:
N = 100; % Base sample size.
delta = 1;

% ---- Define parameter sets ----
X_kss = OAT_Sampling( { [ (kss - kss*delta) (kss + kss*delta) ]; } , N);
X_kss = [X_kss , ones(N,1)*kts, ones(N,1)*Cts, ...
                 ones(N,1)*Cce_L, ones(N,1)*Cce_S,ones(N,1)*act_factor];

X_kts = OAT_Sampling( { [ (kts - kts*delta) (kts + kts*delta) ]; } , N);
X_kts = [ones(N,1)*kss, X_kts , ones(N,1)*Cts, ...
                 ones(N,1)*Cce_L, ones(N,1)*Cce_S,ones(N,1)*act_factor];
               
X_Cts = OAT_Sampling( { [ (Cts - Cts*delta) (Cts + Cts*delta) ]; } , N);
X_Cts = [ones(N,1)*kss,ones(N,1)*kts,X_Cts, ...
                 ones(N,1)*Cce_L, ones(N,1)*Cce_S,ones(N,1)*act_factor];
   
X_Cce_L = OAT_Sampling( { [ (Cce_L - Cce_L*delta) (Cce_L + Cce_L*delta) ]; } , N);
X_Cce_L = [ones(N,1)*kss,ones(N,1)*kts,ones(N,1)*Cts, ...
                 X_Cce_L, ones(N,1)*Cce_S,ones(N,1)*act_factor];
   
X_Cce_S = OAT_Sampling( { [ (Cce_S - Cce_S*delta) (Cce_S + Cce_S*delta) ]; } , N);
X_Cce_S = [ones(N,1)*kss,ones(N,1)*kts,ones(N,1)*Cts, ...
                 ones(N,1)*Cce_L, X_Cce_S,ones(N,1)*act_factor];
             
X_act_factor = OAT_Sampling( { [ (act_factor - act_factor*delta) (act_factor + act_factor*delta) ]; } , N);
X_act_factor = [ones(N,1)*kss,ones(N,1)*kts,ones(N,1)*Cts, ...
                 ones(N,1)*Cce_L, ones(N,1)*Cce_S,X_act_factor];
             
Xs = { X_kss, X_kts, X_Cts, X_Cce_L, X_Cce_S, X_act_factor };

Results = { };
parfor i = 1:numel(Xs)
  % Run the model and compute selected model output at sampled parameter
  Y = model_evaluation_par( model_wrapper_fn, Xs{i} ) ; % size (N,1)
  Results{i} = [ Y , Xs{i} ];
end

for i = 1:numel(Results)
  Ys(:,i) = Results{i}(:,1);
end

Ys = Ys ./ min(Ys);

figure (1); hold on;
title('SA OAT Wfm');
xlabel('% Change');
ylabel('RMSE ');
plot(linspace(-1,1,100),Ys);
legend('kss', 'kts', 'Cts', 'Cce_L', 'Cce_S','act_factor');

figure (2); hold on;
title('SA OAT Wfm');
ylabel('RMSE');
xlabel('Parameter');
boxplot(Ys ./ max(Ys) );
