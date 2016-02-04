#!/bin/ksh

rm hostinfo
while read line;
do
	echo "$line" | awk '{print $2}' >> hostinfo
done < A-sysinfo.txt
cat hostinfo | xargs