#!/usr/bin/bash
filename="$1"
while read -r line
do
    ./iplocator.pl $line | tee -a client-iplocator.txt
done < "$filename"
