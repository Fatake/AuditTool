#!/bin/bash

##
## What WEb
##
echo -e "\n${yellowColour}Starting ${purpleColour}whatweb${endColour}"
TOOL_PATH="$(pwd)/Pentest_${NAME}/whatweb"

if [ ! -d "${TOOL_PATH}" ]; then
    echo -e "${greenColour}[+]${endColour} Creating  dir ${TOOL_PATH}/"
    run_cmd "mkdir ${TOOL_PATH}"
fi

for d in $(cat Pentest_${NAME}/targets/domains.txt); do 
    whatweb --log-xml ${TOOL_PATH}/out_${d}.xml -v -a 3 $d
done 

##
## Auto ffuf
##
WORDLIST_PATH="/home/kali/Documents/Tools/SecLists/"
WORDLIST="-w ${WORDLIST_PATH}/Discovery/Web-Content/big.txt "
EXTENSIONS="-e conf,config,bak,backup,swp,old,db,sql,asp,aspx,aspx~,asp~,py,py~,rb,rb~,php,php~,bak,bkp,cache,cgi,conf,csv,html,inc,jar,js,json,jsp,jsp~,lock,log,rar,old,sql,sql.gz,sql.zip,sql.tar.gz,sql~,swp,swp~,tar,tar.bz2,tar.gz,txt,wadl,zip,.log,.xml,.js.,.json"
RECURSION="-recursion -recursion-depth 2"
REPLAY_PROXY="-replay-proxy http://127.0.0.1:8080"
THREADS="-t 10"
## Modifie if necesarie
COOKIES="-b 'Some_some'"

i=1
echo -e "${greenColour}\n[*] Auto ffuff directories listing${endColour}"
echo -e "<------------------------------->";
for target in $(cat Pentest_${NAME}/urls.lst); do
	COMMAND="ffuf -r ${RECURSION} ${REPLAY_PROXY} ${WORDLIST} ${COOKIES} -ac -o ffuf_target${i}.html -of html ${THREADS} -u ${target}/FUZZ"
	echo -e "\n\n[i] Directorie listing Target#${i}: ${target}";
	echo -e "<------------------------------->";
	echo -e "kali$ ${COMMAND}"
	echo -e "<------------------------------->\n";
	eval $COMMAND
	((i=i+1))
done;

##
## Taking screenshots from security headers
##
echo -e "\n${greenColour}[*] Analyzing security headers${endColour}"
for targetSite in $(cat Pentest_${NAME}/urls.lst ); do 
    siteEncoded=$(python3 -c "import sys, urllib.parse as ul; print (ul.quote_plus(sys.argv[1]))" $targetSite)
    command="gowitness single ${siteEncoded}"
    eval "${command}"
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
