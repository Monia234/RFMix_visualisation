#!/bin/bash

#SBATCH --get-user-env
#SBATCH --mem=1G
#SBATCH --time 00:05:00
#SBATCH --qos=1hr

source ~/.bashrc

date

# Create random rearrangement of sample IDs as permutation
shuf -n $( wc -l ../ALL_AFR.inds | cut -f 1 -d ' ') ../ALL_AFR.inds > afr_inds.${SLURM_ARRAY_TASK_ID}

for i in {1..504}; do

    f1=$(cat ../ALL_AFR.inds | awk 'BEGIN {OFS="\t"} {if(NR=='$i') print$0}')
    f2=$(cat afr_inds.${SLURM_ARRAY_TASK_ID} | awk 'BEGIN {OFS="\t"} {if(NR=='$i') print$0}' )

    #For f1's Neand calls, what is the number of these segments that overlap an EUR ancestry track from f2 (a random individual)
    # This is the numerator
    n=$(cat /Genomics/akeylab/abwolf/NeanderthalSeq/IBDmix/Altai.2013.p_SingleArchaic.final_callset/calls_per_ind/"$f1".bed \
        | awk 'BEGIN {OFS="\t"} {if($1==1) print $0}' \
        | bedmap --ec --delim '\t' --echo --count - chr1_"$f2".0.Viterbi.txt.recode.EUR.bed \
        | awk 'BEGIN {OFS="\t"} {v+=$NF} END {print v}')

    #What are the total number of Neand ancstry calls for f1 on chr1
    # This is the denominator
    d=$(cat /Genomics/akeylab/abwolf/NeanderthalSeq/IBDmix/Altai.2013.p_SingleArchaic.final_callset/calls_per_ind/"$f1".bed \
        | awk 'BEGIN {OFS="\t"} {if($1==1) v+=1} END {print v}')

    #Calculate rate of neand calls that overlap a EUR ancestry track
    awk 'BEGIN {print '$n'/'$d'}'

done > Neand_EURancestry_overlap.${SLURM_ARRAY_TASK_ID}
####
echo EUR ancestry fin
####
for i in {1..504}; do

    f1=$(cat ../ALL_AFR.inds | awk 'BEGIN {OFS="\t"} {if(NR=='$i') print$0}')
    f2=$(cat afr_inds.${SLURM_ARRAY_TASK_ID} | awk 'BEGIN {OFS="\t"} {if(NR=='$i') print$0}' )

    #For f1's Neand calls, what is the number of these segments that overlap an EUR ancestry track from f2 (a random individual)
    # This is the numerator
    n=$(cat /Genomics/akeylab/abwolf/NeanderthalSeq/IBDmix/Altai.2013.p_SingleArchaic.final_callset/calls_per_ind/"$f1".bed \
        | awk 'BEGIN {OFS="\t"} {if($1==1) print $0}' \
        | bedmap --ec --delim '\t' --echo --count - chr1_"$f2".0.Viterbi.txt.recode.EAS.bed \
        | awk 'BEGIN {OFS="\t"} {v+=$NF} END {print v}')

    #What are the total number of Neand ancstry calls for f1 on chr1
    # This is the denominator
    d=$(cat /Genomics/akeylab/abwolf/NeanderthalSeq/IBDmix/Altai.2013.p_SingleArchaic.final_callset/calls_per_ind/"$f1".bed \
        | awk 'BEGIN {OFS="\t"} {if($1==1) v+=1} END {print v}')

    #Calculate rate of neand calls that overlap a EUR ancestry track
    awk 'BEGIN {print '$n'/'$d'}'

done > Neand_EASancestry_overlap.${SLURM_ARRAY_TASK_ID}
####
date
echo fin
