#!/bin/ksh
###########################################################################################################
# NAME: extractnodes-syscheck
#
# DESCRIPTION:
# This script will extract all the hosts from Syscheck and output into a syscheck-$HOST.list
#
#
# INPUT: 
# SOURCEDIR: the path to the directory that contains all the lists of hosts
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
SOURCEDIR=/opt/fundserv/syscheck/local-etc
TMPDIR=/opt/fundserv/syscheck/tmp
TARGETDIR=/opt/fundserv/syscheck/common-data/`date +%Y%m`/$HOST/listMatching
HOST_INFO_DIR=/opt/fundserv/syscheck/common-data/`date +%Y%m`

# Check if it's a syscheck host


# If yes, send the list of hosts to $TARGETDIR
cat $SOURCEDIR/all_dev.list $SOURCEDIR/all_prod.list $SOURCEDIR/all_uat.list | sort -u > $TMPDIR/temp.$$
rm $TARGETDIR/syscheck-$HOST.list
while read hostName;
do
	echo "$hostName" >> $TARGETDIR/syscheck-$HOST.list
	cat $HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt | grep 'ZONELIST' | awk -F: '{print $2}'| tr ' ' '\n' | sed '/^$/d' >> $TARGETDIR/syscheck-$HOST.list
done < $TMPDIR/temp.$$

sort -u $TARGETDIR/syscheck-$HOST.list > $TARGETDIR/syscheck-$HOST.tmp 
mv $TARGETDIR/syscheck-$HOST.tmp $TARGETDIR/syscheck-$HOST.list