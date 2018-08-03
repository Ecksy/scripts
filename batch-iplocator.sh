#!/usr/bin/bash
filename="$1"
while read -r line
do
    ./iplocator.pl $line | tee -a iplocator.out.txt
done < "$filename"
