#!/bin/bash

echo "\n${greenColour}[*] Analyzing security headers${endColour}"

TOOL_PATH="$(pwd)/Pentest_${NAME}/SecurityHeaders_targets/"
if [ ! -d "${TOOL_PATH}" ]; then
    echo -e "${greenColour}[+]${endColour} Creating  dir ${TOOL_PATH}/"
    run_cmd "mkdir ${TOOL_PATH}"
fi

for t in $(cat Pentest_${NAME}/urls.lst ); do 
    echo "https://securityheaders.com/?q=$(urlencode $t)&followRedirects=on"  >> Pentest_${NAME}/SecurityHeaders_targets/securityheaders_urls.txt  
done 

sudo -u kali tmux new -d "eyewitness --web -f Pentest_${NAME}/SecurityHeaders_targets/securityheaders_urls.txt --timeout 30 --max-retries 1 --delay 8 -d Pentest_${NAME}/SecurityHeaders_targets/ --no-prompt --show-selenium"
