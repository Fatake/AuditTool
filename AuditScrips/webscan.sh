#!/bin/bash

echo -e "\n${yellowColour}Starting ${purpleColour}whatweb${endColour}"
TOOL_PATH="$(pwd)/Pentest_${NAME}/whatweb"

if [ ! -d "${TOOL_PATH}" ]; then
    echo -e "${greenColour}[+]${endColour} Creating  dir ${TOOL_PATH}/"
    run_cmd "mkdir ${TOOL_PATH}"
fi

for d in $(cat Pentest_${NAME}/targets/domains.txt); do 
    whatweb --log-xml ${TOOL_PATH}/out_${d}.xml -v -a 3 $d
done 


echo -e "${greenColour}\n[*] Taking screenshots of HTTP Services${endColour}"

## Making files
FILE_HTTPSERVICES="$(pwd)/Pentest_${NAME}/gowitness_HTTPServicesScreenshots/"
FILE_SUBDOMAINS="$(pwd)/Pentest_${NAME}/gowitness_SubdomainsScreenshots/"

if [ ! -d "${FILE_HTTPSERVICES}" ]; then
    echo -e "${greenColour}[+]${endColour} Creating  dir ${FILE_HTTPSERVICES}/"
    run_cmd "mkdir ${FILE_HTTPSERVICES}"
fi
if [ ! -d "${FILE_SUBDOMAINS}" ]; then
    echo -e "${greenColour}[+]${endColour} Creating  dir ${FILE_SUBDOMAINS}/"
    run_cmd "mkdir ${FILE_SUBDOMAINS}"
fi

for d in $(cat Pentest_${NAME}/autonmap_${NAME}/*.xml); do 
    gowitness nmap --file $d --service http --service https
    gowitness nmap --file $d --no-http
done 

i=1
for d in $(cat Pentest_${NAME}/targets/urls.xml Pentest_${NAME}/targets/domains.xml Pentest_${NAME}/targets/Subdomains); do 
    gowitness single -o Captura_${i}.png $d
    ((i=i+1))
done 
