##Convert host lists into IP addresses


#!/bin/bash
echo -e "${greenColour}\n[*] Starting DNS resolutions${endColour}"

echo -e "\n\t${turquoiseColour}Resolving hosts${endColour}"
for h in $(cat targets/domains.txt); do ( host $h); done > pentest/resolved_hosts.txt
for h in $(cat targets/subdomains.txt); do ( host $h); done >> pentest/resolved_hosts.txt

echo -e "\t${turquoiseColour}Resolving IP addresses${endColour}"
for h in $(cat targets/ipaddresses.txt); do ( host $h); done > pentest/resolved_ptrs.txt
cat pentest/resolved_hosts.txt | grep "has address" | sed 's/ has address /\t/g' | sort -u | cut -f2 > pentest/hosts2ipv4addreses.txt
cat pentest/resolved_hosts.txt | grep "has IPv6 address" | sed 's/ has IPv6 address /\t/g' | sort -u | cut -f2 > pentest/hosts2ipv6addreses.txt

echo -e "\n${yellowColour}##################"
echo "Resolved hostnames"
echo -e "##################${endColour}"
cat pentest/resolved_hosts.txt
cat pentest/resolved_ptrs.txt

echo -e "\n${yellowColour}##################"
echo "Unique IP addresses"
echo -e "##################${endColour}"
cat pentest/hosts2ipv4addreses.txt
cat pentest/hosts2ipv6addreses.txt
