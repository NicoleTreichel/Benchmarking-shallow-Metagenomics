# Taxonomic Analysis

A conda environment for CoverM was created according to the [instructions](https://github.com/wwood/CoverM?tab=readme-ov-file#installation).

Activate the CoverM conda environment:
```
conda activate coverm
```
## 1. Coverage of reference genomes
Align pre-processed samples to reference genomes with `covered_fraction` option:

```
for file in *_rmphiX_forward_paired.fq.gz; do
name="$(basename -s _rmphiX_forward_paired.fq.gz $file)"
echo $name
coverm genome \
--threads 24 \
--mapper bwa-mem \
--methods covered_fraction \
--min-covered-fraction 0 \
--genome-fasta-directory /DATA/shallow_Metagenomics/Reference_Genomes/ \
--genome-fasta-extension fa \
--coupled \
$name"_rmphiX_forward_paired.fq.gz" \
$name"_rmphiX_reverse_paired.fq.gz" \
> $name"_coverM_covered_fraction_BWA-MEM.txt"
done
```

## 2. Number of reads mapped to the reference genomes
Align pre-processed samples to reference genomes with `count` option:
```
for file in *_rmphiX_forward_paired.fq.gz; do
name="$(basename -s _rmphiX_forward_paired.fq.gz $file)"
echo $name
coverm genome \
--threads 24 \
--mapper bwa-mem \
--methods count \
--min-covered-fraction 0 \
--genome-fasta-directory /DATA/shallow_Metagenomics/Reference_Genomes/ \
--genome-fasta-extension fa \
--coupled \
$name"_rmphiX_forward_paired.fq.gz" \
$name"_rmphiX_reverse_paired.fq.gz" \
> $name"_coverM_counts_BWA-MEM.txt"
done
```

**In this example**
- The pre-processed samples (quality filtered and phiX removed) share the ending "_rmphiX_forward_paired.fq.gz" and "_rmphiX_reverse_paired.fq.gz"
- The prefix is uniqe and used as basename
- The fasta files of the reference genomes are placed in /DATA/shallow_Metagenomics/Reference_Genomes/
- Detailed information of the CoverM parameters use can be found [here](https://github.com/wwood/CoverM?tab=readme-ov-file#usage)


## 2. Taxonomic profile analysis with MetaPhlAn
Biobakery can be installed via conda as described [here](https://github.com/biobakery/conda-biobakery)

Input files are the pre-processed samples (quality filtered and phiX removed)

Activate the conda environment:
``` 
conda activate Biobakery
```
Run taxonomic profiling:
```
for file in *_rmphiX_forward_paired.fq.gz ; do
	sample_name="$(basename -s _rmphiX_forward_paired.fq.gz $file)"
	metaphlan $file --input_type fastq --nproc 20 > $sample_name"_profile.txt"
done
```

Merge the MetaPhlAn profiles:
```
merge_metaphlan_tables.py *_profile.txt > Mock_even_merged_abundance_table.txt

grep -E "s__|CM-even" Mock_even_merged_abundance_table.txt \
| grep -v "t__" \
| sed "s/^.*|s__//g" \
> Mock_even_abundance_table_species.txt

```

**In this example**
- The pre-processed samples (quality filtered and phiX removed) share the ending "_rmphiX_forward_paired.fq.gz" and "_rmphiX_reverse_paired.fq.gz"
- The prefix is uniqe and used as basename
- A tutorial on MetaPhlAn 4.1 can be found [here](https://github.com/biobakery/biobakery/wiki/MetaPhlAn-4.1)
- Note: upon first usage of MetaPhlAn the required marker gene database will be downloaded (in this case mpa_vJun23_CHOCOPhlAnSGB_202403)
