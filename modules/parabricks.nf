process fastq2bam {

    container 'nvidia/cuda:11.0-base nvidia-smi'

    tag { sample_id }

    publishDir "${params.outdir}", mode: 'copy', pattern: "*"
    
    input:
    tuple val(sample_id), path(reads_1), path(reads_2)
 
    output:
    path("*"), emit: results
    path("*.bam"), emit: bam

    script:
    """
    # mkdir ${sample_id}
    # touch ${sample_id}/${reads_1}

    pbrun fq2bam \
      --ref ${params.ref} \
      --in-fq ${reads_1} ${reads_2} \
      --out-bam ${sample_id}.bam
    """
}

process bam2vcf {

    container 'nvidia/cuda:11.0-base nvidia-smi'

    publishDir "${params.outdir}", mode: 'copy', pattern: "*"
    
    input:
    path(bam)
 
    output:
    path("*"), emit: results

    script:
    """
    # mkdir ${sample_id}
    # touch ${sample_id}/${reads_1}

    pbrun haplotypecaller \
      --ref ${params.ref} \
      --in-bam ${bam} \
      --out-variants variants.vcf
    """
}