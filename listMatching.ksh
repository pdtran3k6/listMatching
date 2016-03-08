#!/bin/ksh
###########################################################################################################
# NAME: listMatching
#
# DESCRIPTION:
# This script will merge all sources' list of hosts together to generate the master list
# and show which hosts are missing and which hosts are not supposed to be in that source (exceptions) 
#
#
# INPUT: 
# SOURCE1, SOURCE2, ... , SOURCEN: one file per source that contains a column of hosts' names 
# registered in a particular source
# ExceptionFile: contains a list of all the exception hosts that shouldn't be in certain sources.
# Master: a file that contains all the possible hosts from all the sources (Masterlist)
#
#
# OUTPUT:
# finalSOURCE1, finalSOURCE2, ... , finalSOURCEN: one file per source that contains a column 
# filled with YES, blank ( ), or N/A ex# (e.g N/A 2093). It also shows expired exception values
# MasterTable: Table with the first column being the list containing all the possible hosts, 
# then the rest of the columns are the finalSOURCE1, finalSOURCE2, ... , finalSOURCEN. Last column 
# is the matched list (hosts that appeared in all sources including exception)
# 
# 
# ENVIRONMENT VARIABLES:
# 
#
# NOTES:
# The name of the sources in the ExceptionFile must match the names of sources 
# as defined in the variables below
#
#
# EXIT CODE:
# 0 - success
# 1 - incorrect arguements
#
#
# CHANGELOG:
# Feb 23 2016 PHAT TRAN
############################################################################################################

SOURCE_DIR=/opt/fundserv/syscheck/webcontent/listMatching/sources
SOURCE1=BOKS.list
SOURCE2=CONTROLM.list
SOURCE3=NETBACKUP.list
SOURCE4=SYSCHECK.list
SOURCE5=UPTIME.list
MASTER=/opt/fundserv/syscheck/webcontent/listMatching/totals/Master 
NO_HEADER_MASTER=/opt/fundserv/syscheck/webcontent/listMatching/totals/noHeader-Master
NO_HEADER_MASTER_FULLNAME=/opt/fundserv/syscheck/webcontent/listMatching/totals/noHeader-Master_fullname
EXCEPTION=/opt/fundserv/syscheck/webcontent/listMatching/exception/ExceptionFile
HOST_ONLY_EXCEPTION=/opt/fundserv/syscheck/webcontent/listMatching/exception/hostOnly-ExceptionFile
MASTERTABLE=/opt/fundserv/syscheck/webcontent/listMatching/table/MasterTable
REPORTS_OUTPUT_DIR=/opt/fundserv/syscheck/webcontent/listMatching/reports

HostTally=0
MatchedTally=0


cd $SOURCE_DIR

# Generate raw Masterlist and raw ExceptionFile (no header)
cat $SOURCE1 $SOURCE2 $SOURCE3 $SOURCE4 $SOURCE5 | sort -u > $NO_HEADER_MASTER_FULLNAME
cat $NO_HEADER_MASTER_FULLNAME | sed 's/ /+/g' > $NO_HEADER_MASTER

cat $EXCEPTION | sed '1d' | awk '{print $3}' > $HOST_ONLY_EXCEPTION


echo "Hosts that are in the ExceptionFile but not in the Master" > $REPORTS_OUTPUT_DIR/Missing_Hosts_Report.txt
date '+%a %d-%b-%Y %R' >> $REPORTS_OUTPUT_DIR/Missing_Hosts_Report.txt
echo >> $REPORTS_OUTPUT_DIR/Missing_Hosts_Report.txt

# Added missing hosts from ExceptionFile
while read hostName;
do
	grep -sw "$hostName" $NO_HEADER_MASTER > /dev/null
	if [ $? -ne 0 ] 
	then
		echo "$hostName" >> $NO_HEADER_MASTER_FULLNAME
		echo "$hostName" >> $REPORTS_OUTPUT_DIR/Missing_Hosts_Report.txt
	fi
done < $HOST_ONLY_EXCEPTION

