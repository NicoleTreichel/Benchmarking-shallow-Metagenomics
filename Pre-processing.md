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

*export conda environment Genome_env and upload here*

```
conda activate Genome_env 
```

To run this script for quality filtering, phiX read removal and assembly of contig with MEGAHIT, the sub-sampled R1 and R2 files for a sample have to be in one folder. Each file pair gets it´s own folder.
``` bash
for d in */ ; do
    cd "$d"
    FILENAME1=$(echo *_R1.fastq)
    FILENAME2=$(echo *_R2.fastq)

        BASE=$(basename $FILENAME1 _R1.fastq)
        mkdir -p ./OUTPUT_${BASE}

        #Quality filtering and eliminating read through into adapters
        trimmomatic PE -phred33 $FILENAME1 $FILENAME2 OUTPUT_${BASE}/${BASE}_output_forward_paired.fq.gz OUTPUT_${BASE}/${BASE}_output_forward_unpaired.fq.gz OUTPUT_${BASE}/${BASE}_output_reverse_paired.fq.gz OUTPUT_${BASE}/${BASE}_output_reverse_unpaired.fq.gz ILLUMINACLIP:../NexteraPE-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:5:20 MINLEN:50

        #phiX removal step
        bbduk.sh ref=/PATH/toPHIX/REFERENCE/phix.fasta in1=OUTPUT_${BASE}/${BASE}_output_forward_paired.fq.gz in2=OUTPUT_${BASE}/${BASE}_output_reverse_paired.fq.gz k=31 hdist=1 out=OUTPUT_${BASE}/${BASE}_rmphiX_forward_paired.fq.gz out2=OUTPUT_${BASE}/${BASE}_rmphiX_reverse_paired.fq.gz

      # Assembly with MEGAHIT
      megahit --k-list 21,27,33,37,43,55,63,77,83,99 --min-count 5 --num-cpu-threads 52 --out-dir OUTPUT_${BASE}/${BASE}-assembly -1 OUTPUT_${BASE}/${BASE}_rmphiX_forward_paired.fq.gz -2 OUTPUT_${BASE}/${BASE}_rmphiX_reverse_paired.fq.gz

    cd ..
    echo "$d" "$FILENAME1" "$FILENAME2" "$BASE" >> log.txt
done
echo "----------Script Finished-------------"
```

## Assembly of contigs with metaSPAdes 

The quality filtered and phiX removed files created by the script above are used here.
Install SPAdes as described [here](https://ablab.github.io/spades/installation.html)

Run metaSPAdes: 
```
spades --meta -t 20 -1 Mock2_1-sub0.1Gb_rmphiX_forward_paired.fq.gz -2 Mock2_1-sub0.1Gb_rmphiX_reverse_paired.fq.gz -o metaSpades_out
```



