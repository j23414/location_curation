# Processing new locations

```
NEW_RUN=mergeloc_Apr25
IN_DIR=~/Desktop/Ingest_Locations/Downloads/2022-04-25

# Setup Repos
[[ -d Ingest_Locations ]] || mkdir Ingest_Locations
cd Ingest_Locations

git clone https://github.com/j23414/merge_loc.git  # For manual annotation, but remove later

git clone https://github.com/nextstrain/ncov-ingest.git
git clone https://github.com/nextstrain/ncov.git
cd ncov-ingest
git branch ${NEW_RUN}      # For gisaid/genbank_annotations.txt
git checkout ${NEW_RUN}
git push origin ${NEW_RUN}
cd ../ncov
git branch ${NEW_RUN}       # For defaults/colors lat_long.txt
git checkout ${NEW_RUN}
git push origin ${NEW_RUN}

# Pull existing s3 datasets
nextstrain remote download s3://nextstrain-ncov-private/metadata.tsv.gz /dev/stdout | gunzip > data/downloaded_gisaid.tsv
nextstrain remote download s3://nextstrain-data/files/ncov/open/metadata.tsv.gz /dev/stdout | gunzip > data/metadata_genbank.tsv

# Pull data from slack
mkdir -p scripts/curate_metadata/inputs_new_sequences
cp ${INDIR}/* scripts/curate_metadata/inputs_new_sequences/.
```

## For new locations, download from slack:

From the `#ncov-gisaid-updates` slack channel, download:

* `additional-info-changes.txt`
* (download all or in batches of 10) or rename 10> with a 9 prefix

Place the above files in `ncov/scripts/curate_metadata/inputs_new_sequences`.

Tag with Greenbox emoji to indicate it's been downloaded. Will replace with Greencheckmark emoji to indicate it's been merged.

* [ ] TODO: Would be great if this was a remote pull, instead of a manual process...

## Run parse additional info

From the `ncov` folder, run:

```
# This seems to take several minutes, add a timing command
time python scripts/curate_metadata/parse_additional_info.py --auto 

ls -l scripts/curate_metadata/outputs_new_sequences  # View output files
#> total 1.3M
#> -rw-r--r-- 1 jenchang staff 995K Apr 11 11:57 additional_info_annotations.tsv # added to top of files
#> -rw-r--r-- 1 jenchang staff 318K Apr 11 11:55 omicron_additional_info.txt # don't worry
```

Add to top of gisaid_annotations

```
cat scripts/curate_metadata/outputs_new_sequences/additional_info_annotations.tsv > temp.txt
echo "" >> temp.txt
cat ../ncov-ingest/source-data/gisaid_annotations.tsv >> temp.txt
# Remove empty lines
cat temp.txt | grep -v "^$" > a.txt
mv a.txt ../ncov-ingest/source-data/gisaid_annotations.tsv
```

## Run curate metadata

```
cp ../merge_loc/manualAnnotationRules.txt scripts/curate_metadata/config_curate_metadata/manualAnnotationRules.txt
cp ../merge_loc/geoLocationRules.txt scripts/curate_metadata/config_curate_metadata/geoLocationRules.txt
python scripts/curate_metadata/curate_metadata.py 
```

In top, at division region, may need to add manual annotation rules. Quit and rerun after editing file.

```
# Fix Delimiters errors (Austrian case)
vscode scripts/curate_metadata/config_curate_metadata/manualAnnotationRules.txt
```

For example:

```
Europe,Austria,Upper Austria / Voecklabruck / Voecklamarkt,             Europe,Austria,Upper Austria,Voecklamarkt
Europe,Austria,Upper Austria / Voecklabruck / Frankenburg Am Hausruck,  Europe,Austria,Upper Austria,Frankenburg Am Hausruck
```

Notice the middle delimiter ",\t"

```
# Fix other geolocation errors (change spelling, or resolution, or duplicates, missing county, Porto Rico needs to change to USA)
# Save to check.txt (double check later)


grep -i "Unknown location name" defaults/color_ordering.tsv 
less defaults/color_ordering.tsv  # Search for country, might be different spelling

# search country, division (a instead of n/y)
emacs scripts/curate_metadata/config_curate_metadata/geoLocationRules.txt
```

Example

```
Current place for missing division:	Kosice - Okolie, Slovakia
Geopy suggestion: District of Košice - okolie, Region of Košice, Slovakia
Is this the right place (a - alter division level) [y/n/a]? a
Type correct division to produce corrective rule: Kosice
Europe/Slovakia/Kosice - Okolie/	Europe/Slovakia/Kosice/Kosice - Okolie
```

