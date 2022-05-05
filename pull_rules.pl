#! /usr/bin/env perl
# USAGE: perl pull_rules.pl ../ncov/scripts/curate_metadata/output_curate_metadata/color_ordering.tsv
# Expected Output:
# Asia/Israel/South District/Alumim
# Asia/Israel/South District/Arad
# Asia/Israel/South District/Ashdod
# Asia/Israel/South District/Ashkelon
# ...

my $continent="";
my $country="";
my $district="";
my $location="";

while(<>){
  chomp;
  if(/^# Asia/){
    $continent="Asia";
  }elsif(/^# Europe/){
    $continent="Europe";
  }elsif(/^# North America/){
    $continent="North America";
  }elsif(/^# South America/){
    $continent="South America";
  }elsif(/^# Africa/){
    $continent="Africa";
  }elsif(/^# Oceana/){
    $continent="Oceana";
  }elsif(/^### (.+)/){
    $country=$1;
  }elsif(/^# (.+)/){
    $district=$1;
  }elsif(/location\s*(\S.*)/){
    $location=$1;
    print("$continent/$country/$district/$location\n")
  }
}