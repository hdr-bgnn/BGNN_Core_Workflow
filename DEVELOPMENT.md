# Development Instructions

To run the pipeline locally requires Snakemake and Singularity.
One portable approach to providing these requirements is using Docker.

## Start Docker Environment
First clone this repository and cd into the base directory.
Since we are using singularity inside the Docker container we will need to enable priviledged mode.
To make the source code from the repository available we will need to mount it into the container.
Run the following command to open up an interactive session with snakemake and singularity enabled.
```
docker run --privileged -it -v $(pwd):/src -w /src snakemake/snakemake:v7.12.1 bash
```
Once you are finished you can type `exit` to quit.

## Running Step by Step
By default the workflow will run the entire process from end to end.
When working on the pipeline it can be useful to run steps one at a time.
To do so we should isolate a single image in the input CSV file we wish to process.
Then you can pass the output filename for a step to the snakemake command.

Below we will show how to run each step for the `INHS_FISH_14841` image included in `List/list_test.csv`.

### Step 1: Download Image
The output of the download_image rule has an output of `Images/{image}.jpg`.

To download the `INHS_FISH_14841` image run the following command:
```
snakemake -c1 --use-singularity --config list=List/list_test.csv -- Images/INHS_FISH_14841.jpg
```

### Step 2: Generate Metadata
The generate_metadata rule has an output of `Metadata/{image}.json`.


To generate the metadata run the following command:
```
snakemake -c1 --use-singularity --config list=List/list_test.csv -- Metadata/INHS_FISH_14841.json
```

### Step 3: Crop Image
```
snakemake -c1 --use-singularity --config list=List/list_test.csv -- Cropped/INHS_FISH_14841_cropped.jpg
```

### Step 4: Segment Image
```
snakemake -c1 --use-singularity --config list=List/list_test.csv -- Segmented/INHS_FISH_14841_segmented.png
```

### Step 5: Create Morphological Analysis
```
snakemake -c1 --use-singularity --config list=List/list_test.csv -- Morphology/Measure/INHS_FISH_14841_measure.json
```
