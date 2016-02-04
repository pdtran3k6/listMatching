#!/bin/ksh
TARGETDIR=/opt/fundserv/syscheck/data/`date +%Y%m`/`uname –n`/listmatching
SOURCEDIR=/

cat `find $SOURCEDIR -type f -name 'boks-*.lst'` | sort > $TARGETDIR/BoKS.lst