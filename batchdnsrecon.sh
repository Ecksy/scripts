#!/usr/bin/bash
filename="$1"
while read -r line
do
    dnsrecon -d $line >> dnsrecon.out.txt
done < "$filename"
