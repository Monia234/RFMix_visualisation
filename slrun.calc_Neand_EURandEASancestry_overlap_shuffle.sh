#!/bin/bash

#SBATCH --get-user-env
#SBATCH --mem=5G
#SBATCH --time 1-00:00:00
#SBATCH --qos=1day

source ~/.bashrc

date


for f in $(cat ../ALL_AFR.inds); do

    n=$(bedtools shuffle -i chr1_"$f".0.Viterbi.txt.recode.EUR.bed -g ../chr1.genome -chrom -seed ${SLURM_ARRAY_TASK_ID} -incl /Genomics/akeylab/abwolf/NeanderthalSeq/IBDmix/include_regions/chr1.include.bed \
        | sort-bed - \
	| bedmap --ec --delim '\t' --echo --indicator /Genomics/akeylab/abwolf/NeanderthalSeq/IBDmix/Altai.2013.p_SingleArchaic.final_callset/calls_per_ind/"$f".bed - \
        | awk 'BEGIN {OFS="\t"} {if($1==1) v+=$NF} END {print v}' )

    d=$(cat /Genomics/akeylab/abwolf/NeanderthalSeq/IBDmix/Altai.2013.p_SingleArchaic.final_callset/calls_per_ind/"$f".bed \
        | awk 'BEGIN {OFS="\t"} {if($1==1) v+=1} END {print v}')

    awk 'BEGIN {print '$n'/'$d'}'

done > Neand_EURancestry_overlap.${SLURM_ARRAY_TASK_ID}


####
echo EUR ancestry fin
####
for f in $(cat ../ALL_AFR.inds); do

    n=$(bedtools shuffle -i chr1_"$f".0.Viterbi.txt.recode.EAS.bed -g ../chr1.genome -chrom -seed ${SLURM_ARRAY_TASK_ID} -incl /Genomics/akeylab/abwolf/NeanderthalSeq/IBDmix/include_regions/chr1.include.bed \
        | sort-bed - \
	| bedmap --ec --delim '\t' --echo --indicator /Genomics/akeylab/abwolf/NeanderthalSeq/IBDmix/Altai.2013.p_SingleArchaic.final_callset/calls_per_ind/"$f".bed - \
        | awk 'BEGIN {OFS="\t"} {if($1==1) v+=$NF} END {print v}' )

    d=$(cat /Genomics/akeylab/abwolf/NeanderthalSeq/IBDmix/Altai.2013.p_SingleArchaic.final_callset/calls_per_ind/"$f".bed \
        | awk 'BEGIN {OFS="\t"} {if($1==1) v+=1} END {print v}')

    awk 'BEGIN {print '$n'/'$d'}'

done > Neand_EASancestry_overlap.${SLURM_ARRAY_TASK_ID}
####
date
echo fin
