#!/bin/bash
source utils.sh

if [ ! -d "pentest/dnsrecon" ] 
then
    run_cmd "mkdir pentest/dnsrecon/"
fi

#Enumerate DNS records
echo -e "\n${greenColour}[*]${endColour} Starting ${purpleColour}dnsrecon${endColour}"

for d in $(cat pentest/targets/domains.txt); 
do 
run_cmd "touch pentest/dnsrecon/${NAME}_dnsreconstdrecon_$d.csv"
run_cmd "touch pentest/dnsrecon/${NAME}_dnsrecon_axfr_$d.csv"
run_cmd "touch pentest/dnsrecon/${NAME}_dnsrecon_bing_$d.csv"
run_cmd "touch pentest/dnsrecon/${NAME}_dnsrecon_crt_$d.csv"

dnsrecon  -d $d --disable_check_bindversion -t std -c pentest/dnsrecon/${NAME}_dnsreconstdrecon_$d.csv  
dnsrecon -d $d -t axfr -c pentest/dnsrecon/${NAME}_dnsrecon_axfr_$d.csv 
dnsrecon-d $d -t bing -c pentest/dnsrecon/${NAME}_dnsrecon_bing_$d.csv 
dnsrecon-d $d -t zonewalk -c pentest/dnsrecon/${NAME}_dnsrecon_crt_$d.csv 
done 

for d in $(cat pentest/targets/ipaddresses.txt); 
do ( dnsrecon-d $d -t rvl -c pentest/dnsrecon/${NAME}_dnsrecon_rvl_$d.csv );
done 

for f in pentest/dnsrecon/${NAME}_dnsrecon_*.csv; 
do awk -v d=$(echo ${f} | cut -d "_" -f 4 ) 'NR>1 {print d","$0}' $f ; 
done | sort -u >> pentest/dnsrecon/${NAME}_dnsrecon_all.txt

cat pentest/dnsrecon/${NAME}_dnsrecon_all.txt

run_cmd "chown -R 1000:1000 pentest/dnsrecon/"
exit 0

echo -e "\t${turquoiseColour}dig nameservers"
for d in $(cat pentest/targets/domains.txt); do ( dig +multi NS $d +noall +answer | cut -f4 | sed 's/.$//'); done | sort -u > pentest/nameservers.txt

echo -e "\t${turquoiseColour}dig zonetransfers${endColour}"
for ns in $(cat pentest/nameservers.txt); do ( for d in $(cat targets/domains.txt); do ( echo -e "AXFR\tnameserver:\t${ns}\tdomain:\t${d}" && dig @${ns} AXFR $d +noall +answer ); done ); done  >> pentest/axfr.txt
##first grab some custom made wordlists

echo -e "\t${turquoiseColour}Creating custom wordlist${endColour}"
for d in $(cat pentest/targets/domains.txt); do ( cewl $d -d 2 -m 4 --email_file pentest/cewl_emails_${NAME}_${d}.txt -c -w pentest/cewl_dict_${NAME}_${d}.txt	); done 
cat pentest/cewl_dict_*.txt |  iconv -f utf8 -t ascii//TRANSLIT  | awk -F ',' '{a[$1] += $2} END{for (i in a) print i, a[i]}' | sort -nr -t " " -k 2,2 >> pentest/cewl_words_${NAME}_num.txt
head -n 1000 pentest/cewl_words_${NAME}_num.txt | cut -d "," -f 1 >> pentest/custom_dictionary_${NAME}.lst

#Now actually test for subdomains
for d in $(cat pentest/targets/domains.txt); do ( /home/kali/go/bin/subfinder -d $d >> pentest/foundsubdomains.txt	); done 
for d in $(cat pentest/targets/domains.txt); do ( /home/kali//go/bin/assetfinder -subs-only $d >> pentest/foundsubdomains.txt	); done 
for d in $(cat pentest/targets/domains.txt); do ( amass enum -norecursive -noalts -d $d >> pentest/foundsubdomains.txt ); done 

echo -e "\t${turquoiseColour} DNSbruteforce${endColour}"
for d in $(cat pentest/targets/domains.txt); do ( amass enum -brute -w /opt/rlyeh/dictionaries/subdomain.all.txt -d $d >> pentest/foundsubdomains.txt ); done 
for d in $(cat pentest/targets/domains.txt); do ( amass enum -brute -w pentest/custom_dictionary_${NAME}.lst -d $d >> pentest/foundsubdomains.txt ); done 
##next line dont uncomment, it is only for really special clients and/or when thoroughness is mandatory, better to be used whit a lot of open resolvers
###for d in $(cat targets/domains.txt); do ( amass enum -brute -w /opt/rlyeh/dictionaries/subdomain.plusFinancial.plusSpanish.7k.lst -d $d >> pentest/foundsubdomains.txt ); done 
cat pentest/foundsubdomains.txt | sort -u > pentest/subdomains.txt
for h in $(cat pentest/targets/subdomains.txt); do ( host $h); done >> pentest/all_resolved_subdomains.txt
cat pentest/all_resolved_subdomains.txt | grep "has address" | sed 's/ has address /\t/g' | sort -u | cut -f2 | sort -u > pentest/all_ipv4addreses.txt

chown -R 1000:1000 pentest/