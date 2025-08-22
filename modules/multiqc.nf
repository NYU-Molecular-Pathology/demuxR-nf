process MULTIQC {
    publishDir "${params.outputDir}/reports", mode: 'copy', overwrite: true

    input:
    path(fastqc_zips)
    val runID

    output:
    path("${output_HTML}"), emit: multiqc_report_html
    path(multiqc_data)
    path(multiqc_plots)

    script:
    output_HTML="${runID}.multiqc.report.html"

    """
    multiqc . --export
    mv multiqc_report.html "${output_HTML}"
    """
}