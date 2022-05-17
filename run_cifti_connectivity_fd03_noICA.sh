#!/bin/bash -l

#SBATCH -J dconn
#SBATCH --ntasks=4
#SBATCH --tmp=40gb
#SBATCH --mem=40gb
#SBATCH -t 01:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=moser297@umn.edu
#SBATCH -p small,amdsmall
#SBATCH -o output_logs/dconn_%A_%a.out
#SBATCH -e output_logs/dconn_%A_%a.err
#SBATCH -A rando149

work_dir=/tmp/
data_bucket=s3://Washu_Nordic_infant/reliability_curve_dconn

pwd; hostname; date



if [ ! -d ${work_dir} ]; then
	mkdir -p ${work_dir}

fi
module load workbench;
python3 /home/faird/shared/code/internal/utilities/cifti_connectivity/cifti_conn_wrapper.py \
--motion /home/miran045/shared/projects/WashU_Nordic/output_noICA/sub-4049/ses-102521/files/DCANBOLDProc_v4.0.0/analyses_v2/motion/ses-102521_task-rest_power_2014_FD_only.mat \
--left /home/miran045/shared/projects/WashU_Nordic/output_noICA/filemapper_derivatives/derivatives/infant-abcd-bids-pipeline/sub-4049/ses-102521/anat/sub-4049_ses-102521_hemi-L_space-MNI_mesh-fsLR32k_midthickness.surf.gii \
--right /home/miran045/shared/projects/WashU_Nordic/output_noICA/filemapper_derivatives/derivatives/infant-abcd-bids-pipeline/sub-4049/ses-102521/anat/sub-4049_ses-102521_hemi-R_space-MNI_mesh-fsLR32k_midthickness.surf.gii \
--mre-dir /home/feczk001/shared/code/external/utilities/MATLAB_MCR/v91/ \
--wb-command /home/faird/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command \
--fd-threshold 0.3 --smoothing-kernel 0.85 \
/home/miran045/shared/projects/WashU_Nordic/output_noICA/filemapper_derivatives/derivatives/infant-abcd-bids-pipeline/sub-4049/ses-102521/func/sub-4049_ses-102521_task-rest_bold_desc-filtered_timeseries.dtseries.nii \
1.761 ${work_dir} matrix; 
module unload workbench;
s3cmd sync ${work_dir} ${data_bucket}/alldata_noICA/
