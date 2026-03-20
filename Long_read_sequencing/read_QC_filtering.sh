
# Settings
NPDIR=data
THREADS=$SLURM_CPUS_PER_TASK; # Number of threads to use

# load conda
module load conda

#QC raw data
cd $NPDIR
conda activate seqkit-2.10.0
seqkit stats *gz -a > seqkit_stats.tsv

conda activate nanocomp-1.24.2 
NanoComp --threads $SLURM_CPUS_PER_TASK --tsv_stats --fastq *gz --outdir ../results/NP_QC -p $(cat ../JMF_ID)

# Filter raw data: create Qtrimmed library and Qlength trimmed library
mkdir -p filtered
conda activate chopper-0.10.0
gunzip -c JMF-2507-23-0001A.fastq.gz | chopper -q 20 -t $SLURM_CPUS_PER_TASK | pigz > filtered/JMF-2507-23-0001A.fastq.gz
gunzip -c JMF-2507-23-0001A.fastq.gz  | chopper -q 20 -l 1000 -t $SLURM_CPUS_PER_TASK | pigz > filtered/JMF-2507-23-0001B.fastq.gz

#QC filtered data
cd filtered

conda activate nanocomp-1.24.2 
NanoComp --threads $SLURM_CPUS_PER_TASK --tsv_stats --fastq *.gz --outdir ../../results/NP_QC_filtered -p $(cat ../../JMF_ID)

conda activate seqkit-2.10.0
seqkit stats *gz -a > seqkit_stats.tsv
