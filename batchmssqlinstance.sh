#!/usr/bin/bash
filename="$1"
echo "Running Impacket MSSQL Instance queries: $(date)" | tee -a $1-mssqlinstance.txt
echo "" | tee -a $1-mssqlinstance.txt
while read -r line
do
    echo "Querying $line for SQL Instances:" | tee -a $1-mssqlinstance.txt
    impacket-mssqlinstance $line | tee -a $1-mssqlinstance.txt
    echo "" | tee -a $1-mssqlinstance.txt
done < "$filename"
