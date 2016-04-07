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
	# Apr 7 2016 PHAT TRAN
	############################################################################################################

	HOST_INFO_DIR=/opt/fundserv/syscheck/all-data/`date +%Y%m`
	WEB_HOST_INFO_DIR=/opt/fundserv/syscheck/webcontent/CMDB/sysinfo
	NO_HEADER_MASTER=/opt/fundserv/syscheck/webcontent/listMatching/totals/noHeader-Master
	ALLFIELD_INFO=/opt/fundserv/syscheck/webcontent/CMDB/reports/allfieldReport.txt
	HARDWARE_INFO=/opt/fundserv/syscheck/webcontent/CMDB/reports/hardwareReport.txt
	SOFTWARE_INFO=/opt/fundserv/syscheck/webcontent/CMDB/reports/softwareReport.txt
	ZONELIST_INFO=/opt/fundserv/syscheck/webcontent/CMDB/reports/zonelistReport.txt
	NETWORK_INFO=/opt/fundserv/syscheck/webcontent/CMDB/reports/networkReport.txt
	VX_INFO=/opt/fundserv/syscheck/webcontent/CMDB/reports/VXReport.txt
	TMPFILE=/opt/fundserv/syscheck/tmp/`basename $0`.$$
	TMPFILE2=/opt/fundserv/syscheck/tmp/`basename $0`-2.$$
	
	# Delete all current sysinfo.txt files from WEB_HOST_INFO_DIR
	rm $WEB_HOST_INFO_DIR/* $ALLFIELD_INFO $HARDWARE_INFO $SOFTWARE_INFO $ZONELIST_INFO $NETWORK_INFO $VX_INFO 2> /dev/null

	# Header of all the reports file
	allfieldFormat="%-40s"
	echo "GENERAL REPORT" > $ALLFIELD_INFO
	date '+%a %d-%b-%Y %R' >> $ALLFIELD_INFO
	echo >> $ALLFIELD_INFO
	printf "$allfieldFormat$allfieldFormat$allfieldFormat$allfieldFormat$allfieldFormat$allfieldFormat$allfieldFormat$allfieldFormat$allfieldFormat$allfieldFormat$allfieldFormat$allfieldFormat$allfieldFormat$allfieldFormat$allfieldFormat$allfieldFormat\n" \
	"HOSTNAME" "DATE" "REMOTE_MGMT" "OS" "KERNEL" "MODEL" "CPU" "ZONETYPE" "CHASSIS_S/N" "SITE" "RACK" \
	"U_BOTTOM" "CONTRACT_#" "ASSET_TAG" "ENV" "APPS" >> $ALLFIELD_INFO
	
	hardwareFormat="%-40s"
	echo "HARDWARE REPORT" > $HARDWARE_INFO
	date '+%a %d-%b-%Y %R' >> $HARDWARE_INFO
	echo >> $HARDWARE_INFO
	printf "$hardwareFormat$hardwareFormat$hardwareFormat$hardwareFormat$hardwareFormat$hardwareFormat$hardwareFormat\n" \
	"HOSTNAME" "DATE" "OS" "KERNEL" "MODEL" "CPU" "ZONETYPE" >> $HARDWARE_INFO
	
	softwareFormat="%-35s"
	echo "SOFTWARE REPORT" > $SOFTWARE_INFO
	date '+%a %d-%b-%Y %R' >> $SOFTWARE_INFO
	echo >> $SOFTWARE_INFO
	printf "$softwareFormat$softwareFormat$softwareFormat$softwareFormat$softwareFormat\n" "HOSTNAME" "DATE" "OS" "NETBACKUP" "UPTIME" >> $SOFTWARE_INFO
	
	zonelistFormat="%-30s"
	echo "ZONELIST REPORT" > $ZONELIST_INFO
	date '+%a %d-%b-%Y %R' >> $ZONELIST_INFO
	echo >> $ZONELIST_INFO
	printf "$zonelistFormat$zonelistFormat$zonelistFormat\n" "HOSTNAME" "DATE" "ZONELIST" >> $ZONELIST_INFO

	# Loop through all the hosts
	while read hostName
	do
		if [ -f "$HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt" ]
		then
			# Copy new set of sysinfo.txt files from HOST_INFO_DIR into WEB_HOST_INFO_DIR
			cp $HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt $WEB_HOST_INFO_DIR/$hostName-sysinfo.txt
			
			SYSINFO=$HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt
			zonetype=`grep "^ZONETYPE:" $SYSINFO | awk -F: '{print $2}'`
			
			# Data for all field
			grep "^HOSTNAME:" $SYSINFO > $TMPFILE
			grep "^DATE:" $SYSINFO >> $TMPFILE
			if [ "$zonetype" == " global" ]
			then
				grep "^REMOTE MGMT:" $SYSINFO >> $TMPFILE
				grep "^OS:" $SYSINFO >> $TMPFILE
				grep "^KERNEL:" $SYSINFO >> $TMPFILE
				grep "^MODEL:" $SYSINFO >> $TMPFILE
				grep "^CPU:" $SYSINFO >> $TMPFILE
				grep "^ZONETYPE:" $SYSINFO >> $TMPFILE
				grep "^CHASSIS SERIAL NUMBER:" $SYSINFO >> $TMPFILE
				grep "^SITE:" $SYSINFO >> $TMPFILE
				grep "^RACK:" $SYSINFO >> $TMPFILE
				grep "^U BOTTOM:" $SYSINFO >> $TMPFILE
				grep "^CONTRACT #:" $SYSINFO >> $TMPFILE
				grep "^ASSET TAG:" $SYSINFO >> $TMPFILE
				echo "$hostName" >> $TMPFILE2
			else
				echo "REMOTE MGMT: " >> $TMPFILE
				grep "^OS:" $SYSINFO >> $TMPFILE
				grep "^KERNEL:" $SYSINFO >> $TMPFILE
				grep "^MODEL:" $SYSINFO >> $TMPFILE
				grep "^CPU:" $SYSINFO >> $TMPFILE
				grep "^ZONETYPE:" $SYSINFO >> $TMPFILE
				echo "CHASSIS SERIAL NUMBER: ">> $TMPFILE
				echo "SITE: " >> $TMPFILE
				echo "RACK: " >> $TMPFILE
				echo "U BOTTOM: " >> $TMPFILE
				echo "CONTRACT #: " >> $TMPFILE
				echo "ASSET TAG: " >> $TMPFILE
			fi
			grep "^ENV:" $SYSINFO >> $TMPFILE
			grep "^APPS: " $SYSINFO >> $TMPFILE
			awk -F: '{print $2 $3}' $TMPFILE | sed -e 's/^[ ]*//' | sed 's/ /_/g' | awk '{printf "%-40s", $1}' >> $ALLFIELD_INFO
			echo >> $ALLFIELD_INFO
			
			# Data for hardware
			grep "^HOSTNAME:" $SYSINFO > $TMPFILE
			grep "^DATE:" $SYSINFO >> $TMPFILE
			grep "^OS:" $SYSINFO >> $TMPFILE
			grep "^KERNEL:" $SYSINFO >> $TMPFILE
			grep "^MODEL:" $SYSINFO >> $TMPFILE
			grep "^CPU:" $SYSINFO >> $TMPFILE
			grep "^ZONETYPE:" $SYSINFO >> $TMPFILE
			awk -F: '{print $2}' $TMPFILE | sed -e 's/^[ ]*//' | sed 's/ /_/g' | awk '{printf "%-40s", $1}' >> $HARDWARE_INFO
			echo >> $HARDWARE_INFO
			
			# Data for software
			grep "^HOSTNAME:" $SYSINFO > $TMPFILE
			grep "^OS:" $SYSINFO >> $TMPFILE
			grep "^DATE:" $SYSINFO >> $TMPFILE
			grep "UPTIME:" $SYSINFO >> $TMPFILE
			grep "NETBACKUP:" $SYSINFO >> $TMPFILE
			awk -F: '{print $2}' $TMPFILE | sed -e 's/^[ ]*//' | sed 's/ /_/g' | awk '{printf "%-35s", $1}' >> $SOFTWARE_INFO
			echo >> $SOFTWARE_INFO
		fi
	done < $NO_HEADER_MASTER
	rm -f $TMPFILE
	
	while read globalHosts
	do
		SYSINFO2=$HOST_INFO_DIR/$globalHosts/CMDB/$globalHosts-sysinfo.txt
		# Data for zonelistReport
		grep "^HOSTNAME:" $SYSINFO2 > $TMPFILE
		grep "^DATE:" $SYSINFO2 >> $TMPFILE
		grep "^ZONELIST:" $SYSINFO2 >> $TMPFILE
		awk -F: '{print $2}' $TMPFILE | sed -e 's/^[ ]*//' | sed 's/ /_/g' | awk '{printf "%-30s", $1}' >> $ZONELIST_INFO
		echo >> $ZONELIST_INFO
	done < $TMPFILE2
	rm -f $TMPFILE2
