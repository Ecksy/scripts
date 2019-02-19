#!/bin/bash
# Split nmap .gnmap output for common open ports
# USAGE: splitter.sh <grepable nmap files>
#
#Count number of files
if [ $# -eq 0 ]
then
	echo "Split nmap.gnmap output for common open ports 25,80,139,443,8080"
	echo "USAGE: splitter.sh <grepable nmap files>"
	exit 1;
fi
COUNTER=0
for line in "$@" 
do
	echo $line
	(( COUNTER++ ))	
#grep file
	name=$line
	outname=`echo $line | awk -F'[/.]' '{print $1}'`
#	outname=`echo $line |sed -e 's;/;-;'`
	echo $outname
	echo "$COUNTER: Scanning $line"
	grep "21/open" $name  | awk '{print $2}' | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n >> 21-$outname.txt
	grep "23/open" $name | awk '{print $2}' | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n >> 23-$outname.txt
	grep "25/open" $name | awk '{print $2}' | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n >> 25-$outname.txt
	grep "53/open" $name | awk '{print $2}' | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n >> 53-$outname.txt
	grep "80/open" $name | awk '{print $2}' | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n >> 80-$outname.txt
	grep "110/open" $name | awk '{print $2}' | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n >> 110-$outname.txt
	grep "161/open" $name | awk '{print $2}' | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n >> 161-$outname.txt
	grep "443/open" $name | awk '{print $2}' | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n >> 443-$outname.txt
	grep "3389/open" $name | awk '{print $2}' | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n >> 3389-$outname.txt
	grep "500/open" $name  | awk '{print $2}' | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n >> 500-$outname.txt
	grep "389/open" $name  | awk '{print $2}' | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n >> 389-$outname.txt
	grep "8080/open" $name  | awk '{print $2}' | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n >> 8080-$outname.txt
	grep "/open" $name  | awk '{print $2}' | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n >> all-$outname.txt
	echo "--------------------------------------"
done 
