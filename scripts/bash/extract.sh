#!/bin/bash

# the below extracts by article id
#hadoop dfs -cat $1/* | tr -d "[]," | awk '!($2="")' | awk '!($2="")' | awk -f transpose.awk > $2

transpose_script=$(cd "$( dirname "$0" )" && pwd)/transpose.awk

# the below extracts by name


# This is the expected format:
#
#month	month	month	['2012-01', '2012-02', '2012-03', '2012-04', '2012-05', '2012-06', '2012-07', '2012-08', '2012-09', '2012-10', '2012-11', '2012-12', '2013-01', '2013-02', '2013-03', '2013-04', '2013-05', '2013-06', '2013-07', '2013-08', '2013-09', '2013-10', '2013-11', '2013-12']
#10183239904331591	en.z	Tokaj_wine_region	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 108, 1146, 1593, 2241, 1818, 1613, 1516, 1330, 1648, 1475, 1838, 1701, 1905]
#10963517029208960	en.z	La_Fortaleza	[2996, 2999, 3068, 2549, 2360, 2150, 2137, 2255, 2161, 2672, 3827, 2580, 4000, 2980, 3237, 2849, 2724, 2015, 1810, 1799, 1723, 2695, 2195, 2172]
#11005519267367854	en.z	Banc_d'Arguin_National_Park	[0, 0, 0, 5, 6, 16, 5, 20, 25, 21, 48, 29, 43, 40, 46, 0, 30, 55, 36, 39, 28, 28, 204, 218]
# ....




#First url encode non ascii characters as windows R seems unable to deal with them. Then remove the [ and ] that surround the entries then remove the first two columns (id and project name). Then run the transpose script. Then remove columns that duplicate the first column. Then translate all whitespace to a single space character. Finally remove separating quotes around the dates in the first column.
hadoop dfs -cat $1/* | tr -d "[]," | perl -ne '$_ =~ s/([^\x00-\x7F])/sprintf("%%%0X", ord($1))/eg; print;' | awk '!($1="")' | awk '!($1="")' | awk -f ${transpose_script} | awk ' FNR==1 {for (i =1; i <=NF; i++) if ($i == $1) bad[i]=$i }; { for (i=2; i<=NF; i++) if (i in bad) $i=""; print $0 }' | tr -s " "| awk 'NR==1 {print $0}; NR>1{ $1=substr($1,2,length($1)-2);print $0}' > $2
