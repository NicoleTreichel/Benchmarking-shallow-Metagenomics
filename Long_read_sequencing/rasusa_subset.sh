#!/usr/bin/env bash

cd data/filtered

module load conda
conda activate singularity

gunzip JMF-2507-23-0001B.fastq.gz > reads.fq

singularity exec  "docker://quay.io/mbhall88/rasusa" rasusa reads -o JMF-2507-23-0001B-ONT_0010.fastq.gz -b 0.1gb -s 42 reads.fq
singularity exec  "docker://quay.io/mbhall88/rasusa" rasusa reads -o JMF-2507-23-0001B-ONT_0025.fastq.gz -b 0.25b -s 42 reads.fq
singularity exec  "docker://quay.io/mbhall88/rasusa" rasusa reads -o JMF-2507-23-0001B-ONT_0050.fastq.gz -b 0.5gb -s 42 reads.fq
singularity exec  "docker://quay.io/mbhall88/rasusa" rasusa reads -o JMF-2507-23-0001B-ONT_0075.fastq.gz -b 0.75gb -s 42 reads.fq
singularity exec  "docker://quay.io/mbhall88/rasusa" rasusa reads -o JMF-2507-23-0001B-ONT_0100.fastq.gz -b 1gb -s 42 reads.fq
singularity exec  "docker://quay.io/mbhall88/rasusa" rasusa reads -o JMF-2507-23-0001B-ONT_0150.fastq.gz -b 1.5gb -s 42 reads.fq
singularity exec  "docker://quay.io/mbhall88/rasusa" rasusa reads -o JMF-2507-23-0001B-ONT_0200.fastq.gz -b 2gb -s 42 reads.fq
singularity exec  "docker://quay.io/mbhall88/rasusa" rasusa reads -o JMF-2507-23-0001B-ONT_0500.fastq.gz -b 5gb -s 42 reads.fq
singularity exec  "docker://quay.io/mbhall88/rasusa" rasusa reads -o JMF-2507-23-0001B-ONT_1000.fastq.gz -b 10gb -s 42 reads.fq
singularity exec  "docker://quay.io/mbhall88/rasusa" rasusa reads -o JMF-2507-23-0001B-ONT_2000.fastq.gz -b 20gb -s 42 reads.fq
singularity exec  "docker://quay.io/mbhall88/rasusa" rasusa reads -o JMF-2507-23-0001B-ONT_5000.fastq.gz -b 50gb -s 42 reads.fq