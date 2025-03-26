#!/usr/bin/env bash

# Activate conda env before running 
# conda activate Genome_env


for d in */ ; do
    cd "$d"
    FILENAME1=$(echo *_R1.fastq)
    FILENAME2=$(echo *_R2.fastq)

	BASE=$(basename $FILENAME1 _R1.fastq) 

	# create directory if it does not exist already
	mkdir -p ./OUTPUT_${BASE}

	#Quality filtering and eliminating read through into adapters
	trimmomatic PE -phred33 $FILENAME1 $FILENAME2 OUTPUT_${BASE}/${BASE}_output_forward_paired.fq.gz OUTPUT_${BASE}/${BASE}_output_forward_unpaired.fq.gz OUTPUT_${BASE}/${BASE}_output_reverse_paired.fq.gz OUTPUT_${BASE}/${BASE}_output_reverse_unpaired.fq.gz ILLUMINACLIP:../NexteraPE-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:5:20 MINLEN:50

	#phix removal step
	bbduk.sh ref=/DATA/Nicole/Bin/Other_Database/phix.fasta in1=OUTPUT_${BASE}/${BASE}_output_forward_paired.fq.gz in2=OUTPUT_${BASE}/${BASE}_output_reverse_paired.fq.gz k=31 hdist=1 out=OUTPUT_${BASE}/${BASE}_rmphiX_forward_paired.fq.gz out2=OUTPUT_${BASE}/${BASE}_rmphiX_reverse_paired.fq.gz

	#Assembly 
	megahit --k-list 21,27,33,37,43,55,63,77,83,99 --min-count 5 --num-cpu-threads 52 --out-dir OUTPUT_${BASE}/${BASE}-assembly -1 OUTPUT_${BASE}/${BASE}_rmphiX_forward_paired.fq.gz -2 OUTPUT_${BASE}/${BASE}_rmphiX_reverse_paired.fq.gz

    cd ..
    echo "$d" "$FILENAME1" "$FILENAME2" "$BASE" >> log.txt
done
echo "----------Script Finished-------------"


