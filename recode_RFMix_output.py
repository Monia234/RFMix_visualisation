import sys
import numpy as np

RFMix_output = sys.argv[1]
# chr1_HG02461.0.Viterbi.txt
snp_locations = sys.argv[2]
# chr1.impute.legend.snp_locations
genetic_coords_file = sys.argv[3]
# /Genomics/akeylab/1000GP_Phase3/genetic_map_chr1_combined_b37.txt


snp_dict = {}
with open(genetic_coords_file, 'r') as gcoords:
    for line in gcoords:
        if 'position' in line:
            pass
        else:
            f_list = line.strip().split()
            pos = int(f_list[0])
            gen_pos = str(f_list[2])
            # print(gen_pos, pos, sep='\t')
            if gen_pos in snp_dict:
                # print('ERROR, repeated gen_pos', file=sys.stderr)
                gen_pos=str(gen_pos)+'a'
                # print(gen_pos, file=sys.stderr)
                snp_dict[gen_pos] = pos
            else:
                snp_dict[gen_pos] = pos
            ##  { 0.0005522465934874: 61495,
            ##    0.0014745340202658: 62226,
            ##    0.001568167118427: 62309 }
# print(len(snp_dict))
# print(snp_dict.keys())

rfmix_array = np.loadtxt(RFMix_output, usecols=range(0,2), dtype=str)
        ## [ [1, 1],
        ##   [1, 2],
        ##   [2, 1] ]

snp_array = np.loadtxt(snp_locations, usecols=0, dtype=str).reshape(rfmix_array.shape[0],1)
        ## [ [0],
        ##   [0.410292036939447],
        ##   [0.417429561063975] ]

full_array = np.concatenate((snp_array, rfmix_array), axis=1)
        ## [ [0,                    1, 1],
        ##   [0.410292036939447,    1, 2],
        ##   [0.417429561063975,    2, 1] ]

with open(RFMix_output+'.recode', 'w') as o:
    count = 0
    for i in range(0,full_array.shape[0]):
        gen_pos = str(full_array[i][0])
        # print(gen_pos, type(gen_pos), sep='\t')
        if gen_pos in snp_dict:
            # print(gen_pos, snp_dict[gen_pos], sep='\t')
            # print(str(snp_dict[gen_pos]),
            #      full_array[i][1], full_array[i][2],
            #      sep='\t')
            o.write(str(snp_dict[gen_pos])+
                    '\t'+
                    str(full_array[i][1])+'\t'+str(full_array[i][2])+
                    '\n')
            count +=1

print(count, file=sys.stderr)
