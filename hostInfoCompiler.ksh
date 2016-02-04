#!/bin/ksh
HOST_INFO_DIR=/u1/tranp

echo "Date		CPU		Model" > hostinfo
while read hostname;
do
	cd $HOST_INFO_DIR
	grep -s . $hostname-sysinfo.txt | awk '{print $2}' ORS='	' >> hostinfo
	echo >> hostinfo
done < Master
cat hostinfo