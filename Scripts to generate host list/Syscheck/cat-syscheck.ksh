#!/bin/ksh
TARGETDIR=/opt/fundserv/syscheck/data/`date +%Y%m`/`uname –n`/listmatching
SOURCEDIR=/opt/fundserv/syscheck/local-etc

cat `find $SOURCEDIR -type f -name 'all_*.list'` | sort > $TARGETDIR/Syscheck.lst