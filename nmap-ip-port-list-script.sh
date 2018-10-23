#!/usr/bin/bash
echo ""
echo "********** Here are your gnmap files **********"
echo ""
ls *.gnmap
echo ""
echo "********** Select file(s) to process **********"
read -ep "Enter filename(s): " filename
echo ""
cat $filename | grep open | awk '{printf "%s\t", $2;
 for (i=4;i<=NF;i++) {
 split($i,a,"/");
 if (a[2]=="open") printf ",%s",a[1];}
print ""}' | sed -e 's/,//' | tee -a client-nmap-port-list.txt
echo ""
echo "!!!!! Wrote results to file client-nmap-port-list.txt !!!!!"
echo ""
echo ""

#one-liner
#cat filename.gnmap | grep /open | awk '{printf "%s\t", $2; for (i=4;i<=NF;i++) {split($i,a,"/"); if (a[2]=="open") printf ",%s",a[1];} print ""}' | sed -e 's/,//'
