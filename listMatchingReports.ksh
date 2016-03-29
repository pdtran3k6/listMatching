	#!/bin/ksh
	###########################################################################################################
	# NAME: listMatchingReports
	#
	# DESCRIPTION:
	# This script will generate a report containing all the information below: 
	# 	- All the hosts that aren't supposed to be in a source but end up appearing in that source.	
	#	- The number of 'YES's and 'N/A's/total for each source with percentages, respectively.
	#	- All the exceptions that has expired.
	#	- All the exceptions sorted by date of expiration/host's name
	#	- All hosts that is in ExceptionFile but not in Master (Masterlist)
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
	# Yes_NA_Report.txt: A text file that contains the number of 'YES's and 'N/A's/total 
	# for each source with percentages, respectively.
	# Extra_Hosts_Report.txt: A text file that contains all the lists of extra hosts from different
	# sources.
	# Expired_Exceptions_Report.txt: A text file that contains all the expired exceptions
	# Exceptions_By_Date_Report.txt: A text file that contains all the exceptions sorted by date
	# Exceptions_By_Hostname_Report.txt: A text file that contains all the exceptions sorted by host name
	# Missing_Hosts_Report.txt: A text file that contains all the missing hosts that aren't in 
	# any sources but they are in the ExceptionFile
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
	# Mar 7 2016 PHAT TRAN
	############################################################################################################

	SOURCE_DIR=/opt/fundserv/syscheck/webcontent/listMatching/sources
	SOURCE1=BOKS.list
	SOURCE2=CONTROLM.list
	SOURCE3=NETBACKUP.list
	SOURCE4=SYSCHECK.list
	SOURCE5=UPTIME.list
	NO_HEADER_MASTER=/opt/fundserv/syscheck/webcontent/listMatching/totals/noHeader-Master
	NO_HEADER_MASTER_FULLNAME=/opt/fundserv/syscheck/webcontent/listMatching/totals/noHeader-Master_fullname 
	EXCEPTION=/opt/fundserv/syscheck/webcontent/listMatching/exception/ExceptionFile
	NO_HEADER_EXCEPTION=/opt/fundserv/syscheck/webcontent/listMatching/exception/noHeader-ExceptionFile
	HOST_ONLY_EXCEPTION=/opt/fundserv/syscheck/webcontent/listMatching/exception/hostOnly-ExceptionFile
	REPORTS_OUTPUT_DIR=/opt/fundserv/syscheck/webcontent/listMatching/reports

	HostTally=0
	MatchedTally=0
	Yes_Tally=0
	NA_Tally=0
	Yes_TallyMBOKS=0
	NA_TallyMBOKS=0
	Yes_TallyMCONTROLM=0
	NA_TallyMCONTROLM=0
	Yes_TallyMNETBACKUP=0
	NA_TallyMNETBACKUP=0
	Yes_TallyMSYSCHECK=0
	NA_TallyMSYSCHECK=0
	Yes_TallyMUPTIME=0
	NA_TallyMUPTIME=0

	cd $SOURCE_DIR

	# Generate raw Masterlist and raw ExceptionFile (no header)
	cat $EXCEPTION | sed '1d' > $NO_HEADER_EXCEPTION
	rm $REPORTS_OUTPUT_DIR/Extra_Hosts_Report.txt 2> /dev/null
	echo "EXTRA HOSTS" > $REPORTS_OUTPUT_DIR/Extra_Hosts_Report.txt
	date '+%a %d-%b-%Y %R' >> $REPORTS_OUTPUT_DIR/Extra_Hosts_Report.txt
	echo >> $REPORTS_OUTPUT_DIR/Extra_Hosts_Report.txt
	total=$(cat $NO_HEADER_MASTER | wc -l)

	# Generate the total matches
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
			grep -si "`echo $source | sed 's/.list//g'`" $EXCEPTION | sed 's/+/ /g'| grep -sw "$hostName" > /dev/null
				if [ $? -eq 0 ]
				then
					HostTally=$((HostTally + 1))
				fi
			fi
		done
			
		# If the rows are filled with 'Yes's and/or 'N/a's, keep track of it as MatchedTally
		if [ $HostTally -eq  5 ]
		then
			MatchedTally=$((MatchedTally + 1))
			for source in $SOURCE1 $SOURCE2 $SOURCE3 $SOURCE4 $SOURCE5
			do		
			grep -sw "$hostName" $source > /dev/null
			if [ $? -eq 0 ]
			then
				export Yes_TallyM`echo $source | sed 's/.list//g'`=$((Yes_TallyM`echo $source | sed 's/.list//g'` + 1))
			else
			grep -si "`echo $source | sed 's/.list//g'`" $EXCEPTION | sed 's/+/ /g'| grep -sw "$hostName" > /dev/null
				if [ $? -eq 0 ]
				then
					export NA_TallyM`echo $source | sed 's/.list//g'`=$((NA_TallyM`echo $source | sed 's/.list//g'` + 1))
				fi
			fi
			done
		fi
		HostTally=0
	done < $NO_HEADER_MASTER_FULLNAME


	# Loop through each source
	for source in $SOURCE1 $SOURCE2 $SOURCE3 $SOURCE4 $SOURCE5
	do
		shortSource=$(echo $source | sed 's/.list//g')
		Yes_M=$(eval "echo \"\$Yes_TallyM$shortSource\"")
		NA_M=$(eval "echo \"\$NA_TallyM$shortSource\"")
		
		# Check to see if there's any host that isn't supposed to be in the source but appear in the source
		while read hostName;
		do
			grep -si "`echo $source | sed 's/.list//g'`" $EXCEPTION | sed 's/+/ /g' | grep -sw "$hostName" > /dev/null
			if [ $? -eq 0 ]
			then
				echo "$hostName" >> extra_hosts-$source
			fi
		done < $source
		
		# List all the hosts that aren't supposed to be in certain source	
		ls | grep -s "extra_hosts-$source" > /dev/null
		if [ $? -eq 0 ]
		then
			echo "List of extra hosts in $source" >> $REPORTS_OUTPUT_DIR/Extra_Hosts_Report.txt
			cat extra_hosts-$source >> $REPORTS_OUTPUT_DIR/Extra_Hosts_Report.txt
			echo >> $REPORTS_OUTPUT_DIR/Extra_Hosts_Report.txt
		fi
		
		Yes_Tally=$(cat $source | wc -l | sed 's/^[ \t]*//')
		NA_Tally=$(grep -si "`echo $source | sed 's/.list//g'`" $EXCEPTION | wc -l | sed 's/^[ \t]*//')
		
		# Calculating percentages for Yes and N/A		
		HostPercTotal=$(print "scale=4; (($Yes_Tally + $NA_Tally)/$total)*100" | bc | sed 's/^[ \t]*//')
		HostPercTotal=$(printf %.0f $HostPercTotal)
		
		# Output into file with Header for sources' columns
		# YES column
		echo "--$source--" | sed 's/.list//g' > column$source
		echo "YES\tN/A" >> column$source
		echo >> column$source
		echo "$Yes_M\t$NA_M" >> column$source
		echo >> column$source
		echo "$Yes_Tally\t$NA_Tally" >> column$source
		echo >> column$source
		echo "    $(($Yes_Tally + $NA_Tally))    " >> column$source
		echo "    $HostPercTotal%   " >> column$source
		
		# Reset all tally counts
		Yes_Tally=0
		NA_Tally=0
	done


	percMatched=$(print "scale=4; ($MatchedTally/$total)*100" | bc | sed 's/^[ \t]*//')
	percMatched=$(printf %.0f $percMatched)
	# Output the total number of hosts matched
	echo "Total       " > totalMatches
	echo >> totalMatches
	echo >> totalMatches
	echo $MatchedTally"\t"$percMatched"%" >> totalMatches
	echo >> totalMatches
	echo $total"\t100%" >> totalMatches


	# Generate the first column of the table with corresponding attributes
	echo "Sources              " > attributes
	echo "                     " >> attributes
	echo >> attributes
	echo "Match in all sources" >> attributes
	echo >> attributes
	echo "Count in each source" >> attributes
	echo "                    " >> attributes
	echo "                    " >> attributes
	echo "                    " >> attributes

	# Generate the output table
	echo "List Matching Matrix as of `date '+%a %d-%b-%Y %R'`" > $REPORTS_OUTPUT_DIR/Yes_NA_Report.txt
	echo >> $REPORTS_OUTPUT_DIR/Yes_NA_Report.txt
	echo >> $REPORTS_OUTPUT_DIR/Yes_NA_Report.txt
	paste attributes column$SOURCE1 column$SOURCE2 column$SOURCE3 column$SOURCE4 column$SOURCE5 totalMatches >> $REPORTS_OUTPUT_DIR/Yes_NA_Report.txt
	echo >> $REPORTS_OUTPUT_DIR/Yes_NA_Report.txt


	# Clean up trash in the source folder
	rm attributes totalMatches
	for source in $SOURCE1 $SOURCE2 $SOURCE3 $SOURCE4 $SOURCE5
	do 
		rm column$source 2> /dev/null
		rm extra_hosts-$source 2> /dev/null
	done

	# Generate the list of all the exceptions that has expired
	echo "List of expired exceptions" > $REPORTS_OUTPUT_DIR/Expired_Exceptions_Report.txt
	date '+%a %d-%b-%Y %R' >> $REPORTS_OUTPUT_DIR/Expired_Exceptions_Report.txt
	echo >> $REPORTS_OUTPUT_DIR/Expired_Exceptions_Report.txt
	while read row;
	do
		if [ $(echo $row | awk '{print $4}') != "Never" ] && [ $(date +%Y%m%d) -gt $(echo $row | awk '{print $4}' | sed 's/-//g') ]
		then
			grep -s "$(echo $row | awk '{print $4}')" $EXCEPTION >> $REPORTS_OUTPUT_DIR/Expired_Exceptions_Report.txt
		fi
	done < $NO_HEADER_EXCEPTION

	# List of exceptions sorted by date
	echo "Exceptions sorted by date" > $REPORTS_OUTPUT_DIR/Exceptions_By_Date_Report.txt
	date '+%a %d-%b-%Y %R' >> $REPORTS_OUTPUT_DIR/Exceptions_By_Date_Report.txt
	echo >> $REPORTS_OUTPUT_DIR/Exceptions_By_Date_Report.txt
	cat $NO_HEADER_EXCEPTION | sort -b -k 4.1,4.4 -k 4.6,4.7 -k 4.9,4.10 >> $REPORTS_OUTPUT_DIR/Exceptions_By_Date_Report.txt
	echo >> $REPORTS_OUTPUT_DIR/Exceptions_By_Date_Report.txt 

	# List of exceptions sorted by host's name
	echo "Exceptions sorted by host name" > $REPORTS_OUTPUT_DIR/Exceptions_By_Hostname_Report.txt
	date '+%a %d-%b-%Y %R' >> $REPORTS_OUTPUT_DIR/Exceptions_By_Hostname_Report.txt
	echo >> $REPORTS_OUTPUT_DIR/Exceptions_By_Hostname_Report.txt
	cat $NO_HEADER_EXCEPTION | sort -b -k 3 >> $REPORTS_OUTPUT_DIR/Exceptions_By_Hostname_Report.txt
	echo >> $REPORTS_OUTPUT_DIR/Exceptions_By_Hostname_Report.txt
