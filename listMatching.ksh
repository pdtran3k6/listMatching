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
# Feb 8 2016 PHAT TRAN
############################################################################################################

SOURCE_DIR=/u1/tranp/sources
SOURCE1=NetBackup.lst
SOURCE2=Syscheck.lst
SOURCE3=BoKS.lst
SOURCE4=Uptime.lst
MASTER=Master
EXCEPTION=ExceptionFile

HostTally=0
MatchedTally=0


cd $SOURCE_DIR
rm noHeader-$MASTER
# Generate raw Masterlist and raw ExceptionFile (no header)
cat $SOURCE1 $SOURCE2 $SOURCE3 $SOURCE4 | sort -u | sed 's/ /_/g' | cut -c1-15 > noHeader-$MASTER
cat $EXCEPTION | sed '1d' | awk '{print $3}' > noHeader-$EXCEPTION
while read hostName;
do
	grep "$hostName" noHeader-$MASTER > /dev/null
	if [ $? -ne 0 ] 
	then
		echo "$hostName" >> noHeader-$MASTER
	fi
done < noHeader-$EXCEPTION
total=$(wc -l noHeader-$MASTER | awk {'print $1'})

# Loop through each source
for source in $SOURCE1 $SOURCE2 $SOURCE3 $SOURCE4 
do
	echo "$source" > final$source
	while read hostName;
	do
		# Check to see if the host is in the source
		grep "$hostName" $source > /dev/null
		if [ $? -eq 0 ] 
		then
			echo "YES" >> final$source
		else
			# If not found in the source, check if it's in the $EXCEPTION
			grep -s "$source		$hostName" $EXCEPTION > /dev/null
			if [ $? -eq 0 ]
			then
				# Check the expiration date of the exception. If it never expires or hasn't expired, insert N/A Ex#; otherwise, insert N/A Ex# (exp). 
				if [ $(grep -s "$source		$hostName" $EXCEPTION | awk '{print $4}') == "Never" ] || [ $(date +%Y%m%d) -le $(grep "$source		$hostName" $EXCEPTION | awk '{print $4}' | sed 's/-//g') ]
				then
					grep -s "$source		$hostName" $EXCEPTION | awk '{print "N/A_" $1}' >> final$source
				else
					grep -s "$source		$hostName" $EXCEPTION | awk '{print "N/A_" $1 "-(exp)"}' >> final$source
				fi
			else
				echo "_" >> final$source			
			fi
		fi
	done < noHeader-$MASTER
	
	# For formatting purposes
	echo "_" >> final$source
	echo "_" >> final$source
done


# Generate the matched list
echo "MATCH" > matchedList
	while read hostName;
	do
		# Check if each source has a specific host
		for source in $SOURCE1 $SOURCE2 $SOURCE3 $SOURCE4
		do
		grep "$hostName" $source > /dev/null
			if [ $? -eq 0 ]
			then
				HostTally=$((HostTally + 1))

			else
			grep -s "$source		$hostName" $EXCEPTION > /dev/null
				if [ $? -eq 0 ]
				then
					HostTally=$((HostTally + 1))
				fi
			fi
		done
		
		# If the rows are filled with 'Yes's and/or 'N/a's, then add '***' to the matchedList
		if [ $HostTally -eq  4 ]
		then
			MatchedTally=$((MatchedTally + 1))
			echo "***" >> matchedList	
		else
			echo "_" >> matchedList
		fi
		HostTally=0
	done < noHeader-$MASTER

# Calculate the percentage matched + Output the total number of hosts matched
echo $MatchedTally >> matchedList
percTotal=$(print "scale=4; ($MatchedTally/$total)*100" | bc)
echo $percTotal"%" >> matchedList


# Generate the Masterlist with proper header and important attributes
echo "Hostname" > $MASTER
cat noHeader-$MASTER >> $MASTER
echo "Num_Host_Matched" >> $MASTER
echo "Percentage_Matched" >> $MASTER

# Generate the output table
paste $MASTER final$SOURCE1 final$SOURCE2 final$SOURCE3 final$SOURCE4 matchedList | pr -t -e20 > MasterTable
cat MasterTable
echo
