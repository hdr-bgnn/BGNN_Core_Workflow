rule transform_metadata:
    input: 'DrexelMetadata/{image}.json'
    output: 'Metadata/{image}.json',
    log: 'logs/transform_metadata_{image}.log'
    container:
        'docker://jbradley/drexel_metadata_formatter:dev'
    shell: 'python /pipeline/dm_formatter.py {input} {output} > {log} 2>&1'
