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
	# Apr 29 2016 PHAT TRAN
	############################################################################################################

	HOST_INFO_DIR=/opt/fundserv/syscheck/all-data/`date +%Y%m`
	WEB_HOST_INFO_DIR=/opt/fundserv/syscheck/webcontent/CMDB/sysinfo
	REPORT_DIR=/opt/fundserv/syscheck/webcontent/CMDB/reports
	NO_HEADER_MASTER=/opt/fundserv/syscheck/webcontent/listMatching/totals/noHeader-Master
	TMPFILE=/opt/fundserv/syscheck/tmp/`basename $0`.$$
	TMPFILE2=/opt/fundserv/syscheck/tmp/`basename $0`-2.$$
	HOSTS_WITH_SYSINFO=/opt/fundserv/syscheck/webcontent/listMatching/totals/hostsWithSysinfo
	CURRENT_HOSTNAME=`hostname`
	ENVIRONMENT_LIST=/opt/fundserv/syscheck/webcontent/listMatching/environmentList.txt
	OS_LIST=/opt/fundserv/syscheck/webcontent/listMatching/osList.txt
	MODEL_LIST=/opt/fundserv/syscheck/webcontent/listMatching/modelList.txt

	
	# Delete all current sysinfo.txt files from WEB_HOST_INFO_DIR
	rm $WEB_HOST_INFO_DIR/* $REPORT_DIR/* 2> /dev/null
	
	# Header of all the reports file
	hostInfoFormat="%-35s"
	printf "$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat \
	$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat\n" \
	"HOSTNAME" "DATE" "REMOTE_MGMT" "OS" "KERNEL" "MODEL" "CPU" "ZONETYPE" "CHASSIS_S/N" "SITE" "RACK" \
	"U_BOTTOM" "CONTRACT_#" "ASSET_TAG" "ENV" "APP_CODE" "APP_NAME" > $REPORT_DIR/hostInfoReport.txt

	softwareFormat="%-35s"
	printf "$softwareFormat$softwareFormat$softwareFormat$softwareFormat$softwareFormat$softwareFormat\n" "HOSTNAME" "DATE" "OS" "NETBACKUP" "RSYNC" "UPTIME" > $REPORT_DIR/softwareReport.txt
	
	zonelistFormat="%-30s"
	printf "$zonelistFormat$zonelistFormat$zonelistFormat\n" "GLOBAL_ZONE" "DATE" "ZONELIST" > $REPORT_DIR/zonelistReport.txt
	
	while read hostName
	do
		# Copy new set of sysinfo.txt files from HOST_INFO_DIR into WEB_HOST_INFO_DIR
		[ -f "$HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt" ] && cp $HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt $WEB_HOST_INFO_DIR/$hostName-sysinfo.txt
	done < $NO_HEADER_MASTER
	
	ls $WEB_HOST_INFO_DIR | sed 's/-sysinfo.txt//' > $HOSTS_WITH_SYSINFO
	
	# Loop through all the hosts (global and local) that have a sysinfo.txt file
	while read hostName
	do	
		# Declare variables for all hosts (global and local)
		SYSINFO=$HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt
		ZONETYPE=`grep -i "^ZONETYPE:" $SYSINFO | head -1`
		zone=`echo $ZONETYPE | awk -F: '{print $2}'`
		HOSTNAME=`grep -i "^HOSTNAME:" $SYSINFO | head -1`
		DATE=`grep -i "^DATE:" $SYSINFO | head -1`
		OS=`grep -i "^OS:" $SYSINFO | head -1`
		REMOTE_MGMT=`grep -i "^REMOTE MGMT:" $SYSINFO | head -1`
		KERNEL=`grep -i "^KERNEL:" $SYSINFO | head -1`
		MODEL=`grep -i "^MODEL:" $SYSINFO | head -1`
		CPU=`grep -i "^CPU:" $SYSINFO | head -1`
		ZONELIST=`grep -i "^ZONETYPE:" $SYSINFO | head -1`
		CHASSIS_SN=`grep -i "^CHASSIS SERIAL NUMBER:" $SYSINFO | head -1`
		SITE=`grep -i "^SITE:" $SYSINFO | head -1`
		RACK=`grep -i "^RACK:" $SYSINFO | head -1`
		U_BOTTOM=`grep -i "^U BOTTOM:" $SYSINFO | head -1`
		CONTRACT_NUM=`grep -i "^CONTRACT #:" $SYSINFO | head -1`
		ASSET_TAG=`grep -i "^ASSET TAG:" $SYSINFO | head -1`
		ENV=`grep -i "^ENV:" $SYSINFO | head -1`
		APP_CODE=`grep -i "^App code:" $SYSINFO | head -1`
		APP_NAME=`grep -i "^App name:" $SYSINFO | head -1`
		NETBACKUP=`grep -i "^NETBACKUP:" $SYSINFO | head -1`
		RSYNC=`grep -i "^RSYNC:" $SYSINFO | head -1`
		UPTIME=`grep -i "^UPTIME:" $SYSINFO | head -1`
		rack=`echo $RACK | awk -F: '{print $2}'`
		app=`echo $APP_CODE | awk -F: '{print $2}'`
		
		numIP=`grep -v "^#" /etc/hosts 2> /dev/null | grep -v loghost 2> /dev/null | grep "$hostName" 2> /dev/null | wc -l | sed 's/^[ ]*//'`
		if [ "$numIP" -gt 1 ]
		then
			primIP=`echo "Error - $numIP lines found in $CURRENT_HOSTNAME:/etc/hosts"`
		else
			primIP=`grep -v "^#" /etc/hosts 2> /dev/null | grep "$hostName" 2> /dev/null | awk '{print $1}'` 
		fi
		echo "LOGIN IP: $primIP" > $TMPFILE
		
		if [ "$zone" != " global" ]
		then
			parentGlobalZone=`egrep "ZONELIST.*$hostName" $WEB_HOST_INFO_DIR/* | cut -d/ -f8 | cut -d- -f1`
			echo "PARENT GLOBAL ZONE: $parentGlobalZone" >> $TMPFILE
		fi
		
		echo >> $TMPFILE
		cat $TMPFILE $HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt > $WEB_HOST_INFO_DIR/$hostName-sysinfo.txt

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
		echo "$APP_CODE" >> $TMPFILE
		echo "$APP_NAME" >> $TMPFILE
		
		# Re-format the data in table format (hostInfoReport.txt)
		awk -F: '{print $2 $3}' $TMPFILE | sed -e 's/^[ ]*//' | sed 's/ /_/g' | sed 's/^$/_/g' | awk '{printf "%-35s", $1}' >> $REPORT_DIR/hostInfoReport.txt
		echo >> $REPORT_DIR/hostInfoReport.txt
		
		# Data for Rack report
		# Only includes the host if the it has Rack info
		if [ ! -z "$rack" ]
		then
			echo "$SITE" > $TMPFILE
			echo "$RACK" >> $TMPFILE
			echo "$U_BOTTOM" >> $TMPFILE
			echo "$HOSTNAME" >> $TMPFILE
			echo "$MODEL" >> $TMPFILE
			echo "$CHASSIS_SN" >> $TMPFILE
			echo "$ASSET_TAG" >> $TMPFILE
			
			# Re-format the data in table format (rackReport.txt)
			awk -F: '{print $2}' $TMPFILE | sed -e 's/^[ ]*//' | sed 's/ /_/g' | sed 's/^$/_/g' | awk '{printf "%-40s", $1}' >> $REPORT_DIR/rackReport.txt
			echo >> $REPORT_DIR/rackReport.txt
		fi
		
		# Data for Apps report
		# Only includes the host if the it has App info
		if [ ! -z "$app" ]
		then
			echo "$APP_CODE" > $TMPFILE
			echo "$APP_NAME" >> $TMPFILE
			echo "$ENV" >> $TMPFILE
			echo "$SITE" >> $TMPFILE
			echo "$HOSTNAME" >> $TMPFILE
			
			# Re-format the data in table format (appsReport.txt)
			awk -F: '{print $2}' $TMPFILE | sed -e 's/^[ ]*//' | sed 's/ /_/g' | sed 's/^$/_/g' | awk '{printf "%-40s", $1}' >> $REPORT_DIR/appsReport.txt
			echo >> $REPORT_DIR/appsReport.txt
		fi
		
		# Data for Software report
		echo "$HOSTNAME" > $TMPFILE
		echo "$DATE" >> $TMPFILE
		echo "$OS" >> $TMPFILE
		echo "$NETBACKUP" >> $TMPFILE
		echo "$RSYNC" >> $TMPFILE
		echo "$UPTIME" >> $TMPFILE
		
		# Re-format the data in table format (softwareReport.txt)
		awk -F: '{print $2}' $TMPFILE | sed -e 's/^[ ]*//' | sed 's/ /_/g' | sed 's/^$/_/g' | awk '{printf "%-35s", $1}' >> $REPORT_DIR/softwareReport.txt
		echo >> $REPORT_DIR/softwareReport.txt
	done < $HOSTS_WITH_SYSINFO

	echo > HIP_globalHosts.txt
	mv $TMPFILE2 listOfGlobalHosts.txt
	# Loop through all the global hosts
	while read globalHosts
	do
		# Declare variables for global hosts
		SYSINFO2=$HOST_INFO_DIR/$globalHosts/CMDB/$globalHosts-sysinfo.txt
		HOSTNAME=`grep -i "^HOSTNAME:" $SYSINFO2 | head -1`
		DATE=`grep -i "^DATE:" $SYSINFO2 | head -1`
		ZONELIST=`grep -i "^ZONELIST:" $SYSINFO2 | head -1`
		
		# Data for Zonelist report
		echo "$HOSTNAME" > $TMPFILE
		echo "$DATE" >> $TMPFILE
		echo "$ZONELIST" >> $TMPFILE
		
		# Re-format the data in table format (zonelistReport.txt)
		awk -F: '{print $2}' $TMPFILE | sed -e 's/^[ ]*//' | sed 's/ /_/g' | sed 's/^$/_/g' | awk '{printf "%-30s", $1}' >> $REPORT_DIR/zonelistReport.txt
		echo >> $REPORT_DIR/zonelistReport.txt
		
		grep "$globalHosts" $REPORT_DIR/hostInfoReport.txt >> HIP_globalHosts.txt 
	done < listOfGlobalHosts.txt
	
	# Header of reports that need to be sorted
	sort $REPORT_DIR/rackReport.txt > $TMPFILE 
	rackFormat="%-40s"
	printf "$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat$hostInfoFormat\n" "SITE" "RACK" "U_BOTTOM" "HOSTNAME" "MODEL" "CHASSIS_S/N" "ASSET_TAG" > $TMPFILE2
	cat $TMPFILE2 $TMPFILE > $REPORT_DIR/rackReport.txt
	
	sort $REPORT_DIR/appsReport.txt > $TMPFILE
	appsFormat="%-40s"
	printf "$appsFormat$appsFormat$appsFormat$appsFormat$appsFormat\n" "APP_CODE" "APP_NAME" "ENV" "SITE" "HOSTNAME" > $TMPFILE2
	cat $TMPFILE2 $TMPFILE > $REPORT_DIR/appsReport.txt
	
	
	#############################################
	#############################################
	#############################################
	###### ALL 'COUNT' REPORTS START HERE #######
	#############################################
	#############################################
	#############################################
	
	
	#### Environment count report ####
	echo "ENVIRONMENT COUNT" > $REPORT_DIR/environmentCountReport.txt
	while read environment
	do
		count=`grep -i "$environment" $REPORT_DIR/hostInfoReport.txt | wc -l` 
		echo "$environment: $count" >> $REPORT_DIR/environmentCountReport.txt
		etotal=$(($etotal + $count))
	done < $ENVIRONMENT_LIST
	echo >> $REPORT_DIR/environmentCountReport.txt
	echo "Total: $etotal" >> $REPORT_DIR/environmentCountReport.txt
	
	HOST_INFO_TABLE=$REPORT_DIR/hostInfoTable.txt
	sed '1d' $REPORT_DIR/hostInfoReport.txt > $HOST_INFO_TABLE
	echo > $TMPFILE
	echo > $TMPFILE2
	while read hostname date remote_mgmt os kernel model cpu zonetype chassis_sn site rack u_bottom contract_num asset_tag env app_code app_name
	do
		echo "$os" >> $TMPFILE
		echo "$model" >> $TMPFILE2
	done < $HOST_INFO_TABLE
	
	sed '/^$/d' $TMPFILE | sed '/^_$/d' | sort -u > $OS_LIST 
	sed '/^$/d' $TMPFILE2 | sed '/^_$/d' | sort -u > $MODEL_LIST 
	
	
	#### Os count report ####
	echo "OS COUNT" > $REPORT_DIR/osCountReport.txt
	while read os
	do
		count=`grep -i "$os" $HOST_INFO_TABLE | wc -l` 
		echo "$os: $count" >> $REPORT_DIR/osCountReport.txt
		ototal=$(($ototal + $count))
	done < $OS_LIST
	echo >> $REPORT_DIR/osCountReport.txt
	echo "Total: $ototal" >> $REPORT_DIR/osCountReport.txt
	
	
	#### Model count report ####
	#### Since we want only global hosts, we will have to grep from HIP_globalHosts.txt instead of hostInfoReport.txt ####
	echo "MODEL COUNT" > $REPORT_DIR/modelCountReport.txt
	while read model
	do
		count=`grep -i "$model" HIP_globalHosts.txt | wc -l` 
		echo "$model: $count" >> $REPORT_DIR/modelCountReport.txt
		mtotal=$(($mtotal + $count))
	done < $MODEL_LIST
	echo >> $REPORT_DIR/modelCountReport.txt
	echo "Total: $mtotal" >> $REPORT_DIR/modelCountReport.txt
	
	#### Cron jobs count report ####
	totalCronJobs=0
	total=0
	echo "ENVIRONMENT CRON-JOBS" > $REPORT_DIR/cronJobsReport.txt
	while read envTag
	do
		for hostName in $(ls $HOST_INFO_DIR)
		do
			if [ -f "$HOST_INFO_DIR/$hostName/CMDB/$hostName-countcronjobs" ] 
			then
				environment=`tail -1 $HOST_INFO_DIR/$hostName/CMDB/$hostName-countcronjobs | awk '{print $2}'`
				if [ "$environment" == "$envTag" ]
				then
					numCronJobs=`tail -1 $HOST_INFO_DIR/$hostName/CMDB/$hostName-countcronjobs | awk '{print $3}'`
					total=$(($total + $numCronJobs))
				fi
			fi
		done
		echo "$envTag: $total" >> $REPORT_DIR/cronJobsReport.txt
		totalCronJobs=$(($totalCronJobs + $total))
		total=0
	done < $ENVIRONMENT_LIST
	echo "Total: $totalCronJobs" >> $REPORT_DIR/cronJobsReport.txt
	
	# Clean up trashes
	rm -f $TMPFILE2
	rm -f $TMPFILE