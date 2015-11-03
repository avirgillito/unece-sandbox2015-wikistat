#!/bin/bash
usage() { echo "Usage: $0 -c <config_file> (-g <hour|day|week|month>)
config file format:
outdir=\"<hdfs_folder_for_output>\"
tempdir=\"<hdfs_folder_for_temporary_files>\"
proj1=\"<proj> <file_with_articles> <input_for_2012_2012> <input_for_2014_2015>\"
proj2=\"<proj> <file_with_articles> <input_for_2012_2012> <input_for_2014_2015>\"
...
" 1>&2; exit 1; }

nooutput() { echo "The config file" $1 " does not contain a definition of the parameter outdir." 1>&2; exit 1; }
nooutput() { echo "The config file" $1 " does not contain a definition of the parameter tempdir." 1>&2; exit 1; }
notdir() { echo $1 "is not a directory in hdfs" 1>&2; exit 1; }
existsdir() { echo $1 " exists. Output directory should not exist." 1>&2; exit 1; }
notexists() { echo $1 "does not exist" 1>&2; exit 1; }

while getopts ":c:g:" o; do
    case "${o}" in
        c)
            cfgfile=${OPTARG}
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

if [ -z "${cfgfile}" ]; then
  usage
fi

if [ -z "${aggregation}" ]; then
  aggregation="hour"
fi

source $cfgfile

if [ -z "${outdir}" ]; then
  nooutput $cfgfile
fi

if hadoop fs -test -d ${outdir}
then
  existsdir ${outdir}
fi

if [ -z "${tempdir}" ]; then
  notemp $cfgfile
fi

if hadoop fs -test -d ${tempdir}
then
  existsdir ${tempdir}
fi

# pyhton filter mapper
mapper=$(dirname $(cd "$( dirname "$0" )" && pwd))/python/filter_mapper.py
# pyhton filter reducer
reducer=$(dirname $(cd "$( dirname "$0" )" && pwd))/python/filter_reducer.py

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
    artfile=${params[1]}    
    input_old=${params[2]}
    input_new=${params[3]}
    count=$((count + 1))

    if [ ! -e "${artfile}" ]; then
      notexists ${artfile}
    fi

    if ! hadoop fs -test -d ${input_old}
    then
      notdir ${input_old}
    fi
    
    if ! hadoop fs -test -d ${input_new}
    then
      notdir ${input_new}
    fi

#    cmd="hadoop jar /usr/hdp/2.2.4.2-2/hadoop-mapreduce/hadoop-streaming.jar -D mapred.reduce.tasks=7 -file ${mapper} -file ${artfile} -mapper ${mapper} -file ${reducer} -reducer ${reducer} -input ${input_old} -output ${tempdir}/"$proj"_old -cmdenv WIKI_PROJ=${proj} -cmdenv WIKI_AGGR=${aggregation} -cmdenv ART_FILE=$(basename ${artfile}) -cmdenv FIRST_YEAR=2012 -cmdenv FIRST_MONTH=1 -cmdenv FIRST_DAY=1 -cmdenv LAST_YEAR=2013 -cmdenv LAST_MONTH=12 -cmdenv LAST_DAY=31"
#    $cmd &
#    cmd="hadoop jar /usr/hdp/2.2.4.2-2/hadoop-mapreduce/hadoop-streaming.jar -D mapred.reduce.tasks=7 -file ${mapper} -file ${artfile} -mapper ${mapper} -file ${reducer} -reducer ${reducer} -input ${input_new} -output ${tempdir}/"$proj"_new -cmdenv WIKI_PROJ=${proj} -cmdenv WIKI_AGGR=${aggregation} -cmdenv ART_FILE=$(basename ${artfile}) -cmdenv FIRST_YEAR=2014 -cmdenv FIRST_MONTH=1 -cmdenv FIRST_DAY=1 -cmdenv LAST_YEAR=2015 -cmdenv LAST_MONTH=12 -cmdenv LAST_DAY=31"
#    $cmd &
    cmd="hadoop jar /usr/hdp/2.2.4.2-2/hadoop-mapreduce/hadoop-streaming.jar -D mapred.reduce.tasks=7 -file ${mapper} -file ${artfile} -mapper ${mapper} -file ${reducer} -reducer ${reducer} -input ${input_old} -output ${tempdir}/"$proj"_old -cmdenv WIKI_PROJ=${proj} -cmdenv WIKI_AGGR=${aggregation} -cmdenv ART_FILE=$(basename ${artfile}) -cmdenv FIRST_YEAR=2012 -cmdenv FIRST_MONTH=1 -cmdenv FIRST_DAY=1 -cmdenv LAST_YEAR=2015 -cmdenv LAST_MONTH=12 -cmdenv LAST_DAY=31"
    $cmd &
    cmd="hadoop jar /usr/hdp/2.2.4.2-2/hadoop-mapreduce/hadoop-streaming.jar -D mapred.reduce.tasks=7 -file ${mapper} -file ${artfile} -mapper ${mapper} -file ${reducer} -reducer ${reducer} -input ${input_new} -output ${tempdir}/"$proj"_new -cmdenv WIKI_PROJ=${proj} -cmdenv WIKI_AGGR=${aggregation} -cmdenv ART_FILE=$(basename ${artfile}) -cmdenv FIRST_YEAR=2012 -cmdenv FIRST_MONTH=1 -cmdenv FIRST_DAY=1 -cmdenv LAST_YEAR=2015 -cmdenv LAST_MONTH=12 -cmdenv LAST_DAY=31"
    $cmd &
done
echo "waiting.."
wait
echo "filters done."

# directory with the pig scripts
pigdir=$(dirname $(cd "$( dirname "$0" )" && pwd))/pig
# pyhton pig helpers
pighelpers=$(dirname $(cd "$( dirname "$0" )" && pwd))/python/pighelpers.py

pig -f $pigdir/assemble_from_languages.grunt -param input_dir=$tempdir -param output_dir=$outdir -param python_helper=$pighelpers

hadoop dfs -rm -R $tempdir
echo "done"  
