#!/bin/bash
#SBATCH --job-name=vbsa_wfm
#SBATCH --output=/scratch/cw729/gfmm/Results/Monsoon/vbsa_wfm_output.txt
#SBATCH --error=/scratch/cw729/gfmm/Results/Monsoon/vbsa_wfm_error.txt
#SBATCH --time=10:00:00
#SBATCH --cpus-per-task=24
#SBATCH --workdir=/scratch/cw729/gfmm/Anaylsis/SenstivityAnaylsis
#SBATCH --mail-type=ALL

module load octave/4.2.0-gcc-5.2.0

srun octave run_vbsa_wfm.m
