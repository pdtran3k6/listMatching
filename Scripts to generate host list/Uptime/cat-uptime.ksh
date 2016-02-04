#!/bin/ksh
TARGETDIR=/opt/fundserv/syscheck/data/`date +%Y%m`/`uname –n`/listmatching
SOURCEDIR=/

cat `find $SOURCEDIR -type f -name 'uptime-*.lst'` | sort > $TARGETDIR/Uptime.lst