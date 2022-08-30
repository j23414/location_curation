# Location Curation

1. Set environmental variables
  https://github.com/j23414/location_curation/blob/7ef5e25bc148cf6b55f35e2ebfb89aa9d98c55b5/runner.sh#L5-L9

2. Pull repos and create new branches
  https://github.com/j23414/location_curation/blob/7ef5e25bc148cf6b55f35e2ebfb89aa9d98c55b5/runner.sh#L12-L23

3.  Pull existing s3 datasets
  https://github.com/j23414/location_curation/blob/7ef5e25bc148cf6b55f35e2ebfb89aa9d98c55b5/runner.sh#L27-L28
  
4. Link pulled "additional_info.txt" files from slack channel
  https://github.com/j23414/location_curation/blob/7ef5e25bc148cf6b55f35e2ebfb89aa9d98c55b5/runner.sh#L32-L33

  For new locations, download from slack:

  From the `#ncov-gisaid-updates` slack channel, download:

  * `additional-info-changes.txt`
  * (download all or in batches of 10) or rename 10> with a 9 prefix

  Place the above files in `ncov/scripts/curate_metadata/inputs_new_sequences`.

  Tag with Greenbox emoji to indicate it's been downloaded. Will replace with Greencheckmark emoji to indicate it's been merged.

  * [ ] TODO: Remote pull, instead of a manual process...

5. Run parse additional info from the `ncov` folder
  https://github.com/j23414/location_curation/blob/7ef5e25bc148cf6b55f35e2ebfb89aa9d98c55b5/runner.sh#L37-L38
  
  ```
  #> real	23m20.843s
  #> user	4m2.279s
  #> sys	8m42.588s
  
  #> total 408K
  #> -rw-r--r-- 1 jenchang staff 9.8K Jun 13 10:46 omicron_additional_info.txt
  #> -rw-r--r-- 1 jenchang staff 394K Jun 13 10:48 additional_info_annotations.tsv
  ```

6. Add to top of gisaid_annotations
  https://github.com/j23414/location_curation/blob/7ef5e25bc148cf6b55f35e2ebfb89aa9d98c55b5/runner.sh#L41-L46

7. Run curate metadata

  https://github.com/j23414/location_curation/blob/7ef5e25bc148cf6b55f35e2ebfb89aa9d98c55b5/runner.sh#L48-L52

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
#> total 35M
#> -rw-r--r-- 1 jenchang staff 626K Jun  6 10:03 lat_longs.tsv
#> -rw-r--r-- 1 jenchang staff 592K Jun  6 10:03 color_ordering.tsv
#> -rw-r--r-- 1 jenchang staff  33M Jun  6 10:06 gisaid_annotations.tsv
#> -rw-r--r-- 1 jenchang staff 202K Jun  6 10:06 genbank_annotations.tsv

total 35M
-rw-r--r-- 1 jenchang staff 627K Jun 15 10:04 lat_longs.tsv
-rw-r--r-- 1 jenchang staff 593K Jun 15 10:04 color_ordering.tsv
-rw-r--r-- 1 jenchang staff  33M Jun 15 10:10 gisaid_annotations.tsv
-rw-r--r-- 1 jenchang staff 202K Jun 15 10:10 genbank_annotations.tsv
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
cd ../ncov-ingest
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
DAY='2022-08-29'
cd ncov-ingest
git commit -m "add: annotation updates up to ${DAY}" source-data/*
git push origin ${NEW_RUN}
cd ../ncov
git commit -m "add: annotation updates up to ${DAY}" defaults/*
# git push --set-upstream origin ${NEW_RUN}
git push origin ${NEW_RUN}
```

## PR

```
add: annotation updates up to 2022-06-27

### Description of proposed changes:

Update annotations up to June 27th. Let me know if I missed anything.

### Related Issue(s):

Related to https://github.com/nextstrain/ncov/pull/966
```
