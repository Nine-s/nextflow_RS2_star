# nextflow_RS2_star

## About

This repository contains a nextflow workflow treating RNAseq data.
It consits of the following steps:
- fastq (preprocessing)
- check strandedness (determine the strandedness of the input data)
- STAR index reference 
- split reads
- STAR Align to reference
- sort and convert alignement to BAM
- merge alignements of chunks
- cufflinks (transcript abuundance)

## Input

References: 
- Reference genome (fasta)
- reference transcriptome (fasta)
- genome annotation (gtf) 
To call the check strandedness, ensembl references are necessary.
Input reads: 
- paired-ends FASTQ files (single end for the moment not supported)

## Output

- Quality control file from fastp 
- transcripts abundance from cufflinks

## How to run the workflow

```
nextflow run path/to/nextflow_RS2_star -c nextflow.config -w /path/to/workdir
```

How to run on the FONDA cluster:
```
nextflow kuberun Nine-s/nextflow_RS2_star -r main -c nextflow.config -v nextflow-ninon:/workdir
```

The configuration files are available in the `config` directory.