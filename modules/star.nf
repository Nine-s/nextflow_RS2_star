process STAR_INDEX_REFERENCE {
    label 'star'
    publishDir params.outdir
    memory '50 GB'
    executor 'k8s'
 
    input:
    path(reference)
    path(annotation)

    output:
    path("star/*")

    script:
    """
    mkdir star
    STAR \\
            --runMode genomeGenerate \\
            --genomeDir star/ \\
	        --genomeFastaFiles ${reference} \\
            --sjdbGTFfile ${annotation}
    """
}

process STAR_ALIGN {
    label 'star'
    publishDir params.outdir
    memory '50 GB'
    executor 'k8s'
    
    input:
    tuple val(sample_name), path(reads_1), path(reads_2)
    path(index)
    path(annotation)
    env STRANDNESS

    output:
    tuple val(sample_name), path("${reads_1.getBaseName()}*.sam"), emit: sample_sam 

    shell:
    '''
    #STRANDNESS="firststrand"
    if [[ ($STRANDNESS == "firststrand") || ($STRANDNESS == "secondstrand") ]]; then
    STAR \\
          --genomeDir . \\
          --readFilesIn !{reads_1} !{reads_2} \\
          --alignSoftClipAtReferenceEnds No \\
          --readFilesCommand gunzip -c \\
          --outFileNamePrefix !{reads_1.getBaseName()}. \\
          --sjdbGTFfile !{annotation} \\
	  --outFilterIntronMotifs RemoveNoncanonical \\
	  --outSAMattrIHstart 0 \\
 	  --runThreadN 7 #!{params.threads}

    elif [[ $STRANDNESS == "unstranded" ]]; then
       STAR \\
          --genomeDir . \\
          --readFilesIn !{reads_1} !{reads_2} \\
	  --outFilterIntronMotifs RemoveNoncanonical \\
          --alignSoftClipAtReferenceEnds No \\
	  --outSAMstrandField intronMotif \\
          --readFilesCommand gunzip -c \\
          --outFileNamePrefix !{reads_1.getBaseName()}. \\
          --sjdbGTFfile !{annotation} \\
	  --outSAMattrIHstart 0
    else  
		echo $STRANDNESS > error_strandness.txt
		echo "strandness cannot be determined" >> error_strandness.txt
	fi

    '''   
   
}
