#!/usr/bin/env python3

import shodan
import sys
import argparse
import netaddr
import time

KEY = 'YOUR_SHODAN_API_KEY'  # Replace YOUR_SHODAN_API_KEY with your actual Shodan API key
api = shodan.Shodan(KEY)

def lookup_ip(ip):
    print('')
    print(ip)
    print('Querying Shodan...')
    print('=' * len(ip) * 3)
    time.sleep(1)

    try:
        host = api.host(ip)
        print('Org             : {0}'.format(host.get('org', '')))
        print('City            : {0}'.format(host.get('city', '')))
        print('State/Region    : {0}'.format(host.get('region_code', '')))
        print('Country         : {0}'.format(host.get('country_name', '')))
        print('Country Code    : {0}'.format(host.get('country_code', '')))
        print('Postal          : {0}'.format(host.get('postal_code', '')))
        print('Area Code       : {0}'.format(host.get('area_code', '')))
        print('Lat             : {0}'.format(host.get('latitude', '')))
        print('Long            : {0}'.format(host.get('longitude', '')))
        print('=' * len(ip) * 3)
        print('ISP             : {0}'.format(host.get('isp', '')))
        print('Hostname        : {0}'.format(', '.join(host.get('hostnames', []))))
        print('Reported IP     : {0}'.format(host.get('ip_str', '')))
        print('OS              : {0}'.format(host.get('os', '')))
        print('ASN             : {0}'.format(host.get('asn', '')))
        print('Ports           : {0}'.format(', '.join([str(p) for p in host['ports']])))
        print('Tags            : {0}'.format(host.get('tags', '')))
        print('Vulns           : {0}'.format(', '.join(host.get('vulns', []))))
        print('Banner          : {0}'.format(host.get('banner', '')))
        print('Device          : {0}'.format(host.get('devicetype', '')))
        print('Domain          : {0}'.format(host.get('domains', '')))
        print('Net             : {0}'.format(host.get('net', '')))
        print('Uptime          : {0}'.format(host.get('uptime', '')))
        print('')

    except shodan.APIError as e:
        print('API Error: {0}\n'.format(e))

if __name__ == '__main__':
    # Parse command line arguments using argparse
    desc = """
This script will query the Shodan API and return a list of open ports on the
specified IP addresses. The IP address(es) to check can be given as a single
IP, a range of IPs, or in CIDR notation.
"""
    parser = argparse.ArgumentParser(description=desc)
    ipgroup = parser.add_mutually_exclusive_group(required=True)
    ipgroup.add_argument('-i', action='store', default=None,
                         metavar="IP",
                         help='A single IP address. ex: 192.168.1.1')
    ipgroup.add_argument('-r', action='store', default=None,
                         metavar="IP", nargs=2,
                         help='A start and end IP address. ex: 192.168.1.1 192.168.1.10')
    ipgroup.add_argument('-c', action='store', default=None,
                         metavar="CIDR",
                         help='A range of IPs in CIDR notation. ex: 192.168.1.0/24')

    args = parser.parse_args()

    try:
        if args.i is not None:
            lookup_ip(args.i)

        elif args.r is not None:
            start, end = args.r
            ip_range = netaddr.IPRange(start, end)

            ips = []
            for c in ip_range.cidrs():
                ips.extend(c)

            for ip in sorted(set(ips)):
                lookup_ip(str(ip))

        else:
            for ip in netaddr.IPNetwork(args.c):
                lookup_ip(str(ip))

    except netaddr.AddrFormatError as e:
        print('Address Error: {0}.\n'.format(str(e)))
        parser.print_help()
        sys.exit(1)
