##
# Terminal Colores
##
greenColour="\e[0;32m\033[1m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
endColour="\033[0m\e[0m"

# This function will help standardize running a command
function run_cmd () {
    # Syntaxt will be: run_cmd "[COMMAND]"
    command="$1"
    # we just assume stderr is a permission thing and give a generic
    # failure message.
    /bin/bash -c "$command" 2>/dev/null
}

function usage () {
	echo -e "\n${greenColour}Usage:\n"
    echo -e "${blueColour}sudo${endColour} ./AuditTool.sh -n [name]     Start Project with [name]"
	echo -e "${blueColour}sudo${endColour} ./AuditTool.sh -h            Show this Help menu"
}

function logo () {
    echo -e "${redColour}\n"
    echo -e "    ___             ___ __      ______            __\n   /   | __  ______/ (_) /_    /_  __/___  ____  / /\n  / /| |/ / / / __  / / __/_____/ / / __ \/ __ \/ / \n / ___ / /_/ / /_/ / / /_/_____/ / / /_/ / /_/ / /  \n/_/  |_\__,_/\__,_/_/\__/     /_/  \____/\____/_/   \n"
    echo -e "${endColour}\n"
}

##
# Check Files
##
# 2>/dev/null redirect standar error to /dev/null
function listTargets () {
    echo -e "\n${yellowColour}Domains${endColour}"
    run_cmd "cat Pentest_${NAME}/targets/domains.txt"

    echo -e "\n${yellowColour}Subdomains${endColour}"
    run_cmd "cat Pentest_${NAME}/targets/subdomains.txt"

    echo -e "\n${yellowColour}IP address${endColour}"
    run_cmd "cat Pentest_${NAME}/targets/ipaddresses.txt"

    echo -e "\n${yellowColour}URLS${endColour}"
    run_cmd "cat Pentest_${NAME}/targets/urls.txt"
}

function checkFiles(){
    itsnew=0
    if [ ! -d "Pentest_${NAME}/" ]; then
        echo -e "${greenColour}[+]${endColour} Creating  dir Pentest_${NAME}/"
        run_cmd "mkdir Pentest_${NAME}/"
        run_cmd "mkdir Pentest_${NAME}/targets/"
        itsnew=1
    fi

    if [[ ! -f "Pentest_${NAME}/targets/domains.txt" ]]
    then
        echo -e "${greenColour}[+]${endColour} Creating Pentest_${NAME}/targets/domains.txt"
        run_cmd "touch Pentest_${NAME}/targets/domains.txt"
        itsnew=1
    fi

    if [[ ! -f "Pentest_${NAME}/targets/subdomains.txt" ]]
    then
        echo -e "${greenColour}[+]${endColour} Creating Pentest_${NAME}/targets/subdomains.txt"
        run_cmd "touch Pentest_${NAME}/targets/subdomains.txt"
        itsnew=1
    fi

    if [[ ! -f "Pentest_${NAME}/targets/ipaddresses.txt" ]]
    then
        echo -e "${greenColour}[+]${endColour} Creating Pentest_${NAME}/targets/ipaddresses.txt"
        run_cmd "touch Pentest_${NAME}/targets/ipaddresses.txt"
        itsnew=1
    fi

    if [[ ! -f "Pentest_${NAME}/targets/urls.txt" ]]
    then
        echo -e "${greenColour}[+]${endColour} Creating Pentest_${NAME}/targets/urls.txt"
        run_cmd "touch Pentest_${NAME}/targets/urls.txt"
        itsnew=1
    fi


    if [ $itsnew -eq 1 ];then
        echo -e "\n${blueColour}[i]${endColour} Please add ${greenColour}Targets${endColour} to the created files to continue"
        read -r -s -p $'Press enter to continue...'
    fi

    run_cmd "chown -R 1000:1000 Pentest_${NAME}/"
}