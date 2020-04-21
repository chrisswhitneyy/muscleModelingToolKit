#!/bin/bash
#SBATCH --job-name=bl3_rse
#SBATCH --workdir=/home/cw729/gfmm/Anaylsis/Optimization/RandomSampling/Bl3
#SBATCH --output=/home/cw729/gfmm/Results/Monsoon/bl3_rse_%A_%a.txt
#SBATCH --array=1-100
#SBATCH --time=00:10:00
#SBATCH --cpus-per-task=10
#SBATCH --mail-type=ALL

# assign the name variable based on files contained in a filelist
name=$(sed -n "$SLURM_ARRAY_TASK_ID"p sample_x_list)

module load matlab
srun matlab -nodisplay -nodesktop -r "evaluate( 'wraper_wfm_bl3_r08_5cm' , '$name' ); quit force"
