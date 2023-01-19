rule crop_image:
    input:
        image = 'Images/{image}.jpg',
        metadata = 'Metadata/{image}.json'
    output: 'Cropped/{image}_cropped.jpg'
    log: 'logs/crop_image_{image}.log'
    container:
        'docker://ghcr.io/hdr-bgnn/crop_image:0.0.4'
    shell: 'Crop_image_main.py {input.image} {input.metadata} {output} > {log} 2>&1'
