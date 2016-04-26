#!/bin/bash

#
# Expected format: "de","Wikipedia:Hauptseite","T2012.01",43998931
#


table_name=$1
input_file=$2

echo "disable '${table_name}'" | hbase shell -n
echo "drop '${table_name}'" | hbase shell -n
echo "create '${table_name}', 'cf1'" | hbase shell -n
n=1
#biginsertsentence="create 'hauptseite', 'cf1';"
biginsertsentence=""
#while IFS='' read -r line || [[ -n "$line" ]]; do
while IFS='' read -r line; do
  #line=$(echo $line| tr -d '"')
  oldifs=${IFS}
  IFS=','
  a=($line)
  IFS=${oldifs}
  proj=${a[0]}
  proj="${proj:0:2}"
  art=${a[1]}
  art="${art:0:11}"
  #echo $proj
  #echo $art
  tm=${a[2]}  
  cnt=${a[3]}  
  if [ "$proj" == "de" ] && [ "${art}" == "Hauptseite" ]; then
    #echo "put 'hauptseite', 'r"$n"', 'cf1:tm', '"$tm"'" | hbase shell -n
    #echo "put 'hauptseite', 'r"$n"', 'cf1:cnt', '"$cnt"'" | hbase shell -n
    #echo "put 'hauptseite', 'r"$n"', 'cf1:tm', '"$tm"'"
    #echo "put 'hauptseite', 'r"$n"', 'cf1:cnt', '"$cnt"'"
    #echo "$art"
    biginsertsentence=$biginsertsentence";put '${table_name}', 'r"$n"', 'cf1:tm', '"$tm"'" 
    biginsertsentence=$biginsertsentence";put '${table_name}', 'r"$n"', 'cf1:cnt', '"$cnt"'"
    #echo "BB"$biginsertsentence
    n=$((n+1))
  fi
  #echo "put 'hauptseite', 'r"$n"', 'cf1:tm', '"$tm"'" | hbase shell -n
  
done <<< "$(cat $input_file | tr -d '"')"
echo $biginsertsentence | hbase shell -n
#echo $biginsertsentence

