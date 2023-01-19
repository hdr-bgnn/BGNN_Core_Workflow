rule generate_metadata:
    input:'Images/{image}.jpg'
    output:
        metadata = 'DrexelMetadata/{image}.json',
        mask = 'Mask/{image}_mask.png'
    log: 'logs/generate_metadata_{image}.log'
    container:
        'docker://ghcr.io/hdr-bgnn/drexel_metadata:0.5'
    shell: 'gen_metadata.py {input} --device cpu --outfname {output.metadata} --maskfname {output.mask} > {log} 2>&1'
