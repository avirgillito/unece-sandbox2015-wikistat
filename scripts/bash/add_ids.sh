#!/bin/bash

usage() { echo "Usage: $0 -i <input_dir> -o <output_dir> -c <collision_dir>" 1>&2; exit 1; }
notdir() { echo $1 "is not a directory in hdfs" 1>&2; exit 1; }
recursive() { echo $1 "input directory must not contain subdirectories" 1>&2; exit 1; }
notempty() { echo $1 "files. Output directory must be empty" 1>&2; exit 1; }
existsdir() { echo $1 " exists. Output directory should not exist." 1>&2; exit 1; }


while getopts ":i:o:c:" o; do
    case "${o}" in
       i)
          indir=${OPTARG}
          ;;
       o) 
          outdir=${OPTARG}
          ;;
       c) 
          collisiondir=${OPTARG}
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

if [ -z "${collisiondir}" ]; then
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

if hadoop fs -test -d ${collisiondir}
then
  existsdir ${collisiondir}
fi

# directory with the pig scripts
pigdir=$(dirname $(cd "$( dirname "$0" )" && pwd))/pig
# pyhton pig helpers
pighelpers=$(dirname $(cd "$( dirname "$0" )" && pwd))/python/pighelpers.py

echo $pighelpers
# real work
pig -f $pigdir/put_ids.grunt -param input_dir=$indir -param output_dir=$outdir -param python_helper=$pighelpers -param collision_dir=$collisiondir 

collisions=$(mktemp)
hadoop dfs -getmerge "$collisiondir" "$collisions"
echo "COLLISIONS:"
cat "$collisions"
rm "$collisions"
