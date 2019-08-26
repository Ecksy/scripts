#!/bin/bash
# ad-merge.sh: Script to merge username password hash files 
# with cracked password list
# USAGE: ad-merge.sh <username hash file> <hash file cracked passwords>
#
filename="$1"
filename2="$2"
#Count number of hashes's
if [ $# -eq 0 ]
then
	echo "xxxxx"
	echo "xxxxx"
	exit 1;
fi
COUNTER=0
while read -r line
do
	(( COUNTER++ ))	
#Line read from file
	name=$line
#Strip / from IP (like /24) can't use that in file names
	outname=`echo $line |sed -e 's;/;-;'`
#	echo $outname
#	echo "$COUNTER: Scanning $line"
#
	HASH1=`echo $line | cut -f1 -d':'`
	PASSWD1=`echo $line | cut -f2 -d':'`
#	echo "Greping for ${HASH1^^}, $PASSWD1"
	OUTLINE=`grep ${HASH1^^} $filename2`
#	echo "OUTLINE=$OUTLINE"
	NEWOUT=`echo $OUTLINE |cut -f1 -d':'`
	echo $NEWOUT:$PASSWD1
done < "$filename"
