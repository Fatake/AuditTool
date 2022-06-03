#!/bin/bash

sudo /opt/autonmap/autonmap.sh -o pentest/"${NAME}" -t "-iL pentest/all_ipv4addreses.txt"
./parse_nmap.py -i pentest/${NAME}_autonmap_servicescan.xml -o pentest/nmap_parsed