Copy last line to `geoLocationRules.txt`.

Then skip all check, and rerun to apply new rules:

```
python scripts/curate_metadata/curate_metadata.py 
```

After it's done:

```
ls -ltr scripts/curate_metadata/output_curate_metadata/
#> total 32M
#> -rw-r--r-- 1 jenchang staff 625K Apr 11 13:24 lat_longs.tsv
#> -rw-r--r-- 1 jenchang staff 562K Apr 11 13:24 color_ordering.tsv
#> -rw-r--r-- 1 jenchang staff  30M Apr 11 13:27 gisaid_annotations.tsv
#> -rw-r--r-- 1 jenchang staff 202K Apr 11 13:27 genbank_annotations.tsv
```

```
cp scripts/curate_metadata/output_curate_metadata/lat_longs.tsv defaults/.
cp scripts/curate_metadata/output_curate_metadata/color_ordering.tsv defaults/.
cp scripts/curate_metadata/output_curate_metadata/gisaid_annotations.tsv ../ncov-ingest/source-data/.
cp scripts/curate_metadata/output_curate_metadata/genbank_annotations.tsv ../ncov-ingest/source-data/.
```

## geoLocationRules

Add to rules to bottom of the files.

```
echo "" >> ../ncov-ingest/source-data/gisaid_geoLocationRules.tsv 
cat scripts/curate_metadata/config_curate_metadata/geoLocationRules.txt >> ../ncov-ingest/source-data/gisaid_geoLocationRules.tsv

# Remove empty lines
cat ../ncov-ingest/source-data/gisaid_geoLocationRules.tsv | grep -v "^$" > one.txt
mv one.txt ../ncov-ingest/source-data/gisaid_geoLocationRules.tsv
```

> If you ever add rules to the `source-data/gisaid_geoLocationRules.tsv` file, new rules always have to be added to the bottom of the file. Then you can run the following to apply new changes and resolve conflicts

```
cd ../ncov-ingest
bin/check-gisaid-geoRules --geo-location-rules source-data/gisaid_geoLocationRules.tsv --output-file gisaid_geoLocationRules.tsv
```

```
bin/check-gisaid-geoRules \
  --geo-location-rules source-data/gisaid_geoLocationRules.tsv \
 --output-file gisaid_geoLocationRules.tsv

Traceback (most recent call last):
  File "/Users/jenchang/Desktop/2022-02-17/ncov-ingest/bin/check-gisaid-geoRules", line 7, in <module>
    from utils.transform import (
ModuleNotFoundError: No module named 'utils.transform'
```

### Only on MY computer

Since I tried to install `pango` whose `utils` is masking the local one. Create a temporary workaround till I can fix my environment.

```
cd ncov-ingest
cp -r lib/utils lib/utils2
cat bin/check-gisaid-geoRules |\
  sed 's/utils./utils2./g' > \
  bin/jc_check-gisaid-geoRules
  
cat lib/utils2/transformpipeline/transforms.py |\
  sed 's/utils./utils2./g' > \
  temp.txt
mv temp.txt lib/utils2/transformpipeline/transforms.py
```

Then run:

```
python3 bin/jc_check-gisaid-geoRules \
  --geo-location-rules source-data/gisaid_geoLocationRules.tsv \
 --output-file gisaid_geoLocationRules.tsv
 
mv gisaid_geoLocationRules.tsv source-data

git status
#>	modified:   source-data/genbank_annotations.tsv
#>	modified:   source-data/gisaid_annotations.tsv
```

rerun curate

```
python scripts/curate_metadata/curate_metadata.py 
```

* Check duplicates
* Check rules

Examples:

```
Iowa found as both division and location within division Wisconsin.

More straightforward:
Jhalokati found as both division and location within division Khulna.
Asia/Bangladesh/Jhalokati/	Asia/Bangladesh/Khulna/Jhalokati
# add to geolocational rules
```

Go back to "curate" rerun to check rules again.

## Commit

```
cd ncov-ingest
git commit -m "add: annotation updates up to 2022 Apr 18" source-data/*
git status # double check
git push --set-upstream origin ${NEW_RUN}
git push origin ${NEW_RUN}
cd ../ncov
git commit -m "add: annotation updates up to 2022 Apr 18" defaults/*
git push --set-upstream origin ${NEW_RUN}
git status # double check
git push origin ${NEW_RUN}
```

## PR


```
add: annotation updates from 2022-04-11 to 2022-04-18

### Description of proposed changes:
Update annotations up to April 18th. Let me know if I missed anything.


### Related Issue(s):
Related to https://github.com/nextstrain/ncov/pull/923
```

