	#!/bin/ksh
	###########################################################################################################
	# NAME: collectIPinfo
	#
	# DESCRIPTION:
	# This script will collect all the IPinfo.txt from all the hosts in all-data
	#
	#
	# INPUT: 
	#
	#
	#
	# OUTPUT:
	# networkReport.txt: containing all the IPinfo.txt of all the existing hosts
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
	# Mar 29 2016 PHAT TRAN
	############################################################################################################

	TARGETDIR=/opt/fundserv/syscheck/webcontent/listMatching/sources
	SOURCEDIR=/opt/fundserv/syscheck/all-data/`date +%Y%m`
	NETWORK_INFO=/opt/fundserv/syscheck/webcontent/CMDB/reports/networkReport.txt
	
	/opt/fundserv/syscheck/common-bin/serverbanner > $NETWORK_INFO
	date '+%a %d-%b-%Y %R' >> $NETWORK_INFO
	echo >> $NETWORK_INFO
	
	for hostName in $(ls $SOURCEDIR)
	do
		if [ -f "$SOURCEDIR/$hostName/CMDB/$hostName-IPinfo.txt" ]
		then
			cat $SOURCEDIR/$hostName/CMDB/$hostName-IPinfo.txt >> $NETWORK_INFO
			echo "###########################################################################" >> $NETWORK_INFO
			echo >> $NETWORK_INFO
		fi
	done

	echo >> $NETWORK_INFO
	/opt/fundserv/syscheck/common-bin/footer $0 $$ >> $NETWORK_INFO
        
	
	