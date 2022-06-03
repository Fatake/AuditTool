#!/bin/bash

##Starting Burp
echo -e "${greenColour}[*]${endColour} Stating burp Project ${yellowColour}$NAME-project.burp${endColour}"
sudo -u kali tmux new -d "/opt/BurpSuitePro/BurpSuitePro --project-file=./pentest/$NAME-project.burp --user-config-file=/home/kali/configs/nointercept.burp.conf.json"
