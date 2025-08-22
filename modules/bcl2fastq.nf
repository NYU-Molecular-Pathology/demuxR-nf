process BCL2FASTQ {
    // demultiplex the samples in the sequencing run
    publishDir "${params.outputDir}/", mode: 'copy', overwrite: true

    input:
    path(validated_samplesheet)
    path(runDir)
    val(assayID)

    output:
    path("${fastq_dir}/**_S[1-9]*_R?_00?.fastq.gz"), emit: fastq
    path("${output_dir}/**Undetermined_S0*_R?_00?.fastq.gz"), emit: undetermined
    path("${output_dir}/Reports"), emit: reports
    path("${output_dir}/Stats"), emit: stats
    path("${output_dir}/Demultiplex_Stats.htm"), emit: demux_stats
    path("${fastq_dir}"), emit: path_to_fastqdir// for archer api job submission
    
    script:
    output_dir = "reads"
    fastq_dir = "${output_dir}/${assayID}"
    """
    nthreads="\${NSLOTS:-\${NTHREADS:-2}}"

    echo "[bcl2fastq]: \$(which bcl2fastq) running with \${nthreads} threads"

    bcl2fastq \
    --min-log-level WARNING \
    --fastq-compression-level 8 \
    --loading-threads 2 \
    --processing-threads \${nthreads:-2} \
    --writing-threads 2 \
    --sample-sheet ${validated_samplesheet} \
    --runfolder-dir ${runDir} \
    --output-dir "./${output_dir}" \
    ${params.bcl2fastq_params}

    # create Demultiplex_Stats.htm
    cat "${output_dir}"/Reports/html/*/all/all/all/laneBarcode.html | grep -v "href=" > "${output_dir}"/Demultiplex_Stats.htm

    # make md5sums
    for item in \$(find "${output_dir}/" -type f -name "*.fastq.gz"); do
    output_md5="\${item}.md5.txt"
    md5sum "\${item}" > \${output_md5}
    done

    # create subfolder and move fastqs
    mkdir -p "${fastq_dir}"
    find ${output_dir} -maxdepth 1 -type f -name "*.fastq.gz" ! -name "Undetermined*_R*_*.fastq.gz" -exec mv {} ${fastq_dir} \\;

    """
}