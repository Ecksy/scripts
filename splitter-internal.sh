#!/bin/bash
# Split nmap.gnmap output for common open ports
# USAGE: splitter.sh <grepable nmap files>
#
#Count number of files
if [ $# -eq 0 ]
then
	echo "Split nmap.gnmap output for common open internal ports 25,80,139,443,8080"
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
	grep "25/open" $name  | awk '{print $2}' | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n >> 25-$outname.txt
	grep "135/open" $name | awk '{print $2}' | sort -t. -k1,1n -k2.2n -k3,3n -k4,4n >> 135-$outname.txt
	grep "1434/open" $name | awk '{print $2}' | sort -t. -k1,1n -k2.2n -k3,3n -k4,4n >> 1434-$outname.txt
	grep "137/open" $name | awk '{print $2}' | sort -t. -k1,1n -k2.2n -k3,3n -k4,4n >> 137-$outname.txt
	grep "138/open" $name | awk '{print $2}' | sort -t. -k1,1n -k2.2n -k3,3n -k4,4n >> 138-$outname.txt
	grep "1433/open" $name | awk '{print $2}' | sort -t. -k1,1n -k2.2n -k3,3n -k4,4n >> 1433-$outname.txt
	grep "23/open" $name | awk '{print $2}' | sort -t. -k1,1n -k2.2n -k3,3n -k4,4n >> 23-$outname.txt
	grep "53/open" $name | awk '{print $2}' | sort -t. -k1,1n -k2.2n -k3,3n -k4,4n >> 53-$outname.txt
	grep "80/open" $name | awk '{print $2}' | sort -t. -k1,1n -k2.2n -k3,3n -k4,4n >> 80-$outname.txt
	grep "139/open" $name  | awk '{print $2}' | sort -t. -k1,1n -k2.2n -k3,3n -k4,4n >> 139-$outname.txt
	grep "443/open" $name  | awk '{print $2}' | sort -t. -k1,1n -k2.2n -k3,3n -k4,4n >> 443-$outname.txt
	grep "8080/open" $name  | awk '{print $2}' | sort -t. -k1,1n -k2.2n -k3,3n -k4,4n >> 8080-$outname.txt
	grep "9001/open" $name  | awk '{print $2}' | sort -t. -k1,1n -k2.2n -k3,3n -k4,4n >> 9001-$outname.txt
	grep "/open" $name  | awk '{print $2}' | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n >> all-$outname.txt
	echo "--------------------------------------"
done 
