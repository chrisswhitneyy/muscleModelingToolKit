#!/bin/bash
#SBATCH --job-name=sop_check_chunk
#SBATCH --workdir=/home/cw729/gfmm/Anaylsis/Optimization
#SBATCH --output=/home/cw729/gfmm/Results/Monsoon/sop_check_chunk.txt
#SBATCH --time=00:02:00
#SBATCH --cpus-per-task=1
#SBATCH --mail-type=ALL

module load octave/4.2.0-gcc-5.2.0

srun octave sop_join_check_chunk.m 'Temp' sop_sample_spec.m
