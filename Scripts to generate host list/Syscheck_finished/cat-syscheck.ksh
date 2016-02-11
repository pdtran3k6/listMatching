#!/bin/ksh
###########################################################################################################
# NAME: cat-syscheck
#
# DESCRIPTION:
# This script will merge all lists of hosts from Syscheck into a bigger list that contains all
# the hosts from Syscheck
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
# Feb 10 2016 PHAT TRAN
############################################################################################################

HOST=`uname -n`
SOURCEDIR=/opt/fundserv/syscheck/common-data/`date +%Y%m`
TARGETDIR=/opt/fundserv/syscheck/common-bin

cd $SOURCEDIR
ls | sort > $TARGETDIR/Syscheck.lst