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
# TARGETDIR: the path to the directory that contains the list of nodes extracted from the admin server  
# 
#
# ENVIRONMENT VARIABLES:
# 
#
# NOTES:
# This script is executed on all nodes.  At the beginning of each section there is some logic 
# to detect if the node is an admin server or not.
# If it is, then the command to extract the node list is executed.
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
SOURCEDIR_SYSCHECK=/opt/fundserv/syscheck/local-etc
TMPDIR=/opt/fundserv/syscheck/tmp
HOST_INFO_DIR=/opt/fundserv/syscheck/common-data/`date +%Y%m`

##### NETBACKUP
# Check to see if this is a NETBACKUP admin server
find /usr/openv/netbackup/bin/admincmd/ -type f -name 'bpplclients' 2> /dev/null

# Send the list of hosts that aren't Windows to the file path
if [ $? -eq 0 ]
then
	sudo bpplclients -allunique -l | grep -i -v "windows" | awk '{print $2}' > $TARGETDIR/netbackup-$HOST.list
fi






##### UPTIME
# Check to see if this is a UPTIME admin server


# Extract all hosts and output into Uptime.list
if [ $? -eq 0 ]
then
mysql -u uptime -puptime -P3308 --protocol=tcp uptime -e "SELECT name FROM entity" | sed '1d' > $TARGETDIR/uptime-$HOST.list
fi





##### BOKS
# Check to see if this is a BOKS admin server
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





##### SYSCHECK
# Check to see if this is a SYSCHECK admin server


# If yes, send the list of hosts to $TARGETDIR
cat $SOURCEDIR_SYSCHECK/all_dev.list $SOURCEDIR_SYSCHECK/all_prod.list $SOURCEDIR_SYSCHECK/all_uat.list | sort -u > $TMPDIR/temp.$$
rm $TARGETDIR/syscheck-$HOST.list
while read hostName;
do
	echo "$hostName" >> $TARGETDIR/syscheck-$HOST.list
	cat $HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt | grep 'ZONELIST' | awk -F: '{print $2}'| tr ' ' '\n' | sed '/^$/d' >> $TARGETDIR/syscheck-$HOST.list
done < $TMPDIR/temp.$$

sort -u $TARGETDIR/syscheck-$HOST.list > $TARGETDIR/syscheck-$HOST.tmp 
mv $TARGETDIR/syscheck-$HOST.tmp $TARGETDIR/syscheck-$HOST.list





##### CONTROLM

##### PIKT