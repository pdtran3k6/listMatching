#!/bin/ksh
HOST_INFO_DIR=/u1/tranp
rm hostinfo
while read hostname;
do
	cd $HOST_INFO_DIR
	while read line;
	do
		echo "$line" | awk '{print $2}' ORS='	' >> hostinfo
	done < $hostname-sysinfo.txt
done < Master
cat hostinfo