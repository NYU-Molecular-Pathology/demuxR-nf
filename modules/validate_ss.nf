process VALIDATE_SAMPLESHEET {
    // make sure sample IDs are formatted correctly
    tag "${sanitized_samplesheet}"
    stageInMode "copy"

    input:
    path sanitized_samplesheet

    output:
    path "${sanitized_samplesheet}", emit: validated_samplesheet

    script:
    """
    validate-samplesheet.py "${sanitized_samplesheet}"
    """
}