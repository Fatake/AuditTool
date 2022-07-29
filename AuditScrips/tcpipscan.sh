#!/bin/bash
echo -e "${greenColour}[*]${endColour} Starting ${purpleColour}nmap${endColour}"
git clone --recursive https://github.com/Fatake/autonmap.git

if [ ! -d "Pentest_${NAME}/nmap" ]  then
    run_cmd "mkdir pentest/nmap/"
fi

sudo /autonmap/autonmap.sh -o Pentest_${NAME}/nmap/"${NAME}" -t "-iL Pentest_${NAME}/hosts2ipv4addreses.txt"
python3 AuditScrips/ParserNMAP/parse_nmap.py -i pentest/nmap/autonmap_${NAME}_openports.xml -o pentest/nmap/nmap_parsed

rm -rf autonmap/
