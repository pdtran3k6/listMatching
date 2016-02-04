#!/bin/ksh
TARGETDIR=/u1/tranp
SOURCEDIR=/

cat `find $SOURCEDIR -type f -name 'pikt-*.lst'` | sort > $TARGETDIR/pikt.lst