#!/bin/ksh
###########################################################################################################
# NAME: hostInfoReports
#
# DESCRIPTION:
# This script will generate 3 different reports that contain all the nodes' information 
#
#
# INPUT: 
# Master: a file that contains all the possible hosts from all the sources (Masterlist) (no header)
#
#
# OUTPUT:
# 
# 
# 
# ENVIRONMENT VARIABLES:
# 
#
# NOTES:
# There must be a folder where it stores all files containing the information of each host 
# ($hostName-sysinfo.txt)
#
#
# EXIT CODE:
# 0 - success
# 1 - incorrect arguements
#
#
# CHANGELOG:
# Mar 8 2016 PHAT TRAN 
############################################################################################################

HOST_INFO_DIR=/opt/fundserv/syscheck/common-data/`date +%Y%m`
WEB_HOST_INFO_DIR=/opt/fundserv/syscheck/webcontent/CMDB/sysinfo
NO_HEADER_MASTER=/opt/fundserv/syscheck/webcontent/listMatching/totals/noHeader-Master
HARDWARE_INFO=/opt/fundserv/syscheck/webcontent/CMDB/reports/hardwareReport.txt
SOFTWARE_INFO=/opt/fundserv/syscheck/webcontent/CMDB/reports/softwareReport.txt
ZONELIST_INFO=/opt/fundserv/syscheck/webcontent/CMDB/reports/zonelistReport.txt
TMPFILE=/opt/fundserv/syscheck/tmp/`basename $0`.$$

# Delete all current sysinfo.txt files from WEB_HOST_INFO_DIR
rm $WEB_HOST_INFO_DIR/* $HARDWARE_INFO $SOFTWARE_INFO $ZONELIST_INFO 2> /dev/null

# Header of all the reports file
echo "HOSTNAME" >> $HARDWARE_INFO
echo "DATE" >> $HARDWARE_INFO
echo "OS" >> $HARDWARE_INFO
echo "KERNEL" >> $HARDWARE_INFO
echo "MODEL" >> $HARDWARE_INFO
echo "CPU" >> $HARDWARE_INFO
echo "ZONETYPE" >> $HARDWARE_INFO
awk '{printf "%-30s", $1}' $HARDWARE_INFO > $HARDWARE_INFO.tmp && mv $HARDWARE_INFO.tmp $HARDWARE_INFO
echo >> $HARDWARE_INFO
echo "HARDWARE REPORT" > $HARDWARE_INFO.tmp
date '+%a %d-%b-%Y %R' >> $HARDWARE_INFO.tmp
echo >> $HARDWARE_INFO.tmp 
cat $HARDWARE_INFO >> $HARDWARE_INFO.tmp
mv $HARDWARE_INFO.tmp $HARDWARE_INFO

echo "HOSTNAME" > $SOFTWARE_INFO
echo "DATE" >> $SOFTWARE_INFO
echo "UPTIME" >> $SOFTWARE_INFO
echo "NETBACKUP" >> $SOFTWARE_INFO
awk '{printf "%-30s", $1}' $SOFTWARE_INFO > $SOFTWARE_INFO.tmp && mv $SOFTWARE_INFO.tmp $SOFTWARE_INFO
echo >> $SOFTWARE_INFO
echo "SOFTWARE REPORT" > $SOFTWARE_INFO.tmp
date '+%a %d-%b-%Y %R' >> $SOFTWARE_INFO.tmp
echo >> $SOFTWARE_INFO.tmp 
cat $SOFTWARE_INFO >> $SOFTWARE_INFO.tmp
mv $SOFTWARE_INFO.tmp $SOFTWARE_INFO

echo "HOSTNAME" > $ZONELIST_INFO
echo "DATE" >> $ZONELIST_INFO
echo "ZONELIST" >> $ZONELIST_INFO
awk '{printf "%-30s", $1}' $ZONELIST_INFO > $ZONELIST_INFO.tmp && mv $ZONELIST_INFO.tmp $ZONELIST_INFO
echo >> $ZONELIST_INFO
echo "ZONELIST REPORT" > $ZONELIST_INFO.tmp
date '+%a %d-%b-%Y %R' >> $ZONELIST_INFO.tmp 
echo >> $ZONELIST_INFO.tmp
cat $ZONELIST_INFO >> $ZONELIST_INFO.tmp
mv $ZONELIST_INFO.tmp $ZONELIST_INFO

# Loop through all the hosts
while read hostName
do
	if [ ! -d $HOST_INFO_DIR/$hostName/CMDB ]
	then
		mkdir -p -m 755 $HOST_INFO_DIR/$hostName/CMDB
	fi
	
	if [ -f "$HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt" ]
	then
		# Copy new set of sysinfo.txt files from HOST_INFO_DIR into WEB_HOST_INFO_DIR
		cp $HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt $WEB_HOST_INFO_DIR/$hostName-sysinfo.txt
		
		# Data for hardware
		cat $HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt | sed '/^$/d' | egrep -v 'ZONELIST|SW' | grep "^HOSTNAME" > $TMPFILE
		cat $HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt | sed '/^$/d' | egrep -v 'ZONELIST|SW' | grep -v "^HOSTNAME" >> $TMPFILE
		awk -F: '{print $2}' $TMPFILE | cut -c 2- | sed 's/ /_/g' | awk '{printf "%-30s", $1}' >> $HARDWARE_INFO
		echo >> $HARDWARE_INFO
		
		# Data for software
		cat $HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt | egrep 'HOSTNAME|DATE|SW' | grep "^HOSTNAME" > $TMPFILE
		cat $HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt | egrep 'HOSTNAME|DATE|SW' | grep -v "^HOSTNAME" >> $TMPFILE
		awk -F: '{print $2}' $TMPFILE | cut -c 2- | sed 's/ /_/g' | awk '{printf "%-30s", $1}' >> $SOFTWARE_INFO 
		echo >> $SOFTWARE_INFO
		
		# Data for zonelist
		cat $HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt | egrep 'HOSTNAME|DATE|ZONELIST' | grep "^HOSTNAME" > $TMPFILE
		cat $HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt | grep 'DATE' >> $TMPFILE
		awk -F: '{print $2}' $TMPFILE | cut -c 2- | sed 's/ /_/g' > $TMPFILE.tmp && mv $TMPFILE.tmp $TMPFILE
		cat $HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt | grep 'ZONELIST' | awk -F: '{print $2}' | cut -c 2- | sed 's/ /,/g' >> $TMPFILE
		awk '{printf "%-30s", $1}' $TMPFILE >> $ZONELIST_INFO
		echo >> $ZONELIST_INFO
	fi
done < $NO_HEADER_MASTER	
rm -f $TMPFILE
