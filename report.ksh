#!/bin/ksh
###########################################################################################################
# NAME: report
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
# The script needs to be in the same folder as all the sources' list and the ExceptionFile
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

#!/bin/ksh
SOURCE_DIR=/u1/tranp/sources
SOURCE1=NetBackup.list
SOURCE2=Syscheck.list
SOURCE3=BoKS.list
SOURCE4=Uptime.list
SOURCE5=PiKT.list
SOURCE6=ControlM.list
MASTER=Master 
EXCEPTION=ExceptionFile
HTML_OUTPUT_DIR=/APACHE/listMatching/Reports

Yes_Tally=0
NA_Tally=0

cd $SOURCE_DIR

# Generate raw Masterlist and raw ExceptionFile (no header)
cat $SOURCE1 $SOURCE2 $SOURCE3 $SOURCE4 | sort -u > $MASTER
cat $EXCEPTION | sed '1d' > noHeader-$EXCEPTION
rm ExpiredExceptionFile 2> /dev/null
rm Extra_Hosts_Report.txt 2> /dev/null

# Loop through each source
for source in $SOURCE1 $SOURCE2 $SOURCE3 $SOURCE4 
do

	rm perc$source 2> /dev/null
	rm extra_hosts-$source 2> /dev/null
	
	# Check to see if there's any host that isn't supposed to be in the source but appear in the source
	while read hostName;
	do
		grep "$source		$hostName" $EXCEPTION > /dev/null
		if [ $? -eq 0 ]
		then
			echo "$hostName" >> extra_hosts-$source
		fi
	done < $source
	
	# List all the hosts that aren't supposed to be in certain source	
	ls | grep "extra_hosts-$source" > /dev/null
	if [ $? -eq 0 ]
	then
		echo "List of extra hosts in $source" >> Extra_Hosts_Report.txt
		cat extra_hosts-$source >> Extra_Hosts_Report.txt
		echo >> Extra_Hosts_Report.txt
	fi
	
	
	while read hostName;
	do
		# Check to see if the host is in the source
		grep "$hostName" $source > /dev/null
		if [ $? -eq 0 ] 
		then
			Yes_Tally=$((Yes_Tally + 1))
		else
			# If not found in the source, check if it's in the $EXCEPTION
			grep "$source		$hostName" $EXCEPTION > /dev/null
			if [ $? -eq 0 ]
			then
				NA_Tally=$((NA_Tally + 1))
			fi	
		fi
	done < $MASTER
	
	# Calculating percentages for Yes and N/A
	total=$(wc -l $MASTER | awk {'print $1'})		
	HostPercTotal=$(print "scale=1; (($Yes_Tally + $NA_Tally)/$total)*100" | bc)
	YesPercTotal=$(print "scale=1; ($Yes_Tally/$total)*100" | bc)
	NAPercTotal=$(print "scale=1; ($NA_Tally/$total)*100" | bc)
	
	# Output into file with Header for sources' columns
	echo "$source" > perc$source
	echo $Yes_Tally >> perc$source
	echo $YesPercTotal"%" >> perc$source
	echo $NA_Tally >> perc$source
	echo $NAPercTotal"%" >> perc$source
	echo $(($Yes_Tally + $NA_Tally)) >> perc$source
	echo $HostPercTotal"%" >> perc$source
	
	# Reset all tally counts
	Yes_Tally=0
	NA_Tally=0
done



# Generate the first column of the table with corresponding attributes
echo "Sources" > attributes
echo "Yes" >> attributes
echo "% Yes" >> attributes
echo "N/A" >> attributes
echo "% N/A" >> attributes
echo "Yes and N/A" >> attributes
echo "% Yes and N/A" >> attributes

# Generate the output table
paste attributes perc$SOURCE1 perc$SOURCE2 perc$SOURCE3 perc$SOURCE4 | pr -t -e20 >> Yes_NA_Report.txt
echo >> Yes_NA_Report.txt


# Generate the list of all the exceptions that has expired
while read row;
do
	if [ $(echo $row | awk '{print $4}') != "Never" ] && [ $(date +%Y%m%d) -gt $(echo $row | awk '{print $4}' | sed 's/-//g') ]
	then
		grep "$(echo $row | awk '{print $4}')" noHeader-$EXCEPTION >> ExpiredExceptionFile
	fi
done < noHeader-$EXCEPTION

echo "List of expired exceptions" >> Expired_Exceptions_Report.txt
cat ExpiredExceptionFile >> Expired_Exceptions_Report.txt
echo >> Expired_Exceptions_Report.txt

# List of exceptions sorted by date
echo "Exceptions sorted by date" >> Exceptions_By_Date_Report.txt
cat noHeader-$EXCEPTION | sort -k 4 >> Exceptions_By_Date_Report.txt
echo >> Exceptions_By_Date_Report.txt 

# List of exceptions sorted by host's name
echo "Exceptions sorted by host name" >> Exceptions_By_Hostname_Report.txt
cat noHeader-$EXCEPTION | sort -k 3 >> Exceptions_By_Hostname_Report.txt
echo >> Exceptions_By_Hostname_Report.txt

# Generate list of hosts in ExceptionFile
cat noHeader-$EXCEPTION | awk {'print $3'} | sort -u > ExHosts

# Check to see if there's any host that is in the ExceptionFile but not in the raw Masterlist
echo "Hosts that are in the $EXCEPTION but not in the $MASTER" >> Missing_Hosts_Report.txt
comm -31 $MASTER ExHosts >> Missing_Hosts_Report.txt

mv Extra_Hosts_Report.txt $HTML_OUTPUT_DIR
mv Yes_NA_Report.txt $HTML_OUTPUT_DIR
mv Expired_Exceptions_Report.txt $HTML_OUTPUT_DIR
mv Exceptions_By_Date_Report.txt $HTML_OUTPUT_DIR
mv Exceptions_By_Hostname_Report.txt $HTML_OUTPUT_DIR
mv Missing_Hosts_Report.txt $HTML_OUTPUT_DIR
cd $HTML_OUTPUT_DIR