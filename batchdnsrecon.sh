#!/usr/bin/bash
filename="$1"
while read -r line
do
    echo "*********************************************************************" | tee -a $1-dnsrecon.txt
    echo "*********************************************************************" | tee -a $1-dnsrecon.txt
    echo "" | tee -a $1-dnsrecon.txt
    dnsrecon -d $line | tee -a $1-dnsrecon.txt
    echo "" | tee -a $1-dnsrecon.txt
done < "$filename"
