#!/bin/ksh

SOURCE_DIR=/u1/tranp
SOURCE1=Altiris
SOURCE2=AV
SOURCE3=OVO
SOURCE4=SNC
MASTER=Master
EXCEPTION=ExceptionFile

Yes_Tally=0
NA_Tally=0

cd $SOURCE_DIR

# Generate raw Masterlist and raw ExceptionFile (no header)
cat $SOURCE1 $SOURCE2 $SOURCE3 $SOURCE4 | sort -u > $MASTER
cat $EXCEPTION | sed '1d' > noHeader-$EXCEPTION
rm ExpiredExceptionFile 2> /dev/null

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
		echo "List of extra hosts in $source"
		cat extra_hosts-$source
		echo
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
	echo $NAPercTotal"#" >> perc$source
	echo $(($Yes_Tally + $NA_Tally)) >> perc$source
	echo $HostPercTotal"%" >> perc$source
	
	# Reset all tally counts
	Yes_Tally=0
	NA_Tally=0
done


# Generate the first column of the table with corresponding attributes
echo "Sources" > attributes
echo "Yes" >> attributes
echo "Yes Percentage" >> attributes
echo "N/A" >> attributes
echo "N/A Percentage" >> attributes
echo "Total Yes and N/A" >> attributes
echo "Percentage Yes and N/A" >> attributes

# Generate the output table
paste attributes perc$SOURCE1 final$SOURCE2 final$SOURCE3 final$SOURCE4 matchedList | pr -t -e20 > Report
cat Report
echo


# Generate the list of all the exceptions that has expired
while read row;
do
	if [ $(echo $row | awk '{print $4}') != "Never" ] && [ $(date +%Y%m%d) -gt $(echo $row | awk '{print $4}' | sed 's/-//g') ]
	then
		grep "$(echo $row | awk '{print $4}')" noHeader-$EXCEPTION >> ExpiredExceptionFile
	fi
done < noHeader-$EXCEPTION

echo "List of expired exceptions"
cat ExpiredExceptionFile
echo

# List of exceptions sorted by date
echo "Exceptions sorted by date"
cat noHeader-$EXCEPTION | sort -k 4 
echo

# List of exceptions sorted by host's name
echo "Exceptions sorted by host name"
cat noHeader-$EXCEPTION | sort -k 3 
echo

# Generate list of hosts in ExceptionFile
cat noHeader-$EXCEPTION | awk {'print $3'} | sort -u > ExHosts

# Check to see if there's any host that is in the ExceptionFile but not in the raw Masterlist
echo "Hosts that are in the $EXCEPTION but not in the $MASTER"
comm -31 $MASTER ExHosts
