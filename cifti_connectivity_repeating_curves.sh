#!/bin/bash -l

#SBATCH -J cifti-con
#SBATCH --ntasks=24
#SBATCH --tmp=10gb
#SBATCH --mem=60gb
#SBATCH -t 24:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=moser297@umn.edu
#SBATCH -p small,amdsmall,ram256g
#SBATCH -o output_logs/cifti-con_%A_%a.out
#SBATCH -e output_logs/cifti-con_%A_%a.err
#SBATCH -A rando149

module load workbench; 
module load matlab; 

for k in {1..100}; 
do for n in {1..40}; do python3 /home/faird/shared/code/internal/utilities/cifti_connectivity/cifti_conn_wrapper.py \
--motion /home/miran045/shared/projects/WashU_Nordic/output_noICA/sub-4049/ses-102521/files/DCANBOLDProc_v4.0.0/analyses_v2/motion/ses-102521_task-rest_power_2014_FD_only.mat \
--mre-dir /home/feczk001/shared/code/external/utilities/MATLAB_MCR/v91/ \
--wb-command /home/faird/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command --fd-threshold 0.3 \
--additional-mask /home/miran045/shared/projects/WashU_Nordic/reliability_maps/reliability_curve_pconn/repeating_curves/masks/masks${k}/mask_all_half1_${n}min.txt \
/home/miran045/shared/projects/WashU_Nordic/output_noICA/filemapper_derivatives/derivatives/infant-abcd-bids-pipeline/sub-4049/ses-102521/func/sub-4049_ses-102521_task-rest_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii \
1.761 /home/miran045/shared/projects/WashU_Nordic/reliability_maps/reliability_curve_pconn/repeating_curves/half1all/${n}min matrix; done

for n in {1..40}; do python3 /home/faird/shared/code/internal/utilities/cifti_connectivity/cifti_conn_wrapper.py \
--motion /home/miran045/shared/projects/WashU_Nordic/output_noICA/sub-4049/ses-102521NORDIC/files/DCANBOLDProc_v4.0.0/analyses_v2/motion/ses-102521NORDIC_task-rest_power_2014_FD_only.mat \
--mre-dir /home/feczk001/shared/code/external/utilities/MATLAB_MCR/v91/ \
--wb-command /home/faird/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command --fd-threshold 0.3 \
--additional-mask /home/miran045/shared/projects/WashU_Nordic/reliability_maps/reliability_curve_pconn/repeating_curves/masks/masks${k}/mask_all_half1_${n}min_NORDIC.txt \
/home/miran045/shared/projects/WashU_Nordic/output_noICA/filemapper_derivatives/derivatives/infant-abcd-bids-pipeline/sub-4049/ses-102521NORDIC/func/sub-4049_ses-102521NORDIC_task-rest_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii \
1.761 /home/miran045/shared/projects/WashU_Nordic/reliability_maps/reliability_curve_pconn/repeating_curves/half1all/${n}min matrix; done; 

matlab -r "addpath('/home/miran045/shared/projects/WashU_Nordic/code'); script_reliability_curve_repetition(${k})";

cd /home/miran045/shared/projects/WashU_Nordic/reliability_maps/reliability_curve_pconn/repeating_curves/half1all/;
rm -R *; 
done;
