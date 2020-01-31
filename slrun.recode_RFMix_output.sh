#!/bin/bash

#SBATCH --get-user-env
#SBATCH --mem=2G
#SBATCH --time 00:55:00
#SBATCH --qos=1hr
#SBATCH --output=slrun.recode_RFMix_output.%A_%a.o
source ~/.bashrc

s=${SLURM_ARRAY_TASK_ID}
#s=1
tag='chr1'
dir='/Genomics/akeylab/abwolf/NeanderthalSeq/IBDmix/RFMixtest/EAS_EUR_AFR'
genmap='/Genomics/akeylab/1000GP_Phase3/genetic_map_chr1_combined_b37.txt'

trgt_sample=$( cat $dir/ALL_AFR.inds | awk 'NR=='$s'{print}')

date

echo -e \
        $tag '\n' \
        $genmap '\n' \
        $trgt_sample '\n' \
        "$tag"_"$trgt_sample".0.Viterbi.txt


python ~/NeanderthalSeq/RFMix/recode_RFMix_output.py \
    "$tag"_"$trgt_sample".0.Viterbi.txt \
    "$dir"/"$tag".impute.legend.snp_locations \
    $genmap


cat "$tag"_"$trgt_sample".0.Viterbi.txt.recode \
    | awk 'BEGIN {OFS="\t"} { if( ($2==2 && $3==2) || ($2==2 && $3==1) || ($2==1 && $3==2) )  print "1", $1, $1+1, $2, $3}' \
    | sort-bed - \
    | bedtools merge -i - -d 10000 \
    > "$tag"_"$trgt_sample".0.Viterbi.txt.recode.EUR.bed

cat "$tag"_"$trgt_sample".0.Viterbi.txt.recode \
    | awk 'BEGIN {OFS="\t"} { if( ($2==3 && $3==3) || ($2==3 && $3==1) || ($2==1 && $3==3) ) print "1", $1, $1+1, $2, $3}' \
    | sort-bed - \
    | bedtools merge -i - -d 10000 \
    > "$tag"_"$trgt_sample".0.Viterbi.txt.recode.EAS.bed

date
echo done
