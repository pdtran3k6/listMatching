	#!/bin/ksh
	###########################################################################################################
	# NAME: collectVXinfo
	#
	# DESCRIPTION:
	# This script will collect all the vxdisk_list_info.txt from all the hosts in all-data
	#
	#
	# INPUT: 
	#
	#
	#
	# OUTPUT:
	# VXReport.txt: containing all the vxdisk_list_info.txt of all the existing hosts
	# 
	#
	# ENVIRONMENT VARIABLES:
	# 
	#
	# NOTES: 
	#
	#
	# EXIT CODE:
	#
	#
	# CHANGELOG:
	# Apr 1 2016 PHAT TRAN
	############################################################################################################

	TARGETDIR=/opt/fundserv/syscheck/webcontent/listMatching/sources
	SOURCEDIR=/opt/fundserv/syscheck/all-data/`date +%Y%m`
	VX_INFO=/opt/fundserv/syscheck/webcontent/CMDB/reports/VXReport.txt
	
	echo "VX DISK INFO REPORT" > $VX_INFO
	date '+%a %d-%b-%Y %R' >> $VX_INFO
	echo >> $VX_INFO
	
	for hostName in $(ls $SOURCEDIR)
	do
		if [ -f "$SOURCEDIR/$hostName/CMDB/vxdisk_list_info.txt" ]
		then
			cat $SOURCEDIR/$hostName/CMDB/vxdisk_list_info.txt >> $VX_INFO
			echo "################################################################################################################" >> $VX_INFO
			echo >> $VX_INFO
		fi
	done

	echo >> $VX_INFO
	/opt/fundserv/syscheck/common-bin/footer $0 $$ >> $VX_INFO
        
	
	