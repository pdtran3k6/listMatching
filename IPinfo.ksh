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
	# Apr 22 2016 PHAT TRAN
	############################################################################################################

	HOST=`uname -n | cut -d'.' -f1`
	TARGETDIR=/opt/fundserv/syscheck/common-data/`date +%Y%m`/$HOST/CMDB
	
	/opt/fundserv/syscheck/common-bin/serverbanner > $TARGETDIR/$HOST-IPinfo.txt
	echo >> $TARGETDIR/$HOST-IPinfo.txt
	echo "                    ********************************************" >> $TARGETDIR/$HOST-IPinfo.txt
	echo "                    ***    Output of command: netstat –nr    ***" >> $TARGETDIR/$HOST-IPinfo.txt
	echo "                    ********************************************" >> $TARGETDIR/$HOST-IPinfo.txt
	echo >> $TARGETDIR/$HOST-IPinfo.txt
	echo >> $TARGETDIR/$HOST-IPinfo.txt
	netstat -nr >> $TARGETDIR/$HOST-IPinfo.txt
	echo >> $TARGETDIR/$HOST-IPinfo.txt
	echo >> $TARGETDIR/$HOST-IPinfo.txt
	echo "                    ********************************************" >> $TARGETDIR/$HOST-IPinfo.txt
	echo "                    ***    Output of command: netstat –an    ***" >> $TARGETDIR/$HOST-IPinfo.txt
	echo "                    ********************************************" >> $TARGETDIR/$HOST-IPinfo.txt
	echo >> $TARGETDIR/$HOST-IPinfo.txt
	echo >> $TARGETDIR/$HOST-IPinfo.txt
	netstat -an >> $TARGETDIR/$HOST-IPinfo.txt
	echo >> $TARGETDIR/$HOST-IPinfo.txt
	echo >> $TARGETDIR/$HOST-IPinfo.txt 
	echo "                    ********************************************" >> $TARGETDIR/$HOST-IPinfo.txt
	echo "                    ***    Output of command: ifconfig –a    ***" >> $TARGETDIR/$HOST-IPinfo.txt
	echo "                    ********************************************" >> $TARGETDIR/$HOST-IPinfo.txt
	echo >> $TARGETDIR/$HOST-IPinfo.txt
	ifconfig -a >> $TARGETDIR/$HOST-IPinfo.txt
	/opt/fundserv/syscheck/common-bin/footer $0 $$ >> $TARGETDIR/$HOST-IPinfo.txt
	