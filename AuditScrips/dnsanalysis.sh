#!/bin/bash
#  Inportart Commands Used
    #    -d [domainTarget] -t [std|axfr|zonewalk|bing] -c [outputFiel].csv
    # dnsrecon -d [IP] -t rvl -c [outputfile].cvs
    # to do dnsenum
    # to do fierce
    # to do dnsmap
# <----------------------- dnsrecon space ----------------------->
echo -e "\n${yellowColour}Starting ${purpleColour}dnsrecon${endColour}"
TOOL_PATH="$(pwd)/Pentest_${NAME}/dnsrecon"

if [ ! -d "${TOOL_PATH}" ]; then
    echo -e "${greenColour}[+]${endColour} Creating  dir ${TOOL_PATH}/"
    run_cmd "mkdir ${TOOL_PATH}"
fi

## dnsrecon for domains
for d in $(cat Pentest_${NAME}/targets/domains.txt); do 
    dnsrecon -d $d --disable_check_bindversion -t std -c ${TOOL_PATH}/dnsrecon_stdrecon_$d.csv
    dnsrecon -d $d -t axfr -c ${TOOL_PATH}/dnsrecon_axfr_$d.csv 
    dnsrecon -d $d -t zonewalk -c ${TOOL_PATH}/dnsrecon_crt_$d.csv 
    # dnsrecon -d $d -t bing -c ${TOOL_PATH}/dnsrecon_bing_$d.csv 
done 

## dnsrecon reverse IP
for d in $(cat Pentest_${NAME}/targets/allipaddreses.txt); do 
    dnsrecon -d $d -t rvl -c $TOOL_PATH/dnsrecon_rvl_$d.csv
done 

for f in $TOOL_PATH/dnsrecon_*.csv; do 
    awk -v d=$(echo ${f} | cut -d "_" -f 4 ) 'NR>1 {print d","$0}' $f
done | sort -u >> $TOOL_PATH/dnsrecon_all.txt


# <----------------------- Dig space ----------------------->
echo -e "\n${yellowColour}Starting ${purpleColour}dig nameservers${endColour}"
for d in $(cat Pentest_${NAME}/targets/domains.txt); do 
    dig +multi NS $d +noall +answer | cut -f4 | sed 's/.$//'
done | sort -u > Pentest_${NAME}/nameservers.txt

for ns in $(cat Pentest_${NAME}/nameservers.txt); do 
    for d in $(cat Pentest_${NAME}/targets/domains.txt); do 
        echo -e "AXFR\tnameserver:\t${ns}\tdomain:\t${d}" && dig @${ns} AXFR $d +noall +answer 
    done  
done  >> Pentest_${NAME}/axfr.txt

# <----------------------- amass, subfinder assetfinder ---------------------->
echo -e "\n${yellowColour}Starting ${purpleColour}amass, subfinder${endColour}"
for d in $(cat Pentest_${NAME}/targets/domains.txt); do 
    subfinder -d $d >> Pentest_${NAME}/foundsubdomains.txt
    assetfinder -subs-only $d >> Pentest_${NAME}/foundsubdomains.txt
    amass enum -d $d -config /opt/AuditTool/ConfigUtils/amass.conf -o Pentest_${NAME}/ammas_output_$d.txt >> Pentest_${NAME}/foundsubdomains.txt
    #amass enum -brute -w AuditScrips/WorldList/DNS_plussFinancial.dic -d $d >> Pentest_${NAME}/foundsubdomains.txt
    #amass enum -brute -w Pentest_${NAME}/custom_dictionary_${NAME}.lst -d $d >> Pentest_${NAME}/foundsubdomains.txt

    ## next line dont uncomment, it is only for really special clients 
    ## and/or when thoroughness is mandatory, 
    ## better to be used whit a lot of open resolvers
    #amass enum -brute -w /opt/rlyeh/dictionaries/DNS_allsubdomains.dic -d $d >> Pentest_${NAME}/foundsubdomains.txt
done 

cat Pentest_${NAME}/foundsubdomains.txt | sort -u > Pentest_${NAME}/subdomains.txt

for h in $(cat Pentest_${NAME}/targets/subdomains.txt); do 
    host $h
done >> Pentest_${NAME}/targets/all_resolved_subdomains.txt

cat Pentest_${NAME}/targets/all_resolved_subdomains.txt | grep "has address" | sed 's/ has address /\t/g' | sort -u | cut -f2 | sort -u > Pentest_${NAME}/all_ipv4addreses.txt
