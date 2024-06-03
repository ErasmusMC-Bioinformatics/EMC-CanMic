process QIIME2_SUMMARIZE {
    label 'process_single','error_ignore'
    conda "${moduleDir}/environment.yml"
    // container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
    //     'https://depot.galaxyproject.org/singularity/YOUR-TOOL-HERE':
    //     'biocontainers/YOUR-TOOL-HERE' }"

    input:
    path freq_table
    // val peepoo

    output:
    path "*.qzv", emit: summary
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    qiime feature-table summarize \\
    $args \\
    --i-table ${freq_table} \\
    --o-visualization summary.qzv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qiime2: \$(qiime --version | head -n 1 | awk '{print \$3}')
    END_VERSIONS
    """

    // stub:
    // def args = task.ext.args ?: ''
    
    // // TODO nf-core: A stub section should mimic the execution of the original module as best as possible
    // //               Have a look at the following examples:
    // //               Simple example: https://github.com/nf-core/modules/blob/818474a292b4860ae8ff88e149fbcda68814114d/modules/nf-core/bcftools/annotate/main.nf#L47-L63
    // //               Complex example: https://github.com/nf-core/modules/blob/818474a292b4860ae8ff88e149fbcda68814114d/modules/nf-core/bedtools/split/main.nf#L38-L54
    // """
    // touch ${prefix}.bam

    // cat <<-END_VERSIONS > versions.yml
    // "${task.process}":
    //     qiime2: \$(samtools --version |& sed '1!d ; s/samtools //')
    // END_VERSIONS
    // """
}
