#!/bin/ksh
TARGETDIR=/opt/fundserv/syscheck/data/`date +%Y%m`/`uname –n`/listmatching
SOURCEDIR=/

mysql -u uptime -puptime -P3308 --protocol=tcp uptime -e "SELECT name FROM entity" > $TARGETDIR/Uptime.lst
