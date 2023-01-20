#!/bin/bash
source ./AuditScrips/utils.sh
sudoCheck
if [[ $IsSudo == 1 ]] then
    exit 1;
fi

URL_audit_Tool="https://github.com/Fatake/AuditTool.git";
PATH_audit="/op/AuditTool";
URL_autonmap_Tool="https://github.com/Fatake/autonmap.git";
PATH_autonmap="/opt/autonmap";
URL_autoffuf_Tool="https://github.com/Fatake/autoffuf.git";
PATH_autoffuf="/opt/autoffuf";
ActualPath=$(pwd)

echo -e "\n[i] Installing tools"
## auto nmap
if [ ! -d "$PATH_autonmap" ]; then
    echo -e "[+] Downloading autonmap tool from $URL_autonmap_Tool";
    cd /opt;
    git clone --recursive $URL_autonmap_Tool
fi

## auto ffuf
if [ ! -d "$PATH_autoffuf" ]; then
    echo -e "\n[+] Downloading autoffuf tool from $URL_autoffuf_Tool";
    cd /opt;
    git clone --recursive $URL_autoffuf_Tool
fi

## Audit Tool
if [ ! -d "$PATH_audit" ]; then
    echo -e "\n[+] Downloading Audit tool from $URL_audit_Tool";
    cd /opt;
    git clone --recursive $URL_audit_Tool
fi

echo -e "\n[+] Updating Sistemp and installing: dnsrecon cewl subfinder assetfinder amass";
## To do, install tools to other scrips
apt update
apt install -y dnsrecon cewl subfinder assetfinder amass