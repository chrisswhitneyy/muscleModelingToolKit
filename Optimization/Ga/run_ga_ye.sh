#!/bin/bash
#SBATCH --job-name=wfm_ga_ye
#SBATCH --workdir=/home/cw729/gfmm/Anaylsis/Optimization/
#SBATCH --output=/home/cw729/gfmm/Results/Monsoon/nov10th_ga_ye.txt
#SBATCH --time=10:00:00
#SBATCH --cpus-per-task=20
#SBATCH --mail-type=ALL

module load matlab
matlab -nodisplay -nodesktop -r "run run_ga_ye.m"
