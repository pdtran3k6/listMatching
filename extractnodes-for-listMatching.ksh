	#!/bin/ksh
	###########################################################################################################
	# NAME: extractnodes-for-listMatching
	#
	# DESCRIPTION:
	# This script will extract the registered nodes out of a central administrative tool 
	# (like NetBackup, BoKS, etc.)
	#
	#
	# INPUT:
	#
	# 
	# OUTPUT:
	# source-hostname.list for each source, which will be store in TARGETDIR path with respect to the host.   
	# 
	#
	# ENVIRONMENT VARIABLES:
	# 
	#
	# NOTES:
	# This script is executed on all nodes.  At the beginning of each section there is some logic 
	# to detect if the node is an admin server or not. If it is, then the command to 
	# extract the node list is executed.
	#
	#
	# EXIT CODE:
	# 0 - success
	# 1 - incorrect arguments
	#
	#
	# CHANGELOG:
	# Apr 6 2016 PHAT TRAN
	############################################################################################################
	 
	HOST=`uname -n | cut -d'.' -f1`
	YM=`date +%Y%m`
	TARGETDIR=/opt/fundserv/syscheck/common-data/$YM/$HOST/listMatching
	HOST_FOLDER=/opt/fundserv/syscheck/common-data/$YM
	TMPFILE=/opt/fundserv/syscheck/tmp/`basename $0`.$$

	if [ ! -d $TARGETDIR ]
	then	
		mkdir -p -m 755 $TARGETDIR
		chown -R syscheck:10 $HOST_FOLDER
	fi
	
	##### BOKS
	# Check to see if this is a BOKS admin server
	# If yes, extract the list of hosts to TARGETDIR
	[ -f "/opt/boksm/sbin/boksadm" ] && /opt/boksm/sbin/boksadm -S hostadm -l -t UNIXBOKSHOST -S | awk '{print $1}' > $TARGETDIR/boks-$HOST.list

	##### CONTROLM
	# Since all the Control M servers are linux, we can hardcode the path of 'whoami' command
	[ -f "/opt/controlm/ctm_server/exe_Linux-x86_64/ctm_agstat" ] && runuser -l controlm -c "/opt/controlm/ctm_server/exe_Linux-x86_64/ctm_agstat -list '*'" | awk '{print $2}' | sed '1,5d' > $TARGETDIR/controlm-$HOST.list
	
	##### NETBACKUP
	# Check to see if this is a NETBACKUP admin server
	# If yes, extract the list of hosts that aren't Windows to the TARGETDIR
	[ -f "/usr/openv/netbackup/bin/admincmd/bpplclients" ] && /usr/openv/netbackup/bin/admincmd/bpplclients -allunique -l | grep -i -v "windows" | awk '{print $2}' > $TARGETDIR/netbackup-$HOST.list

	##### UPTIME
	# Check to see if this is a UPTIME admin server
	ls /etc/init.d/ | grep uptime > /dev/null
	if [ $? -eq 0 ] 
	then 
		# Extract all hosts and output into Uptime.list
		mysql -u uptime -puptime -P3308 --protocol=tcp uptime -e "SELECT sysname, arch FROM entity_configuration WHERE arch LIKE '%Linux%' OR arch LIKE '%SunOS%' ORDER BY arch" > $TMPFILE.name_os 
		grep 'vSphere' $TMPFILE.name_os > $TMPFILE.vSphere
		grep -v 'vSphere' $TMPFILE.name_os | sed '1d' | awk -F. '{print $1}' > $TMPFILE 
		cat $TMPFILE $TMPFILE.vSphere | awk -F'\t' '{print $1}' | sort -u > $TMPFILE.name_os.tmp
		mv $TMPFILE.name_os.tmp $TARGETDIR/uptime-$HOST.list
	fi

	ls $HOST_FOLDER > $TMPFILE
	while read hostName
	do
		size=`du -h $HOST_FOLDER/$hostName/listMatching/*-$hostName.list | awk '{print $1}'`
		if [ -d $HOST_FOLDER/$hostName/listMatching ]
		then
			if [  "$size" == "0K" ] || [ -z "$(ls -A $HOST_FOLDER/$hostName/listMatching)" ]
			then
				rm -rf $HOST_FOLDER/$hostName/listMatching
			fi
		fi
	done < $TMPFILE
	rm -f $TMPFILE
