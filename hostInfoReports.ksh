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
	# Mar 22 2016 PHAT TRAN
	############################################################################################################

	HOST_INFO_DIR=/opt/fundserv/syscheck/all-data/`date +%Y%m`
	WEB_HOST_INFO_DIR=/opt/fundserv/syscheck/webcontent/CMDB/sysinfo
	NO_HEADER_MASTER=/opt/fundserv/syscheck/webcontent/listMatching/totals/noHeader-Master
	HARDWARE_INFO=/opt/fundserv/syscheck/webcontent/CMDB/reports/hardwareReport.txt
	SOFTWARE_INFO=/opt/fundserv/syscheck/webcontent/CMDB/reports/softwareReport.txt
	ZONELIST_INFO=/opt/fundserv/syscheck/webcontent/CMDB/reports/zonelistReport.txt
	NETWORK_INFO=/opt/fundserv/syscheck/webcontent/CMDB/reports/networkReport.txt
	TMPFILE=/opt/fundserv/syscheck/tmp/`basename $0`.$$

	# Delete all current sysinfo.txt files from WEB_HOST_INFO_DIR
	rm $WEB_HOST_INFO_DIR/* $HARDWARE_INFO $SOFTWARE_INFO $ZONELIST_INFO $NETWORK_INFO 2> /dev/null

	# Header of all the reports file
	echo "HOSTNAME" >> $HARDWARE_INFO
	echo "DATE" >> $HARDWARE_INFO
	echo "OS" >> $HARDWARE_INFO
	echo "KERNEL" >> $HARDWARE_INFO
	echo "MODEL" >> $HARDWARE_INFO
	echo "CPU" >> $HARDWARE_INFO
	echo "ZONETYPE" >> $HARDWARE_INFO
	echo "CHASSIS_S/N" >> $HARDWARE_INFO
	echo "SITE" >> $HARDWARE_INFO
	echo "RACK" >> $HARDWARE_INFO
	echo "U_BOTTOM" >> $HARDWARE_INFO
	echo "CONTRACT_#" >> $HARDWARE_INFO
	echo "ASSET_TAG" >> $HARDWARE_INFO
	echo "REMOTE_MGMT" >> $HARDWARE_INFO
	echo "ENV" >> $HARDWARE_INFO
	echo "APPS" >> $HARDWARE_INFO
	awk '{printf "%-40s", $1}' $HARDWARE_INFO > $HARDWARE_INFO.tmp && mv $HARDWARE_INFO.tmp $HARDWARE_INFO
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

		if [ -f "$HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt" ]
		then
			# Copy new set of sysinfo.txt files from HOST_INFO_DIR into WEB_HOST_INFO_DIR
			cp $HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt $WEB_HOST_INFO_DIR/$hostName-sysinfo.txt
			
			SYSINFO=$HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt
			
			# Data for hardware
			grep "^HOSTNAME:" $SYSINFO > $TMPFILE
			grep "^DATE:" $SYSINFO >> $TMPFILE
			grep "^OS:" $SYSINFO >> $TMPFILE
			grep "^KERNEL:" $SYSINFO >> $TMPFILE
			grep "^MODEL:" $SYSINFO >> $TMPFILE
			grep "^CPU:" $SYSINFO >> $TMPFILE
			grep "^ZONETYPE:" $SYSINFO >> $TMPFILE
			zonetype=`grep "^ZONETYPE:" $SYSINFO | awk -F: '{print $2}'`
			if [ "$zonetype" == " global" ]
			then
				grep "^CHASSIS SERIAL NUMBER:" $SYSINFO >> $TMPFILE
				grep "^SITE:" $SYSINFO >> $TMPFILE
				grep "^RACK:" $SYSINFO >> $TMPFILE
				grep "^U BOTTOM:" $SYSINFO >> $TMPFILE
				grep "^CONTRACT #:" $SYSINFO >> $TMPFILE
				grep "^ASSET TAG:" $SYSINFO >> $TMPFILE
				grep "^REMOTE MGMT:" $SYSINFO >> $TMPFILE
			else
				echo >> $TMPFILE
				echo "SITE: " >> $TMPFILE
				echo "RACK: " >> $TMPFILE
				echo "U BOTTOM: " >> $TMPFILE
				echo "CONTRACT #: " >> $TMPFILE
				echo "ASSET TAG: " >> $TMPFILE
				echo "REMOTE MGMT: " >> $TMPFILE
			fi
			grep "^ENV:" $SYSINFO >> $TMPFILE
			grep "^APPS: " $SYSINFO >> $TMPFILE
			awk -F: '{print $2 $3}' $TMPFILE | sed -e 's/^[ \t]*//' | sed 's/ /_/g' | awk '{printf "%-40s", $1}' >> $HARDWARE_INFO
			echo >> $HARDWARE_INFO
			
			# Data for software
			grep "^HOSTNAME:" $SYSINFO > $TMPFILE
			grep "^DATE:" $SYSINFO >> $TMPFILE
			grep "UPTIME:" $SYSINFO >> $TMPFILE
			grep "NETBACKUP:" $SYSINFO >> $TMPFILE
			awk -F: '{print $2}' $TMPFILE | cut -c 2- | sed 's/ /_/g' | awk '{printf "%-30s", $1}' >> $SOFTWARE_INFO
			echo >> $SOFTWARE_INFO
		
			# Data for zonelistReport
			grep "^HOSTNAME:" $SYSINFO > $TMPFILE
			grep "^DATE:" $SYSINFO >> $TMPFILE
			grep "^ZONELIST:" $SYSINFO >> $TMPFILE
			awk -F: '{print $2}' $TMPFILE | cut -c 2- | sed 's/ /_/g' | awk '{printf "%-30s", $1}' >> $ZONELIST_INFO
			echo >> $ZONELIST_INFO
		fi
	done < $NO_HEADER_MASTER
	rm -f $TMPFILE

