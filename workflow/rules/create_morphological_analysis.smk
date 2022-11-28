rule create_morphological_analysis:
    input:
        image = 'Segmented/{image}_segmented.png',
        metadata = 'Metadata/{image}.json'
    output: 'Morphology/Presence/{image}_presence.json'
    log: 'logs/create_morphological_analysis_{image}.log'
    container:
        "docker://jbradley/morphology-analysis:dev"
    shell:
        'Morphology_main.py {input.image} {output.presence} > {log} 2>&1'

