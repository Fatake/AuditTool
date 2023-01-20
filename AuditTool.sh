#!/bin/bash
source /opt/AuditTool/AuditScrips/utils.sh

logo

sudoCheck
if [[ $IsSudo == 1 ]] then
	usage;
    exit 1;
fi

if [[ ${#} -eq 0 ]]; then
	usage;
	exit 1
fi

while getopts ":hn:" opt; do
	case ${opt} in	
		# -n to create a new pentesting NAME Project
		n)
			NAME="$OPTARG"
			f_name=true
			;;
		\?)
			echo -e "${redColour}[!]${endColour} Invalid option:\t -$OPTARG" >&2
			usage
			exit 1
			;;
		:)
			echo -e "${redColour}[!]${endColour} Option -$OPTARG requires an argument." >&2
			usage
			exit 1
			;;
		h)
			usage
			exit 0
			;;
	esac
done
echo -e "${endColour}\n"
echo -e "${yellowColour}<------------ Init Project ------------>${endColour}"
echo -e "${blueColour}[i]${endColour} Pentest project name: ${yellowColour}$NAME${endColour}"
checkFiles
listTargets

echo -e "\n${yellowColour}<------------ Let's Pentest ------------>${endColour}"

. /opt/AuditTool/AuditScrips/scope.sh

##
# + OSINT / services discovery
## 
. /opt/AuditTool/AuditScrips/dnsanalysis.sh
. /opt/AuditTool/AuditScrips/tcpipscan.sh

##
# + Web Analisis
## 
. /opt/AuditTool/AuditScrips/burpproject.sh
. /opt/AuditTool/AuditScrips/webscan.sh

##
# + Vulnerabilities scan
##
#. /opt/AuditTool/AuditScrips/nessusscan.sh
run_cmd "chown -R 1000:1000 Pentest_${NAME}/"
