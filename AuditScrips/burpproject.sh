#!/bin/bash
. /opt/AuditTool/AuditScrips/utils.sh
##Starting Burp
echo -e "${greenColour}[*]${endColour} Starting burp Project ${yellowColour}$NAME-project.burp${endColour}"
TOOL_PATH="$(pwd)/Pentest_${NAME}/BurpSuitePro"
if [ ! -d "${TOOL_PATH}" ]; then
    echo -e "${greenColour}[+]${endColour} Creating  dir ${TOOL_PATH}/"
    run_cmd "mkdir ${TOOL_PATH}"
fi

BURP_BIN_PATH="/home/kali/BurpSuitePro/BurpSuitePro"
BURP_CONFIG="/opt/AuditTool/ConfigUtils/ProxyWeb_conf.json"

sudo -u kali tmux new -d "${BURP_BIN_PATH} --project-file=${TOOL_PATH}/$NAME_project.burp --user-config-file=${BURP_CONFIG}"
