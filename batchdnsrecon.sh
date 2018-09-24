#!/usr/bin/bash
filename="$1"
while read -r line
do
    echo "*********************************************************************" | tee -a client-dnsrecon.txt
    echo "*********************************************************************" | tee -a client-dnsrecon.txt
    echo "" | tee -a client-dnsrecon.txt
    dnsrecon -d $line | tee -a client-dnsrecon.txt
    echo "" | tee -a client-dnsrecon.txt
done < "$filename"
