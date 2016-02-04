#!/bin/ksh
TARGETDIR=/u1/tranp
SOURCEDIR=/

cat `find $SOURCEDIR -type f -name 'netbackup-*.lst'` | sort > $TARGETDIR/NetBackup.lst