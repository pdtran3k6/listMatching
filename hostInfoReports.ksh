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
	# Apr 13 2016 PHAT TRAN
	############################################################################################################

	HOST_INFO_DIR=/opt/fundserv/syscheck/all-data/`date +%Y%m`
	WEB_HOST_INFO_DIR=/opt/fundserv/syscheck/webcontent/CMDB/sysinfo
	REPORT_DIR=/opt/fundserv/syscheck/webcontent/CMDB/reports
	NO_HEADER_MASTER=/opt/fundserv/syscheck/webcontent/listMatching/totals/noHeader-Master
	TMPFILE=/opt/fundserv/syscheck/tmp/`basename $0`.$$
	TMPFILE2=/opt/fundserv/syscheck/tmp/`basename $0`-2.$$
	
	# Delete all current sysinfo.txt files from WEB_HOST_INFO_DIR
	rm $WEB_HOST_INFO_DIR/* $REPORT_DIR/* 2> /dev/null

	# Header of all the reports file
	hostInfoFormat="%-40s"
	printf "$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat\n" \
	"HOSTNAME" "DATE" "REMOTE_MGMT" "OS" "KERNEL" "MODEL" "CPU" "ZONETYPE" "CHASSIS_S/N" "SITE" "RACK" \
	"U_BOTTOM" "CONTRACT_#" "ASSET_TAG" "ENV" "APPS" > $REPORT_DIR/hostInfoReport.txt
	
	hardwareFormat="%-40s"
	printf "$hardwareFormat$hardwareFormat$hardwareFormat$hardwareFormat$hardwareFormat$hardwareFormat$hardwareFormat\n" \
	"HOSTNAME" "DATE" "OS" "KERNEL" "MODEL" "CPU" "ZONETYPE" > $REPORT_DIR/hardwareReport.txt
	
	softwareFormat="%-35s"
	printf "$softwareFormat$softwareFormat$softwareFormat$softwareFormat$softwareFormat$softwareFormat\n" "HOSTNAME" "DATE" "OS" "NETBACKUP" "RSYNC" "UPTIME" > $REPORT_DIR/softwareReport.txt
	
	zonelistFormat="%-30s"
	printf "$zonelistFormat$zonelistFormat$zonelistFormat\n" "HOSTNAME" "DATE" "ZONELIST" > $REPORT_DIR/zonelistReport.txt

	# Loop through all the hosts (global and local) that have a sysinfo.txt file
	while read hostName
	do
		if [ -f "$HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt" ]
		then
			# Copy new set of sysinfo.txt files from HOST_INFO_DIR into WEB_HOST_INFO_DIR
			cp $HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt $WEB_HOST_INFO_DIR/$hostName-sysinfo.txt
			
			# Declare variables for all hosts (global and local)
			SYSINFO=$HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt
			HOSTNAME=`grep "^HOSTNAME:" $SYSINFO | head -1`
			DATE=`grep "^DATE:" $SYSINFO | head -1`
			OS=`grep "^OS:" $SYSINFO | head -1`
			REMOTE_MGMT=`grep "^REMOTE MGMT:" $SYSINFO | head -1`
			KERNEL=`grep "^KERNEL:" $SYSINFO | head -1`
			MODEL=`grep "^MODEL:" $SYSINFO | head -1`
			CPU=`grep "^CPU:" $SYSINFO | head -1`
			ZONETYPE=`grep "^ZONETYPE:" $SYSINFO | head -1`
			CHASSIS_SN=`grep "^CHASSIS SERIAL NUMBER:" $SYSINFO | head -1`
			SITE=`grep "^SITE:" $SYSINFO | head -1`
			RACK=`grep "^RACK:" $SYSINFO | head -1`
			U_BOTTOM=`grep "^U BOTTOM:" $SYSINFO | head -1`
			CONTRACT_NUM=`grep "^CONTRACT #:" $SYSINFO | head -1`
			ASSET_TAG=`grep "^ASSET TAG:" $SYSINFO | head -1`
			ENV=`grep "^ENV:" $SYSINFO | head -1`
			APPS=`grep "^APPS: " $SYSINFO | head -1`
			NETBACKUP=`grep "^NETBACKUP:" $SYSINFO | head -1`
			RSYNC=`grep "^RSYNC:" $SYSINFO | head -1`
			UPTIME=`grep "^UPTIME:" $SYSINFO | head -1`
			zone=`echo $ZONETYPE | awk -F: '{print $2}'`
			
			# Data for hostInfo
			echo "$HOSTNAME" > $TMPFILE
			echo "$DATE" >> $TMPFILE
			if [ "$zone" == " global" ]
			then
				echo "$REMOTE_MGMT" >> $TMPFILE
				echo "$OS" >> $TMPFILE
				echo "$KERNEL" >> $TMPFILE
				echo "$MODEL" >> $TMPFILE
				echo "$CPU" >> $TMPFILE
				echo "$ZONETYPE" >> $TMPFILE
				echo "$CHASSIS_SN" >> $TMPFILE
				echo "$SITE" >> $TMPFILE
				echo "$RACK" >> $TMPFILE
				echo "$U_BOTTOM" >> $TMPFILE
				echo "$CONTRACT_NUM" >> $TMPFILE
				echo "$ASSET_TAG" >> $TMPFILE
				echo "$hostName" >> $TMPFILE2
			else
				echo "REMOTE MGMT: " >> $TMPFILE
				echo "$OS" >> $TMPFILE
				echo "$KERNEL" >> $TMPFILE
				echo "$MODEL" >> $TMPFILE
				echo "$CPU" >> $TMPFILE
				echo "$ZONETYPE" >> $TMPFILE
				echo "CHASSIS SERIAL NUMBER: ">> $TMPFILE
				echo "SITE: " >> $TMPFILE
				echo "RACK: " >> $TMPFILE
				echo "U BOTTOM: " >> $TMPFILE
				echo "CONTRACT #: " >> $TMPFILE
				echo "ASSET TAG: " >> $TMPFILE
			fi
			echo "$ENV" >> $TMPFILE
			echo "$APPS" >> $TMPFILE
			
			# Re-format the data in table format (HOST_INFO)
			awk -F: '{print $2 $3}' $TMPFILE | sed -e 's/^[ ]*//' | sed 's/ /_/g' | sed 's/^$/_/g' | awk '{printf "%-40s", $1}' >> $REPORT_DIR/hostInfoReport.txt
			echo >> $REPORT_DIR/hostInfoReport.txt
			
			# Data for hardware
			echo "$HOSTNAME" > $TMPFILE
			echo "$DATE" >> $TMPFILE
			echo "$OS" >> $TMPFILE
			echo "$KERNEL" >> $TMPFILE
			echo "$MODEL" >> $TMPFILE
			echo "$CPU" >> $TMPFILE
			echo "$ZONETYPE" >> $TMPFILE
			
			# Re-format the data in table format (HARDWARE_INFO)
			awk -F: '{print $2}' $TMPFILE | sed -e 's/^[ ]*//' | sed 's/ /_/g' | sed 's/^$/_/g' | awk '{printf "%-40s", $1}' >> $REPORT_DIR/hardwareReport.txt
			echo >> $REPORT_DIR/hardwareReport.txt
			
			# Data for software
			echo "$HOSTNAME" > $TMPFILE
			echo "$DATE" >> $TMPFILE
			echo "$OS" >> $TMPFILE
			echo "$NETBACKUP" >> $TMPFILE
			echo "$RSYNC" >> $TMPFILE
			echo "$UPTIME" >> $TMPFILE
			
			# Re-format the data in table format (SOFTWARE_INFO)
			awk -F: '{print $2}' $TMPFILE | sed -e 's/^[ ]*//' | sed 's/ /_/g' | sed 's/^$/_/g' | awk '{printf "%-35s", $1}' >> $REPORT_DIR/softwareReport.txt
			echo >> $REPORT_DIR/softwareReport.txt
		fi
	done < $NO_HEADER_MASTER
	
	# Loop through all the global hosts
	while read globalHosts
	do
		# Declare variables for global hosts
		SYSINFO2=$HOST_INFO_DIR/$globalHosts/CMDB/$globalHosts-sysinfo.txt
		HOSTNAME=`grep "^HOSTNAME:" $SYSINFO2 | head -1`
		DATE=`grep "^DATE:" $SYSINFO2 | head -1`
		ZONELIST=`grep "^ZONELIST:" $SYSINFO2 | head -1`
		
		# Data for zonelistReport
		echo "$HOSTNAME" > $TMPFILE
		echo "$DATE" >> $TMPFILE
		echo "$ZONELIST" >> $TMPFILE
		
		# Re-format the data in table format (ZONELIST_INFO)
		awk -F: '{print $2}' $TMPFILE | sed -e 's/^[ ]*//' | sed 's/ /_/g' | sed 's/^$/_/g' | awk '{printf "%-30s", $1}' >> $REPORT_DIR/zonelistReport.txt
		echo >> $REPORT_DIR/zonelistReport.txt
	done < $TMPFILE2
	
	# Clean up trashes
	rm -f $TMPFILE2
	rm -f $TMPFILE