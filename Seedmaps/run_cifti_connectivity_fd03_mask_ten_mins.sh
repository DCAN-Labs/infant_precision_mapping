#!/bin/bash -l

#SBATCH -J dconn
#SBATCH --ntasks=4
#SBATCH --tmp=40gb
#SBATCH --mem=40gb
#SBATCH -t 01:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=moser297@umn.edu
#SBATCH -p msismall
#SBATCH -o output_logs/dconn_%A_%a.out
#SBATCH -e output_logs/dconn_%A_%a.err
#SBATCH -A rando149

work_dir=/tmp/
data_bucket=s3://Washu_Nordic_infant/reliability_curve_dconn

pwd; hostname; date

SES=${1} #session with or without NORDIC
COND=${2} # condition: noICA, full ICA, TE2, ...
INT=${3} #ten minute interval (1-8)

if [ ! -d ${work_dir} ]; then
	mkdir -p ${work_dir}

fi
module load workbench;
python3 /home/faird/shared/code/internal/utilities/cifti_connectivity/cifti_conn_wrapper.py \
--motion /home/miran045/shared/projects/WashU_Nordic/output_${COND}/sub-4049/${SES}/files/DCANBOLDProc_v4.0.0/analyses_v2/motion/${SES}_task-rest_power_2014_FD_only.mat \
--left /home/miran045/shared/projects/WashU_Nordic/output_${COND}/filemapper_derivatives/derivatives/infant-abcd-bids-pipeline/sub-4049/${SES}/anat/sub-4049_${SES}_hemi-L_space-MNI_mesh-fsLR32k_midthickness.surf.gii \
--right /home/miran045/shared/projects/WashU_Nordic/output_${COND}/filemapper_derivatives/derivatives/infant-abcd-bids-pipeline/sub-4049/${SES}/anat/sub-4049_${SES}_hemi-R_space-MNI_mesh-fsLR32k_midthickness.surf.gii \
--mre-dir /home/feczk001/shared/code/external/utilities/MATLAB_MCR/v91/ \
--wb-command /home/faird/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command \
--additional-mask /home/miran045/shared/projects/WashU_Nordic/cifti_connectivity/sub-4049_mask_ten_min${INT}.txt \
--fd-threshold 0.3 --smoothing-kernel 0.85 \
/home/miran045/shared/projects/WashU_Nordic/output_${COND}/filemapper_derivatives/derivatives/infant-abcd-bids-pipeline/sub-4049/${SES}/func/sub-4049_${SES}_task-rest_bold_desc-filtered_timeseries.dtseries.nii \
1.761 ${work_dir} matrix; 
module unload workbench;
s3cmd sync ${work_dir} ${data_bucket}/ten_min${INT}_${COND}/
