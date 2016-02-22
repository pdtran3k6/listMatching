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
# Feb 22 2016 PHAT TRAN
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
echo "DATE\t\t\tHOSTNAME\t  OS\t\tKERNEL\t\t\tMODEL\t\tCPU\t\t\t\tZONETYPE" > $HARDWARE_INFO
echo "UPTIME\tNETBACKUP" > $SOFTWARE_INFO
echo "DATE\t\t\tHOSTNAME\t  ZONELIST" > $ZONELIST_INFO

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
		cat `find $HOST_INFO_DIR/$hostName/CMDB -type f -name $hostName-sysinfo.txt` | sed '/^$/d' | egrep -v 'ZONELIST|SW' | awk -F: '{print $2}'| tr '\n' '\t' >> $HARDWARE_INFO
		echo >> $HARDWARE_INFO
		
		# Data for software
		cat `find $HOST_INFO_DIR/$hostName/CMDB -type f -name $hostName-sysinfo.txt` | grep 'SW' | awk -F: '{print $2}' | tr '\n' '\t' >> $SOFTWARE_INFO
		echo >> $SOFTWARE_INFO
		
		# Data for zonelist
		cat `find $HOST_INFO_DIR/$hostName/CMDB -type f -name $hostName-sysinfo.txt` | egrep 'HOSTNAME|DATE|ZONELIST' | awk -F: '{print $2}' | tr '\n' '\t' >> $ZONELIST_INFO
		echo >> $ZONELIST_INFO
	fi
done < $NO_HEADER_MASTER

