#!/bin/bash

#SBATCH --get-user-env
#SBATCH --mem=5G
#SBATCH --time 1-0
#SBATCH --qos=1day
#SBATCH --output=slrun.RFMix_generate_input_files.%A.o
source ~/.bashrc

tag='chr3'
genmap='/Genomics/akeylab/1000GP_Phase3/genetic_map_chr3_combined_b37.txt'
samplelist='/Genomics/akeylab/abwolf/NeanderthalSeq/IBDmix/1KGP.P3.SampleInfo.txt'
trgt_sample='HG00096'

date

echo -e $tag '\n'
        $genmap '\n'
        $samplelist '\n'
        $trgt_sample

python ~/bin/RFMix_generate_input_files.py \
    $tag \
    $genmap \
    $samplelist \
    $trgt_sample

date
echo done
