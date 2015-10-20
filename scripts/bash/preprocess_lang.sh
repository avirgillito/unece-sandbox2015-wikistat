#!/bin/bash

usage() { echo "Usage: $0 -d <output_root_dir> -l <language_iso_code>" 1>&2; exit 1; }
notdir() { echo $1 "is not a directory in hdfs" 1>&2; exit 1; }

# Check parameters
while getopts ":d:l:" o; do
    case "${o}" in
       d)
          rootdir=${OPTARG}
          ;;
       l)
          lang=${OPTARG}
          ;;
       *)
          usage
          ;;
    esac
done	
shift $((OPTIND-1))

if [ -z "${rootdir}" ]; then
  usage
fi

if [ -z "${lang}" ]; then
  usage
fi

if ! hadoop fs -test -d ${rootdir}
then
  notdir ${rootdir}
fi

# Step1 - Filtering
indir=/datasets/wikistats/
outdir=${rootdir}filtered_${lang}/
tempdir=${rootdir}temp_${lang}/
hadoop fs -mkdir ${outdir}
scripts/bash/filter_lang.sh -l ${lang} -i ${indir} -o ${outdir} -t ${tempdir}

# Step2 - Hourizing
indir=${rootdir}filtered_${lang}/
outdir=${rootdir}hourized_${lang}/
scripts/bash/hourize.sh -i ${indir} -o ${outdir}
#hadoop fs -rm -R $indir

# Step3 - Linearizing
indir=${rootdir}hourized_${lang}/
outdir=${rootdir}linearized_${lang}/
scripts/bash/linearize_direct.sh -i ${indir} -o ${outdir}
#hadoop fs -rm -R $indir

# Step4 - Adding ids
indir=${rootdir}linearized_${lang}/
outdir=${rootdir}articles_time-series_${lang}/
collisiondir=${rootdir}collisions_${lang}/
scripts/bash/add_ids.sh -i ${indir} -o ${outdir} -c ${collisiondir}
#hadoop fs -rm -R $indir

# Report sucess
echo Pre-processing of language version sucessfull
