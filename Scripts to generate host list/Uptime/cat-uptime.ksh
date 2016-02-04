#!/bin/ksh
TARGETDIR=/u1/tranp
SOURCEDIR=/

cat `find $SOURCEDIR -type f -name 'uptime-*.lst'` | sort > $TARGETDIR/uptime.lst