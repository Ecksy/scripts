#!/usr/bin/bash
filename="$1"
echo "Checking SMB shares: $(date)" | tee -a client-smblist.txt
echo "" | tee -a client-smblist.txt
while read -r line
do
    echo "*********************************************************************" | tee -a client-smblist.txt
    echo "*********************************************************************" | tee -a client-smblist.txt
    echo "" | tee -a client-smblist.txt
    echo "SMB shares for:" $line | tee -a client-smblist.txt
    smbclient -N -L //$line | tee -a client-smblist.txt
    echo "" | tee -a client-smblist.txt
done < "$filename"
