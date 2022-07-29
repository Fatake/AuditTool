#!/bin/bash

echo -e "\n${yellowColour}Starting ${purpleColour}auto nmap${endColour}"
COMMAND="git clone --recursive https://github.com/Fatake/autonmap.git"
echo -e "${blueColour}[*]${endColour}Dowloading ${COMMAND}"

run_cmd "${COMMAND}"

TOOL_PATH="$(pwd)/Pentest_${NAME}/nmap"
if [ ! -d "${TOOL_PATH}" ]; then
    echo -e "${greenColour}[+]${endColour} Creating  dir ${TOOL_PATH}/"
    run_cmd "mkdir ${TOOL_PATH}"
fi

echo -e "\n${yellowColour}Starting ${purpleColour}autonmap script${endColour}"
$(pwd)/autonmap/autonmap.sh -o Pentest_${NAME}/nmap/"${NAME}" -t "-iL Pentest_${NAME}/allipaddreses.txt"

# Cambiar biblioteca
##python3 AuditScrips/ParserNMAP/parse_nmap.py -i pentest/nmap/autonmap_${NAME}_openports.xml -o Pentest_${NAME}/nmap/nmap_parsed

rm -rf autonmap/
