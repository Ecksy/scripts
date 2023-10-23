#!/usr/bin/env python3

import re
import argparse

def process_file(input_file):
    # Regular expression to extract domain names and IP addresses
    domain_re = re.compile(r'root@kali:~# dig a (\S+) \+short')
    ip_re = re.compile(r'^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})$')

    with open(input_file, 'r') as f:
        lines = f.readlines()

    domain_to_ip = {}
    ip_set_to_domain = {}

    for line in lines:
        # Extract domain
        domain_match = domain_re.search(line)
        if domain_match:
            current_domain = domain_match.group(1)
            if current_domain not in domain_to_ip:
                domain_to_ip[current_domain] = set()
        # Extract IP addresses
        ip_match = ip_re.search(line)
        if ip_match:
            ip = ip_match.group(1)
            domain_to_ip[current_domain].add(ip)

    for domain, ips in domain_to_ip.items():
        ip_tuple = tuple(sorted(ips))  # Convert set to tuple to be used as a dict key
        ip_set_to_domain.setdefault(ip_tuple, []).append(domain)

    # Filter IP sets that are common to more than one domain
    common_ip_sets = {k: v for k, v in ip_set_to_domain.items() if len(v) > 1}

    # Output results
    if common_ip_sets:
        print("Domains with common IP addresses:")
        print("---------------------------------")
        for ips, domains in common_ip_sets.items():
            print(f"Domains: {', '.join(domains)}")
            print(f"IP Addresses: {', '.join(ips)}\n")
    else:
        print("No domains with common IP addresses found.")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Process dig results to find common domains with the same IPs.')
    parser.add_argument('-i', '--input', required=True, help='Path to the input file with dig results.')

    args = parser.parse_args()
    
    process_file(args.input)
