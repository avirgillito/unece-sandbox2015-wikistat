#!/bin/bash

usage() { echo "Usage: $0 -i <input_dir> -o <output_dir> -a <file_with_articles> -p <proj> (-g <hour|day|week|month>)" 1>&2; exit 1; }
notdir() { echo $1 "is not a directory in hdfs" 1>&2; exit 1; }
notexists() { echo $1 "does not exist" 1>&2; exit 1; }
recursive() { echo $1 "input directory must not contain subdirectories" 1>&2; exit 1; }
notempty() { echo $1 "files. Output directory must be empty" 1>&2; exit 1; }
existsdir() { echo $1 " exists. Output directory should not exist." 1>&2; exit 1; }


while getopts ":i:o:a:p:g:" o; do
    case "${o}" in
       i)
          indir=${OPTARG}
          ;;
       o) 
          outdir=${OPTARG}
          ;;
       a) 
          artfile=${OPTARG}
          ;;
       p) 
          proj=${OPTARG}
          ;;
       g) 
          aggregation=${OPTARG}
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

if [ -z "${artfile}" ]; then
  usage
fi

if [ -z "${proj}" ]; then
  usage
fi

if [ -z "${aggregation}" ]; then
  aggregation="hour"
fi

if [ ! -e "${artfile}" ]; then
  notexists ${artfile}
fi

if ! hadoop fs -test -d ${indir}
then
  notdir ${indir}
fi

if hadoop fs -test -d ${outdir}
then
  existsdir ${outdir}
fi

noutlines=$(hadoop fs -ls ${outdir} | wc -l)
# check that the output directory is empty
if [ "$noutlines" -gt "0" ];
then
  notempty "$noutlines"
fi

# pyhton filter mapper
mapper=$(dirname $(cd "$( dirname "$0" )" && pwd))/python/filter_mapper.py
# pyhton filter reducer
reducer=$(dirname $(cd "$( dirname "$0" )" && pwd))/python/filter_reducer.py

echo ${aggregation}

# real work
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-*streaming*.jar -file ${mapper} -file ${artfile} -mapper ${mapper} -file ${reducer} -reducer ${reducer} -input ${indir} -output ${outdir} -cmdenv WIKI_PROJ=${proj} -cmdenv WIKI_AGGR=${aggregation}
