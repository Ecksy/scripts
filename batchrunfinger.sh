#!/usr/bin/bash
filename="$1"
while read -r line
do
    responder-RunFinger -a -i $line | tee -a $1-Runfinger.txt
    echo "" | tee -a $1-Runfinger.txt
done < "$filename"
