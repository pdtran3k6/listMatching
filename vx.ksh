	#!/bin/ksh
	###########################################################################################################
	# NAME: vx
	#
	# DESCRIPTION:
	# Lists path type and states along with the detailed information on the specified disks
	#
	#
	# INPUT:
	#
	# 
	# OUTPUT:
	# vxdisk_list_info.txt for each host, which will be containing all the information about the physical host.   
	# 
	#
	# ENVIRONMENT VARIABLES:
	# 
	#
	# NOTES:
	# 
	#
	#
	# EXIT CODE:
	# 0 Success 
	# 1 Unknown Error 
	# 2 Invalid OS 
	# 3 Invalid User 
	#
	#
	# CHANGELOG:
	# Mar 15 2016 PHAT TRAN
	############################################################################################################

	HOST=$(hostname)
	NODE=${HOST%%\.*}
	ZNADM=/usr/sbin/zoneadm
	ZNAME=/usr/bin/zonename
	YM=$(date '+%Y%m')
	LOGDIR=/opt/fundserv/syscheck/common-data/$YM/$NODE/CMDB
	BROCADE_OUTFL=$LOGDIR/vxdisk_list_info.txt
	USER=root
	OWNER=syscheck
	GROUP=10     # staff group on Solaris, wheel on Linux
	OS=$(uname)
	TMPFILE=/opt/fundserv/syscheck/tmp/`basename $0`.$$

	case $OS in
		SunOS) WHO=$(/usr/ucb/whoami) ;;
		*) exit 2 ;;
	esac

	# Check that script is being run as root
	[ "$WHO" = "$USER" ] || exit 3

	# Create the logging directory if it does not exist
	umask 022
	if [ ! -d $LOGDIR ]
	then
	   mkdir -m 755 -p $LOGDIR >/dev/null 2>&1 && chown -Rh ${OWNER}:${GROUP} /opt/fundserv/syscheck/common-data/$YM >/dev/null 2>&1 || exit 1
	fi

	# Only generate vxdisk_list_info.txt if the OS is SunOS
	case $OS in
			SunOS)
			if [ -f "/usr/sbin/vxdisk" ]
			then
				[ -x "$ZNAME" ] && zname=$($ZNAME) || zname="global"
				if [ "$zname" = "global" ]
				then
					cd ~syscheck/common-bin/ && ./serverbanner > $BROCADE_OUTFL
					date '+%a %d-%b-%Y %R' >> $BROCADE_OUTFL
					echo >> $BROCADE_OUTFL
					echo "##### one-line summary for all disk access records known to the system #####" >> $BROCADE_OUTFL
					
					# Generate an overview of all the disks
					/usr/sbin/vxdisk list | grep dg >> $BROCADE_OUTFL
					echo >> $BROCADE_OUTFL
					
					# Generate detailed information for each disk
					/usr/sbin/vxdisk list | grep dg | awk '{print $1}' > $TMPFILE
					while read deviceSerial
					do
						echo "##### detailed information on disk $deviceSerial #####" >> $BROCADE_OUTFL
						vxdisk list $deviceSerial >> $BROCADE_OUTFL
						echo >> $BROCADE_OUTFL
						
						deviceTagShort=`echo $deviceSerial | sed 's/....$//'`
						deviceTag=`echo $deviceSerial | sed 's/..$//'`
						if [ "$deviceTagShort" == "emcpower" ]
						then
							/etc/powermt display dev=$deviceTag >> $BROCADE_OUTFL
						fi
						echo >> $BROCADE_OUTFL
						echo >> $BROCADE_OUTFL
						
					done < $TMPFILE
					rm -f $TMPFILE
					cd ~syscheck/common-bin/ && ./footer $0 $$ >> $BROCADE_OUTFL
				fi
			fi ;;
			*) exit 2 ;;
	esac

	exit 0