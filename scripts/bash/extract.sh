#!/bin/bash

# the below extracts by article id
#hadoop dfs -cat $1/* | tr -d "[]," | awk '!($2="")' | awk '!($2="")' | awk -f transpose.awk > $2

transpose_script=$(cd "$( dirname "$0" )" && pwd)/transpose.awk

# the below extracts by name
hadoop dfs -cat $1/* | tr -d "[]," | awk '!($1="")' | awk '!($1="")' | awk -f ${transpose_script} | awk ' FNR==1 {for (i =1; i <=NF; i++) if ($i == $1) bad[i]=$i }; { for (i=2; i<=NF; i++) if (i in bad) $i=""; print $0 }' | tr -s " "> $2
