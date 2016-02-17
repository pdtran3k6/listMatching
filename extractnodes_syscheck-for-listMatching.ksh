#!/bin/ksh
###########################################################################################################
# NAME: extractnodes_syscheck-for-listMatching
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
# syscheck-psa03mgmt.list that contains all the nodes on all_dev.list, all_prod.list, all_uat.list   
# 
#
# ENVIRONMENT VARIABLES:
# 
#
# NOTES:
# This script is executed on psa03mgmt server. 
#
#
# EXIT CODE:
# 0 - success
# 1 - incorrect arguments
#
#
# CHANGELOG:
# Feb 17 2016 PHAT TRAN
############################################################################################################

HOST=`uname -n`
TARGETDIR=/opt/fundserv/syscheck/common-data/`date +%Y%m`/$HOST/listMatching
SOURCEDIR_SYSCHECK=/opt/fundserv/syscheck/local-etc
TMPDIR=/opt/fundserv/syscheck/tmp


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