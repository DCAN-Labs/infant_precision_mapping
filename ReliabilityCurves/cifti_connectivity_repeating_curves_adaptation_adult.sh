#!/bin/bash -l

#SBATCH -J cifti-con
#SBATCH --ntasks=24
#SBATCH --tmp=10gb
#SBATCH --mem=60gb
#SBATCH -t 1:00:00
#SBATCH --mail-type=ALL
#SBATCH -p msismall
#SBATCH -o output_logs/cifti-con_%A_%a.out
#SBATCH -e output_logs/cifti-con_%A_%a.err
#SBATCH -A rando149

SUB=${1} # subject ID
SES=${2} # session ID
TASK=${3} # task (e.g. auditory, rest)
BUCKET=${4} # name of S3 bucket (incl s3://)
FD=${5} # FD for this dataset
NUM=${6} #number of permutations - input the number you're currently running (loop recommended)
MIN=${7} #maximum minutes for reliability curve - attention: MIN must be smaller than time_half1
time_half1=${8} # time from which data snipets for reliability curve shall be sampled from (e.g. first half of the data)
time_groundtruth=${9} # time to which data snipets shall be compared to (e.g. half 2 of the data)


MRE_DIR='/home/feczk001/shared/code/external/utilities/MATLAB_MCR/v91/'
WB_CMD='/home/faird/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command'



work_dir=/tmp/${NUM}
data_bucket=${BUCKET}

pwd; hostname; date

if [ ! -d ${work_dir} ]; then
	mkdir -p ${work_dir}

fi

cd ${work_dir};
s3cmd get ${data_bucket}/processed/xcpd/sub-${SUB}/ses-${SES}/func/sub-${SUB}_ses-${SES}_task-${TASK}_space-fsLR_atlas-Gordon_den-91k_bold.ptseries.nii
s3cmd get ${data_bucket}/processed/xcpd/sub-${SUB}/ses-${SES}/func/sub-${SUB}_ses-${SES}_task-${TASK}_space-fsLR_desc-framewisedisplacement_bold-DCAN.hdf5


module load workbench; 
module load matlab; 

# transform XCP-D motion file to DCAN motion file
matlab -r "addpath('/home/faird/shared/code/internal/utilities/xcpd2dcanmotion/'); xcpd2dcanmotion('${work_dir}/sub-${SUB}_ses-${SES}_task-${TASK}_space-fsLR_desc-framewisedisplacement_bold-DCAN.hdf5', '${work_dir}')";

#grep TR from ptseries
TR=$(wb_command -file-information sub-${SUB}_ses-${SES}_task-${TASK}_space-fsLR_atlas-Gordon_den-91k_bold.ptseries.nii -only-step-interval) 

# run cifti-con for whole dataset to get good frames at FD threshold
python3 /home/faird/shared/code/internal/utilities/cifti_connectivity/cifti_conn_wrapper.py \
--motion ${work_dir}/*.mat \
--mre-dir ${MRE_DIR} \
--wb-command ${WB_CMD} --fd-threshold ${FD} \
${work_dir}/sub-${SUB}_ses-${SES}_task-${TASK}_space-fsLR_atlas-Gordon_den-91k_bold.ptseries.nii \
${TR} ${work_dir}/sub-${SUB}/ses-${SES}/task-${TASK}/alldata/ matrix;

# create masks for half 1 and ground truth
matlab -r "addpath('/home/miran045/shared/projects/WashU_Nordic/code'); mask_data_Xmin_consecutive_adaptation_adult('${work_dir}/sub-${SUB}/ses-${SES}/task-${TASK}/alldata', ${TR}, ${time_half1}, ${time_groundtruth})";

#run cifti-con for ground truth part of data
python3 /home/faird/shared/code/internal/utilities/cifti_connectivity/cifti_conn_wrapper.py \
--motion ${work_dir}/*.mat \
--mre-dir ${MRE_DIR} \
--additional-mask ${work_dir}/masks/mask_groundtruth.txt \
--wb-command ${WB_CMD} --fd-threshold ${FD} \
${work_dir}/sub-${SUB}_ses-${SES}_task-${TASK}_space-fsLR_atlas-Gordon_den-91k_bold.ptseries.nii \
${TR} ${work_dir}/sub-${SUB}/ses-${SES}/task-${TASK}/groundtruth/ matrix;

#run cifti-con for various minutes of half 1 of the data
#mask making into this loop


matlab -r "addpath('/home/miran045/shared/projects/WashU_Nordic/code'); mask_n_rand_min_half1_consecutive_adaptation_adult(${NUM}, ${TR}, ${MIN})"; 
#set MINVAR as for loop does not accept {1..${MIN}
MINVAR=$(seq ${MIN});

for n in ${MINVAR}; 
do python3 /home/faird/shared/code/internal/utilities/cifti_connectivity/cifti_conn_wrapper.py \
--motion ${work_dir}/*.mat \
--mre-dir ${MRE_DIR} \
--additional-mask ${work_dir}/masks/${NUM}/maskC_half1_${n}min.txt \
--wb-command ${WB_CMD} --fd-threshold ${FD} \
${work_dir}/sub-${SUB}_ses-${SES}_task-${TASK}_space-fsLR_atlas-Gordon_den-91k_bold.ptseries.nii \
${TR} ${work_dir}/sub-${SUB}/ses-${SES}/task-${TASK}/half1/${n}min matrix;

done;

cd ${work_dir}/sub-${SUB}/ses-${SES}/task-${TASK}/half1/;
matlab -r "addpath('/home/miran045/shared/projects/WashU_Nordic/code'); script_reliability_curve_repetition_adaptation_adult(${NUM}, ${MIN})";


# TO DO: find appropriate folder
cp -R ${work_dir}/sub-${SUB}/ses-${SES}/task-${TASK}/rel_curve/ /home/miran045/shared/projects/WashU_Nordic/test/
