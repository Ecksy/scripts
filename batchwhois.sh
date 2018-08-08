#!/usr/bin/bash
filename="$1"
while read -r line
do
    echo "*********************************************************************" | tee -a client-whois.txt
    echo "*********************************************************************" | tee -a client-whois.txt
    echo "" | tee -a client-whois.txt
    echo "WHOIS query for:" $line | tee -a client-whois.txt
    whois -H --verbose $line | tee -a client-whois.txt
    echo "" | tee -a client-whois.txt
done < "$filename"
