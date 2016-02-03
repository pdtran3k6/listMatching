#!/bin/ksh

bpps -a > /dev/null
if [ $? -eq 0 ]
then
	sudo bpplclients -allunique -l | grep -i -v "windows" | awk '{print $2}' > /opt/fundserv/syscheck/data/`date +%Y%m`/`uname –n`/listmatching/netbackup-`uname –n`.lst
fi
