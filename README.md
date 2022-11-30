# BGNN_Snakemake
First complete version of the BGNN image segmentation workflow managed using snakemake.

# 1- Introduction

The image segmentation workflow is managed using snakemake, a user-friendly python workflow manager. Snakemake uses a syntax based on python and can use python code in the definition of the workflow. 

The segmentation workflow consists of the following steps each defined by a "rule". 
The output of each rule is stored to specific folders that is produced by the workflow:
   1. Download the fish **Images** from [Tulane server](http://www.tubri.org/HDR/INHS/) using a simple bash script.
      * Images are saved to the folder **Images**.
   
   2. Extract **Metadata** information using Detectron2 (deep learning segmentation). The code developed by Drexel and the script used can be found [here](https://github.com/hdr-bgnn/drexel_metadata/blob/release/gen_metadata.py).
      * This code extracts the ruler scale (pixels/cm).
      * This code identified and extracts a bounding box around the fish in the image.
      * Information about the ruler scale and bounding box size are saved as .json files in the folder **Metadata**.
      * Images retain the original file name and we add the suffix "_mask".
      * The mask is saved in the folder **Mask**.
      
   3. Reformat **Metadata** information using https://github.com/hdr-bgnn/drexel_metadata_formatter. This step is not fundamentally necessary but provide an example of good practice when we use software that doesn't output exactly the format required, it is good practice not to modify the source but instead to create intemediary steps to achieve wanted output. Here is one powerful advantage to sue workflow manager.
      
   4.	Create **Cropped** images of the fish using the bounding box from Metadata. The code is under [Crop_image_main.py](https://github.com/hdr-bgnn/Crop_image/blob/main/Crop_image_main.py).
      * We increased the bounding box around the fish by 2.5% on each side (5% total) for the crop to prevent truncation of the file.
      * Images retain the original file name and we add the suffix "_cropped".
      * The cropped image is in the folder **Cropped**.
      
   5. **Segmented** traits using code developed by Maruf [here](https://github.com/hdr-bgnn/BGNN-trait-segmentation/blob/main/Segment_mini/scripts/segmentation_main.py).
      * This code produces an image of a segmented fish (color coding following example in "Stage 1" below).
      * The input cropped image must be resized to 800x320 pixels.
      * We then resize the output segmented image (800x320) to the size of the cropped image (which is the size of the bounding box plus 5% increase).
           - This ensures that the image is at the same scale as the ruler when the ruler scale was extracted in Metadata.
      * Images retain the original file name and we add the suffix "_segmented".
      * The segmented image is saved in the folder **Segmented**.
      
   6. BGNN version of **morphology** traits extraction, including linear measurements, areas, ratios, and landmarks. This part is done in collaboration between Battelle (Meghan, Paula and Thibault) and Tulane (Yasin, Bahadir and Hank). The code is under [Morphology_main.py](https://github.com/hdr-bgnn/Morphology-analysis/blob/main/Scripts/Morphology_main.py). 
      * The rule creates the folder **Morphology** to store the outputs
      * The default output is:
           - .json files of the presence and number of part for each segmented traits (called blobs), it is saved in the folder **Morphology/Presence**.
      * Additional output could be called by changing the command line calling the function Morphology_main.py [here](workflow/rules/create_morphological_analysis.smk). A complete description of the function command line instrcution is available [here](https://github.com/hdr-bgnn/Morphology-analysis/tree/version-presence-absence). The additional possible output are :
           - .json files of the position of the extracted landmarks saved in the folder **Morphology/Landmark**. 
           - .json files of the measurements of distance and area traits saved in the folder **Morphology/Measure**.
           - A visualization of the landmarks on the segmented fish image saved in the folder **Morphology/Vis_landmarks**.
               * Images retain the original file name and we add the suffix "_vis_landmarks".
         
For this version the schematic describing the landmarks and measurements are [here](https://github.com/hdr-bgnn/minnowTraits/blob/main/Old_landmark_measure_map/Landmark_Measure.png). This an older version of the labels.

The first 5 steps are represented in the following workflow diagram, and the 5th step (Stage 2) can be found on the <a href="https://github.com/hdr-bgnn/Morphology-analysis">Morphology_Analysis repository</a>.

![Workflow overview 1](https://github.com/hdr-bgnn/BGNN_Snakemake/blob/main/Picture_for_Documentation/Workflow_stage_1.png)

![Workflow overview 2](https://github.com/hdr-bgnn/BGNN_Snakemake/blob/main/Picture_for_Documentation/Workflow_stage_2.png)

## Workflow components

1. Snakemake package: installed and managed by conda or mamba, which is similar to conda but optimized for snakemake. To access snakemake, use the bioconda channel or mamba conda channel.

2. Snakefile

3. Scripts for
   - Generating metadata (in particular bounding box, bbox) [code here](https://github.com/hdr-bgnn/drexel_metadata/gen_metadata.py)
   - reformat metadata [code here](https://github.com/hdr-bgnn/drexel_metadata_formatter/blob/main/dm_formatter.py)
   - Cropping the fish using bbox and generating cropped image [code here](https://github.com/hdr-bgnn/Crop_image/blob/main/Crop_image_main.py)
   - Traits segmentation [code here](https://github.com/hdr-bgnn/BGNN-trait-segmentation/blob/main/Segment_mini/scripts/segmentation_main.py)
   - Morphology [code here](https://github.com/hdr-bgnn/Morphology-analysis/blob/main/Scripts/Morphology_main.py)
 
4. Containers
   - In Packages on their respective gihub repo

5. Data
   - **Images** : store the ouput from the Download step. Images downloaded from Tulane server
   - **Metadata** : store the output from generate_metadata.py code developed by Drexel team. One file ".json" per image
   - **Reformatted Metadata** : Just a simple reformat of the drexel metadata output.  One file ".json" per image
   - **Cropped** : store the ouput from Crop image.  One file ".jpg" per image
   - **Segmented** : store the ouput from Segment trait using code developed by M. Maruf (Virginia Tech)
   - **Morphology** : in development, current version (1) has been develop by Thibault Tabarin (Battelle), for information about the trait and morphology check [minnowsTraits repo](https://github.com/hdr-bgnn/minnowTraits) and [Morphology-analysis repo](https://github.com/hdr-bgnn/Morphology-analysis)
      - **Presence** : presence/absence table
      Optional: 
         - **Measure** : specific measurement the fish (e.i. head depth, head width, snout to eye distance....)
         - **Landmark** : table with specific landmark positions used to determinate the measurement 
         - **Vis_Landmark** : image of segmented fish with landmark

# 2- Setup and Requirements

   - To start with OSC system check instructions in Setup_Snakemake_OSC.txt. (not up to date, for question post issues)
   - _Todo copy paste the contain of Setup_Snakemake_OSC.txt here and format it nicely... Probably a lot of typo to fix_


# 3- Usage and test
   
   ```
   snakemake --jobs $NUMJOBS --profile slurm/ --use-singularity --directory $WORKDIR --config list=$REAL_INPUTCSV
   ```

# 4- Codes and Containers location

All containers are created using GitHub action, available as pachkage in their respective repository


* [Metadata_generator](https://github.com/hdr-bgnn/drexel_metadata) :

* [Drexel_reformatter](https://github.com/hdr-bgnn/drexel_metadata_formatter) :

* [Crop_image](https://github.com/hdr-bgnn/Crop_image) :

* [Segment_trait](https://github.com/hdr-bgnn/BGNN-trait-segmentation):  

* [Morphology](https://github.com/hdr-bgnn/Morphology-analysis) :

# 6- Quick start with OSC

## 1- Using interactive (command sinteractive)

   This is the best way to start.  
   Requirement: have an acount at OSC. If you need one, contact Hilmar Lapp (Hilmar.Lapp@duke.edu) or Steve Chang (chang.136@osu.edu).
   
   1-  Log onto a login node... Be gentle with them, they don't like to work too hard!
   
   ```ssh <username>@pitzer.osc.edu```
  
   2- Clone the repository, do it only the first time.
   
   ```git clone git@github.com:hdr-bgnn/BGNN_Snakemake.git ```
   
   3- Only the first.
   
   ```module load miniconda3``` 
   
   4- Create an environment named snakemake  with module snakemake
   
   ```conda create -n snakemake -c bioconda -c conda-forge snakemake -y```
   
   5- Activate the environment, so now you have access to the package snakemake
   
   ```source activate snakemake``` 
   
   6- you should see environment named "snakmake" if not check [here](https://www.osc.edu/resources/getting_started/howto/howto_add_python_packages_using_the_conda_package_manager) for more info
   
   ```conda info -e```
   
   9- Request an interactive session on a computing node. Replace <PROJECT_NAME> by the appropriete value.
   
   ```sinteractive  -N 1 -n 4  -t 00:10:00  -A <PROJECT_NAME> -J test -p debug squeue -u $USER``` 
   
   10- Again! yes since you are on different node (computing node that you have requested)
   
   ```module load miniconda3``` 
   
   11- # Again! Same as before
   
   ```source activate snakemake``` 

   12- Test snakeme. The first time, it may take sometime to download the container. In this simple version, snakemake will call Snakefile, all the results will be dump in the directory where you are (containing Snakefile)
   
   ```snakemake --jobs $NUMJOBS --profile slurm/ --use-singularity --directory $WORKDIR --config list=$REAL_INPUTCSV ``` 
   
   13- To exit the computing node
   
   ```exit```
   
   14- To check the result. You shloud see folders Images/ Metadata/ Cropped/ Segmented/... populated with multiple fish_file on some sort.
   
    ```ls ~/BGNN_Snakemake```

## 2- sbatch and slurm (work in progress)
   
   To submit a job to OSC I use the script [SLURM_Snake](SLURM_Snake), it will call the Snakefile from the same directory.
   
   Usage, connect to the login node
   
   ```ssh <username>@pitzer```
   
   Clone this BGNN_Snakemake repo (if necessary) and cd into the repo.
   ```
   git clone git@github.com:hdr-bgnn/BGNN_Snakemake.git
   cd BGNN_Snakemake
   ```
   
   The SLURM_snake script requires a `snakemake` conda environment. 
   If you have followed the __Using interactive__ instructions this environment will already exist.
   If not, run the following to load miniconda, create the environment, and unload miniconda.
   ```
   module load miniconda3/4.10.3-py37
   conda create -n snakemake -c bioconda -c conda-forge snakemake -y
   module purge
   ```
   
   The SLURM_snake script has the following positional arguments:
   - a data directory to hold all data for a single run - **required**
   - a CSV file that contains details about the image files to process - **required**
   - the number of jobs for Snakemake to run at once - **optional defaults to 4**   
 
   The `SLURM_Snake` script should be run with arguments like so:
   ```
   sbatch SLURM_Snake <data_directory> <path_to_csv> [number_of_jobs]
   ```
   For example if you want to store the data files at the relative path of `data/list_test` and processs `List/list_test.csv` run the following:
   
   ```
   sbatch SLURM_Snake data/list_test List/list_test.csv
   ```

   To run the example with up to 8 parallel jobs run the command like so:
   ```
   sbatch SLURM_Snake data/list_test List/list_test.csv 8
   ```
   
   To check the process
   
   ```squeue -u $USER```
   
   That's it!
   
   *Comment*: this script will create a slurm-job_ID.out log file.
   
   The `data_directory` will contain the following directory structure (plus some log and cache file):
   ```
   Images/
   Cropped/
   Metadata/
   Mask/
   Segmented/
   Morphology/Measure, Morphology/Presence\, Morphology/Landmark, Morphology/Vis_landmark
   ```
   
   ---
   
   The `SLURM_Snake` script configures Snakemake to submit separate sbatch jobs for each step run.
   Details about individual steps can be seen by running the `sacct` command.
   
   For example:
   ```
   sacct --format JobID,JobName%40,State,Elapsed,ReqMem,MaxRSS
   ```
   Keep in mind that `sacct` defaults to showing jobs from the current day. See [sacct docs](https://slurm.schedmd.com/sacct.html#SECTION_DEFAULT-TIME-WINDOW) for options to specify a different time range.

## 3- Rerun only one part of the pipeline (work in progress)


## Running using docker
The pipeline can be run using [docker](https://docs.docker.com/get-docker/) to provide the required snakemake and singularity environment.
After installing docker clone this repo and cd into the BGNN_Snakemake directory.
To process the images in `List/list_test.csv` using the pipeline run (on macOS or Linux):
```
docker run --privileged -it -v $(pwd):/src -w /src snakemake/snakemake:v7.12.1 \
    snakemake -c4 --use-singularity --config list=List/list_test.csv

```
For Windows use PowerShell replacing `$(pwd)` with `${PWD}` in the command above.
