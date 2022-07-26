#!/bin/bash -l

#SBATCH -J matrix_rel_val
#SBATCH --ntasks=4
#SBATCH --tmp=10gb
#SBATCH --mem=10gb
#SBATCH -t 00:10:00
#SBATCH --mail-type=ALL
#SBATCH -p msismall
#SBATCH -o output_logs/txt_mat_%A_%a.out
#SBATCH -e output_logs/txt_mat_%A_%a.err
#SBATCH -A miran045

SES=${1} # session ID
MNUM=${2} #max number of permutations
MIN=${3} #minutes of data from half 1 

BUCKET='s3://Washu_Nordic_infant/reliability_map_values_TE2/sub-4049/FD03_40min'



work_dir=/tmp/rel_val_parcel/${MIN}

if [ ! -d ${work_dir} ]; then
	mkdir -p ${work_dir}

fi
# step 1: sync .txt files from one minute to temp
#first: get one file as starting point

s3cmd sync ${BUCKET}/rel_val_txt_parcel/rel_val_parcel_ses-${SES}_${MIN}min_perm1.txt ${work_dir}/;

cd ${work_dir}
mv rel_val_parcel_ses-${SES}_${MIN}min_perm1.txt rel_val_parcel_ses-${SES}_${MIN}min_perm1.csv

# second: ceate loop for others and append files
MVAR=$(seq 2 ${MNUM});
for n in ${MVAR}; 

do s3cmd sync ${BUCKET}/rel_val_txt_parcel/rel_val_parcel_ses-${SES}_${MIN}min_perm${n}.txt ${work_dir}/;
 paste -d, rel_val_parcel_ses-${SES}_${MIN}min_perm1.csv rel_val_parcel_ses-${SES}_${MIN}min_perm${n}.txt>new${n}.csv
 mv new${n}.csv rel_val_parcel_ses-${SES}_${MIN}min_perm1.csv
 #how to get it to join it to the same file?
done

mv rel_val_parcel_ses-${SES}_${MIN}min_perm1.csv matrix_rel_val_parcel_ses-${SES}_${MIN}min_${MNUM}perm.csv


# save them as table on Tier1 

mkdir /home/miran045/shared/projects/WashU_Nordic/reliability_maps/matrices_map_perm_parcel_TE2/;
cp ${work_dir}/matrix_rel_val_parcel_ses-${SES}_${MIN}min_${MNUM}perm.csv /home/miran045/shared/projects/WashU_Nordic/reliability_maps/matrices_map_perm_parcel_TE2/
