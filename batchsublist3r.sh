#!/usr/bin/bash
filename="$1"
while read -r line
do
    ./Sublist3r/sublist3r.py -d $line >> sublist3r.out.txt
done < "$filename"
