# Functional Analysis

## 1. Prediction of protein coding genes in reference genomes and metagenomic data

Instructions on how to install prodigal can be found [here](https://github.com/hyattpd/Prodigal/wiki/installation)

To see a complete list of options:
```
prodigal -h
```

Prediction of protein coding sequences of the reference genomes by prodigal:
```
for k in *.fa; do prodigal -i $k -c -m -f sco -a  `basename $k .fa`.faa; done
```

For prediction of protein coding sequences from the contigs assembled from the metagenome data the `-p meta` option of prodigal was used:
```
for file in *.fa ; do
    sample_name="$(basename -s _final.contigs.fa $file)"
    prodigal -i $file -o Functional_analysis/$sample_name'_functional_genes.txt' -a Functional_analysis/$sample_name'_proteins.faa' -p meta -f sco -c -m
done
```

## 2. Coverage of predicted protein sequences

Copy all protein sequences predicted from the reference genomes to one file:
```
cat *.faa > Ref_FAA_all_Complex_Mock.faa
```
Count the predicted protein sequences predicted of all reference genomes:
```
grep ">" Ref_FAA_all_Complex_Mock.faa | wc -l
```
This number represents 100% of the functional coverage, that could be reached by a metagenome at a certain sequencing depth. 

Create a Diamond database from the concatenated protein sequences predicted from the reference genomes: 
```
diamond makedb --in Ref_FAA_all_Complex_Mock.faa -d Complex_Mock_AA_Diamond_DB.faa 
```

Do the `blastp` alignment of the predicted protein sequences of the metagenome data to the Diamond database of the predicted protein sequences from the reference genomes:
```
for file in *_proteins.faa ; do
    sample_name="$(basename -s _proteins.faa $file)"
   echo $sample_name
   diamond blastp -d Complex_Mock_AA_Diamond_DB.faa.dmnd -q $file -o $sample_name"_blastp_id90_qc80" --sensitive --query-cover 80 --id 90
done
```

Count the unique reference protein sequences:
```
for file in *blastp_id90_qc80; do
  sample_name="$(basename -s _blastp_id90_qc80 $file)"
  echo $sample_name
  awk -F"\t" '{print $2}' $file | sort -u | wc -l 
done
```
These numbers were used to calculate the functional coverage achived by a metagenome of a certain sequencing depth.


## 3. Pathway completeness

### KofamScan
An introduction of the preparation and usage of KofamScan can be found [here](https://github.com/takaram/kofam_scan?tab=readme-ov-file#usage)

Run KofamScan on the predicted protein sequences (output of `prodigal`):
```
for file in ../*.faa ; do
    sample_name="$(basename -s _proteins.faa $file)"
    ./exec_annotation -f mapper -o $sample_name'_kofam_results.txt' $file
done
```

### KEGGDecoder
More information about KEGGDecoder are available [here](https://github.com/bjtully/BioData/tree/master/KEGGDecoder)

To be able to further process all samples of the KofamScan output with KEGGDecoder together, attach the sample name to front of each line in a file:
```
for file in *kofam-results.txt; do
    Sample="$(basename -s kofam-results.txt $file)"
    sed -i -e "s/^/$Sample/" $file
done
```

Gather the results of all samples in one file for visualisation as heat map:
```
cat *kofam-results.txt >> All_Kofam_results_combined
```

**Caution with sample naming**: everything after the first _ will be cut off. Make sure sample names are unique before the first _

Run KEGG-decoder:
```
KEGG-decoder --input All_Kofam_results_combined --output Kofam_results_combined_OUT.list --vizoption static
```

*add example of heatmap*

