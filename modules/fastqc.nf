process FASTQC {
    publishDir "${params.outputDir}/fastqc", mode: 'copy', overwrite: true

    input:
    path(raw_fastq)

    output:
    path("${output_html}")
    path("${output_zip}"), emit: fastqc_zips
    val("${output_html}"), emit: done_fastqc

    script:
    output_html = "${raw_fastq}".replaceFirst(/.fastq.gz$/, "_fastqc.html")
    output_zip = "${raw_fastq}".replaceFirst(/.fastq.gz$/, "_fastqc.zip")
    """
    fastqc -o . "${raw_fastq}"
    """
}