close all;

warning("off","all"); % Turns off loading warnings
addpath(genpath('../../'));

load 'sa_results.mat'

Ys = [];

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
