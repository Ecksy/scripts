#!/usr/bin/bash
filename="$1"
while read -r line
do
    gnome-terminal -- bash -c "firefox --new-tab $line"
done < "$filename"
