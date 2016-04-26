	#!/bin/ksh
	###########################################################################################################
	# NAME: propagate-local
	#
	# DESCRIPTION:
	# This script will propagate folders from Master to other global zones
	# 
	# 
	# INPUT:
	# 
	# 
	# OUTPUT:
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
	# Apr 25 2016 PHAT TRAN
	############################################################################################################

	HOST=`uname -n | cut -d'.' -f1`
	PATH=$PATH:/usr/ucb
	WHO=$(whoami)
	USER=syscheck
	RSYNC_CMD=/opt/fundserv/syscheck/local-bin/rsyncwrapper-local.ksh
	MASTER=/opt/fundserv/syscheck/local-etc/master.txt
	
	read masterName < $MASTER
	[ "$HOST" = "$masterName" ] && [ "$WHO" = "$USER" ] || exit 3
	
	$RSYNC_CMD -q -l all_dev
	$RSYNC_CMD -q -l all_mgt
	$RSYNC_CMD -q -l all_prod
	$RSYNC_CMD -q -l all_uat

