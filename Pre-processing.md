# Pre-processing

Sequencing of Mock communities took place at nine different sequencing depths. 
The sequencing depth was set by uneven pooling of the libraries, but to reach the exact number of sequences for a certain sequencing depth subsampling was used. 

## Subsampling 
Seqtk can be installed as documented [here](https://github.com/lh3/seqtk)


```
seqtk sample -s100 Mock-1_R1.fastq.gz 33333333 > Mock_sub10Gb_R1.fastq
seqtk sample -s100 Mock-1_R2.fastq.gz 33333333 > Mock_sub10Gb_R2.fastq

seqtk sample -s100 Mock-2_R1.fastq.gz 333333 > Mock_sub0.1Gb_R1.fastq
seqtk sample -s100 Mock-2_R2.fastq.gz 333333 > Mock_sub0.1Gb_R2.fastq

seqtk sample -s100 Mock-3_R1.fastq.gz 833333 > Mock_sub0.25Gb_R1.fastq
seqtk sample -s100 Mock-3_R2.fastq.gz 833333 > Mock_sub0.25Gb_R2.fastq

seqtk sample -s100 Mock-4_R1.fastq.gz 1666667 > Mock_sub0.5Gb_R1.fastq
seqtk sample -s100 Mock-4_R2.fastq.gz 1666667 > Mock_sub0.5Gb_R2.fastq

seqtk sample -s100 Mock-5_R1.fastq.gz 2500000 > Mock_sub0.75Gb_R1.fastq
seqtk sample -s100 Mock-5_R2.fastq.gz 2500000 > Mock_sub0.75Gb_R2.fastq

seqtk sample -s100 Mock-6_R1.fastq.gz 3333333 > Mock_sub1.0Gb_R1.fastq
seqtk sample -s100 Mock-6_R2.fastq.gz 3333333 > Mock_sub1.0Gb_R2.fastq

seqtk sample -s100 Mock-7_R1.fastq.gz 5000000 > Mock_sub1.5Gb_R1.fastq
seqtk sample -s100 Mock-7_R2.fastq.gz 5000000 > Mock_sub1.5Gb_R2.fastq

seqtk sample -s100 Mock-8_R1.fastq.gz 6666667 > Mock_sub2Gb_R1.fastq
seqtk sample -s100 Mock-8_R2.fastq.gz 6666667 > Mock_sub2Gb_R2.fastq

seqtk sample -s100 Mock-9_R1.fastq.gz 16666667 > Mock_sub5Gb_R1.fastq
seqtk sample -s100 Mock-9_R2.fastq.gz 16666667 > Mock_sub5Gb_R2.fastq
```


## Quality-filtering, phiX removal and contig assembly by MegaHit

*export conda environment Genome_env*

*upload Assembly script*



