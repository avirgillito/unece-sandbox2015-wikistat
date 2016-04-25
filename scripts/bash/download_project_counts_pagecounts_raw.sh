#!/bin/bash
usage() { 
  printf "Usage: $0 -o <output_dir> -s <start_date> -e <end_date> \n Dates have to be in a format understandable by GNU date.\n" 1>&2; exit 1; 
}
nodir() { echo "Output directory has to exist." 1>&2; exit 1; }
dirnotempty() { echo "Output directory has to be empty." 1>&2; exit 1; }
dateunreachable() {
  printf "Can't download from $1 \n" 1>&2; exit 1; 
}

# Check if the date is in scope.
testurl() {
  url=$1
  echo $url
  tmp=$(mktemp)
  rand=$(echo "$RANDOM % 7" | bc)
  sleep $rand
  wget $url -O $tmp
  rm $tmp
  wgetstatus=$?
  echo "Status is: "$wgetstatus
  if [ $wgetstatus -eq 0 ]; then
    echo "Should NOT delete!"
  else
    echo "Should delete!"
    dateunreachable $url
  fi
}

while getopts ":o:s:e:p:g:" o; do
    case "${o}" in
       o)
          outdir=${OPTARG}
          ;;
       s)
          startdate=${OPTARG}
          ;;
       e)
          enddate=${OPTARG}
          ;;
       p)
          proj=${OPTARG}
          ;;
       g)
          aggregation=${OPTARG}
          ;;
       *)
          echo "d"
          usage
          ;;
    esac
done
shift $((OPTIND-1))
if [ -z "${startdate}" ]; then
  echo "a"
  usage
fi

if [ -z "${enddate}" ]; then
  echo "b"
  usage
fi

if [ -z "${outdir}" ]; then
  echo "c"
  usage
fi

if [ ! -d "${outdir}" ]; then
  nodir
fi

if [ "$(ls -A $outdir)" ]; then
  dirnotempty
fi

startyear=$(date -d "$startdate" +%Y)
startmonth=$(date -d "$startdate" +%m)
startday=$(date -d "$startdate" +%d)
starthour=$(date -d "$startdate" +%H)
endyear=$(date -d "$enddate" +%Y)
endmonth=$(date -d "$enddate" +%m)
endday=$(date -d "$enddate" +%d)
endhour=$(date -d "$enddate" +%H)
prefix="https://dumps.wikimedia.org/other/pagecounts-raw/"
starturl=$prefix$startyear"/"$startyear-$startmonth"/projectcounts-"$startyear$startmonth$startday-$starthour"0000"
endurl=$prefix$endyear"/"$endyear-$endmonth"/projectcounts-"$endyear$endmonth$endday-$endhour"0000"

#testurl $starturl
#testurl $endurl
#echo "urls tested!"

epoch1=$(echo "("$(date -d "$startdate" +%s)"/ 3600)" | bc)
epoch2=$(echo "("$(date -d "$enddate" +%s)"/ 3600)" | bc)
#echo $epoch1
#echo $epoch2
diff=$(echo "$epoch2-$epoch1" | bc)
#echo $diff

for i in $(seq 0 $diff);
do
  newhour=$(((epoch1+i)*3600));
  year=$(date -d @"$newhour" +%Y)
  month=$(date -d @"$newhour" +%m)
  day=$(date -d @"$newhour" +%d)
  hour=$(date -d @"$newhour" +%H)
  url=$prefix$year"/"$year-$month"/projectcounts-"$year$month$day-$hour"0000"
  alturl=$prefix$year"/"$year-$month"/projectcounts-"$year$month$day-$hour"0001"
  echo $url
  rand=$(echo "$RANDOM % 3" | bc)
  sleep $rand
  wget -P ${outdir} $url
  if [ $? -ne 0 ]; then
    wget -P ${outdir} $alturl
  fi  
  if [ $? -ne 0 ]; then
    echo "Error on: "$alturl 1>&2  
  fi

done



