#!/bin/ksh
###########################################################################################################
# NAME: cat-syscheck
#
# DESCRIPTION:
# This script will merge all lists of hosts from a particular source into a bigger list that contains all
# the hosts from that source
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
# The name of the individual list has to be in this format: all_*.lst
#
#
# EXIT CODE:
# 0 - success
# 1 - incorrect arguements
#
#
# CHANGELOG:
# Feb 8 2016 PHAT TRAN
############################################################################################################

SOURCEDIR=/opt/fundserv/syscheck/local-etc
TARGETDIR=/opt/fundserv/syscheck/common-data/`date +%Y%m`/`uname –n`/listmatching

cat `find $SOURCEDIR -type f -name 'all_*.list'` | sort > $TARGETDIR/Syscheck.lst