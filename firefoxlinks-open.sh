#!/usr/bin/bash
filename="$1"
lineCount=$(wc $filename | awk '{print $1}')
echo $lineCount "links in file"
read -p "Continue? Enter or Ctrl+c to quit"
while read -r line
do
    gnome-terminal -- bash -c "firefox --new-tab $line"
done < "$filename"
