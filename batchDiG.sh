#!/bin/bash

# Function to run dig on a domain
run_dig() {
    local domain=$1
    echo "Results for $domain:"
    dig a "$domain" +short
    echo "" # Adding a newline for better readability between domain results
}

# Check for input
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <domain_list_file or domain_name>"
    exit 1
fi

# Check if input is a file or a domain
if [ -f "$1" ]; then
    # Input is a file, process each line
    while IFS= read -r domain
    do
        run_dig "$domain"
    done < "$1"
else
    # Input is assumed to be a domain name
    run_dig "$1"
fi
