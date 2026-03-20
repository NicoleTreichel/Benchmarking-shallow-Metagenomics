#let NPsamples be a list of samples

# Settings
NAME=$1
NPDIR=data/filtered
THREADS=$SLURM_CPUS_PER_TASK; # Number of threads to use

# Load modules
module load conda 
MODULE_MINIMAP=minimap2/2.30-GCCcore-14.3.0
MODULE_SAMTOOLS=SAMtools/1.22.1-GCC-14.2.0
MODULE_METABAT=MetaBAT/2.18-GCC-13.3.0

# Binning

module load $MODULE_SAMTOOLS
module load $MODULE_MINIMAP

REF=results/$NAME.flye.medaka1x.fa.gz
while read NPsamples
do
NAMEMAP=$NPsamples;
mkdir -p $TMPDIR/temp/mapping/$NAME
OUTPUTFILE=$TMPDIR/temp/mapping/$NAME/$NAME.$NAMEMAP.np.cov.bam
if [ -s $OUTPUTFILE ]; then echo "$OUTPUTFILE has already been generated";  
else
minimap2 -ax map-ont -t $THREADS $REF $NPDIR/$NAMEMAP.fastq.gz |\
  samtools view --threads $THREADS -Sb -F 0x104 - |\
  samtools sort --threads $THREADS - > $OUTPUTFILE
fi
done < NPsamples

## Extract coverage info 
mkdir -p temp/metabat2/$NAME/bins/
module load $MODULE_METABAT
jgi_summarize_bam_contig_depths --percentIdentity 90 --outputDepth $OUTPUTFILE $TMPDIR/temp/mapping/$NAME/*.np.cov.bam

## Create final bin contig list
metabat2 -i $REF -a $OUTPUTFILE -t $THREADS -o temp/metabat2/$NAME/bins/$NAME.bin
grep -r ">" temp/metabat2/$NAME/bins/ | sed 's/.*bins\///' | sed 's/:>/\t/' > results/$NAME.bin_contig_list.tsv
module unload $MODULE_METABAT


