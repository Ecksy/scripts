#!/usr/bin/bash
#ForgetYouFirefoxESR!
filename="$1"
lineCount=$(wc $filename | awk '{print $1}')
echo ""
echo $lineCount "links in file."
read -p "Continue? Enter or Ctrl+c to quit"
while read -r line
do
    gnome-terminal -- bash -c "google-chrome --no-sandbox --ignore-certificate-errors $line"
done < "$filename"
