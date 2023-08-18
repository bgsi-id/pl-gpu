#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { fastq2vcf } from './modules/parabricks.nf'

fastq_channel = Channel.fromFilePairs( params.globPattern, flat: true ).map{ it -> [it[0].split('_')[0], it[1], it[2]] }.unique{ it -> it[0] }

workflow {
  main:
    fastq2vcf(fastq_channel)
    bam2vcf(fastq2vcf.out.bam)
}
