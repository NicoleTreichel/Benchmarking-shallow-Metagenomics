# Settings
THREADS=32; # Number of threads to use
BINFOLDER="$1"


module load CheckM/1.2.4-foss-2023b
##################################

# Calculate genome completeness and contamination using CheckM (https://github.com/Ecogenomics/CheckM)

OUTPUTFILE=../checkm.tsv
checkm lineage_wf -x fa -t $THREADS --tmpdir $TMPDIR --pplacer_threads $THREADS --reduced_tree --tab_table $BINFOLDER $TMPDIR/checkm_results -f $OUTPUTFILE


# Classify against Gtdb

module load Conda
conda activate GTDBTk-2.5.2

# Classify the genomes using GTDBtk (https://github.com/Ecogenomics/GTDBTk/)
OUTPUTFILE=../gtdb.summary.tsv
gtdbtk classify_wf --cpus $THREADS --genome_dir $BINFOLDER --out_dir $TMPDIR/gtdb -x fa --skip_ani_screen
cat $TMPDIR/gtdb/classify/*.summary.tsv | sed '1!{/^user/d;}' > $OUTPUTFILE

# Bin stats with quast
OUTPUTFILE=../quast.tsv
quast.py --no-plots --no-icarus --threads $THREADS $BINFOLDER/*.fa --output-dir $TMPDIR/quast
cp $TMPDIR/quast/transposed_report.tsv $OUTPUTFILE
