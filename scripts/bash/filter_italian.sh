#!/bin/bash

usage() { echo "Usage: $0 -i <input_dir> -o <output_dir> -t <temp_dir>" 1>&2; exit 1; }
notdir() { echo $1 "is not a directory in hdfs" 1>&2; exit 1; }
recursive() { echo $1 "input directory must not contain subdirectories" 1>&2; exit 1; }
notempty() { echo $1 "files. Output directory must be empty" 1>&2; exit 1; }
tempexists() { echo $1 "Temp directory must not exist." 1>&2; exit 1; }


while getopts ":i:o:t:" o; do
    case "${o}" in
       i)
          indir=${OPTARG}
          ;;
       o) 
          outdir=${OPTARG}
          ;;
       t)
          tempdir=${OPTARG}
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

if [ -z "${tempdir}" ]; then
  usage
fi

if ! hadoop fs -test -d ${indir}
then
  notdir ${indir}
fi

if ! hadoop fs -test -d ${outdir}
then
  notdir ${outdir}
fi

if hadoop fs -test -e ${tempdir}
then
  tempexists ${tempdir}
fi

noutlines=$(hadoop fs -ls ${outdir} | wc -l)
# check that the output directory is empty
if [ "$noutlines" -gt "0" ];
then
  notempty "$noutlines"
fi

infiles=($(hadoop fs -ls ${indir} | sed -n '1!p' | awk '{ print $NF }'))

# check that input dir does not contain subdirectories
for i in "${infiles[@]}"
do
  if hadoop fs -test -d $i
  then
    recursive $i
  fi
done

# directory with the pig scripts
pigdir=$(dirname $(cd "$( dirname "$0" )" && pwd))/pig

# real work
for i in "${infiles[@]}"
do
  yearmonth=${i##*pagecounts-}
  yearmonth=${yearmonth:0:7}
  pig -f $pigdir/filter_italian.grunt -param input_file=$i -param output_dir=$tempdir/$yearmonth -param yearmonth=$yearmonth
done

echo "Finished processing, now moving ..."

# move results into output directory
tempdirs=($(hadoop fs -ls ${tempdir} | sed -n '1!p' | awk '{ print $NF }'))
for d in "${tempdirs[@]}"
do
  if [ ${d:0:1} != "." ] 
  then
    outfiles=($(hadoop fs -ls $d | sed -n '1!p' | awk '{ print $NF }'))
    for o in "${outfiles[@]}"
    do
      fname=$(basename $o)
      mnth=$(basename $(dirname $o))
      newname="$outdir"/"$mnth"-"$fname"
      echo $o
      echo $newname
      hadoop fs -mv "$o" "$newname"
    done 
  fi
done 



# delete temporary directory

hadoop fs -rm -R $tempdir
