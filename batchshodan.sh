#!/usr/bin/bash
filename="$1"
while read -r line
do
    ./shodan_ip.py -i $line | tee -a client-shodan.txt
done < "$filename"
