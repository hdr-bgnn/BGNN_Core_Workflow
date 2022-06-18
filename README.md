# BGNN_Snakemake
First complete version of the BGNN image segmentation workflow managed using snakemake.

# 1- Introduction

The image segmentation workflow is managed using snakemake, a user-friendly python workflow manager. Snakemake uses a syntax based on python and can use python code in the definition of the workflow. 

The segmentation workflow consists of the following steps each defined by a "rule". 
The output of each rule is store to specific folder:
   1. Download the fish **Images** from Tulane server using a simple bash script: Folder: Images/
   2. Extract **Metadata** information using Detectron2 (deep learning segmentation). The 2 important parameters used, are the bounding box(bbox) around the fish and scale (pixel/cm from the ruler). The code developed by Drexel and the script used can be found [here](https://github.com/hdr-bgnn/drexel_metadata/blob/Thibault/gen_metadata_mini/scripts/gen_metadata.py). Folder: Metadata/
   3.	Create **Cropped** images of the fish using the bounding box from Metadata (we had 10% increase in size from the original bbox to prevent truncation of the file). The code is under the [Scripts](https://github.com/hdr-bgnn/BGNN_Snakemake/blob/main/Scripts/Crop_image). Folder Crop/ 
   4. **Segment** traits using code developed by Maruf and reorganize by Thibault [here](https://github.com/hdr-bgnn/BGNN-trait-segmentation/blob/segment_mini). Folder Segment/
   5. First version to	Extraction of **morphology** traits, including linear measurements, areas, ratios, and landmarks. This part is done in collaboration between Battelle (Meghan, Paula and I) and Yasin. The code is under the [Scripts](https://github.com/hdr-bgnn/BGNN_Snakemake/blob/main/Scripts/Morphology). Folder Morphology/ 

These 4 steps are represented in the following workflow diagram

![Workflow overview 1](https://github.com/hdr-bgnn/BGNN_Snakemake/blob/main/Workflw_stage_1.png)

![Workflow overview 2](https://github.com/hdr-bgnn/BGNN_Snakemake/blob/main/Workflw_stage_2.png)

## Workflow components

1. Snakemake package: installed and managed by conda or mamba, which is similar to conda but optimized for snakemake. To access snakemake, use the bioconda channel or mamba conda channel.

2. Snakefile

3. Scripts for
   - Generating metadata (in particular bounding box, bbox)
   - cropping the fish using bbox and generating cropped image
   - traits segmentation
   - morphology
 
I believe the scripts should live on their respective repository. This part is still a bit comfusing... Need to work on that.
Yes I agree we are try to do it. WIP
 
4. Containers
   - these are available at https://cloud.sylabs.io/library/thibaulttabarin
   - The rest is in the release on their respective gihub repo

5. Data
   - Images/ : store the ouput from the Download step. Images downloaded from Tulane server
   - Metadata/ : store the output from generate_metadata.py code developed by Drexel team. One file ".json" per image
   - Cropped/ : store the ouput from Crop image. 
   - Segmented/ : store the ouput from Segment trait using code developed by M. Maruf (Virginia Tech)
   - Morphology/ : in development, current version (1) has been develop by Thibault Tabarin (Battelle)

# 2- Setup and Requirements

   - To start with OSC system check instructions in Setup_Snakemake_OSC.txt.
   - Todo opy paste the contain of Setup_Snakemake_OSC.txt here and format it nicely... Probably a lot of typo to fix

# 3- Download models

   Not sure if this is relevant here... Keep it for the moment. This should go with the documentation for indivdual code on ecah correponding repository
   *Models for segment trait* : located at https://drive.google.com/uc?id=1HBSGXbWw5Vorj82buF-gCi6S2DpF4mFL
   Follow instruction in BGNN_Snakemake/Containers/Singularity_def_segment_trait/Scripts/saved_models/load.txt
   or
   
   ```
   cd ~/BGNN_Snakemake/Containers/Singularity_def_segment_trait/Scripts
   gdown -O saved_models/ https://drive.google.com/uc?id=1HBSGXbWw5Vorj82buF-gCi6S2DpF4mFL
   ```
   
   *Models for generate metadata* : https://drive.google.com/file/d/1QWzmHdF1L_3hbjM85nOjfdHsm-iqQptG
   

# 4- Usage
   
   For explanation check instruction in Instruction_Snakemake.txt
   
   ```
   snakemake --cores 1 --use-singularity --config list=List/list_lepomis_INHS.csv
   ```

# 5- Codes and Containers location

The containers related to this project are located at https://cloud.sylabs.io/library/thibaulttabarin
Some of the containers are created using github action, some other are created using singularity remote builder. We are currently transitioning all the containers to github action.

there are 3 containers of interest:


* [Metadata_generator](https://github.com/hdr-bgnn/drexel_metadata/blob/Thibault/gen_metadata_mini/scripts/gen_metadata.py) :
   ```
   singularity pull --arch amd64 library://thibaulttabarin/bgnn/metadata_generator:v2
   Usage : gen_metadata.py {image.jpg} {metadata.json} {mask.jpg}
   ```
* [Crop_image](https://github.com/hdr-bgnn/BGNN_Snakemake/blob/main/Scripts/Crop_image) :
    ```
    docker://ghcr.io/hdr-bgnn/bgnn_snakemake/crop_morph:0.0.16
    Usage : Crop_image_main.py {image.jpg} {metadata.json} {Cropped.jpg}
    ```
* [segment_trait](https://github.com/hdr-bgnn/BGNN-trait-segmentation/blob/segment_mini):  
   ```
   docker://ghcr.io/hdr-bgnn/bgnn-trait-segmentation:0.0.4
   Usage : segmentation_main.py {Cropped.png} {Segmented.png}
   ```
* [Morphology](https://github.com/hdr-bgnn/BGNN_Snakemake/blob/main/Scripts/Morphology) :
    ```
    docker://ghcr.io/hdr-bgnn/bgnn_snakemake/crop_morph:0.0.16
    Usage : Crop_image_main.py {image.jpg} {metadata.json} {Cropped.jpg}
    ```
# 6- Quick start with OSC

## 1- Using interactive (command sinteractive)

   This is the best way to start.  
   Requirement: have an acount at OSC. If you need one, contact Hilmar Lapp (Hilmar.Lapp@duke.edu) or Steve Chang (chang.136@osu.edu).
   
   1- ssh <username>@pitzer.osc.edu # you are now on login node... Be gentle with them, they don't like to work too hard!
   
   2- git clone git@github.com:hdr-bgnn/BGNN_Snakemake.git # only the first time.
   
   3- module load miniconda3 # only the first.
   
   4- conda create -n snakemake -c bioconda -c conda-forge snakemake -y # Create an environment named snakemake 
   
   5- source activate snakemake # Activate the environment, so now you have access to the package snakemake
   
   6- conda info -e # you should see environment named "snakmake" if not check [here](https://www.osc.edu/resources/getting_started/howto/howto_add_python_packages_using_the_conda_package_manager) for more info
   
   9- sinteractive  -N 1 -n 4  -t 00:10:00  -A <PROJECT_NAME> -J test -p debug squeue -u $USER # your now on a computing node.
   
   10- module load miniconda3 # Again! yes it is a different node (understand different machine).
   
   11- source activate snakemake # Again! Same as before

   12- snakemake --cores 4 --use-singularity --config list=List/list_lepomis_INHS.csv # the first time, it may take sometime to download the container and some models.
   
   13- exit # exit the computing node
   
   14- ls ~/BGNN_Snakemake # you shloud see folders Images/ Metadata/ Cropped/ Segmented/ populated with multiple fish_file on some sort.

## 2- sbatch and slurm (work in progress)
   
   To submit a job to OSC I use the script [SLURM_Snake](SLURM_Snake).
   
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
   
   The `data_directory` will contain the following directory structure:
   ```
   Images/
   Cropped/
   Metadata/
   Segmented/
   Morphology/
   ```
   
   ---
   
   The `SLURM_Snake` script configures Snakemake to submit separate sbatch jobs for each step run.
   Details about individual steps can be seen by running the `sacct` command.
   
   For example:
   ```
   sacct --format JobID,JobName%40,State,Elapsed,ReqMem,MaxRSS
   ```
   Keep in mind that `sacct` defaults to showing jobs from the current day. See [sacct docs](https://slurm.schedmd.com/sacct.html#SECTION_DEFAULT-TIME-WINDOW) for options to specify a different time range.

