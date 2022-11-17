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
        "docker://jbradley/morphology-analysis:dev"
    shell:
        'Morphology_main.py --metadata {input.metadata} --morphology {output.measure} --landmark {output.landmark} --lm_image {output.vis_landmarks} {input.image} {output.presence} > {log} 2>&1'

