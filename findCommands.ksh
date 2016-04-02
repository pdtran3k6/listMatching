#!/bin/ksh
KEYWORD=rsync
echo "List of files" > files
for fname in $(ls /opt/fundserv/syscheck/common-bin)
do
	grep -i "$KEYWORD" $fname 2>&1 > /dev/null 
	if [ $? -eq 0 ]
	then
		echo "--------" >> files
		grep -i "$KEYWORD" $fname >> files
		echo $fname >> files
		echo >> files
	fi
done
