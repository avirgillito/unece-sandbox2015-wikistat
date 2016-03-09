#!/bin/bash

# Takes as input a directory with files and outputs to stdout the hourly counts
# The naming convention for the files is projectcounts-yyyymmdd-hh0000 as it appears here http://dumps.wikimedia.org/other/pagecounts-all-sites/ 

usage() { 
  printf "Usage: $0 -i <input_dir> -p proj \n" 1>&2; exit 1; 
}
while getopts ":i:o:p:g:" o; do
    case "${o}" in
       i)
          indir=${OPTARG}
          ;;
       p) 
          proj=${OPTARG}
          ;;
       *)
          usage
          ;;
    esac
done	
shift $((OPTIND-1))

if [ -z "${indir}" ]; then
  usage
fi

files=($(ls ${indir}))
for f in ${files[@]};
do
  year=${f:14:4}
  month=${f:18:2}
  day=${f:20:2}
  hour=${f:23:2}
  cnt=$(cat $f | grep "^$proj " | perl -ne '$_ =~ /[^\d]*\s(\d*)\s(\d*)/; print "$1\n"') 
  echo "$year-$month-$day:$hour $cnt" 
done 

