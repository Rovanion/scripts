#!/bin/bash

#This script requires suitable POSIX environment with wget, and awk installed. It takes command a file with one adress on each row as input.

declare -a ARRAY
exec 10<&0
exec < $1
 let count=0
while read LINE; do
ARRAY[$count]=$LINE
((count++))


#For each URL in stdin
for URL in $LINE
do

#Download the site and save it to hemsidan
wget $URL -O hemsidan
touch raderna
#Grep out the lines that contain links and output them to the file raderna
grep href hemsidan | grep -v $URL | grep http:// > raderna
grep src hemsidan | grep -v $URL | grep http:// >> raderna

#We then want to strip out the parts of the lines that are not part of the FQDN
#First awk takes what's after :// and puts it into the file bags
awk -F "://" '{print $2 > "bags"}' raderna
#Then cut takes the first part before the " delimiter
cut -f1 -d\" bags > bags1
#Then cut takes the first part before the / delimiter
cut -f1 -d/ bags1 > bags3
#We then sort the list and only keep the unique entries
sort bags3 | uniq > bags4
#After that, output the result.
echo $URL länkar vidare till följande sidor:
cat bags4

rm bags* hemsidan raderna

done
done
exec 0<&10 10<&-