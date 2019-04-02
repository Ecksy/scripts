#!/usr/bin/bash
filename="$1"
while read -r line
do
    echo "***********************************************************************************************" | tee -a client-nslookup.txt
#    echo "***********************************************************************************************" | tee -a client-nslookup.txt
#    echo "" | tee -a client-nslookup.txt
    echo "nslookup query for:" $line | tee -a client-nslookup.txt
    nslookup $line | tee -a client-nslookup.txt
    echo "" | tee -a client-nslookup.txt
done < "$filename"