cat $NO_HEADER_MASTER_FULLNAME | sort -u > $NO_HEADER_MASTER_FULLNAME.tmp
mv $NO_HEADER_MASTER_FULLNAME.tmp $NO_HEADER_MASTER_FULLNAME

cat $NO_HEADER_MASTER_FULLNAME | sed 's/ /+/g' > $NO_HEADER_MASTER

# Loop through each source
for source in $SOURCE1 $SOURCE2 $SOURCE3 $SOURCE4 $SOURCE5
do
	echo "$source" | sed 's/.list//g' > final$source
	while read hostName;
	do
		# Check to see if the host is in the source
		grep -sw "$hostName" $source > /dev/null
		if [ $? -eq 0 ] 
		then
			echo "YES" >> final$source
		else
			# If not found in the source, check if it's in the $EXCEPTION
			grep -si "`echo $source | sed 's/.list//g'`" $EXCEPTION | sed 's/+/ /g' | grep -sw "$hostName" > /dev/null
			if [ $? -eq 0 ]
			then
			expiryDate=$(grep -si "`echo $source | sed 's/.list//g'`" $EXCEPTION | grep -sw "$hostName" | awk '{print $4}')
				# Check the expiration date of the exception. If it never expires or hasn't expired, insert N/A Ex#; otherwise, insert N/A Ex# (exp). 
				if [ "$expiryDate" == "Never" ] || [ "$(date +%Y%m%d)" -le "$(echo $expiryDate | sed 's/-//g')" ]
				then
					grep -si "`echo $source | sed 's/.list//g'`" $EXCEPTION | sed 's/+/ /g' | grep -sw "$hostName" | awk '{print "N/A_" $1}' >> final$source
				else
					grep -si "`echo $source | sed 's/.list//g'`" $EXCEPTION | sed 's/+/ /g' | grep -sw "$hostName" | awk '{print "N/A_" $1 "-(exp)"}' >> final$source
				fi
			else
				echo "_" >> final$source			
			fi
		fi
	done < $NO_HEADER_MASTER_FULLNAME
done

# Generate the matched list
echo "MATCH" > matchedList
while read hostName;
do
	# Check if each source has a specific host
	for source in $SOURCE1 $SOURCE2 $SOURCE3 $SOURCE4 $SOURCE5
	do
	grep -sw "$hostName" $source > /dev/null
		if [ $? -eq 0 ]
		then
			HostTally=$((HostTally + 1))
		else
		grep -si "`echo $source | sed 's/.list//g'`" $EXCEPTION | sed 's/+/ /g' | grep -sw "$hostName" > /dev/null
			if [ $? -eq 0 ]
			then
				HostTally=$((HostTally + 1))
			fi
		fi
	done
		
	# If the rows are filled with 'Yes's and/or 'N/a's, then add '***' to the matchedList
	if [ $HostTally -eq  5 ]
	then
		echo "***" >> matchedList	
	else
		echo "_" >> matchedList
	fi
	HostTally=0
done < $NO_HEADER_MASTER_FULLNAME
	
	
# Remove domains of certain nodes 
grep -s "142.148" $NO_HEADER_MASTER > IPonly
comm -3 $NO_HEADER_MASTER IPonly > noIP_master
awk -F. '{print $1}' noIP_master > noIP_master.tmp && mv noIP_master.tmp noIP_master
cat IPonly noIP_master > $NO_HEADER_MASTER
rm noIP_master IPonly

# Generate the Masterlist with proper header and important attributes
echo "Hostname" > $MASTER
cat $NO_HEADER_MASTER >> $MASTER

# Generate the output table
paste $MASTER final$SOURCE1 final$SOURCE2 final$SOURCE3 final$SOURCE4 final$SOURCE5 matchedList | pr -t -e20 > $MASTERTABLE

# Clean up trash in source folder
rm matchedList
for source in $SOURCE1 $SOURCE2 $SOURCE3 $SOURCE4 $SOURCE5
do 
	rm final$source
done
