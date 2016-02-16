#!/bin/ksh
###########################################################################################################
# NAME: extractnodes-boks
#
# DESCRIPTION:
# This script will extract all the hosts from BoKS server and output into a boks-$HOST.list file
#
#
# INPUT: 
# TARGETDIR: the path to the directory that contains the final list of hosts
#
#
# OUTPUT:
# 
# 
# ENVIRONMENT VARIABLES:
# 
#
# NOTES:
#
#
# EXIT CODE:
# 0 - success
# 1 - incorrect arguements
#
#
# CHANGELOG:
# Feb 16 2016 PHAT TRAN
############################################################################################################

HOST=`uname -n`
TARGETDIR=/opt/fundserv/syscheck/common-data/`date +%Y%m`/$HOST/listMatching

# Check to see if there's a symbolic link on pam.conf
cd /etc
ls -l pam.conf | grep "pam.conf..ssm" 2> /dev/null
if [ $? -eq 0 ]
then
	# Check if the process exists
	ps -ef | grep "boksinit.client" /etc/opt/boksm 2> /dev/null
	if [ $? -eq 0 ]
	then
		# Send the list of hosts to TARGETDIR
		sudo /opt/boksm/sbin/boksadm -S hostadm -l -t UNIXBOKSHOST -S | awk '{print $1}' > $TARGETDIR/boks-$HOST.list
	fi
fi
