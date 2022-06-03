#!/bin/bash
source utils.sh

# <----------------------- DNS Recon ----------------------->
echo -e "\n${blueColour}[*]${endColour} Starting ${purpleColour}dnsrecon${endColour}"

if [ ! -d "pentest/dnsrecon" ]  then
    run_cmd "mkdir pentest/dnsrecon/"
fi
path="$(pwd)/pentest/dnsrecon"

for d in $(cat pentest/targets/domains.txt); do 
    dnsrecon  -d $d --disable_check_bindversion -t std -c $path/${NAME}_dnsreconstdrecon_$d.csv  
    dnsrecon -d $d -t axfr -c $path/${NAME}_dnsrecon_axfr_$d.csv 
    dnsrecon -d $d -t zonewalk -c $path/${NAME}_dnsrecon_crt_$d.csv 
    # dnsrecon -d $d -t bing -c $path/${NAME}_dnsrecon_bing_$d.csv 
done 

for d in $(cat pentest/targets/ipaddresses.txt); do 
    dnsrecon-d $d -t rvl -c $path/${NAME}_dnsrecon_rvl_$d.csv
done 

for f in $path/${NAME}_dnsrecon_*.csv; do 
    awk -v d=$(echo ${f} | cut -d "_" -f 4 ) 'NR>1 {print d","$0}' $f
done | sort -u >> pentest/dnsrecon/${NAME}_dnsrecon_all.txt
# <----------------------- DNS Recon ----------------------->

# <----------------------- Dig space ----------------------->
echo -e "\n${blueColour}[*]${endColour} dig nameservers"
for d in $(cat pentest/targets/domains.txt); do 
    dig +multi NS $d +noall +answer | cut -f4 | sed 's/.$//'
done | sort -u > pentest/nameservers.txt

echo -e "\n${blueColour}[*]${endColour} dig zonetransfers"
for ns in $(cat pentest/nameservers.txt); do 
    for d in $(cat pentest/targets/domains.txt); do 
    echo -e "AXFR\tnameserver:\t${ns}\tdomain:\t${d}" && dig @${ns} AXFR $d +noall +answer 
    done  
done  >> pentest/axfr.txt

# <----------------------- Custom word list ----------------------->
echo -e "\n${greenColour}[+]${endColour} Creating custom wordlist"
for d in $(cat pentest/targets/domains.txt); do 
    cewl $d -d 2 -m 4 --email_file pentest/cewl_emails_${NAME}_${d}.txt -c -w pentest/cewl_dict_${NAME}_${d}.txt
done 
cat pentest/cewl_dict_*.txt |  iconv -f utf8 -t ascii//TRANSLIT  | awk -F ',' '{a[$1] += $2} END{for (i in a) print i, a[i]}' | sort -nr -t " " -k 2,2 >> pentest/cewl_words_${NAME}_num.txt
head -n 1000 pentest/cewl_words_${NAME}_num.txt | cut -d "," -f 1 >> pentest/custom_dictionary_${NAME}.lst


# <----------------------- amass, subfinder assetfinder ---------------------->
for d in $(cat pentest/targets/domains.txt); do 
    subfinder -d $d >> pentest/foundsubdomains.txt
    assetfinder -subs-only $d >> pentest/foundsubdomains.txt
    amass enum -norecursive -noalts -d $d >> pentest/foundsubdomains.txt
    
done 


# <----------------------- DNS Brute ----------------------->

echo -e "\n${blueColour}[*]${endColour} DNS brute force${endColour}"
for d in $(cat pentest/targets/domains.txt); do
    amass enum -brute -w AuditScrips/WorldList/DNS_plussFinancial.dic-d $d >> pentest/foundsubdomains.txt
    #amass enum -brute -w pentest/custom_dictionary_${NAME}.lst -d $d >> pentest/foundsubdomains.txt

    ## next line dont uncomment, it is only for really special clients 
    ## and/or when thoroughness is mandatory, 
    ## better to be used whit a lot of open resolvers
    #amass enum -brute -w /opt/rlyeh/dictionaries/DNS_allsubdomains.dic -d $d >> pentest/foundsubdomains.txt
done 


cat pentest/foundsubdomains.txt | sort -u > pentest/subdomains.txt

for h in $(cat pentest/targets/subdomains.txt); do 
    host $h
done >> pentest/targets/all_resolved_subdomains.txt

cat pentest/targets/all_resolved_subdomains.txt | grep "has address" | sed 's/ has address /\t/g' | sort -u | cut -f2 | sort -u > pentest/all_ipv4addreses.txt

chown -R 1000:1000 pentest/