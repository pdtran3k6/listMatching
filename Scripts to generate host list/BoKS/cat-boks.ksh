#!/bin/ksh
TARGETDIR=/u1/tranp
SOURCEDIR=/

cat `find $SOURCEDIR -type f -name 'BoKS-*.lst'` | sort > $TARGETDIR/BoKS.lst