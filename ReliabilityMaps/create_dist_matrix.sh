#!/bin/bash

#SBATCH --job-name=test_distance # job name
#SBATCH --mem-per-cpu=60GB
#SBATCH --time=24:00:00          # total run time limit (HH:MM:SS)
#SBATCH --cpus-per-task=4
#SBATCH --partition=amdsmall,small,ram256g

#SBATCH --mail-type=begin        # send email when job begins
#SBATCH --mail-type=end          # send email when job ends
#SBATCH --mail-user=moser297@umn.edu
#SBATCH -e testing_session.err 
#SBATCH -o testing_session.out 

#SBATCH -A rando149

module load matlab
module load workbench


matlab -r "create_dist_matrix"
