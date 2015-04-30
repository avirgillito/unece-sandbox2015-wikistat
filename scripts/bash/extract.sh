#!/bin/bash

# the below extracts by article id
#hadoop dfs -cat $1/* | tr -d "[]," | awk '!($2="")' | awk '!($2="")' | awk -f transpose.awk > $2

# the below extracts by name
hadoop dfs -cat $1/* | tr -d "[]," | awk '!($1="")' | awk '!($1="")' | awk -f transpose.awk > $2
