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
# Feb 8 2016 PHAT TRAN
############################################################################################################
HOST_INFO_DIR=/u1/tranp
OUTPUT_DIR=/APACHE/inv
MASTER=Master

# Header of the hostinfo.txt file soon to be added

# Loop through all the hosts
while read hostname;
do
	cd $HOST_INFO_DIR
	grep -s . $hostname-sysinfo.txt | sed '/^$/g' | awk -F: '{print $2}' ORS='		' >> hostinfo.txt
	echo >> hostinfo.txt
done < $MASTER
mv hostinfo.txt $OUTPUT_DIR
cd $OUTPUT_DIR
cat hostinfo.txt