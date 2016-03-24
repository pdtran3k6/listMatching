	#!/bin/ksh
	###########################################################################################################
	# NAME: extractnodes_syscheck-for-listMatching
	#
	# DESCRIPTION:
	# This script build the list of nodes under syscheck control based on
	# 1)the global zones from the all_* lists found in ~sycheck/local-etc on the syscheck master server
	# 2)then extracting for each of the global zones, the local zones captured in their respective sysinfo.txt files
	#
	#
	# INPUT:
	# ~syscheck/local-etc/all_dev.list, all_uat.list and all_prod.list
	# 
	# 
	# OUTPUT:
	# syscheck-$HOST.list that contains all the nodes on all_dev.list, all_prod.list, all_uat.list   
	# 
	#
	# ENVIRONMENT VARIABLES:
	# 
	#
	# NOTES:
	#
	#
	# EXIT CODE:
	# 0 - success
	# 1 - incorrect arguments
	#
	#
	# CHANGELOG:
	# Mar 21 2016 PHAT TRAN
	############################################################################################################

	HOST=`uname -n | cut -d'.' -f1`
	TARGETDIR=/opt/fundserv/syscheck/all-data/`date +%Y%m`/$HOST/listMatching
	TMPFILE=/opt/fundserv/syscheck/tmp/`basename $0`.$$
	HOST_INFO_DIR=/opt/fundserv/syscheck/all-data/`date +%Y%m`

	if [ ! -d $TARGETDIR ]
	then
		mkdir -p -m 755 $TARGETDIR
		chown syscheck:10 $TARGETDIR
	fi
	
	rm $TARGETDIR/syscheck-$HOST.list 2> /dev/null
	
	for hostName in $(ls $HOST_INFO_DIR)
	do
		if [ -f "$HOST_INFO_DIR/$hostName/CMDB/$hostName-sysinfo.txt" ] 
		then
			echo "$hostName" >> $TARGETDIR/syscheck-$HOST.list
		fi
	done
	
	export size=`du -h $TARGETDIR/syscheck-$HOST.list | awk '{print $1}'`
	if [  "$size" == "0K" ]
	then 
		rm -rf $TARGETDIR
	fi
