# muscleModelingToolKit
A collection of scripts and programs used to run muscle modeling simulation experiments. Models included within the toolkit are the open sim Hill type model and the novel winding filament muscle model. Repository also includes visualization functions, random sampling scripts, statistical evaluation functions and scripts for running simulations on high-performance computers using the slurm scheduler. Example  run scripts can be found at the root directory. 

Work developed by researchers at the Nishikawa Lab at Northern Arizona University.
https://in.nau.edu/nishikawa-lab/

## Dependencies 
### Sensitivity Anaylsis for Everyone (SAFE) Toolbox 
In order to run many of the optimization methods and sensitivity anaylsis the following libabry needs to be in the search path of MatLab.
https://www.safetoolbox.info/

### Matlab Optimization Toolbox 
In order to run the genetic algrothim the following Matlab package needs to be installed. 
https://www.mathworks.com/products/optimization.html


### Matlab Parallel Toolbox 
In order to run many of programs devoloped for a HPC you will need this tool box installed. 

## Directory Breakdown 

## /Optimization 
This directory contains scripts to run a variantly of differnet methods to find the optimal parameter sets and the optimal training set (data set which is used during optimization). The optimization methods includes a large scale random sampling expirment, a genetic algorthim, and the build in Matlab optimizer fmnincon. 

### /Fmincon 
Script examples to run the built in MatLab optimizer.

### /Genetic Algrothim 
Scripts to run a genetic algrothim for optimization on a slurm super computer. 

### /RandomSampling
Scripts to a run a large scale random sampling expirment on a slurm HPC 

### /TestingTraining 
Scripts to run an optimization / testing expirment to see which dataset is ideal for training the reset of the data sets. 

## /Sensitivity Anaylsis 
Contains scripts to run different types of senstivity anaylsis including one at a time and a varaince based approach. Please not many of these scripts require the Sensitivity Anaylsis For Everyone (SAFE) tool kit. Find link in the dependencies. 

## /Statistics 
Contains functions for basic statistices for evaluating model results. These functions are used during optimization and single model evaluations. 

## /Support 
Contains a varity of different helper functions which accomplish common tasks throughout the kit. 

## /Visualization 
Contains different functions for different visualization techinques to evaluate a model run. This includes a post-flight anaylsis which looks at indiviaul components of the model. 
