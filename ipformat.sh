#!/bin/bash
# Take a file of IP addresses and format for usage in reports
# and Nessus. 
# USAGE: ipformat.sh <file with ip addresses or ranges>
#
filename="$1"
#Count number of IP's
if [ $# -eq 0 ]
then
	echo "Take a file of IP addresses and format for usage in reports and Nessus" 
	echo "USAGE: ipformat.sh <file with ip addresses or ranges>"
	exit 1;
fi
COUNTER=0
while read -r line
do
	(( COUNTER++ ))	
#Line read from file
	name=$line
#Strip / from IP (like /24) can't use that in file names
#	outname=`echo $line |sed -e 's;/;-;'`
	echo -n "$line, "
#
done < "$filename"