#! /usr/bin/env bash
set -euv

# === Variables to change each time
export DATE=2022-09-13
export NEW_BRANCH="location_curation/${DATE}"
export INDIR=~/Desktop/Ingest_Locations/Downloads/${DATE}
export LOC_CUR=~/Desktop/Ingest_Locations/location_curation
export NEW_DIR="Run_${DATE}"

# === Setup Repos
[[ -d location_curation ]] || git clone https://github.com/j23414/location_curation.git 

mkdir -p ${NEW_DIR}
cd ${NEW_DIR}
git clone https://github.com/nextstrain/ncov-ingest.git
git clone https://github.com/nextstrain/ncov.git
cd ncov-ingest
git branch ${NEW_BRANCH}       # For gisaid/genbank_annotations.txt
git checkout ${NEW_BRANCH}
cd ../ncov
git branch ${NEW_BRANCH}       # For defaults/colors lat_long.txt
git checkout ${NEW_BRANCH}

# Pull existing s3 datasets
set +eu
nextstrain remote download s3://nextstrain-ncov-private/metadata.tsv.gz /dev/stdout | gunzip > data/downloaded_gisaid.tsv
nextstrain remote download s3://nextstrain-data/files/ncov/open/metadata.tsv.gz /dev/stdout | gunzip > data/metadata_genbank.tsv
set -eu

# Pull data from slack
mkdir -p scripts/curate_metadata/inputs_new_sequences
cp ${INDIR}/* scripts/curate_metadata/inputs_new_sequences/.

# This seems to take several minutes, add a timing command
date
time python scripts/curate_metadata/parse_additional_info.py --auto 
ls -ltrh scripts/curate_metadata/outputs_new_sequences
date

cat scripts/curate_metadata/outputs_new_sequences/additional_info_annotations.tsv > temp.txt
echo "" >> temp.txt
cat ../ncov-ingest/source-data/gisaid_annotations.tsv >> temp.txt
# Remove empty lines
cat temp.txt | grep -v "^$" > a.txt
mv a.txt ../ncov-ingest/source-data/gisaid_annotations.tsv

cp ${LOC_CUR}/manualAnnotationRules.txt scripts/curate_metadata/config_curate_metadata/manualAnnotationRules.txt
#cp ${LOC_CUR}/geoLocationRules.txt scripts/curate_metadata/config_curate_metadata/geoLocationRules.txt
# This takes several minutes, might be due to size of metadata
date
python scripts/curate_metadata/curate_metadata.py
