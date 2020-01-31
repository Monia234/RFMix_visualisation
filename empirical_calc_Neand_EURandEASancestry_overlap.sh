#!/bin/bash

source ~/.bashrc

for f in $(cat ../ALL_AFR.inds); do
#    echo $f
    n=$(cat /Genomics/akeylab/abwolf/NeanderthalSeq/IBDmix/Altai.2013.p_SingleArchaic.final_callset/calls_per_ind/"$f".bed \
        | awk 'BEGIN {OFS="\t"} {if($1==1) print $0}' \
        | bedmap --ec --delim '\t' --echo --indicator - chr1_"$f".0.Viterbi.txt.recode.EUR.bed.intersect \
        | awk 'BEGIN {OFS="\t"} {v+=$NF} END {print v}')

    d=$(cat /Genomics/akeylab/abwolf/NeanderthalSeq/IBDmix/Altai.2013.p_SingleArchaic.final_callset/calls_per_ind/"$f".bed \
        | awk 'BEGIN {OFS="\t"} {if($1==1) v+=1} END {print v}')

    #Calculate rate of neand calls that overlap a EUR ancestry track
    awk 'BEGIN {print '$n'/'$d'}'

done > Neand_EURancestry_overlap.empirical.indicator.intersect


for f in $(cat ../ALL_AFR.inds); do
#    echo $f

    n=$(cat /Genomics/akeylab/abwolf/NeanderthalSeq/IBDmix/Altai.2013.p_SingleArchaic.final_callset/calls_per_ind/"$f".bed \
        | awk 'BEGIN {OFS="\t"} {if($1==1) print $0}' \
        | bedmap --ec --delim '\t' --echo --indicator - chr1_"$f".0.Viterbi.txt.recode.EAS.bed.intersect \
        | awk 'BEGIN {OFS="\t"} {v+=$NF} END {print v}')

    d=$(cat /Genomics/akeylab/abwolf/NeanderthalSeq/IBDmix/Altai.2013.p_SingleArchaic.final_callset/calls_per_ind/"$f".bed \
        | awk 'BEGIN {OFS="\t"} {if($1==1) v+=1} END {print v}')

    #Calculate rate of neand calls that overlap a EAS ancestry track
    awk 'BEGIN {print '$n'/'$d'}'

done > Neand_EASancestry_overlap.empirical.indicator.intersect
