rule create_morphological_analysis:
    input:
        image = 'Segmented/{image}_segmented.png',
        metadata = 'Metadata/{image}.json'
    output:
        measure = "Morphology/Measure/{image}_measure.json",
        landmark = "Morphology/Landmark/{image}_landmark.json",
        presence = "Morphology/Presence/{image}_presence.json",
        vis_landmarks = "Morphology/Vis_landmarks/{image}_landmark_image.png"
    log: 'logs/create_morphological_analysis_{image}.log'
    container:
        "docker://ghcr.io/hdr-bgnn/morphology-analysis/morphology:0.2.0"
    shell:
        'Morphology_main.py {input.image} {input.metadata} {output.measure} {output.landmark} {output.presence} {output.vis_landmarks} > {log} 2>&1'
