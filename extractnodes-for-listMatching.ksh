#!/bin/ksh
###########################################################################################################
# NAME: extractnodes-for-listMatching
#
# DESCRIPTION:
# This script will extract the registered nodes out of a central administrative tool 
# (like NetBackup, BoKS, etc.)
#
#
# INPUT:
#
# 
# OUTPUT:
# source-hostname.list for each source, which will be store in TARGETDIR path with respect to the host.   
# 
#
# ENVIRONMENT VARIABLES:
# 
#
# NOTES:
# This script is executed on all nodes.  At the beginning of each section there is some logic 
# to detect if the node is an admin server or not. If it is, then the command to 
# extract the node list is executed.
#
#
# EXIT CODE:
# 0 - success
# 1 - incorrect arguments
#
#
# CHANGELOG:
# Feb 18 2016 PHAT TRAN
############################################################################################################
 
HOST=`uname -n`
TARGETDIR=/opt/fundserv/syscheck/common-data/`date +%Y%m`/$HOST/listMatching

if [ ! -d $TARGETDIR ]
then
	mkdir -p -m 755 $TARGETDIR
	chown syscheck:staff $TARGETDIR
fi

##### BOKS
# Check to see if this is a BOKS admin server
# If yes, extract the list of hosts to TARGETDIR
if [ -f "/opt/boksm/sbin/boksadm" ]
then
	/opt/boksm/sbin/boksadm -S hostadm -l -t UNIXBOKSHOST -S | awk '{print $1}' > $TARGETDIR/boks-$HOST.list
fi

##### CONTROLM


##### NETBACKUP
# Check to see if this is a NETBACKUP admin server
# If yes, extract the list of hosts that aren't Windows to the TARGETDIR
if [ -f "/usr/openv/netbackup/bin/admincmd/bpplclients" ]
then
	/usr/openv/netbackup/bin/admincmd/bpplclients -allunique -l | grep -i -v "windows" | awk '{print $2}' > $TARGETDIR/netbackup-$HOST.list
fi

##### UPTIME
# Check to see if this is a UPTIME admin server

# Extract all hosts and output into Uptime.list
# if [ $? -eq 0 ]
# then
# mysql -u uptime -puptime -P3308 --protocol=tcp uptime -e "SELECT name FROM entity" | sed '1d' > $TARGETDIR/uptime-$HOST.list
# fi




