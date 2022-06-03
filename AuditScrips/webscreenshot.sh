#!/bin/bash

echo -e "${greenColour}\n[*] Taking screenshots of HTTP Services${endColour}"
mkdir pentest/${NAME}_EyeWitness_HTTPServicesScreenshots/
chown -R kali:kali pentest/${NAME}_EyeWitness_HTTPServicesScreenshots/
mkdir pentest/${NAME}_EyeWitness_SubdomainsScreenshots/
chown -R kali:kali pentest/${NAME}_EyeWitness_SubdomainsScreenshots/
sudo -u kali tmux new -s "SS-${NAME}-Targets" -d "eyewitness --web -f targets/urls.txt --proxy-ip 127.0.0.1 --proxy-port 8080 --proxy-type http --timeout 30 --max-retries 2 --delay 1 -d pentest/${NAME}_EyeWitness_HTTPServicesScreenshots/ --no-prompt --show-selenium"
sudo -u kali tmux new -s "SS-${NAME}-HTTPServices" -d "eyewitness --web -x pentest/${NAME}_autonmap_servicescan.xml --proxy-ip 127.0.0.1 --proxy-port 8080 --proxy-type http --timeout 30 --max-retries 2 --delay 1 -d pentest/${NAME}_EyeWitness_HTTPServicesScreenshots/ --no-prompt --show-selenium"
sudo -u kali tmux new -s "SS-${NAME}-Subdomains" -d "eyewitness --web -f pentest/subdomains.txt --proxy-ip 127.0.0.1 --proxy-port 8080 --proxy-type http --timeout 30 --max-retries 2 --delay 1 -d pentest/${NAME}_EyeWitness_SubdomainsScreenshots/ --no-prompt --show-selenium --prepend-https"
tmux ls
