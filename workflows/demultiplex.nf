include { VALIDATE_RUN_COMPLETION } from '../modules/validate_run.nf'
include { SANITIZE_SAMPLESHEET } from '../modules/sanitize_ss.nf'
include { VALIDATE_SAMPLESHEET } from '../modules/validate_ss.nf'
include { BCL2FASTQ } from '../modules/bcl2fastq.nf'
include { FASTQC } from '../modules/fastqc.nf'
include { MULTIQC } from '../modules/multiqc.nf'
include { APIJOB } from '../modules/apijob.nf'

workflow DEMULTIPLEX {

    main:
        // Get runID from the input channel runDir (here runDir is path to bcl files)
        ch_runDir = params.runDir
        ch_samplesheet = file(params.samplesheet)
        // Need runID and samplesheet for downstream processes
        def rdir_path = params.runDir
        // Get runID info from runDir path
        def runID = rdir_path.tokenize('/')[-1]
        println runID
        // get assayId for downstream process
        def assayID = ch_samplesheet.text.split('\n')[3].split(',')[1].trim()
        println assayID

        // Validate and Clean input samplesheet
        VALIDATE_RUN_COMPLETION(ch_runDir)
        SANITIZE_SAMPLESHEET(ch_samplesheet)
        VALIDATE_SAMPLESHEET(SANITIZE_SAMPLESHEET.out.sanitized_samplesheet)

        // Convert bcl to fastq
        BCL2FASTQ(VALIDATE_SAMPLESHEET.out.validated_samplesheet,ch_runDir,assayID)
        ch_fastq_raw = BCL2FASTQ.out.fastq
        // Get fastqc metrics for the generated fastq files
        FASTQC(BCL2FASTQ.out.fastq.flatMap())
        // Generate multiqc report for the run
        ch_multiqc = (FASTQC.out.fastqc_zips.collect())
        MULTIQC(ch_multiqc,runID)
        ch_multiqc_report = MULTIQC.out.multiqc_report_html
    
        //APIJOB process runs only when profile has Archer in it
        if(workflow.profile.contains("Archer")){
            APIJOB(VALIDATE_SAMPLESHEET.out.validated_samplesheet,BCL2FASTQ.out.path_to_fastqdir)
        }

    emit:
        // multiqc report for fastqc metrics across all samples in the run
        sample_fastq = ch_fastq_raw
        runID_name = runID
}