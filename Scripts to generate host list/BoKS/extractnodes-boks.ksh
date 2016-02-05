#!/bin/ksh
TARGETDIR=/opt/fundserv/syscheck/data/`date +%Y%m`/`uname –n`/listmatching

# Check to see if there are processes running (except JAVA GUI)


# Send the list of hosts that aren't Windows to the file path
if [ $? -eq 0 ]
then
	sudo /opt/boksm/sbin/boksadm -S hostadm -l -t UNIXBOKSHOST -S | awk '{print $1}' > $TARGETDIR/boks-`uname –n`.lst
fi
