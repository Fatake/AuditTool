#!/bin/bash
source AuditScrips/utils.sh

logo

if [ "$EUID" -ne 0 ] ; then
	echo -e "\n${redColour}[!]${endColour} Not sudo detected";
    usage
	exit 1
fi

if [[ ${#} -eq 0 ]]; then
	usage
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

. AuditScrips/scope.sh
. AuditScrips/dnsanalysis.sh
. AuditScrips/tcpipscan.sh
#  Descoment if u have Burp Pro
#. AuditScrips/burpproject.sh
. AuditScrips/webscreenshot.sh
. AuditScrips/scriptkiddie_webscan.sh
. AuditScrips/nessusscan.sh
run_cmd "chown -R 1000:1000 Pentest_${NAME}/"
exit