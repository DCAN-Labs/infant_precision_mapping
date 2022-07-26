#!/bin/bash -l

#SBATCH -J cifti-con
#SBATCH --ntasks=6
#SBATCH --tmp=20gb
#SBATCH --mem=20gb
#SBATCH -t 01:30:00
#SBATCH --mail-type=ALL
#SBATCH -p msismall
#SBATCH -o output_logs/cifti-con_parcel.out
#SBATCH -e output_logs/cifti-con_parcel.err
#SBATCH -A miran045

SUB=${1} # subject ID
SES=${2} # session ID
TASK=${3} # task (e.g. auditory, rest)
DIR=${4} # Name of input directory (filemapper output directory)
FD=${5} # FD for this dataset
NUM=${6} #number of permutations - input the number you're currently running (loop recommended)
MIN=${7} #minutes of data from half 1 - attention: MIN must be smaller than time_half1 in setup step

BUCKET='s3://Washu_Nordic_infant/reliability_map_values/sub-4049/FD03_40min'

MRE_DIR='/home/feczk001/shared/code/external/utilities/MATLAB_MCR/v91/'
WB_CMD='/home/faird/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command'


# TO DO: remove hardcoding of motion file
work_dir=/tmp/parcel/${SES}/${NUM}/${MIN}

if [ ! -d ${work_dir} ]; then
	mkdir -p ${work_dir}

fi


#sync from s3: masks and ground truth dconn

s3cmd sync ${BUCKET}/groundtruth_parcel/ ${work_dir}/groundtruth/
s3cmd sync ${BUCKET}/masks_parcel/ ${work_dir}/masks/ 


module load workbench; 
module load matlab;
#grep TR from dtseries
cd ${DIR}
TR=$(wb_command -file-information sub-${SUB}_ses-${SES}_task-${TASK}_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii -only-step-interval) 

#run cifti-con for various minutes of half 1 of the data
#mask making into this loop

cd ${work_dir};
matlab -r "addpath('/home/miran045/shared/projects/WashU_Nordic/code/RelMapPerm'); mask_half1_relmap(${TR}, ${MIN})"; 

 
python3 /home/faird/shared/code/internal/utilities/cifti_connectivity/cifti_conn_wrapper.py \
--motion /home/miran045/shared/projects/WashU_Nordic/output_noICA/sub-4049/ses-102521/files/DCANBOLDProc_v4.0.0/analyses_v2/motion/ses-102521_task-rest_power_2014_FD_only.mat \
--mre-dir ${MRE_DIR} \
--additional-mask ${work_dir}/masks/maskC_half1_${MIN}min.txt \
--wb-command ${WB_CMD} --fd-threshold ${FD} \
${DIR}/sub-${SUB}_ses-${SES}_task-${TASK}_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii \
${TR} ${work_dir}/half1 matrix;


D_ONE=${work_dir}/half1/sub-${SUB}_ses-${SES}_task-${TASK}_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii_all_frames_at_FD_0.3.pconn.nii
D_TWO=${work_dir}/groundtruth/sub-${SUB}_ses-${SES}_task-${TASK}_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii_all_frames_at_FD_0.3.pconn.nii

OUTDIR=${work_dir}/rel_val/
OUTNAME=rel_val_parcel_ses-${SES}_${MIN}min_perm${NUM}

WB_C='/home/faird/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command'
CIFTI_C='/home/miran045/shared/code/external/utilities/cifti-matlab' 
GIFTI_C='/home/miran045/shared/code/external/utilities/gifti/'

mkdir ${work_dir}/rel_val/; 
matlab -r "addpath('/home/miran045/shared/projects/WashU_Nordic/code/RelMapPerm'); CalculateDconntoDconnCorrelationIndividualParcels('DconnShort','${D_ONE}','DconnGroundTruth','${D_TWO}', 'OutputDirectory','${OUTDIR}', 'OutputName','${OUTNAME}', 'wb_command','${WB_C}', 'CIFTI_path','${CIFI_C}', 'GIFTI_path','${GIFI_C}')"

#sync to s3
module unload workbench;
s3cmd sync ${work_dir}/rel_val/${OUTNAME}.txt ${BUCKET}/rel_val_txt_parcel/

