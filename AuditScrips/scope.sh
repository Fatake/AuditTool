#!/bin/bash
##Convert host lists into IP addresses

for h in $(cat Pentest_${NAME}/targets/domains.txt Pentest_${NAME}/targets/subdomains.txt); do 
    host $h
done > Pentest_${NAME}/targets/resolved_hosts.txt

for h in $(cat Pentest_${NAME}/targets/ipaddresses.txt);  do 
    host $h
done > Pentest_${NAME}/targets/resolved_ptrs.txt

cat Pentest_${NAME}/targets/resolved_hosts.txt | grep "has address" | sed 's/ has address /\t/g' | sort -u | cut -f2 > Pentest_${NAME}/targets/hosts2ipv4addreses.txt
cat Pentest_${NAME}/targets/resolved_hosts.txt | grep "has IPv6 address" | sed 's/ has IPv6 address /\t/g' | sort -u | cut -f2 > Pentest_${NAME}/targets/hosts2ipv6addreses.txt

echo -e "${yellowColour}Resolved hostnames${endColour}"
cat Pentest_${NAME}/targets/resolved_hosts.txt Pentest_${NAME}/targets/resolved_ptrs.txt

echo -e "\n${yellowColour}IP addresses${endColour}"
cat Pentest_${NAME}/targets/hosts2ipv4addreses.txt Pentest_${NAME}/targets/hosts2ipv6addreses.txt Pentest_${NAME}/targets/ipaddresses.txt