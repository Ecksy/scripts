#!/bin/bash
filename="$1"
lineCount=$(wc -l < "$filename")
echo "$lineCount links in file"
read -p "Continue? Enter or Ctrl+c to quit"

# Create a string of URLs to open in Chrome
urls=""

while read -r line; do
    urls="$urls $line"
done < "$filename"

# Open all URLs in new Chrome tabs with SSL certificate bypass
google-chrome --no-sandbox --ignore-certificate-errors --new-tab $urls
