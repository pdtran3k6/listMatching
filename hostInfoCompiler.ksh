#!/bin/ksh

rm hostinfo
while read line;
do
	echo -n "$line" | awk '{print $2 "\t"}' >> hostinfo
done < A-sysinfo.txt