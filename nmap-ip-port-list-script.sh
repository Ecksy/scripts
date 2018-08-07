#!/usr/bin/bash
echo ""
echo "********** Listing Directory Contents for gnmap extension **********"
echo ""
ls *.gnmap
echo ""
echo "********** Select file to process **********"
read -p "Enter filename: " filename
echo ""
cat $filename | grep open | awk '{printf "%s\t", $2;
 for (i=4;i<=NF;i++) {
 split($i,a,"/");
 if (a[2]=="open") printf ",%s",a[1];}
print ""}' | sed -e 's/,//' | tee -a nmap-port-list.txt
echo ""

#one-liner
#cat filename.gnmap | grep /open | awk '{printf "%s\t", $2; for (i=4;i<=NF;i++) {split($i,a,"/"); if (a[2]=="open") printf ",%s",a[1];} print ""}' | sed -e 's/,//'
