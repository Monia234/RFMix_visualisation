import sys
import gzip
import pathlib

# chr1
impute_hap_file = sys.argv[1]+'.impute.hap'
impute_legend_file = sys.argv[1]+'.impute.legend'
impute_indv_file = sys.argv[1]+'.impute.hap.indv'

genetic_coords_file = sys.argv[2]
# /Genomics/akeylab/1000GP_Phase3/genetic_map_chr1_combined_b37.txt
kg_samples_file = sys.argv[3]
# /Genomics/akeylab/abwolf/NeanderthalSeq/IBDmix/1KGP.P3.SampleInfo.txt
trgt_sample = sys.argv[4]
# HG00096


def write_alleles_file_fn(impute_hap_file, line_list):
    with open(impute_hap_file, 'r') as f:
        with open(impute_hap_file+'.alleles','w') as o:
            line_num=0
            for line in f:
                line_num+=1
                if line_num in line_list:
                    f_list = line.strip().split()
                    #print(''.join(f_list), file=o)
                    o.write(''.join(f_list)+'\n')


def write_snp_locations_file_fn(impute_legend_file, genetic_coords_file):
    snp_dict = {}
    with open(genetic_coords_file) as f:
        for line in f:
            if 'position' in line:
                pass
            else:
                f_list = line.strip().split()
                pos = f_list[0]
                gen_pos = f_list[2]

                snp_dict[pos] = gen_pos


    with open(impute_legend_file, 'r') as f:
        with open(impute_legend_file+'.snp_locations','w') as o:
            line_num = 0
            line_list = []
            for line in f:
                line_num += 1
                if 'ID' in line:
                    pass
                else:
                    f_list = line.strip().split()
                    rsnum = f_list[0]
                    pos = f_list [1]
                    allele0 = f_list[2]
                    allele1 = f_list[3]

                    if pos in snp_dict:
                        ## Not all positions will have genetic_coordinates
                        ## in the mapping file,
                        ## so we can only report those that do.
                        o.write(snp_dict[pos]+'\n')
                        line_list.append(line_num)
    return(line_list)


def write_classes_file_fn(impute_indv_file,kg_samples_file,trgt_sample):
    samples_dict = {}
    with open(kg_samples_file,'r') as f:
        for line in f:
            if 'ID' in line:
                pass
            else:
                f_list = line.strip().split()
                ID = f_list[1]
                pop = f_list[2]
                anc = f_list[3]

                samples_dict[ID] = [pop,anc]

#    print(samples_dict)

    with open(impute_indv_file) as f:
        with open(trgt_sample+'.impute.hap.indv.classes','w') as o:
            for line in f:
                ID = line.strip().split()[0]

                if ID == trgt_sample:
                    classes = '0'+' '+'0'+' '
                elif samples_dict[ID][1] == 'AFR':
                    classes = '1'+' '+'1'+' '
                elif samples_dict[ID][1] == 'EUR':
                    classes = '2'+' '+'2'+' '
                elif samples_dict[ID][1] == 'EAS':
                    classes = '3'+' '+'3'+' '
                elif ID not in samples_dict:
                    print('not in samples_dict', file=sys.stderr)
                    continue
                o.write(classes)



if pathlib.Path(impute_legend_file+'.snp_locations').exists():
    print('snp_locations and allele files exist')
    pass
else:
    print('Generating snp_locations and allele files')
    line_list = write_snp_locations_file_fn(impute_legend_file, genetic_coords_file)
    write_alleles_file_fn(impute_hap_file, line_list)

write_classes_file_fn(impute_indv_file, kg_samples_file, trgt_sample)
