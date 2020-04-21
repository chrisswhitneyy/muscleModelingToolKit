% ----- Defines variables for generating sample matrix -----
NumFiles = 100;
samplefp = 'Samples';

M  = 6; % number of uncertain parameters
DistrFun  = 'unif'  ; % Parameter distribution
DistrPar  = { [ 1 4000 ]; ...
              [ 1 4000 ]; ...
              [ 1 400 ]; ...
              [ 1 100 ]; ...
              [ 1 100 ]; ...
              [ 0 1]; } ; % Parameter ranges

SampStrategy = 'lhs' ;
N = 1e3; % Base sample size.




