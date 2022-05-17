#!/bin/bash

#SBATCH --job-name=dconn_corr # job name
#SBATCH --nodes=1
#SBATCH --ntasks=6
#SBATCH --tmp=10gb
#SBATCH --mem=60gb
#SBATCH -t 03:00:00
#SBATCH --partition=amdsmall,small,ram256g

#SBATCH --mail-type=begin        # send email when job begins
#SBATCH --mail-type=end          # send email when job ends
#SBATCH --mail-user=moser297@umn.edu
#SBATCH -e runDconnCorr.err 
#SBATCH -o runDconnCorr.out 

#SBATCH -A rando149

module load matlab
module load workbench


SUB=${1}
SES=${2}
MIN=${3} #minutes of data calculated from half 1
OUTDIR=${4} #make sure to enter full path


# WARNING: HARDCODED INPUTS

D_ONE=/home/miran045/shared/projects/WashU_Nordic/reliability_maps/${SUB}_${SES}_task-rest_bold_desc-filtered_timeseries.dtseries.nii_${MIN}_minutes_of_data_at_FD_0.3.dconn.nii
D_TWO=/home/miran045/shared/projects/WashU_Nordic/reliability_maps/${SUB}_${SES}_task-rest_bold_desc-filtered_timeseries.dtseries.nii_all_frames_at_FD_0.3.dconn.nii

WB_C='/home/faird/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command'
CIFTI_C='/home/faird/shared/code/external/utilities/cifti-matlab' 
GIFTI_C='/home/faird/shared/code/external/utilities/gifti/'

matlab -r "addpath('/home/miran045/shared/projects/WashU_Nordic/code'); CalculateDconntoDconnCorrelation('DconnOne','${D_ONE}','DconnTwo','${D_TWO}','OutputDirectory','${OUTDIR}', 'wb_command','${WB_C}', 'CIFTI_path','${CIFI_C}', 'GIFTI_path','${GIFI_C}')"


#matlab arguments:
#DconnOne, DconnTwo, OutputDirectory, wb_command, CIFI_path, GIFI_path 


