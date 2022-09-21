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


WORDLIST_PATH="/home/kali/Documents/Tools/SecLists/"
WORDLIST="-w ${WORDLIST_PATH}/Discovery/Web-Content/big.txt "
EXTENSIONS="-e conf,config,bak,backup,swp,old,db,sql,asp,aspx,aspx~,asp~,py,py~,rb,rb~,php,php~,bak,bkp,cache,cgi,conf,csv,html,inc,jar,js,json,jsp,jsp~,lock,log,rar,old,sql,sql.gz,sql.zip,sql.tar.gz,sql~,swp,swp~,tar,tar.bz2,tar.gz,txt,wadl,zip,.log,.xml,.js.,.json"
RECURSION="-recursion -recursion-depth 2"
REPLAY_PROXY="-replay-proxy http://127.0.0.1:8080"
THREADS="-t 10"

#Optional
COOKIES="-b 'visid_incap_1358118=aV3YZIcXTGqCqpFEm5u2JFlPK2MAAAAAQUIPAAAAAAB7dZiNVP+1CefacooTDh4N; JSESSIONID=L7k4jrnpsxhLn0Wf24GngjG8SLvPgJF1MBbRTn481mfpdPDQjP0G!-2056007853; incap_ses_1054_1358118=NMx4cBE6YQwj3p8nfZCgDtRTK2MAAAAAh3JZUrGB7Bk1mSoHEOccJg==; incap_ses_1059_1358118=V0+hZc5RrVfW0BaOBlOyDjNUK2MAAAAA54wBHz4W4nWZva3uAUdUXQ==; incap_ses_1435_1358118=y66nYdwpcjUmiUYyUybqE+tUK2MAAAAAcSZUgFsiiv0foqvSHjvDDA==; incap_ses_1053_1358118=L3kjCb0anFK6yGNWGgKdDtltK2MAAAAA+OLBBGm0QQg0owIQleLn0A=='"

i=1
echo -e "${greenColour}\n[*] Auto ffuff directories listing${endColour}"
echo -e "<------------------------------->";
for target in $(cat Targets.txt); do
	COMMAND="ffuf -r ${RECURSION} ${REPLAY_PROXY} ${WORDLIST} ${COOKIES} -ac -o ffuf_target${i}.html -of html ${THREADS} -u ${target}/FUZZ"
	echo -e "\n\n[i] Directorie listing Target#${i}: ${target}";
	echo -e "<------------------------------->";
	echo -e "kali$ ${COMMAND}"
	echo -e "<------------------------------->\n";
	eval $COMMAND
	((i=i+1))
done;


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
