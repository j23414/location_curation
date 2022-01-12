# Processing new locations

## For new locations, download from slack:

From the `#ncov-gisaid-updates` slack channel, download:

* `additional-info-changes.txt` -> parse
* `flagged-annotations.txt` (actually rest of these might not be called by either parse or curate)
* `flagged-metadata-additions.txt`
* `location-hierarchy-additions.tsv.txt` 

Place the above files in `ncov/scripts/curate_metadata/inputs_new_sequences`.

## Pull s3 datasets

From within `ncov`. 

```
nextstrain remote download s3://nextstrain-ncov-private/metadata.tsv.gz /dev/stdout | gunzip > data/downloaded_gisaid.tsv
nextstrain remote download s3://nextstrain-data/files/ncov/open/metadata.tsv.gz /dev/stdout | gunzip > data/metadata_genbank.tsv
```

Which sometimes gives me `gunzip: (stdin): trailing garbage ignored` messages.

> Maybe pull all files from a nextstrain remote download s3:XXXXXX` command?
> 
> Right now it's a tmp file: 
> 
> * https://github.com/nextstrain/ncov-ingest/blob/04ca33cbed1f96320035b9f7ebcc6abf4fa25a72/bin/notify-on-additional-info-change#L29
> * https://github.com/nextstrain/ncov-ingest/blob/ac98385fd086dfb977b8ffe77ae7f000f6f398be/Snakefile#L386

## Run parse additional info

From the `ncov` folder, run:

```
python scripts/curate_metadata/parse_additional_info.py --auto
```

Output will be in `ncov/scripts/curate_metadata/outputs_new_sequences`

* `additional_info_annotation.tsv` # <= where to put this

```
-rw-r--r--  1 jenchang  staff    59K Jan 12 12:18 omicron_additional_info.txt
-rw-r--r--  1 jenchang  staff    51K Jan 12 12:18 additional_info_annotations.tsv
```

## Run curate metadata

```
python scripts/curate_metadata/curate_metadata.py
```

Outputs

<details><summary>Full output</summary>

```

===============================================

Reading GISAID metadata...
Reading GenBank metadata...

===============================================

Checking exposure consistency...

===============================================

Applying new geoLocationRules...

Applying manualAnnotationRules...

(Applying adjustments to international cruiseships...)

===============================================

Checking for division inconsistencies...
Botswana found as both division and location within division Africa.
Africa/Botswana/Botswana/	Africa/Botswana/Africa/Botswana


===============================================

Checking for location duplicates...
Abbreviation missing for Canary Islands. Please add to abbreviations.txt
Abbreviation missing for US state American Samoa. Please add to abbreviations.txt
Potential duplicate inconsistent with current rules: Bogota D.C.

