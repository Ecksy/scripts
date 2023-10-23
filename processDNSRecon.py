#!/usr/bin/env python3

import argparse
from collections import defaultdict

def parse_dnsrecon_output(filename):
    with open(filename, 'r') as file:
        data = file.read()

    # Splitting each domain's records block
    blocks = data.split("*********************************************************************\n*********************************************************************")

    # Data structure to store parsed data
    domain_to_records = defaultdict(set)

    # Parsing each block
    for block in blocks:
        lines = block.strip().split("\n")
        domain = None
        for line in lines:
            if line.startswith("root@kali:~# dnsrecon -d"):
                domain = line.split()[-1]
            elif " MX " in line or " A " in line:
                parts = line.split()
                record = parts[-1]  # Last part is the IP or domain for MX/A
                domain_to_records[domain].add(record)

    return domain_to_records

def find_common_domains(domain_to_records):
    ip_to_domains = defaultdict(set)

    for domain, records in domain_to_records.items():
        for record in records:
            ip_to_domains[tuple(records)].add(domain)

    # Filtering for domains with common IPs
    common_domains = {k: v for k, v in ip_to_domains.items() if len(v) > 1}

    return common_domains

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Process dnsrecon output to find domains with common MX/A records.")
    parser.add_argument('-i', '--input', help='Input file containing dnsrecon output.', required=True)

    args = parser.parse_args()

    domain_to_records = parse_dnsrecon_output(args.input)
    common_domains = find_common_domains(domain_to_records)

    print("Domains with common MX/A Records:")
    print("---------------------------------")
    for records, domains in common_domains.items():
        print("Domains:", ", ".join(sorted(domains)))
        print("MX/A Records:", ", ".join(records))
        print()

