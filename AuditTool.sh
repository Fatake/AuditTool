#!/bin/bash
##
# Inports
##
source checkTargets.sh
. TermFormat/Colors.sh

function usage () {
	echo -e "\n${greenColour}Usage:\n"
    echo -e "${blueColour}sudo${endColour} ./AuditTool.sh -i            Start necessary files"
    echo -e "${blueColour}sudo${endColour} ./AuditTool.sh -n [name]     [name] name of proyect\n"
	echo -e "${blueColour}sudo${endColour} ./AuditTool.sh -h            Show this Help menu"
}


# If there are no arguments, show usage
if [[ ${#} -eq 0 ]]; then
	usage
	exit 1
fi

# Get Options
while getopts ":hn:i" opt; do
	case ${opt} in	
		i)
			echo -e "${greenColour}[i]${endColour} Init Project" >&2
			createFiles
			;;
		n)
			checkFiles
			echo -e "${blueColour}[i]${endColour} Pentest project name:\t $OPTARG" >&2
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

# If not Sudo run
if [ "$EUID" -ne 0 ] ; then
	echo -e "\n${redColour}[!]${endColour} Not sudo detected";
    usage
	exit 1
fi

. AuditScrips/burpproject.sh
. AuditScrips/scope.sh
. AuditScrips/dnsanalysis.sh
. AuditScrips/tcpipscan.sh
. AuditScrips/webscreenshot.sh
. AuditScrips/scriptkiddie_webscan.sh
. AuditScrips/nessusscan.sh
