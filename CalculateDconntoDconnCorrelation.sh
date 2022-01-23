#!/bin/bash

#SBATCH --job-name=dconn_corr # job name
#SBATCH --mem-per-cpu=64GB
#SBATCH --time=4:00:00          # total run time limit (HH:MM:SS)
#SBATCH --cpus-per-task=4
#SBATCH --partition=dcan

#SBATCH --mail-type=begin        # send email when job begins
#SBATCH --mail-type=end          # send email when job ends
#SBATCH --mail-user=lmoore@umn.edu
#SBATCH -e runDconnCorr.err
#SBATCH -o runDconnCorr.out

#SBATCH -A miran045

module load matlab
module load workbench

D_ONE=${1}
D_TWO=${2}

# WARNING: HARDCODED INPUTS
OUTDIR='./'
WB_C='/home/feczk001/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command'

matlab -r "CalculateDconntoDconnCorrelation('DconnOne','${D_ONE}','DconnTwo','${D_TWO}','OutputDirectory','${OUTDIR}','wb_command','${WB_C}')"




