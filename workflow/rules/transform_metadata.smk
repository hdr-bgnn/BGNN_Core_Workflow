rule transform_metadata:
    input: 'DrexelMetadata/{image}.json'
    output: 'Metadata/{image}.json',
    log: 'logs/transform_metadata_{image}.log'
    container:
        'docker://ghcr.io/hdr-bgnn/drexel_metadata_formatter:0.0.1'
    shell: 'python /pipeline/dm_formatter.py {input} {output} > {log} 2>&1'
