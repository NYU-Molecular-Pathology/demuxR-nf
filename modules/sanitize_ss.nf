process SANITIZE_SAMPLESHEET {
    // remove any whitespace errors, carriage returns, BOM from samplesheet file
    tag "${input_samplesheet}"
    publishDir "${params.outputDir}/", mode: 'copy', overwrite: true

    input:
    path input_samplesheet, name: "input_sheet.csv"

    output:
    path "${default_samplesheet_name}", emit: sanitized_samplesheet

    script:
    default_samplesheet_name = "SampleSheet.csv"
    """
    dos2unix "input_sheet.csv"
    cp "input_sheet.csv" "${default_samplesheet_name}"
    """

}