#!/bin/bash

for URL in "http://google.com/" "http://facebook.com/" "http://youtube.com/" "http://yahoo.com/" "http://www.baidu.com/"
do

#This script depends on ab which is a part of the apache2-utils package in Debian
    echo "The mean HTTP response time for " $URL " was:"
    ab -c 10 -n 100 -i $URL | grep "Connect" | awk -F " " '{print $3}'

    echo "The mean DNS response time for " $URL " was:"

    TOTALT=`echo 0`
    for i in 1 2 3 4 5 6 7 8 9 10
    do
	RESULT=`dig +noall +stats $URL | grep "Query time:" | awk -F ":" '{print $2}' |  awk -F " " '{print $1}'`
	TOTALT=`expr $TOTALT + $RESULT`
    done
    TOTALT=`expr $TOTALT / 10`
    echo $TOTALT
    
    echo "The mean throughput of the connection is:"
    ab -c 500 -n 500 -i $URL | grep "Transfer rate" | awk -F ":" '{print $2}' | awk -F " " '{print $1 $2}'

    echo "The average load time without rendering of the main page of" $URL " is:"
    wget $URL -o lol
    grep "100%" lol | cut -d= -f2
    rm lol
done