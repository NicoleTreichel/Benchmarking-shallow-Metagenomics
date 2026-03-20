# Settings
THREADS=$SLURM_CPUS_PER_TASK; # Number of threads to use
ASMDIR=$1

# Load modules

module load conda
module load QUAST/5.3.0-gfbf-2023b

####################  QC assemblies with quast ##############################

quast.py --threads $SLURM_CPUS_PER_TASK --no-plots --no-html --output-dir temp/assemblies_qc_quast $ASMDIR/*fa.gz
cp temp/assemblies_qc_quast/transposed_report.tsv $ASMDIR/asm_qc_quast.tsv
