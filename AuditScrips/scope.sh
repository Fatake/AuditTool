#!/bin/bash
##Convert host lists into IP addresses
: '
Commands used:
    $host [target]
'
echo -e "\n${greenColour}[*]${endColour} Starting DNS resolutions"

for h in $(cat pentest/targets/domains.txt pentest/targets/subdomains.txt); do 
    host $h
done > pentest/resolved_hosts.txt

for h in $(cat pentest/targets/ipaddresses.txt);  do 
    host $h
done > pentest/resolved_ptrs.txt

cat pentest/resolved_hosts.txt | grep "has address" | sed 's/ has address /\t/g' | sort -u | cut -f2 > pentest/hosts2ipv4addreses.txt
cat pentest/resolved_hosts.txt | grep "has IPv6 address" | sed 's/ has IPv6 address /\t/g' | sort -u | cut -f2 > pentest/hosts2ipv6addreses.txt

echo -e "${yellowColour}Resolved hostnames${endColour}"
cat pentest/resolved_hosts.txt pentest/resolved_ptrs.txt

echo -e "\n${yellowColour}Unique IP addresses${endColour}"
cat pentest/hosts2ipv4addreses.txt pentest/hosts2ipv6addreses.txt