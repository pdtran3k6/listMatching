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
# Mar 1 2016 PHAT TRAN
############################################################################################################

HOST_INFO_DIR=/opt/fundserv/syscheck/common-data/`date +%Y%m`
WEB_HOST_INFO_DIR=/opt/fundserv/syscheck/webcontent/CMDB/sysinfo
NO_HEADER_MASTER=/opt/fundserv/syscheck/webcontent/listMatching/totals/noHeader-Master
HARDWARE_INFO=/opt/fundserv/syscheck/webcontent/CMDB/reports/hardwareReport.txt
SOFTWARE_INFO=/opt/fundserv/syscheck/webcontent/CMDB/reports/softwareReport.txt
ZONELIST_INFO=/opt/fundserv/syscheck/webcontent/CMDB/reports/zonelistReport.txt

# Delete all current sysinfo.txt files from WEB_HOST_INFO_DIR
rm $WEB_HOST_INFO_DIR/* $HARDWARE_INFO $SOFTWARE_INFO $ZONELIST_INFO

# Header of all the reports file
echo "DATE\t\t\tHOSTNAME\t\t\tOS\t\t\tKERNEL\t\t\t\tMODEL\t\t\t\tCPU\t\t\t\tZONETYPE" > $HARDWARE_INFO
echo "DATE\t\t\tHOSTNAME\t\t\tUPTIME\t\t\tNETBACKUP" > $SOFTWARE_INFO
echo "DATE\t\t\tHOSTNAME\t\t\tZONELIST" > $ZONELIST_INFO

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
		cat $HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt | sed '/^$/d' | egrep -v 'ZONELIST|SW' | grep "HOSTNAME" > tmp1
		cat $HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt | sed '/^$/d' | egrep -v 'ZONELIST|SW' | grep -v "HOSTNAME" >> tmp1
		awk -F: '{print $2}' tmp1 | cut -c 2- | perl -p -e 's/\n/\t\t/' >> $HARDWARE_INFO
		echo >> $HARDWARE_INFO
		
		# Data for software
		cat $HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt | egrep 'HOSTNAME|DATE|SW' | grep "HOSTNAME" > tmp1
		cat $HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt | egrep 'HOSTNAME|DATE|SW' | grep -v "HOSTNAME" >> tmp1
		awk -F: '{print $2}' tmp1 | cut -c 2- | perl -p -e 's/\n/\t\t/' >> $SOFTWARE_INFO 
		echo >> $SOFTWARE_INFO
		
		# Data for zonelist
		cat $HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt | egrep 'HOSTNAME|DATE|ZONELIST' | grep "HOSTNAME" > tmp1
		cat $HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt | egrep 'HOSTNAME|DATE|ZONELIST' | grep -v "HOSTNAME" >> tmp1
		awk -F: '{print $2}' tmp1 | cut -c 2- | perl -p -e 's/\n/\t\t/' >> $ZONELIST_INFO
		echo >> $ZONELIST_INFO
	fi
done < $NO_HEADER_MASTER	

rm tmp1
