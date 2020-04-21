warning("off","all"); 
addpath(genpath('../../../../'));

samples_config;

samples = { };

parfor i = 1:NumFiles 
    disp(['Generating X' num2str(i) ' ...']);
    X = AAT_sampling(SampStrategy,M,DistrFun,DistrPar,N);
    samples{i} = X; 
end

for i = 1:NumFiles 
    disp(['Saving X' num2str(i) '...']);
    X = samples{i};
    save([samplefp '/sample' num2str(i) '.mat'],'X');
end

generate_filelist(samplefp,'sample_x_list');

