#!/bin/bash

echo "\n${greenColour}[*] Analyzing security headers${endColour}"
for t in $(cat pentest/all_urls.lst ); do ( echo "https://securityheaders.com/?q=$(urlencode $t)&followRedirects=on"  >> pentest/securityheaders_urls.txt ); done 
mkdir pentest/${NAME}_SecurityHeaders_targets/
chown -R kali:kali pentest/${NAME}_SecurityHeaders_targets/
sudo -u kali tmux new -d "eyewitness --web -f pentest/securityheaders_urls.txt --timeout 30 --max-retries 1 --delay 8 -d pentest/${NAME}_SecurityHeaders_targets/ --no-prompt --show-selenium"
