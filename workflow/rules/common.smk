import pandas as pd
import glob
import os
from functools import cache


@cache
def get_name_to_url():
    LIST = config['list']

    print(f"Building name to url dictionary from {LIST}")

    # Read images CSV file into a dataframe
    df = pd.read_csv(LIST)
    # Create 'name' column by removing the filename extension from 'original_file_name'
    df['name'] = df['original_file_name'].apply(lambda x : os.path.splitext(x)[0])
    # Create Series to lookup a URL for an image 'name'
    df = df.set_index('name')
    return df['path']


def get_morphology_files(wildcards):
    name_to_url = get_name_to_url()
    NAMES = list(name_to_url.index)
    return expand("Morphology/Measure/{image}_measure.json", image=NAMES)
