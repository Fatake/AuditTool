#!/bin/bash

echo -e "\n${yellowColour}Starting ${purpleColour}auto nmap${endColour}"

AUTONMAP_PATH="/opt/AuditTool/autonmap/autonmap.sh"
sudo bash ${AUTONMAP_PATH} -o "${NAME}" -t "-iL $(pwd)/Pentest_${NAME}/targets/allipaddreses.txt"
mv autonmap_* ${PROJECT_PATH}/Pentest_${NAME}
python3 ${PROJECT_PATH}/AuditScrips/ParserNMAP/parse_nmap.py -i Pentest_${NAME}/autonmap_${NAME}/${NAME}_syn_scan.xml -o Pentest_${NAME}/autonmap_${NAME}/nmap_parsed
