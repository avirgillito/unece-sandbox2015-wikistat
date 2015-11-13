#!/bin/bash

usage() { echo "Usage: $0 -t <text_to_search> (-d <base_dir>)  (-s <start_month>) (-m <months>) (-p <parallelism_level>)" 1>&2; exit 1; }
notdir() { echo $1 "is not a directory in hdfs" 1>&2; exit 1; }

while getopts ":d:t:s:m:" o; do
    case "${o}" in
       d)
          basedir=${OPTARG}
          ;;
       t) 
          text=${OPTARG}
          ;;
       s)
          startmonth=${OPTARG}
          ;;
       m)
          monhts=${OPTARG}
          ;;
       p)
          par=${OPTARG}
          ;;
       *)
          usage
          ;;
    esac
done	

shift $((OPTIND-1))

if [ -z "${basedir}" ]; then
  basedir="/datasets/wikistats/"
fi

if [ -z "${startmonth}" ]; then
  startmonth="2012-01"
fi

if [ -z "${months}" ]; then
  months=24
fi

if [ -z "${par}" ]; then
  par=12
fi

if [ -z "${text}" ]; then
  usage
fi

if ! hadoop fs -test -d ${basedir}
then
  notdir ${basedir}
fi

pref=$basedir"/pagecounts-"
#sufs=($(seq -f %05g "$n"))
declare -a infixes
infixes[1]="$startmonth"
for i in $(seq 2 $months)
do
  imin1=$((i-1))
  prev="${infixes[$imin1]}""-1"
  #echo 'date +%Y-%m --date="$prev next month"'
  infixes[$i]=$(date +%Y-%m --date="${prev} next month")
done
for i in $(seq 1 $months)
do
  nextfile="$pref"${infixes[$i]}"-views-ge-5"
  cnt=$((10#$i))
  remn=$((cnt%par))
  #echo $nextfile
  #echo $remn
  ##echo "######"$cnt"#######"$remn"######"
  hadoop dfs -cat "$nextfile" | awk '{print "'"$i "'" $1 $2}' | grep $text &
  if [ $remn -eq 0 ]; then
    wait
  fi
done
wait
