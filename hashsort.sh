#!/bin/bash
# Take a file of hashes and sorts out unique entries. 
# USAGE: hashsort.sh <file with hashes>
#
filename="$1"
if [ $# -eq 0 ]
then
	echo "Take a file of hashes and sorts out unique entries." 
	echo "USAGE: hashsort.sh <file with hashes>"
	exit 1;
fi
sort -t: -u -k1,1 $1 > sort-$1