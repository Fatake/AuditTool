#!/bin/bash

echo -e "${greenColour}\n[*] Taking screenshots of HTTP Services${endColour}"

## Making files
FILE_HTTPSERVICES="pentest/${NAME}_gowitness_HTTPServicesScreenshots/"
FILE_SUBDOMAINS="pentest/${NAME}_gowitness_SubdomainsScreenshots/"
run_cmd "mkdir ${FILE_HTTPSERVICES}"
run_cmd "mkdir ${FILE_SUBDOMAINS}"

COMMAND="gowitness "
run_cmd "mkdir pentest/dnsrecon/"
"SS-${NAME}-Targets" -d 
"gowitness --web -f targets/urls.txt 
--proxy-ip 127.0.0.1 --proxy-port 8080 
--proxy-type http --timeout 30 
--max-retries 2 --delay 1 -d 
pentest/${NAME}_gowitness_HTTPServicesScreenshots/ --no-prompt --show-selenium"



"SS-${NAME}-HTTPServices" -d "gowitness --web -x pentest/${NAME}_autonmap_servicescan.xml --proxy-ip 127.0.0.1 --proxy-port 8080 --proxy-type http --timeout 30 --max-retries 2 --delay 1 -d pentest/${NAME}_gowitness_HTTPServicesScreenshots/ --no-prompt --show-selenium"
"SS-${NAME}-Subdomains" -d "gowitness --web -f pentest/subdomains.txt --proxy-ip 127.0.0.1 --proxy-port 8080 --proxy-type http --timeout 30 --max-retries 2 --delay 1 -d pentest/${NAME}_gowitness_SubdomainsScreenshots/ --no-prompt --show-selenium --prepend-https"
ls
