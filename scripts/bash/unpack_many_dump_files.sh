#!/bin/bash
usage() { echo "Usage: $0 -i <input_dir_on_linux>" 1>&2;exit 1; }
noconf() { echo "Target direcotry has to contain exclusively files with the .bz2 extension." 1>&2;exit 1; }

while getopts ":i:" o; do
    case "${o}" in
        i)
            indir=${OPTARG}
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

files=($(ls $indir))
for f in ${files[@]}
do
  suf=${f:${#f}-4}
  if [[ ! "$suf" = ".bz2" ]]; then
    noconf
  fi 
  #echo ${f%.bz2}
  #echo $a
  #echo $f
  #echo $indir/$f
done

for f in ${files[@]}
do
  suf=${f:${#f}-4}
  if [[ "$suf" = ".bz2" ]]; then
    newfile=${f%.bz2}
    echo $indir/$f
    bzcat $indir/$f > $indir/$newfile  
  fi
done

