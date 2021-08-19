#!/usr/bin/bash
filename="$1"
method="$2"
while read -r line
do
    crackmapexec $method $line
done < "$filename"
