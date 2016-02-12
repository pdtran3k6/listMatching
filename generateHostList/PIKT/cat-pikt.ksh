#!/bin/ksh
###########################################################################################################
# NAME: cat-pikt
#
# DESCRIPTION:
# This script will merge all smaller lists of hosts from PIKT into a bigger list that contains all
# the hosts from PIKT
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
# Feb 12 2016 PHAT TRAN
############################################################################################################
TARGETDIR=/opt/fundserv/syscheck/data/`date +%Y%m`/`uname –n`/listmatching
SOURCEDIR=/

cat `find $SOURCEDIR -type f -name 'pikt-*.list'` | sort > $TARGETDIR/PIKT.list