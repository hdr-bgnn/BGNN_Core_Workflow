rule generate_metadata:
    input:'Images/{image}.jpg'
    output:
        metadata = 'Metadata/{image}.json',
        mask = 'Mask/{image}_mask.png'
    log: 'logs/generate_metadata_{image}.log'
    container:
        'library://thibaulttabarin/bgnn/gen_metadata:v2'
    shell: 'gen_metadata.py {input} {output.metadata} {output.mask} > {log} 2>&1'
