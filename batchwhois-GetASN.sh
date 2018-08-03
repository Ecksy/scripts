#!/usr/bin/bash
filename="$1"
while read -r line
do
    whois -h whois.cymru.com -v $line >> whoisASN.out.txt
done < "$filename"
