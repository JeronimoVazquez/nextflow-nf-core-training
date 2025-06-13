#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.fastq_dir = "${projectDir}/data"
params.outdir    = "results"

process SEQKIT_STATS {

    container 'community.wave.seqera.io/library/gatk_seqkit:08544d2d699aecde'
    publishDir params.outdir, mode: 'copy'

    input:
      tuple path(fastq), path(fasta)

    output:
      path "stats_all.tsv"

    script:
    """
    seqkit stats $fastq $fasta > stats_all.tsv
    """
}

workflow {

    fastq_ch = Channel.fromPath("${params.fastq_dir}/*.fastq")

    
    fasta_ch = Channel.fromPath("${params.fastq_dir}/*.fa")

   
    paired_ch = fastq_ch.combine(fasta_ch).view()


    SEQKIT_STATS(paired_ch)
}
