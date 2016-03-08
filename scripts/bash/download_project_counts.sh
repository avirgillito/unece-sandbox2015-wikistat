#!/bin/bash
usage() { 
  printf "Usage: $0 -o <outpu_dir> -s <start_date> -e <end_date> -p proj (-g <hour|day|week|month>) \n Dates are in a format understandable by GNU date.\n" 1>&2; exit 1; 
}
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
          usage
          ;;
    esac
done
shift $((OPTIND-1))
if [ -z "${startdate}" ]; then
  usage
fi

if [ -z "${enddate}" ]; then
  usage
fi

startyear=$(date -d "$startdate" +%Y)
startmonth=$(date -d "$startdate" +%m)
startday=$(date -d "$startdate" +%d)
starthour=$(date -d "$startdate" +%H)
endyear=$(date -d "$enddate" +%Y)
endmonth=$(date -d "$enddate" +%m)
endday=$(date -d "$enddate" +%d)
endhour=$(date -d "$enddate" +%H)
prefix="http://dumps.wikimedia.org/other/pagecounts-all-sites/"
starturl=$prefix$startyear"/"$startyear-$startmonth"/projectcounts-"$startyear$startmonth$startday-$starthour"0000"
endurl=$prefix$endyear"/"$endyear-$endmonth"/projectcounts-"$endyear$endmonth$endday-$endhour"0000"

testurl $starturl
testurl $endurl
echo "urls tested!"

epoch1=$(echo "("$(date -d "$startdate" +%s)"/ 3600)" | bc)
epoch2=$(echo "("$(date -d "$enddate" +%s)"/ 3600)" | bc)
echo $epoch1
echo $epoch2
diff=$(echo "$epoch2-$epoch1" | bc)
echo $diff
