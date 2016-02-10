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
# Feb 10 2016 PHAT TRAN
############################################################################################################

HOST=`uname -n`
TARGETDIR=/opt/fundserv/syscheck/common-data/`date +%Y%m`/$HOST/listmatching

# Check to see if there are processes running (except JAVA GUI)
/usr/openv/netbackup/bin/bpps -a | grep -v "java" > /dev/null

# Send the list of hosts that aren't Windows to the file path
if [ $? -eq 0 ]
then
	sudo bpplclients -allunique -l | grep -i -v "windows" | awk '{print $2}' > $TARGETDIR/netbackup-$HOST.lst
fi
