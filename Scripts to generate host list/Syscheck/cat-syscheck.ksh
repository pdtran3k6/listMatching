#!/bin/ksh
TARGETDIR=/u1/tranp
SOURCEDIR=/

cat `find $SOURCEDIR -type f -name 'syscheck-*.lst'` | sort > $TARGETDIR/syscheck.lst