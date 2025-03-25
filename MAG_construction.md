# MAG Construction
The construction of metagenome-assembled genomes requires the following files from the pre-processing workflow:
- Files with metagenomic sequences after quality filtering and phiX removal (*rmphiX_forward_paired.fq.gz, *rmphiX_reverse_paired.fq.gz)
- Contigs assembled from files above (*_final.contigs.fa)

## 1. Remove contigs below 1000 bp 
needed: removesmalls.pl (*add source*)

```
mkdir SmallContigs_removed

for fasta_file in *_final.contigs.fa ; do
  output_fasta_file="$(basename $fasta_file _final.contigs.fa)_1000rm.fasta"
  perl removesmalls.pl 1000 $fasta_file > SmallContigs_removed/$output_fasta_file
done
```

## 2. Map reads to contigs: Bowtie2

Build depth table for files containing contigs > 1000 bp
```
for fasta_file in *_1000rm.fasta ; do
  output_fasta_file="$(basename -s _1000rm.fasta $fasta_file)"
  bowtie2-build $fasta_file $output_fasta_file
done
```

List the names of the samples in a file (sample_list.txt).

Align the paired end reads to bowtie index/depth table of contigs.

```
conda activate Biobakery

for sample_name in $(cat sample_list.txt) ; do
    bowtie2 -x $sample_name -1 $sample_name'_rmphiX_forward_paired.fq' -2 $sample_name'_rmphiX_reverse_paired.fq' -S - --very-sensitive-local --no-unal -p 30 | samtools view -bS - > $sample_name'.unsorted.bam'
done
```

Sort bam files
```
for file in *.unsorted.bam ; do
    sample_name="$(basename -s .unsorted.bam $file)"
    samtools sort $file -o $sample_name.bam -@ 30
done
```

## 3. Binning using Metabat2

```
conda activate Biobakery

mkdir Unsorted_bam_files
mv *.unsorted.bam Unsorted_bam_files
```


```
for file in *.bam ; do
    sample_name="$(basename -s .bam $file)"
    jgi_summarize_bam_contig_depths --outputDepth $sample_name'_depth.txt' $file
done
```

Create bins
```
for file in *_1000rm.fasta ; do
    sample_name="$(basename -s _1000rm.fasta $file)"
    metabat2 -m 1500 --maxP 95 --minS 60 --maxEdges 200 -t 30 --unbinned --seed 0 -i $sample_name'_1000rm.fasta' -a $sample_name'_depth.txt' -o Bins_dir/$sample_name'_bin'
done
```


## 4. CheckM quality analysis
CheckM can be installed through [conda](https://github.com/Ecogenomics/CheckM/wiki/Installation#installation-through-conda)

```
conda activate checkm

checkm lineage_wf -x fa -t 20 --pplacer_threads 20  --tab_table --file Bins_dir/checkm/stats.tsv Bins_dir Bins_dir/checkm 
```

## 5. Assign taxonomy to MAGs with GTDB-tk

GTDB-tk can be installed through [conda](https://ecogenomics.github.io/GTDBTk/installing/bioconda.html)

```
conda activate Gtdbtk

mkdir Gtdb_mash_db
gtdbtk classify_wf --extension fa --mash_db Gtdb_mash_db --cpus 30 --genome_dir . --out_dir Gtdbtk_out
```

## 6. Alignment of MAGs to reference genomes



