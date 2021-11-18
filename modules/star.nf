process STAR_INDEX_REFERENCE {
    label 'star'
    publishDir params.outdir
    memory '30 GB'
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

    output:
    tuple val(sample_name), path("${reads_1.getBaseName()}*.sam"), emit: sample_sam 

    script:
    """

    STAR \\
          --genomeDir . \\
          --readFilesIn ${reads_1} ${reads_2} \\
          --readFilesCommand gunzip -c \\
          --outFileNamePrefix ${reads_1.getBaseName()}. \\
          --sjdbGTFfile ${annotation}
    """   
   
}
