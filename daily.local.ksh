#!/bin/ksh
./../common-bin/extractnodes-for-listMatching.ksh 2> /dev/null
./extractnodes_syscheck-for-listMatching.ksh 2> /dev/null
./catSources.ksh 2> /dev/null
./../common-bin/listMatching.ksh 2> /dev/null
./../common-bin/convert2HTML.ksh 2> /dev/null
./listMatchingReports.ksh 2> /dev/null
./hostInfoReports.ksh 2> /dev/null
