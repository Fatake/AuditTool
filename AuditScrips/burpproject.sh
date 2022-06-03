#!/bin/bash

##Starting Burp
echo -e "${greenColour}Stating burp${endColour}"
sudo -u kali tmux new -d "/opt/BurpSuitePro/BurpSuitePro --project-file=$(pwd)/pentest/$(NAME)_project.burp --user-config-file=/home/kali/configs/nointercept.burp.conf.json"
