#!/usr/bin/bash
filename="$1"
lineCount=$(wc $filename | awk '{print $1}')

#Comment and uncomment below for port suffix

filename2=$(awk '{print "http://" $1}' "$filename")
#filename2=$(awk '{print "https://" $1}' "$filename")
#filename2=$(awk '{print "http://" $1 ":8080"}' "$filename")
echo "$filename2" > "${filename}-links.txt"
echo 'Success!!! File created with $lineCount links.'
