#!/bin/ksh
###########################################################################################################
# NAME: cat-netbackup
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
# The name of the individual list has to be in this format: netbackup-*.lst
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
TARGETDIR=/u1/tranp
SOURCEDIR=/

cat `find $SOURCEDIR -type f -name 'netbackup-*.lst'` | sort > $TARGETDIR/NetBackup.lst