#!/bin/ksh
###########################################################################################################
# NAME: hostinfoCompiler
#
# DESCRIPTION:
# This script will generate a file that contains all the hosts' information in a table 
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
# ($hostname-sysinfo.txt)
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

HOST_INFO_DIR=/opt/fundserv/syscheck/common-data/`date +%Y%m`
MASTER=/opt/fundserv/syscheck/webcontent/listMatching/totals/Master
HARDWARE_INFO=/opt/fundserv/syscheck/webcontent/CMDB/reports/hardwareReport.txt
SOFTWARE_INFO=/opt/fundserv/syscheck/webcontent/CMDB/reports/softwareReport.txt
ZONELIST_INFO=/opt/fundserv/syscheck/webcontent/CMDB/reports/zonelistReport.txt

# Header of all the reports file
echo "HOSTNAME		DATE			OS			KERNEL			MODEL			CPU					ZONETYPE" >> $HARDWARE_INFO
echo "UPTIME		NETBACKUP" >> $SOFTWARE_INFO
echo "HOSTNAME		DATE			ZONELIST" >> $ZONELIST_INFO

# Loop through all the hosts
while read hostName;
do
	# Data for hardware
	cat `find $HOST_INFO_DIR/$hostname/CMDB -type f -name '$hostName-sysinfo.txt'` | sed '/^$/d' | egrep -v 'ZONELIST|SW'  | awk -F: '{print $2}' ORS='		' >> $HARDWARE_INFO
	echo >> $HARDWARE_INFO
	
	# Data for software
	cat `find $HOST_INFO_DIR/$hostname/CMDB -type f -name '$hostName-sysinfo.txt'` | grep 'SW' | awk -F: '{print $2}' ORS='			' >> $SOFTWARE_INFO
	echo >> $SOFTWARE_INFO
	
	# Data for zonelist
	cat `find $HOST_INFO_DIR/$hostname/CMDB -type f -name '$hostName-sysinfo.txt'` | egrep 'HOSTNAME|DATE|ZONELIST' | awk -F: '{print $2}' ORS='			' >> $ZONELIST_INFO
	echo >> $ZONELIST_INFO
	
done < $MASTER

