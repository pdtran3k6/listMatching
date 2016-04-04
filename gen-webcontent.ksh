	#!/bin/ksh -x
	###########################################################################################################
	# NAME: gen-webcontent
	#
	# DESCRIPTION:
	# This script will run other scripts involved in the listMatching project 
	# in their respective location sequentially
	#
	#
	# INPUT:
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
	# This script will only be executed on syscheck master server (psa03mgmt).
	#   
	#
	# EXIT CODE:
	# 0 - success
	# 1 - incorrect arguments
	#
	#
	# CHANGELOG:
	# Mar 28 2016 PHAT TRAN
	############################################################################################################

	if [ `hostname` == "psa03mgmt" ]
	then
		/opt/fundserv/syscheck/local-bin/extractnodes_syscheck-for-listMatching.ksh 2> /dev/null
		/opt/fundserv/syscheck/local-bin/catSources.ksh 2> /dev/null
		/opt/fundserv/syscheck/local-bin/listMatching.ksh 2> /dev/null
		/opt/fundserv/syscheck/local-bin/convert2HTML.ksh 2> /dev/null
		/opt/fundserv/syscheck/local-bin/listMatchingReports.ksh 2> /dev/null
		/opt/fundserv/syscheck/local-bin/hostInfoReports.ksh 2> /dev/null
		/opt/fundserv/syscheck/local-bin/collectIPinfo.ksh 2> /dev/null
		/opt/fundserv/syscheck/local-bin/collectVXinfo.ksh 2> /dev/null
	fi
