#!/bin/ksh
TARGETDIR=/u1/tranp
SOURCEDIR=/

cat `find $SOURCEDIR -type f -name 'pikt-*.lst'` > $TARGETDIR/pikt.lst