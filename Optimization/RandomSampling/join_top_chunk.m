warning("off","all"); % Turns off loading warnings
addpath(genpath('../../../../'));

filepath = 'Errors';

filelists = get_mat_dir(filepath);

Full = [];
for i = 1:numel(filelists)

  disp (['Loading file ' filelists{i} ' ...']);

  LXFull = load ( filelists{i} );

  Full = [Full ; LXFull.Y , LXFull.X];

end

% Sort sets by first collumn (R^2)
[~,idx]=max(Full(:,1));
x=Full(idx,:);
disp(x);

% Get top 20 sets
%Top = Full(1:20,:);

%disp (Top);

