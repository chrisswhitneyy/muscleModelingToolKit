#!/bin/bash
#SBATCH --job-name=tt_bl3
#SBATCH --workdir=/home/cw729/gfmm/Anaylsis/Optimization/TestingTraning/Bl3
#SBATCH --output=/home/cw729/gfmm/Results/Monsoon/tt_bl3_%A_%a.txt
#SBATCH --array=1-13
#SBATCH --time=20:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mail-type=ALL

# assign the name variable based on files contained in a filelist
name=$(sed -n "$SLURM_ARRAY_TASK_ID"p training_wrap_list)

module load matlab
srun matlab -nodisplay -nodesktop -r "fmincon_run(  '$name' ); quit force"
