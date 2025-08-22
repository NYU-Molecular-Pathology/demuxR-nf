//RESTAPI Archer Job submission 
process APIJOB {
    input:
    path(samplesheetFile)
    path(path_to_fastqdir)

    script:
    """
    # get name and seq file params for the submit job #
    job_name="\$(cat "${samplesheetFile}" | grep "VariantPlex_Run*" | cut -d',' -f2 | head -n 1)"
    archer_variantplex_api_jobsubmit.py -f "${path_to_fastqdir}" -j "\${job_name}"
    """
}