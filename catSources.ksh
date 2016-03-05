#!/bin/ksh
###########################################################################################################
# NAME: catSources
#
# DESCRIPTION:
# This script will merge all lists of nodes from a server (if there are more than one)
# into a bigger list that contains all the nodes from that server
#
#
# INPUT: 
# SOURCEDIR: the path to the directory that contains all lists of nodes extracted from each admin server
# TARGETDIR: the path to the directory that contains one list of nodes for each tool 
# (NetBackup, BoKS, etc.)
#
#
# OUTPUT:
# `SOURCENAME`.list (where SOURCENAME is the administrative tool name all uppercased)
# 
# ENVIRONMENT VARIABLES:
# 
#
# NOTES: 
#
#
# EXIT CODE:
# 0 - success
# 1 - incorrect arguements
#
#
# CHANGELOG:
# Feb 24 2016 PHAT TRAN
############################################################################################################

TARGETDIR=/opt/fundserv/syscheck/webcontent/listMatching/sources
SOURCEDIR=/opt/fundserv/syscheck/common-data/`date +%Y%m`
SOURCE1=netbackup
SOURCE2=syscheck
SOURCE3=boks
SOURCE4=uptime
SOURCE5=controlm
NO_HEADER_MASTER=/opt/fundserv/syscheck/webcontent/listMatching/totals/noHeader-Master

while read hostName;
do
	for source in $SOURCE1 $SOURCE2 $SOURCE3 $SOURCE4 $SOURCE5
	do	
		if [ -f "$SOURCEDIR/$hostName/listMatching/$source-$hostName.list" ]
		then
			cp $SOURCEDIR/$hostName/listMatching/$source-$hostName.list $TARGETDIR/$source-$hostName.list
		fi
	done
done < $NO_HEADER_MASTER

for source in $SOURCE1 $SOURCE2 $SOURCE3 $SOURCE4 $SOURCE5
do	
	cat $TARGETDIR/$source-*.list | sed '/^$/d' | sort -u > $TARGETDIR/`echo $source | tr [a-z] [A-Z]`.list
	rm $TARGETDIR/$source-*.list
done
