rule download_image:
    output:'Images/{image}.jpg'
    params: download_link = lambda wildcards: get_name_to_url()[wildcards.image]
    log: 'logs/download_image_{image}.log'
    container:
        'docker://quay.io/biocontainers/gnu-wget:1.18--h7132678_6'
    shell: 'wget -O {output} {params.download_link} > {log} 2>&1'
