#!/usr/bin/bash
filename="$1"
echo "Running Traceroute: $(date)" | tee -a client-tracert.txt
echo "" | tee -a client-tracert.txt
while read -r line
do
    echo "***********************************************************************************************" | tee -a client-tracert.txt
    echo "***********************************************************************************************" | tee -a client-tracert.txt
    echo "" | tee -a client-tracert.txt
    echo "Traceroute for:" $line | tee -a client-tracert.txt
    traceroute -n $line | tee -a client-tracert.txt
    echo "" | tee -a client-tracert.txt
done < "$filename"
