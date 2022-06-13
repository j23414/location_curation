#! /usr/bin/env bash

set -v

# === Variables to change each time
export NEW_RUN=mergeloc_Jun13
export INDIR=~/Desktop/Ingest_Locations/Downloads/2022-06-13

# # Setup Repos
# #[[ -d Ingest_Locations ]] || mkdir Ingest_Locations
# #cd Ingest_Locations
# #git clone https://github.com/j23414/merge_loc.git  # For manual annotation, but remove later
# 
# git clone https://github.com/nextstrain/ncov-ingest.git
# git clone https://github.com/nextstrain/ncov.git
# cd ncov-ingest
# git branch ${NEW_RUN}      # For gisaid/genbank_annotations.txt
# git checkout ${NEW_RUN}
# git push origin ${NEW_RUN}
# cd ../ncov
# git branch ${NEW_RUN}       # For defaults/colors lat_long.txt
# git checkout ${NEW_RUN}
# git push origin ${NEW_RUN}

# Pull existing s3 datasets
cd ncov # 
nextstrain remote download s3://nextstrain-ncov-private/metadata.tsv.gz /dev/stdout | gunzip > data/downloaded_gisaid.tsv
nextstrain remote download s3://nextstrain-data/files/ncov/open/metadata.tsv.gz /dev/stdout | gunzip > data/metadata_genbank.tsv

# Pull data from slack
mkdir -p scripts/curate_metadata/inputs_new_sequences
cp ${INDIR}/* scripts/curate_metadata/inputs_new_sequences/.

# This seems to take several minutes, add a timing command
time python scripts/curate_metadata/parse_additional_info.py --auto 