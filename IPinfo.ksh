	#!/bin/ksh
	###########################################################################################################
	# NAME: IPinfo
	#
	# DESCRIPTION:
	# This script will output the network info of all the hosts (for NetOps)
	# 
	# 
	# INPUT:
	# 
	# 
	# 
	# OUTPUT:
	# `hostname`-IPinfo.txt: containing the output of netstat and ifconfig command
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
	# 3 - Invalid User
	#
	#
	# CHANGELOG:
	# Mar 29 2016 PHAT TRAN
	############################################################################################################

	HOST=`uname -n | cut -d'.' -f1`
	TARGETDIR=/opt/fundserv/syscheck/common-data/`date +%Y%m`/$HOST/CMDB
	OS=`uname`
	
	case $OS in
		SunOS) WHO=$(/usr/ucb/whoami) ;;
		*) exit 2 ;;
	esac
	
	# Check that script is being run as root
	[ "$WHO" = "root" ] || exit 3
	
	echo "$HOST:" > $TARGETDIR/$HOST-IPinfo.txt
	echo "--------------------------------------------" >> $TARGETDIR/$HOST-IPinfo.txt
	netstat -an >> $TARGETDIR/$HOST-IPinfo.txt
	ifconfig -a >> $TARGETDIR/$HOST-IPinfo.txt
	