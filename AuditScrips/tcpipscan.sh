#!/bin/bash
PROJECT_PATH="$(pwd)"

echo -e "\n${yellowColour}Starting ${purpleColour}auto nmap${endColour}"

## Dowloadling autonmap tool
if [ ! -d "${PROJECT_PATH}/autonmap" ]; then
    COMMAND="git clone --recursive https://github.com/Fatake/autonmap.git"
    echo -e "${blueColour}[*]${endColour}Dowloading ${purpleColour}${COMMAND}${endColour}"
    run_cmd "${COMMAND}"
    run_cmd "chown -R 1000:1000 {PROJECT_PATH}/autonmap/"
fi

sudo ./autonmap/autonmap.sh -o "${NAME}" -t "-iL ${PROJECT_PATH}/Pentest_${NAME}/targets/allipaddreses.txt"
mv autonmap_* ${PROJECT_PATH}/Pentest_${NAME}
python3 ${PROJECT_PATH}/AuditScrips/ParserNMAP/parse_nmap.py -i Pentest_${NAME}/autonmap_${NAME}/${NAME}_syn_scan.xml -o Pentest_${NAME}/autonmap_${NAME}/nmap_parsed
