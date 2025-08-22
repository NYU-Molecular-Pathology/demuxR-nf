process VALIDATE_RUN_COMPLETION {
    // Check if sequencer finished sequencing, Check for RunCompletionStatus.xml, RTAComplete.txt and RunParamters.xml files
    tag "${runDir}"
    publishDir "${params.outputDir}/", mode: 'copy', overwrite: true

    input:
    val runDir

    output:
    path 'RTAComplete.txt'
    path 'RunCompletionStatus.xml'
    path 'RunParameters.xml'

    script:
    """
    cp ${runDir}/RTAComplete.txt .
    cp ${runDir}/RunCompletionStatus.xml .
    cp ${runDir}/RunParameters.xml . 
    """

}