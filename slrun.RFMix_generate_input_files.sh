#!/bin/bash

#SBATCH --get-user-env
#SBATCH --mem=5G
#SBATCH --time 1-0
#SBATCH --qos=1day
#SBATCH --output=slrun.RFMix_generate_input_files.%A_%a.o
source ~/.bashrc

s=${SLURM_ARRAY_TASK_ID}

tag='chr1'
genmap='/Genomics/akeylab/1000GP_Phase3/genetic_map_chr1_combined_b37.txt'
samplelist='/Genomics/akeylab/abwolf/NeanderthalSeq/IBDmix/1KGP.P3.SampleInfo.txt'
trgt_sample=$( cat ALL_AFR.inds | awk 'NR=='$s'{print}')

date

echo -e $tag '\n' \
        $genmap '\n' \
        $samplelist '\n' \
        $trgt_sample

python ~/NeanderthalSeq/RFMix/RFMix_generate_input_files.py \
    $tag \
    $genmap \
    $samplelist \
    $trgt_sample

#-G originaly set to 120, corresponds to only 3kya
python2 ~/software/RFMix_v1.5.4/RunRFMix.py \
    TrioPhased \
    $tag.impute.hap.alleles \
    $trgt_sample.impute.hap.indv.classes \
    $tag.impute.legend.snp_locations \
    -G 120 \
    -w 0.1 \
    -o $tag"_"$trgt_sample \

date
echo done
