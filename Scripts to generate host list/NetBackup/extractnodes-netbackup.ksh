#!/bin/ksh
TARGETDIR=/opt/fundserv/syscheck/data/`date +%Y%m`/`uname –n`/listmatching

# Check to see if there are processes running (except JAVA GUI)
/usr/openv/netbackup/bin/bpps -a | grep -v "java" > /dev/null

# Send the list of hosts that aren't Windows to the file path
if [ $? -eq 0 ]
then
	sudo bpplclients -allunique -l | grep -i -v "windows" | awk '{print $2}' > $TARGETDIR/netbackup-`uname –n`.lst
fi
