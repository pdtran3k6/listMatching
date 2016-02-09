#!/bin/ksh
###########################################################################################################
# NAME: extractnodes-netbackup
#
# DESCRIPTION:
# This script will extract all the hosts from a NetBackup server and output into a .lst file
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
# Feb 9 2016 PHAT TRAN
############################################################################################################

TARGETDIR=/opt/fundserv/syscheck/data/`date +%Y%m`/`uname –n`/listmatching

# Check to see if the BoKS server is running


# Send the list of hosts to TARGETDIR
if [ $? -eq 0 ]
then
	sudo /opt/boksm/sbin/boksadm -S hostadm -l -t UNIXBOKSHOST -S | awk '{print $1}' > $TARGETDIR/boks-`uname –n`.lst
fi
