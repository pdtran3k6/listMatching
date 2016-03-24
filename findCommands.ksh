#!/bin/ksh
echo "List of files" > files
for fname in $(ls /opt/fundserv/syscheck/common-bin)
do
	grep "all.zones" $fname 2>&1 > /dev/null 
	if [ $? -eq 0 ]
	then
		echo "--------" >> files
		grep "all.zones" $fname >> files
		echo $fname >> files
		echo >> files
	fi
done
