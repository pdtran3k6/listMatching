	#!/bin/ksh
	###########################################################################################################
	# NAME: catSources
	#
	# DESCRIPTION:
	# This script will merge all lists of nodes from a server (if there are more than one)
	# into a bigger list that contains all the nodes from that server. It will also generates all_exclusion.txt
	#
	#
	# INPUT: 
	# SOURCEDIR: the path to the directory that contains all lists of nodes extracted from each admin server
	# TARGETDIR: the path to the directory that contains one list of nodes for each tool 
	# (NetBackup, BoKS, etc.)
	# EXCLUSION/$source-exclusion: a list of exclusions to not be included in the raw source data
	#
	#
	# OUTPUT:
	# `SOURCENAME`.list (where SOURCENAME is the administrative tool name all uppercased)
	# all_exclusion.txt (a list of all exclusions from all administrative tools)
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
	# Apr 20 2016 PHAT TRAN
	############################################################################################################

	TARGETDIR=/opt/fundserv/syscheck/webcontent/listMatching/sources
	EXCLUSION=/opt/fundserv/syscheck/webcontent/listMatching/exception
	SOURCEDIR=/opt/fundserv/syscheck/all-data/`date +%Y%m`
	REPORTS_OUTPUT_DIR=/opt/fundserv/syscheck/webcontent/listMatching/reports
	TMPFILE=/opt/fundserv/syscheck/tmp/`basename $0`.$$
	name1=netbackup
	name2=syscheck
	name3=boks
	name4=uptime
	name5=controlm
	
	for hostName in $(ls $SOURCEDIR)
	do
		for source in $name1 $name2 $name3 $name4 $name5
		do      
			if [ -f "$SOURCEDIR/$hostName/listMatching/$source-$hostName.list" ]
			then
				cp $SOURCEDIR/$hostName/listMatching/$source-$hostName.list $TARGETDIR/$source-$hostName.list
			fi
		done
	done

	for source in $name1 $name2 $name3 $name4 $name5
	do      
		cat $TARGETDIR/$source-*.list | sed '/^$/d' | sort -u > $TARGETDIR/`echo $source | tr [a-z] [A-Z]`.list 
		if [ -f "$EXCLUSION/$source-exclusion" ]
		then
			while read excludingHost
			do
				grep -v "$excludingHost" $TARGETDIR/`echo $source | tr [a-z] [A-Z]`.list > $TMPFILE && mv $TMPFILE $TARGETDIR/`echo $source | tr [a-z] [A-Z]`.list
			done < $EXCLUSION/$source-exclusion
		fi
		rm $TMPFILE 2> /dev/null
		rm $TARGETDIR/$source-*.list 2> /dev/null
	done
	
	echo "LIST OF EXCLUSION FROM ALL MANAGEMENT TOOLS" > $REPORTS_OUTPUT_DIR/all_exclusion.txt
	date '+%a %d-%b-%Y %R' >> $REPORTS_OUTPUT_DIR/all_exclusion.txt
	echo >> $REPORTS_OUTPUT_DIR/all_exclusion.txt
	cat $EXCLUSION/*-exclusion | sed '/^$/d' | sort -u >> $REPORTS_OUTPUT_DIR/all_exclusion.txt
	