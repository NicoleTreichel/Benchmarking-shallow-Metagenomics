# Benchmarking Shallow Metagenomics - UNDER CONSTRUCTION

This GitHub repository describes the workflow used for benchmarking shallow metagenomic sequencing of Mock communities (DNA mixtures), as described in Treichel et al. ([bioRxiv](https://www.biorxiv.org/content/10.1101/2025.03.27.645659v1)).

## Background
With this study we aimed to systematically assess the threshold of sequencing depth necessary for the read-outs of taxonomic analysis, functional genes and pathways, and MAG construction. We used two complex mixtures of DNA from cultured gut bacteria. An evenly distributed Mock community containing DNA of 70 strains and one with staggered distribution containing DNA of 24 strains. Analysis was done at nine sequencing depths (0.1, 0.25, 0.5, 0.75, 1.0, 1.5, 2.0, 5.0, and 10.0 Gb). Additionally, library preparation was performed in two facilities and the effect of background DNA was tested. 

## Description
**Pre-processing**
1. Sub-sampling of shotgun metagenomic data to exact number of reads ([seqtk](https://github.com/lh3/seqtk))
2. Quality filtering and phiX removal ([trimmomatic](http://www.usadellab.org/cms/index.php?page=trimmomatic), [bbmap, bbduk](https://archive.jgi.doe.gov/data-and-tools/software-tools/bbtools/bb-tools-user-guide/))
3. Assembly into Contigs ([MegaHit](https://github.com/voutcn/megahit))

**Taxonomic Analysis**
1. Coverage of reads to reference genomes ([coverM](https://github.com/wwood/CoverM))
2. Read count per reference genome / Relative abundance ([coverM](https://github.com/wwood/CoverM))

**Functional Analysis**
1. Protein coding gene prediction ([prodigal](https://github.com/hyattpd/Prodigal))
2. Alignment to predicted protein sequences of reference genomes ([Diamond](https://github.com/bbuchfink/diamond))
3. Completeness of functional pathways ([kofamscan](https://github.com/takaram/kofam_scan), [KEGGdecoder](https://github.com/bjtully/BioData/tree/master/KEGGDecoder))
   
**Construction of metagenome-assembled genomes (MAGs)**
1. Removal of contigs < 1000 bp
2. MAG construction ([bowtie2](https://bowtie-bio.sourceforge.net/bowtie2/index.shtml), [metabat2](https://bitbucket.org/berkeleylab/metabat/src/master/))
3. Evaluation of completeness and contamination ([checkM](https://ecogenomics.github.io/CheckM/))
4. Taxonomic assignment ([GTDB-tk](https://github.com/Ecogenomics/GTDBTk))
5. MAG composition with respect to reference genomes ([blastn](https://blast.ncbi.nlm.nih.gov/Blast.cgi))

   
## Graphical overview
![Workflow overview](https://github.com/NicoleTreichel/Benchmarking-shallow-Metagenomics/blob/main/Workflow_Overview.pdf)

## Installation / Requirements
For installation of the required tools please visite their original websites linked above.

## Data availability
Metagenomic data has be deposited at the European Nucleotide Archive/NCBI and is accessible under Project no. PRJEB83573. 

## Publication
Treichel et al. [bioRxiv](https://www.biorxiv.org/content/10.1101/2025.03.27.645659v1)
