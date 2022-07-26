#!/bin/bash

#SBATCH --job-name=dscalarfigs # job name
#SBATCH --mem-per-cpu=35GB
#SBATCH --time=02:00:00          # total run time limit (HH:MM:SS)
#SBATCH --cpus-per-task=2
#SBATCH --partition=small,amdsmall,ram256g
#SBAtCH --tmp=35GB

#SBATCH --mail-user=moser297@umn.edu
#SBATCH -e output_logs/dscalarfigs.err 
#SBATCH -o output_logs/dscalarfigs.out 

#SBATCH -A rando149

work_dir=/tmp/reliability_maps
data_bucket=s3://Washu_Nordic_infant/reliability_curve_dconn

pwd; hostname; date


SES=${1}
AREA=${2}
VERTEX=${3}
FOLDER=${4} #folder in which to search for input data


if [ ! -d ${work_dir} ]; then
	mkdir -p ${work_dir}

fi

cd ${work_dir};
s3cmd get ${data_bucket}/${FOLDER}/sub-4049_${SES}_task-rest_bold_desc-filtered_timeseries_SMOOTHED_0.85.dtseries.nii_all_frames_at_FD_0.3.dconn.nii;
	

module load workbench;
module load matlab;

wb_command -cifti-math 'x' ./${AREA}_${VERTEX}_${SES}_${FOLDER}.dscalar.nii -var x sub-4049_${SES}_task-rest_bold_desc-filtered_timeseries_SMOOTHED_0.85.dtseries.nii_all_frames_at_FD_0.3.dconn.nii -select 1 ${VERTEX}

matlab -r "addpath('/home/miran045/shared/projects/WashU_Nordic/cifti_connectivity/seedmap_comparison'); make_figures_s3('${work_dir}', '${AREA}', '${VERTEX}', '${SES}', '${FOLDER}')";

mv ${work_dir}/*.png /home/miran045/shared/projects/WashU_Nordic/cifti_connectivity/seedmap_comparison/figuresTEx/



