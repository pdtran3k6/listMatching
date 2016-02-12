#!/bin/ksh
###########################################################################################################
# NAME: hostinfoCompiler
#
# DESCRIPTION:
# This script will generate a file that contains all the hosts' information in a table 
#
#
# INPUT: 
# Master: a file that contains all the possible hosts from all the sources (Masterlist) (no header)
#
#
# OUTPUT:
# hostinfo.txt: A table containing all the hosts with their information
# 
# 
# ENVIRONMENT VARIABLES:
# 
#
# NOTES:
# There must be a folder where it stores all files containing the information of each host 
# ($hostname-sysinfo.txt)
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

HOST_INFO_DIR=/opt/fundserv/syscheck/common-data/`date +%Y%m`
OUTPUT_DIR=/opt/fundserv/syscheck
MASTER=Master

# Header of the hostinfo.txt file soon to be added

# Loop through all the hosts
while read hostname;
do
	cat `find $HOST_INFO_DIR/$hostname/CMDB -type f -name '$hostname-sysinfo.txt'` | sed '/^$/d' | awk -F: '{print $2}' ORS=: >> hostinfo.txt
	echo >> hostinfo.txt
done < $MASTER
mv hostinfo.txt $OUTPUT_DIR
cd $OUTPUT_DIR
cat hostinfo.txt