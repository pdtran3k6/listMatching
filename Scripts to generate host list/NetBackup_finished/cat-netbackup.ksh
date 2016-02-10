#!/bin/ksh
###########################################################################################################
# NAME: cat-netbackup
#
# DESCRIPTION:
# This script will merge all lists of hosts from NetBackup into a bigger list that contains all
# the hosts from NetBackup
#
#
# INPUT: 
# SOURCEDIR: the path to the directory that contains all the lists of hosts
# TARGETDIR: the path to the directory that contains the final list of hosts
#
#
# OUTPUT:
# 
# 
# ENVIRONMENT VARIABLES:
# 
#
# NOTES:
# The name of the individual list has to be in this format: netbackup-*.lst
#
#
# EXIT CODE:
# 0 - success
# 1 - incorrect arguements
#
#
# CHANGELOG:
# Feb 10 2016 PHAT TRAN
############################################################################################################

HOST=`uname -n`
TARGETDIR=/opt/fundserv/syscheck/common-data/`date +%Y%m`/$HOST/listmatching
SOURCEDIR=/opt/fundserv/syscheck/common-data/`date +%Y%m`/$HOST/listmatching

cat `find $SOURCEDIR -type f -name 'netbackup-*.lst'` | sort > $TARGETDIR/NetBackup.lst