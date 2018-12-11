#!/bin/bash
# Split nmap.gnmap output for common open ports
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
	grep "25/open" $name  | awk '{print $2}'>>25-$outname.txt
	grep "135/open" $name | awk '{print $2}'>> 135-$outname.txt
	grep "1434/open" $name | awk '{print $2}'>> 1434-$outname.txt
	grep "137/open" $name | awk '{print $2}'>> 137-$outname.txt
	grep "138/open" $name | awk '{print $2}'>> 138-$outname.txt
	grep "1433/open" $name | awk '{print $2}'>> 1433-$outname.txt
	grep "23/open" $name | awk '{print $2}'>> 23-$outname.txt
	grep "53/open" $name | awk '{print $2}'>> 53-$outname.txt
	grep "80/open" $name | awk '{print $2}'>> 80-$outname.txt
	grep "139/open" $name  | awk '{print $2}'>>139-$outname.txt
	grep "443/open" $name  | awk '{print $2}'>>443-$outname.txt
	grep "8080/open" $name  | awk '{print $2}'>>8080-$outname.txt
	grep "9001/open" $name  | awk '{print $2}'>>9001-$outname.txt
	grep "/open" $name  | awk '{print $2}'>>all-$outname.txt
	echo "--------------------------------------"
done 
