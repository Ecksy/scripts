#!/usr/bin/bash
filename="$1"
echo "Running WHOIS query: $(date)" | tee -a $1-whois.txt
echo "" | tee -a $1-whois.txt
while read -r line
do
    echo "*********************************************************************" | tee -a $1-whois.txt
    echo "*********************************************************************" | tee -a $1-whois.txt
    echo "" | tee -a $1-whois.txt
    echo "root@kali:~# whois " $line | tee -a $1-whois.txt
    echo "WHOIS query for:" $line | tee -a $1-whois.txt
    whois -H --verbose $line | tee -a $1-whois.txt
    echo "" | tee -a $1-whois.txt
done < "$filename"
