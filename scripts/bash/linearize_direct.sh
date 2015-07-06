#!/bin/bash

usage() { echo "Usage: $0 -i <input_dir> -o <output_dir>" 1>&2; exit 1; }
notdir() { echo $1 "is not a directory in hdfs" 1>&2; exit 1; }
recursive() { echo $1 "input directory must not contain subdirectories" 1>&2; exit 1; }
notempty() { echo $1 "files. Output directory must be empty" 1>&2; exit 1; }
existsdir() { echo $1 " exists. Output directory should not exist." 1>&2; exit 1; }


while getopts ":i:o:" o; do
    case "${o}" in
       i)
          indir=${OPTARG}
          ;;
       o) 
          outdir=${OPTARG}
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
mapper=$(dirname $(cd "$( dirname "$0" )" && pwd))/python/linearize_mapper.py
# pyhton filter reducer
reducer=$(dirname $(cd "$( dirname "$0" )" && pwd))/python/linearize_reducer.py


# real work

cmd="hadoop jar /usr/hdp/2.2.4.2-2/hadoop-mapreduce/hadoop-streaming.jar -file ${mapper} -mapper ${mapper} -file ${reducer} -reducer ${reducer} -input ${indir} -output ${outdir}"
$cmd
