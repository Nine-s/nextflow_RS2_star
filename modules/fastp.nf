process FASTP {
    label 'fastp'
    publishDir params.outdir

    input:
    tuple val(name), path(reads_1), path(reads_2)

    output:
    tuple val(name), path("*${name}*R1.trimmed.f*q.gz"), path("*${name}*R2.trimmed.f*q.gz"), emit: sample_trimmed
    path "${name}_fastp.json"
    path "${name}_fastp.html"

    script:
    """
    fastp -i ${reads_1} -I ${reads_2} -o ${reads_1.getBaseName()}.R1.trimmed.fastq.gz -O ${reads_1.getBaseName()}.R2.trimmed.fastq.gz --detect_adapter_for_pe --json ${name}_fastp.json --html ${name}_fastp.html
    """
}
