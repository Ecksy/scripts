#!/usr/bin/bash
filename="$1"
while read -r line
do
    ./iplocator.pl $line | tee -a $1-iplocator.txt
sleep .8
done < "$filename"
