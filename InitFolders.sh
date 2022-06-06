. TermFormat/Colors.sh
source utils.sh

if [ ! -d "pentest" ] 
then
    run_cmd "mkdir pentest/"
    run_cmd "mkdir pentest/targets/"
    run_cmd "chown -R 1000:1000 pentest/"
fi

if [[ -f pentest/targets/domains.txt ]]; then
    domains=1
fi
if [[ -f pentest/targets/subdomains.txt ]]; then
    subdomains=1
fi
if [[ -f pentest/targets/ipaddresses.txt ]]; then
    ipaddresses=1
fi
if [[ -f pentest/targets/urls.txt ]]; then
    urls=1
fi

if [[ domains -ne 1 || subdomains -ne 1 || ipaddresses -ne 1 || urls -ne 1 ]]; then
    echo -e "${blueColour}[i]${endColour} I will Create following files in ${purpleColour}pentest/targets/${endColour} to begin:"
    
    if [[ domains -ne 1 ]]; then # Create Domains File
        echo -e "${greenColour}[+]${endColour} domains.txt"
        run_cmd "touch pentest/targets/domains.txt"
    fi

    if [[ subdomains -ne 1 ]]; then # Create Subdomains File
        echo -e "${greenColour}[+]${endColour} subdomains.txt"
        run_cmd "touch pentest/targets/subdomains.txt"
    fi

    if [[ ipaddresses -ne 1 ]]; then # Create Ip Addres
        echo -e "${greenColour}[+]${endColour} ipaddresses.txt"
        run_cmd "touch pentest/targets/ipaddresses.txt"
    fi

    if [[ urls -ne 1 ]]; then # Create Ip Addres
        echo -e "${greenColour}[+]${endColour} urls.txt"
        run_cmd "touch pentest/targets/urls.txt"
    fi

    run_cmd "chown -R 1000:1000 pentest/"
    echo -e "\n${blueColour}[i]${endColour} Add ${greenColour}Targets${endColour} To files"
fi