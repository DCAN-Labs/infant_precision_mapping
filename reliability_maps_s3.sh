#!/bin/bash

#SBATCH --job-name=dconn_corr # job name
#SBATCH --mem-per-cpu=80GB
#SBATCH --time=04:00:00          # total run time limit (HH:MM:SS)
#SBATCH --cpus-per-task=2
#SBATCH --partition=amdsmall,small,ram256g #might have to change due to temp allocation
#SBAtCH --tmp=40GB

#SBATCH --mail-type=begin        # send email when job begins
#SBATCH --mail-type=end          # send email when job ends
#SBATCH --mail-user=moser297@umn.edu
#SBATCH -e runDconnCorr.err 
#SBATCH -o runDconnCorr.out 

#SBATCH -A rando149

work_dir=/tmp/reliability_maps
data_bucket=s3://Washu_Nordic_infant/reliability_curve_dconn

pwd; hostname; date


#TODO make output dir tier 1
SUB=${1}
SES=${2}
MIN=${3} #minutes of data calculated from half 1
OUTDIR=${4} #make sure to enter full path

if [ ! -d ${work_dir}/${SUB}/${SES}/${MIN} ]; then
	mkdir -p ${work_dir}/${SUB}/${SES}/${MIN}

fi

cd ${work_dir}/${SUB}/${SES}/${MIN}/
s3cmd get ${data_bucket}/half1/N_nonnordic/${SUB}_${SES}_task-rest_bold_desc-filtered_timeseries.dtseries.nii_${MIN}_minutes_of_data_at_FD_0.3.dconn.nii -v
s3cmd get ${data_bucket}/half2/N_nonnordic/${SUB}_${SES}_task-rest_bold_desc-filtered_timeseries.dtseries.nii_all_frames_at_FD_0.3.dconn.nii -v
	

module load matlab
module load workbench


#TODO: sync from S3
#TODO: define paths within tmp dir instead after sync
D_ONE=${work_dir}/${SUB}/${SES}/${MIN}/${SUB}_${SES}_task-rest_bold_desc-filtered_timeseries.dtseries.nii_${MIN}_minutes_of_data_at_FD_0.3.dconn.nii
D_TWO=${work_dir}/${SUB}/${SES}/${MIN}/${SUB}_${SES}_task-rest_bold_desc-filtered_timeseries.dtseries.nii_all_frames_at_FD_0.3.dconn.nii
D_MAT=/home/miran045/shared/projects/WashU_Nordic/reliability_maps/DistanceMatrix/EUGEODistancematrix_vox_xyz.mat

WB_C='/home/faird/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command'
CIFTI_C='/home/miran045/shared/code/external/utilities/cifti-matlab' 
GIFTI_C='/home/miran045/shared/code/external/utilities/gifti/'

matlab -r "addpath('/home/miran045/shared/projects/WashU_Nordic/code'); CalculateDconntoDconnCorrelationIndividualSeeds('DconnShort','${D_ONE}','DconnGroundTruth','${D_TWO}', 'DistanceMatrix', '${D_MAT}', 'OutputDirectory','${OUTDIR}', 'wb_command','${WB_C}', 'CIFTI_path','${CIFI_C}', 'GIFTI_path','${GIFI_C}')"


