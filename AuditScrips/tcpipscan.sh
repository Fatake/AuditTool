#!/bin/bash
echo -e "${greenColour}[*]${endColour} Starting ${purpleColour}nmap${endColour}"
git clone --recursive https://github.com/cthulhu897/autonmap.git
mr -rf autonmap/.git

if [ ! -d "pentest/nmap" ]  then
    run_cmd "mkdir pentest/nmap/"
fi
sudo autonmap/autonmap.sh -o pentest/nmap/"${NAME}" -t "-iL pentest/hosts2ipv4addreses.txt"
python3 AuditScrips/ParserNMAP/parse_nmap.py -i pentest/nmap/${NAME}_autonmap_servicescan.xml -o pentest/nmap/nmap_parsed
