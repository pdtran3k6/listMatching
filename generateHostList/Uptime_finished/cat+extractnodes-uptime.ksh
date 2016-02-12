#!/bin/ksh
###########################################################################################################
# NAME: cat+extractnodes-uptime
#
# DESCRIPTION:
# This script will extract all hosts from UpTime mysql database and output into a file .list
#
#
# INPUT: 
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

TARGETDIR=/opt/fundserv/syscheck/common-bin

# Check if Uptime is running on the server


# Extract all hosts and output into Uptime.lst
mysql -u uptime -puptime -P3308 --protocol=tcp uptime -e "SELECT name FROM entity" | sed '1d' > $TARGETDIR/Uptime.list
