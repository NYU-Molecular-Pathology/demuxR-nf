#!/usr/bin/env nextflow

include { DEMULTIPLEX } from './workflows/demultiplex.nf'

workflow {
    // Call Demux to get fastq and qc demux reports
    DEMULTIPLEX()

}