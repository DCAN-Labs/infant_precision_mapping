#!/bin/bash -l

#SBATCH -J cifti-con_setup
#SBATCH --ntasks=24
#SBATCH --tmp=10gb
#SBATCH --mem=10gb
#SBATCH -t 00:30:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=moser297@umn.edu
#SBATCH -p msismall
#SBATCH -o output_logs/cifti-con_parcel_setup.out
#SBATCH -e output_logs/cifti-con_parcel_setup.err
#SBATCH -A miran045

SUB=${1} # subject ID
SES=${2} # session ID
TASK=${3} # task (e.g. auditory, rest)
DIR=${4} # Name of input directory (filemapper output directory)
FD=${5} # FD for this dataset
time_half1=${6} # time from which data snipets for reliability curve shall be sampled from (e.g. first half of the data)
time_groundtruth=${7} # time to which data snipets shall be compared to (e.g. half 2 of the data)


BUCKET=s3://Washu_Nordic_infant/reliability_map_values_TE2/sub-4049/FD03_40min


MRE_DIR='/home/feczk001/shared/code/external/utilities/MATLAB_MCR/v91/'
WB_CMD='/home/faird/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command'


# TO DO: remove hardcoding of motion file
work_dir=/tmp

if [ ! -d ${work_dir} ]; then
	mkdir -p ${work_dir}

fi

module load workbench; 
module load matlab; 


#grep TR from dtseries
cd ${DIR}
#TR=$(wb_command -file-information sub-${SUB}_ses-${SES}_task-${TASK}_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii -only-step-interval) 
TR=1.761 #TR not correct in file info for these files (needs to be redone)
# run cifti-con for whole dataset to get good frames at FD threshold
python3 /home/faird/shared/code/internal/utilities/cifti_connectivity/cifti_conn_wrapper.py \
--motion /home/miran045/shared/projects/WashU_Nordic/output_noICA/sub-4049/ses-102521/files/DCANBOLDProc_v4.0.0/analyses_v2/motion/ses-102521_task-rest_power_2014_FD_only.mat \
--mre-dir ${MRE_DIR} \
--wb-command ${WB_CMD} --fd-threshold ${FD} \
${DIR}/sub-${SUB}_ses-${SES}_task-${TASK}_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii \
${TR} ${work_dir}/alldata/ matrix; 


cd ${work_dir};
# create masks for half 1 and ground truth
matlab -r "addpath('/home/miran045/shared/projects/WashU_Nordic/code'); mask_data_Xmin_consecutive_adaptation_adult('${work_dir}/alldata', ${TR}, ${time_half1}, ${time_groundtruth})";

#run cifti-con for ground truth part of data
python3 /home/faird/shared/code/internal/utilities/cifti_connectivity/cifti_conn_wrapper.py \
--motion /home/miran045/shared/projects/WashU_Nordic/output_noICA/sub-4049/ses-102521/files/DCANBOLDProc_v4.0.0/analyses_v2/motion/ses-102521_task-rest_power_2014_FD_only.mat \
--mre-dir ${MRE_DIR} \
--additional-mask ${work_dir}/masks/mask_groundtruth.txt \
--wb-command ${WB_CMD} --fd-threshold ${FD} \
${DIR}/sub-${SUB}_ses-${SES}_task-${TASK}_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii \
${TR} ${work_dir}/groundtruth/ matrix;


#sync outputs do designated position on S3
module unload workbench;
s3cmd sync ${work_dir}/alldata/* ${BUCKET}/alldata_parcel/
s3cmd sync ${work_dir}/groundtruth/* ${BUCKET}/groundtruth_parcel/
s3cmd sync ${work_dir}/masks/* ${BUCKET}/masks_parcel/