Asia/Bangladesh/Dhaka/Gopalganj	Asia/Bangladesh/Dhaka/Gopalganj BD
Asia/India/Bihar/Gopalganj	Asia/India/Bihar/Gopalganj IN
Asia/India/Tamil Nadu/Vellore	Asia/India/Tamil Nadu/Vellore (Tamil Nadu)
Asia/India/Telangana/Vellore	Asia/India/Telangana/Vellore (Telangana)
Europe/Poland/Slaskie/Pisarzowice	Europe/Poland/Slaskie/Pisarzowice (Slaskie)
Europe/Poland/Dolnośląskie/Pisarzowice	Europe/Poland/Dolnośląskie/Pisarzowice (Dolnośląskie)
Europe/Poland/Pomorskie/Zielin	Europe/Poland/Pomorskie/Zielin (Pomorskie)
Europe/Poland/Zachodniopomorskie/Zielin	Europe/Poland/Zachodniopomorskie/Zielin (Zachodniopomorskie)
Europe/Poland/Pomorskie/Kamien	Europe/Poland/Pomorskie/Kamien (Pomorskie)
Europe/Poland/Mazowieckie/Kamien	Europe/Poland/Mazowieckie/Kamien (Mazowieckie)
Europe/Poland/Dolnośląskie/Olesnica	Europe/Poland/Dolnośląskie/Olesnica (Dolnośląskie)
Europe/Poland/Malopolskie/Olesnica	Europe/Poland/Malopolskie/Olesnica (Malopolskie)
Europe/Poland/Kujawsko-Pomorskie/Mogilno	Europe/Poland/Kujawsko-Pomorskie/Mogilno (Kujawsko-Pomorskie)
Europe/Poland/Łódzkie/Mogilno	Europe/Poland/Łódzkie/Mogilno (Łódzkie)
Europe/Poland/Malopolskie/Lazany	Europe/Poland/Malopolskie/Lazany PL
Europe/Slovakia/Prešov/Lazany	Europe/Slovakia/Prešov/Lazany SK
Europe/Poland/Lubuskie/Lagow	Europe/Poland/Lubuskie/Lagow (Lubuskie)
Europe/Poland/Mazowieckie/Lagow	Europe/Poland/Mazowieckie/Lagow (Mazowieckie)
Europe/Poland/Mazowieckie/Ilza	Europe/Poland/Mazowieckie/Ilza (Mazowieckie)
Europe/Poland/Swietokrzyskie/Ilza	Europe/Poland/Swietokrzyskie/Ilza (Swietokrzyskie)
North America/USA/North Carolina/Macon	North America/USA/North Carolina/Macon NC
Europe/France/Grand Est/Ardennes	Europe/France/Grand Est/Ardennes FR
Europe/Spain/Aragon/Fraga	Europe/Spain/Aragon/Fraga ES
South America/Chile/Coquimbo/Salamanca CL	South America/Chile/Coquimbo/Salamanca (Coquimbo)
South America/Chile/Valparaiso/Salamanca	South America/Chile/Valparaiso/Salamanca (Valparaiso)
North America/USA/Idaho/Washington County	North America/USA/Idaho/Washington County ID
North America/USA/Missouri/Jackson County	North America/USA/Missouri/Jackson County MO
North America/USA/Iowa/Howard County	North America/USA/Iowa/Howard County IA
North America/USA/Arizona/Graham County	North America/USA/Arizona/Graham County AZ
North America/USA/Arizona/Wayne	North America/USA/Arizona/Wayne AZ
North America/USA/Mississippi/Wayne	North America/USA/Mississippi/Wayne MS
North America/USA/Texas/Moore County	North America/USA/Texas/Moore County TX
North America/USA/Maryland/Montgomery	North America/USA/Maryland/Montgomery MD
North America/USA/Tennessee/Montgomery	North America/USA/Tennessee/Montgomery TN
North America/USA/Louisiana/Ouachita Parish	North America/USA/Louisiana/Ouachita Parish LA
North America/USA/New York/Erie County	North America/USA/New York/Erie County NY
North America/USA/Ohio/Stark County	North America/USA/Ohio/Stark County OH
North America/USA/Illinois/Stark County	North America/USA/Illinois/Stark County IL
North America/USA/North Carolina/Burke County	North America/USA/North Carolina/Burke County NC
North America/USA/North Carolina/Chatham County	North America/USA/North Carolina/Chatham County NC
North America/USA/North Carolina/Rockingham County	North America/USA/North Carolina/Rockingham County NC
North America/USA/North Carolina/Henderson	North America/USA/North Carolina/Henderson NC
North America/USA/Illinois/Henderson	North America/USA/Illinois/Henderson IL
North America/USA/Wisconsin/Dane County	North America/USA/Wisconsin/Dane County WI
South America/Colombia/Antioquia/Santa Barbara	South America/Colombia/Antioquia/Santa Barbara CO
South America/Brazil/São Paulo/Andradina	South America/Brazil/São Paulo/Andradina (São Paulo)
South America/Brazil/Mato Grosso do Sul/Andradina	South America/Brazil/Mato Grosso do Sul/Andradina (Mato Grosso do Sul)
South America/Brazil/Distrito Federal/Taguatinga	South America/Brazil/Distrito Federal/Taguatinga (Distrito Federal)
South America/Brazil/Tocantins/Taguatinga	South America/Brazil/Tocantins/Taguatinga (Tocantins)
South America/Brazil/Para/Bom Jesus do Tocantins	South America/Brazil/Para/Bom Jesus do Tocantins (Para)
South America/Brazil/Tocantins/Bom Jesus do Tocantins	South America/Brazil/Tocantins/Bom Jesus do Tocantins (Tocantins)
South America/Brazil/Rio de Janeiro/Natividade	South America/Brazil/Rio de Janeiro/Natividade (Rio de Janeiro)
South America/Brazil/Tocantins/Natividade	South America/Brazil/Tocantins/Natividade (Tocantins)

----------

Checking for division duplicates...

