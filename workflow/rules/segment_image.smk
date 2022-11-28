rule segment_image:
    input: 'Cropped/{image}_cropped.jpg'
    output: 'Segmented/{image}_segmented.png'
    log: 'logs/segment_image_{image}.log'
    container:
        'docker://ghcr.io/hdr-bgnn/bgnn-trait-segmentation:0.0.6'
    shell:
        'segmentation_main_rescale_origin.py {input} {output} > {log} 2>&1'
