#!/bin/bash

# Takes as input a directory with files and outputs to stdout the hourly counts
# The naming convention for the files is projectcounts-yyyymmdd-hh0000 as it appears here http://dumps.wikimedia.org/other/pagecounts-all-sites/ 

usage() { 
  printf "Usage: $0 -i <input_dir> -o <output_dir> -p <proj_cfg_file> (-g <hour|day|month>)\n
config file format:
proj1=\"<proj1_specification>\"
proj2=\"<proj2_specification>\"
...
" 1>&2; exit 1; 
}
notempty() { echo $1 "files. Output directory must be empty" 1>&2; exit 1; }
while getopts ":i:o:p:g:" o; do
    case "${o}" in
       i)
          indir=${OPTARG}
          ;;
       o)
          outdir=${OPTARG}
          ;;
       p) 
          cfgfile=${OPTARG}
          ;;
       g) 
          aggr=${OPTARG}
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

if [ -z "${outdir}" ]; then
  usage
fi

if [ -z "${cfgfile}" ]; then
  usage
fi

if [ ! -d "${indir}" ]; then
  usage
fi

if [ ! -d "${outdir}" ]; then
  usage
fi

noutlines=$(ls -A ${outdir} | wc -l)
# check that the output directory is empty
if [ "$noutlines" -gt "0" ];
then
  notempty "$noutlines"
fi

source $cfgfile

bashdir=$(dirname $(cd "$( dirname "$0" )" && pwd))/bash
pythondir=$(dirname $(cd "$( dirname "$0" )" && pwd))/python

count=1
while true; do
    next_proj=proj"$count"
    # if variable projN doesn't exist
    cmd="if [ -z \"\$""$next_proj""\" ]; then  break; fi"
    eval $cmd
    echo "Next project:"$count
    cmd="params=(\$proj"$count")"
    eval $cmd
    proj=${params[0]}
    echo $proj
    sh $bashdir/extract_project_series.sh -i ${indir} -p ${proj} | python ${pythondir}/aggregate_project.py -g ${aggr} > ${outdir}/${proj}".txt"
    #sh $bashdir/extract_project_series.sh -i ${indir} -p ${proj} > ${outdir}/${proj}".txt"
    count=$((count + 1))
done

#files=($(ls ${indir}))
#for f in ${files[@]};
#do
#  year=${f:14:4}
#  month=${f:18:2}
#  day=${f:20:2}
#  hour=${f:23:2}
#  cnt=$(cat ${indir}/${f} | grep "^$proj " | perl -ne '$_ =~ /[^\d]*\s(\d*)\s(\d*)/; print "$1\n"') 
#  echo "$year-$month-$day:$hour $cnt" 
#done 

