#!/bin/ksh
###########################################################################################################
# NAME: daily.local
#
# DESCRIPTION:
# This script will run other scripts involved in the listMatching project 
# in their respective location sequentially. It will also set specfic permission and owner to 
# every files in ~syscheck/common-data/ 
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
# Mar 3 2016 PHAT TRAN
############################################################################################################


./../common-bin/extractnodes-for-listMatching.ksh 2> /dev/null
./extractnodes_syscheck-for-listMatching.ksh 2> /dev/null
./catSources.ksh 2> /dev/null
./../common-bin/listMatching.ksh 2> /dev/null
./../common-bin/convert2HTML.ksh 2> /dev/null
./listMatchingReports.ksh 2> /dev/null
./hostInfoReports.ksh 2> /dev/null

chown -R syscheck:staff ../common-data/*
chmod -R 644 ../common-data/*