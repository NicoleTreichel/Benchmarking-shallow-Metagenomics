# Settings
NAME=$1
NPREADS=data/filtered/$NAME.fastq.gz
MEDAKAMODEL=r1041_e82_400bps_bacterial_methylation
THREADS=$SLURM_CPUS_PER_TASK; # Number of threads to use
MODULE_MINIMAP=minimap2/2.28
MODULE_SAMTOOLS=samtools/1.20-1.23
TF_CPP_MIN_LOG_LEVEL=0

#module load
module load conda
module load bcftools
module load $MODULE_MINIMAP
module load $MODULE_SAMTOOLS
module load medaka


mkdir -p results
##################################

# Polishing
OUTPUTFILE=results/$NAME.flye.medaka1x.fa.gz
medaka_consensus -i $NPREADS -b 20 -d temp/$NAME.flye.fa -o $TMPDIR -t $THREADS -m $MEDAKAMODEL
cat $TMPDIR/consensus.fasta | gzip > $OUTPUTFILE
