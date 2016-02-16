#!/bin/ksh
###########################################################################################################
# NAME: extractnodes-netbackup
#
# DESCRIPTION:
# This script will extract all the hosts from a NetBackup server and output into a netbackup-$HOST.list file
#
#
# INPUT: 
# TARGETDIR: the path to the directory that contains the list of hosts gathered from that server
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

# Check to see if the command exists
find /usr/openv/netbackup/bin/admincmd/ -type f -name 'bpplclients' 2> /dev/null

# Send the list of hosts that aren't Windows to the file path
if [ $? -eq 0 ]
then
	sudo bpplclients -allunique -l | grep -i -v "windows" | awk '{print $2}' > $TARGETDIR/netbackup-$HOST.list
fi
