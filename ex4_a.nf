#!/usr/bin/env nextflow

params.fastq_dir = "${projectDir}/data"
params.outdir = "results"

process SEQKIT_STATS {

    container 'community.wave.seqera.io/library/gatk_seqkit:08544d2d699aecde'
    publishDir params.outdir, mode: 'copy'

    input:
      path fastq
      path fasta

    output:
      path "stats_all.tsv"

    script:
    
    """
    seqkit stats $fastq $fasta > stats_all.tsv
   
    """
}

workflow {
    // fastq channel
    Channel.fromPath("${params.fastq_dir}/*.fastq")
          .view()
           .set { fastq_files }

    // fasta channel
    Channel.fromPath("${params.fastq_dir}/*.fa")
          .view()
           .set { fasta_files }

    SEQKIT_STATS(fastq_files,fasta_files)
}