(Ignoring duplicate division Luxembourg in favor of the country Luxembourg.)
(Ignoring duplicate division Maryland in favor of the USA.)
(Ignoring duplicate division Montana in favor of the USA.)


----------

Checking for country duplicates...


===============================================

Checking for missing lat_longs...

----------

Missing divisions:
# Asia #
Vietnam
	division	Ha Noi

# Europe #
United Kingdom
	division	?
Bosnia and Herzegovina
	division	West Herzegovina
Canary Islands
	division	Gran Canaria
	division	Las Palmas de Gran Canaria
Croatia
	division	Split - Dalmatia County
	division	Sisak - Moslavina County

# Africa #
Botswana
	division	Boteti
Nigeria
	division	Anambra
	division	Cross River
Namibia
	division	Otjozodjupa

# North America #
USA
	division	American Samoa


----------


Missing countries:
# Europe #
	country	Canary Islands

===============================================

Checking for similar names...

----------


Similar divisions (sorted by descending similarity):
Africa/Namibia/Otjozodjupa/*	Africa/Namibia/Otjozondjupa/*
Europe/Croatia/Sisak - Moslavina County/*	Europe/Croatia/Sisak-Moslavina County/*
Europe/Croatia/Split - Dalmatia County/*	Europe/Croatia/Split-Dalmatia County/*
Africa/Nigeria/Cross River/*	Africa/Nigeria/Cross River State/*
Europe/Bosnia and Herzegovina/West Herzegovina/*	Europe/Bosnia and Herzegovina/Bosnia and Herzegovina/*
Asia/Vietnam/Ha Noi/*	Asia/Vietnam/Ha Nam/*
Europe/Canary Islands/Las Palmas de Gran Canaria/*	Europe/Canary Islands/Gran Canaria/*
Europe/Canary Islands/Gran Canaria/*	Europe/Canary Islands/Las Palmas de Gran Canaria/*

----------


----------


===============================================

Would you like to search for missing lat_longs [y/n]? y

Searching for lat_longs...
# Vietnam #

Current place for missing division:	Ha Noi, Vietnam
Geopy suggestion: Hanoi, Vietnam
Is this the right place (a - alter division level) [y/n/a]? y

# United Kingdom #

Current place for missing division:	?, United Kingdom
Geopy suggestion: United Kingdom
Is this the right place (a - alter division level) [y/n/a]? n
For: ?, United Kingdom
Type a more specific place name or 'NA' to leave blank: NA

# Bosnia and Herzegovina #

Current place for missing division:	West Herzegovina, Bosnia and Herzegovina
Geopy suggestion: West, Gabrijela Jurkića, Podvornice, Livno, City of Livno, Herzeg-Bosnia Canton, Federation of Bosnia and Herzegovina, 80101, Bosnia and Herzegovina
Is this the right place (a - alter division level) [y/n/a]? y

# Canary Islands #

Current place for missing division:	Gran Canaria, Canary Islands
Geopy suggestion: Gran Canaria, Canary Islands, Spain
Is this the right place (a - alter division level) [y/n/a]? y

Current place for missing division:	Las Palmas de Gran Canaria, Canary Islands
Geopy suggestion: Las Palmas de Gran Canaria, Las Palmas, Canary Islands, Spain
Is this the right place (a - alter division level) [y/n/a]? y

# Croatia #

Current place for missing division:	Split - Dalmatia County, Croatia
Geopy suggestion: Split-Dalmatia County, Croatia
Is this the right place (a - alter division level) [y/n/a]? y

Current place for missing division:	Sisak - Moslavina County, Croatia
Geopy suggestion: Sisak-Moslavina County, Croatia
Is this the right place (a - alter division level) [y/n/a]? y

# Botswana #

Current place for missing division:	Boteti, Botswana
Geopy suggestion: Boteti, Botswana
Is this the right place (a - alter division level) [y/n/a]? y

# Nigeria #

Current place for missing division:	Anambra, Nigeria
Geopy suggestion: Anambra, Nigeria
Is this the right place (a - alter division level) [y/n/a]? y

Current place for missing division:	Cross River, Nigeria
Geopy suggestion: Cross River, Nigeria
Is this the right place (a - alter division level) [y/n/a]? y

# Namibia #

Current place for missing division:	Otjozodjupa, Namibia
The place as currently written could not be found.
For: Otjozodjupa, Namibia
Type a more specific place name or 'NA' to leave blank: Otjiwarongo / Namibia 

Current place for missing division:	Otjozodjupa, Namibia
Geopy suggestion: Otjiwarongo, Otjozondjupa, 12001, Namibia
Is this the right place (a - alter division level) [y/n/a]? y

# USA #

Current place for missing division:	American Samoa, USA
Geopy suggestion: American Samoa, United States
Is this the right place (a - alter division level) [y/n/a]? y


Current place for missing country:	Canary Islands
Geopy suggestion: Canary Islands, Spain
Is this the right place [y/n]? y

New lat_longs written out to scripts/curate_metadata/output_curate_metadata/lat_longs.tsv. Remember to replace the old file in defaults/.

===============================================

Constructing new color_ordering file...
Attention: color_ordering.tsv was altered! Remember to replace the old file in defaults/.

===============================================


Reading annotations...
Would you like to check annotations for conflicts with geoLocationRules and produce manualAnnotations [y/n]? y

----------

Applying new geoLocationRules and manualAnnotationRules to the metadata...

----------

Searching for conflicting annotations and adding manualAnnotationRules...

----------

Would you like to perform additional metadata checks (e.g. date, host, strain name) [y/n]? y
Traversing metadata...

Unknown clade encountered: 21I (Delta)
Unknown clade encountered: 21J (Delta)
Unknown clade encountered: 21H (Mu)
Unknown clade encountered: 21K (Omicron)
Unknown clade encountered: 21L


Unknown clade encountered: 21K (Omicron)
Unknown clade encountered: 21J (Delta)
Unknown clade encountered: 21I (Delta)
Unknown clade encountered: 21H (Mu)


Adding 282 strains to exclude due to early dates...
Attention: exclude.txt was altered! Remember to replace the old file in defaults/.

----------

Writing updated annotation files to scripts/curate_metadata/output_curate_metadata/...
No changes to gisaid_annotations.tsv.
No changes to genbank_annotations.tsv.
```
	
</details>

With key messages being:

```
grep "Remember to replace" full_output.txt

New lat_longs written out to scripts/curate_metadata/output_curate_metadata/lat_longs.tsv. Remember to replace the old file in defaults/.
Attention: color_ordering.tsv was altered! Remember to replace the old file in defaults/.
Attention: exclude.txt was altered! Remember to replace the old file in defaults/.
Attention: color_ordering.tsv was altered! Remember to replace the old file in defaults/.
```

* `scripts/curate_metadata/output_curate_metadata/lat_longs.tsv`
* `color_ordering.tsv`
* `exclude.txt` 

```
Attention: gisaid_annotations.tsv was altered! Remember to replace the old file in ../ncov-ingest/source-data/.
Attention: genbank_annotations.tsv was altered! Remember to replace the old file in ../ncov-ingest/source-data/.
```

```
ls -ltr scripts/curate_metadata/output_curate_metadata/
total 49040
-rw-r--r--  1 jenchang  staff   622K Jan 12 12:25 lat_longs.tsv
-rw-r--r--  1 jenchang  staff   486K Jan 12 12:25 color_ordering.tsv
-rw-r--r--  1 jenchang  staff    23M Jan 12 12:27 gisaid_annotations.tsv
-rw-r--r--  1 jenchang  staff   124K Jan 12 12:27 genbank_annotations.tsv
```

Compare with `ncov-ingest`

```
 ls -ltr ../ncov-ingest/source-data/
total 174520
-rw-r--r--  1 jenchang  staff    58M Jan 12 12:05 accessions.tsv
-rw-r--r--  1 jenchang  staff   124K Jan 12 12:05 genbank_annotations.tsv
-rw-r--r--  1 jenchang  staff    23M Jan 12 12:05 gisaid_annotations.tsv
-rw-r--r--  1 jenchang  staff   3.1M Jan 12 12:05 gisaid_geoLocationRules.tsv
-rw-r--r--  1 jenchang  staff   830K Jan 12 12:05 location_hierarchy.tsv
-rw-r--r--  1 jenchang  staff   769B Jan 12 12:05 us-state-codes.tsv
```


## After

> If you ever add rules to the `source-data/gisaid_geoLocationRules.tsv` file, new rules always have to be added to the bottom of the file. Then you can run the following to apply new changes and resolve conflicts

```
bin/check-gisaid-geoRules --geo-location-rules source-data/gisaid_geoLocationRules.tsv --output-file gisaid_geoLocationRules.tsv
```

