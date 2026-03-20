module load Flye/2.9.6-GCC-13.3.0

# Settings
NAME=$1
NPREADS=data/filtered/$NAME.fastq.gz
THREADS=$SLURM_CPUS_PER_TASK; # Number of threads to u


# Assembly
OUTPUTFILE=temp/$NAME.flye.fa

flye --nano-hq $NPREADS --threads $THREADS --meta --out-dir temp/flye/$NAME

#remove contigs shorter than 1000bp 
module load seqtk/1.5-GCC-14.3.0
seqtk seq -L 1000 temp/flye/$NAME/assembly.fasta > $OUTPUTFILE
