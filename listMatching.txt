#!/usr/bin/ksh
###########################################################################################################
# NAME: listMatching
#
# DESCRIPTION:
# This script will merge all sources' list of hosts together to generate the master list
# and show which hosts are missing and which hosts are not supposed to be in that source (exceptions) 
#
# INPUT: 
# SOURCE1, SOURCE2, ... , SOURCEN: one file per source that contains a column of hosts' names 
# registered in a particular source
# 
# ExceptionFile: contains a list of all the exception hosts that shouldn't be in certain sources.
# 
# SOURCE1name, SOURCE2name, ... , SOURCENname: a file containing the name of the source. 
# This file is used to make the header of the output table 
# 
# Title: a file containing the word "Hostname". This file is used to make the header of the output table
# 
# Master: a file that contains all the possible hosts from all the sources (master list)
#
# OUTPUT:
# finalSOURCE1, finalSOURCE2, ... , finalSOURCEN: one file per source that contains a column 
# filled with YES, blank ( ), or N/A ex# (N/A 2093)
#
# MasterTable: Table with the first column being the master list of all the sources, 
# then the rest of the columns are the finalSOURCE1, finalSOURCE2, ... , finalSOURCEN.
# 
# 
# ENVIRONMENT VARIABLES:
# 
# NOTES:
# The name of the sources in the ExceptionFile must match the names of sources 
# as defined in the variables below
#
#
#
# EXIT CODE:
# 0 - success
# 1 - incorrect arguements
#
# CHANGELOG:
# Jan 22 2016 PHAT TRAN
############################################################################################################

SOURCEDIR=/u1/tranp
SOURCE1=Altiris
SOURCE2=AV
SOURCE3=OVO
SOURCE4=SNC
MASTER=Master
SOURCE1name=Altirisname
SOURCE2name=AVname
SOURCE3name=OVOname
SOURCE4name=SNCname

cd $SOURCEDIR

cat $SOURCE1 $SOURCE2 $SOURCE3 $SOURCE4 | sort -u > $MASTER

for source in $SOURCE1 $SOURCE2 $SOURCE3 $SOURCE4 

do

rm final$source
	
	while read hostName;
	
	do
		# Check to see if the host is in the source
		
		grep "$hostName" $source > /dev/null
		
		if [ $? -eq 0 ] 
		
		then
			echo "YES" >> final$source
		else
			# If not found in the source, check if it's in the ExceptionFile

			grep "$source		$hostName" ExceptionFile > /dev/null

			if [ $? -eq 0 ]
			
			then

				# Check the expiration date of the exception. If it never expires or hasn't expired, insert N/A Ex#; otherwise, insert N/A Ex# (exp). 

				if [ $(grep "$source		$hostName" ExceptionFile | awk '{print $4}') == "Never" ] || [ $(date +%Y%m%d) -le $(grep "$source		$hostName" ExceptionFile | awk '{print $4}' | sed 's/-//g') ]
				
				then
					grep "$source		$hostName" ExceptionFile | awk '{print "N/A_" $1}' >> final$source

				else

					grep "$source		$hostName" ExceptionFile | awk '{print "N/A_" $1 "-(exp)"}' >> final$source

				fi
			else
				echo "_" >> final$source
			fi
		fi

	done < $MASTER

done

paste Title $SOURCE1name $SOURCE2name $SOURCE3name $SOURCE4name | pr -t -e20 > MasterTable

paste $MASTER final$SOURCE1 final$SOURCE2 final$SOURCE3 final$SOURCE4 | pr -t -e20 >> MasterTable

cat MasterTable
