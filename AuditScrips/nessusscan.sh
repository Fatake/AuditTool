#!/bin/bash

echo -e "\n${greenColour}[*] Generating Nessus Scan${endColour}"

#Nessus scan on target ip addresses
source ../conf/nessus.conf
nessusscanname=$NAME
nessustargets=$(cat targets/ipaddresses.txt | sort -u | tr "\n" "," | sed 's/,$/\n/g')
nessustoken=$(curl -s -k -X POST -H 'Content-Type: application/json' -d "{\"username\":\"${nessususer}\",\"password\":\"${nessuspassword}\"}" "https://127.0.0.1:8834/session" -x "http://127.0.0.1:8080/" | jq -r '.token')
nessusapikey=$(curl -s -k -X GET -H 'Content-Type: application/json' "https://127.0.0.1:8834/nessus6.js?v=$(date +%s)" |  grep -Eo "getApiToken\"\,value\:function\(\){return(\".*?\")}}," | cut -d '"' -f3 )

#create folder
POSTDATA="{\"name\": \"${nessusscanname}\"}"
curl -s -k -X POST -H "X-API-Token: ${nessusapikey}" -H "X-Cookie: token=${nessustoken}" -H 'Content-Type: application/json' -d ${POSTDATA} "https://127.0.0.1:8834/folders"  -x "http://127.0.0.1:8080/"

#get folder and policies ids
nessusfolderid=$(curl -s -k -X GET -H "X-API-Token: ${nessusapikey}" -H "X-Cookie: token=${nessustoken}" -H 'Content-Type: application/json' "https://127.0.0.1:8834/folders" | jq --arg name "${nessusscanname}" '.folders | .[] | select(.name == $name ) | .id ')
nessuspolicyuuid=$(curl -s -k -X GET -H "X-API-Token: ${nessusapikey}" -H "X-Cookie: token=${nessustoken}" "https://127.0.0.1:8834/policies" | jq -r --arg scanType "${nessusscantemplate}" '.policies | .[] | select(.name == $scanType) | .template_uuid')
nessuspolicyid=$(curl -s -k -X GET -H "X-API-Token: ${nessusapikey}" -H "X-Cookie: token=${nessustoken}" "https://127.0.0.1:8834/policies" | jq -r --arg scanType "${nessusscantemplate}" '.policies | .[] | select(.name == $scanType) | .id')

#run scan
POSTDATA="{\"uuid\": \"${nessuspolicyuuid}\", \"settings\": { \"emails\":\"\",\"attach_report\":\"no\",\"filter_type\":\"and\",\"filters\":[],\"launch_now\":true,\"enabled\":false,\"live_results\":\"\", \"name\": \"${nessusscanname}\", \"description\":\"Basic scan automated from makemeapentest script for ${nessusscanname}\",\"folder_id\":\"${nessusfolderid}\",\"scanner_id\":\"1\",\"policy_id\":\"${nessuspolicyid}\",\"text_targets\":\"${nessustargets}\",\"file_targets\":\"\"}}"
echo $POSTDATA | jq 
nessusscanid=$(curl -s -k -X POST -H "X-API-Token: ${nessusapikey}" -H "X-Cookie: token=${nessustoken}" -H "Content-Type: application/json" -d ${POSTDATA} "https://127.0.0.1:8834/scans")
echo $nessusscanid | jq 




