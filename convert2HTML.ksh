	#!/bin/ksh
	###########################################################################################################
	# NAME: mastertable2HTML
	#
	# DESCRIPTION:
	# This script will convert all output generated by listMatching.ksh into an html page 
	#
	#
	# INPUT: 
	#
	#
	# OUTPUT:
	# 
	# 
	# ENVIRONMENT VARIABLES:
	# 
	#
	# NOTES:
	#
	#
	# EXIT CODE:
	# 0 - success
	# 1 - incorrect arguments
	#
	# CHANGELOG:
	# Apr 14 2016 PHAT TRAN
	############################################################################################################

	NO_HEADER_MASTER=/opt/fundserv/syscheck/webcontent/listMatching/totals/noHeader-Master
	MASTERTABLE_HTML=/opt/fundserv/syscheck/webcontent/listMatching/MasterTable.html
	MASTERTABLE=/opt/fundserv/syscheck/webcontent/listMatching/table/MasterTable
	HOST_INFO_DIR=/opt/fundserv/syscheck/all-data/`date +%Y%m`
	REPORT_DIR=/opt/fundserv/syscheck/webcontent/CMDB/reports

	##### GENERATE INVENTORY REPORTS #####
	for report in $(ls $REPORT_DIR)
	do
		case $report in 
			hostInfoReport.txt)
			#############################
			##### GENERATE HIP.HTML #####
			#############################
			echo "<html>" > $REPORT_DIR/HIP.html
			
			# Set the spacing between columns for HIP.html
			echo "<head>" >> $REPORT_DIR/HIP.html
			echo "<link rel=\"stylesheet\" href=\"../../css/report.css\"/>" >> $REPORT_DIR/HIP.html
			echo "</head>" >> $REPORT_DIR/HIP.html
			echo "<body>" >> $REPORT_DIR/HIP.html
			
			# Title of the table
			echo "<h2>HOST INFORMATION REPORT</h2>" >> $REPORT_DIR/HIP.html
			echo "<p>`date '+%a %d-%b-%Y %R'`</p>" >> $REPORT_DIR/HIP.html
			echo "<table style=\"width:300%\">" >> $REPORT_DIR/HIP.html
			
			# Add each columns and each rows into table format (Additional columns could be added)
			while read hostname date remote_mgmt os kernel model cpu zonetype chassis_sn site rack u_bottom contract_num asset_tag env apps
			do
				echo "<tr>" >> $REPORT_DIR/HIP.html
				# Link to host sysinfo.txt file (excluding the header of host column, which is HOSTNAME)
				if [ "$hostname" == "HOSTNAME" ] 
				then 
					echo "<td>$hostname</td>" >> $REPORT_DIR/HIP.html
				else 
					echo "<td><a href='/CMDB/sysinfo/$hostname-sysinfo.txt'>$hostname</td>" >> $REPORT_DIR/HIP.html
				fi
				echo "<td>$date</td>" >> $REPORT_DIR/HIP.html
				echo "<td>$remote_mgmt</td>" >> $REPORT_DIR/HIP.html
				echo "<td>$os</td>" >> $REPORT_DIR/HIP.html
				echo "<td>$kernel</td>" >> $REPORT_DIR/HIP.html
				echo "<td>$model</td>" >> $REPORT_DIR/HIP.html
				echo "<td>$cpu</td>" >> $REPORT_DIR/HIP.html
				echo "<td>$zonetype</td>" >> $REPORT_DIR/HIP.html
				echo "<td>$chassis_sn</td>" >> $REPORT_DIR/HIP.html
				echo "<td>$site</td>" >> $REPORT_DIR/HIP.html
				echo "<td>$rack</td>" >> $REPORT_DIR/HIP.html
				echo "<td>$u_bottom</td>" >> $REPORT_DIR/HIP.html
				echo "<td>$contract_num</td>" >> $REPORT_DIR/HIP.html
				echo "<td>$asset_tag</td>" >> $REPORT_DIR/HIP.html
				echo "<td>$env</td>" >> $REPORT_DIR/HIP.html
				echo "<td>$apps</td>" >> $REPORT_DIR/HIP.html
				echo "</tr>" >> $REPORT_DIR/HIP.html
			done < $REPORT_DIR/$report
				
			# Close table
			echo "</table>" >> $REPORT_DIR/HIP.html

			# Link to the report folder
			echo "<h2>Back to <a href='/listMatching/inventory.html'>inventory page</a></h2>" >> $REPORT_DIR/HIP.html

			# Close html
			echo "</body>" >> $REPORT_DIR/HIP.html
			echo "</html>" >> $REPORT_DIR/HIP.html
			;;
			
			softwareReport.txt)
			##################################
			##### GENERATE SOFTWARE.HTML #####
			##################################
			echo "<html>" > $REPORT_DIR/software.html
			
			# Set the spacing between columns for software.html
			echo "<head>" >> $REPORT_DIR/software.html
			echo "<link rel=\"stylesheet\" href=\"../../css/report.css\"/>" >> $REPORT_DIR/software.html
			echo "</head>" >> $REPORT_DIR/software.html
			echo "<body>" >> $REPORT_DIR/software.html

			# Title of the table
			echo "<h2>SOFTWARE REPORT</h2>" >> $REPORT_DIR/software.html
			echo "<p>`date '+%a %d-%b-%Y %R'`</p>" >> $REPORT_DIR/software.html
			echo "<table style=\"width:100%\">" >> $REPORT_DIR/software.html
			
			# Add each columns and each rows into table format (Additional columns could be added)
			while read hostname date os netbackup rsync uptime
			do
				echo "<tr>" >> $REPORT_DIR/software.html
				# Link to host sysinfo.txt file (excluding the header of host column, which is HOSTNAME)
				if [ "$hostname" == "HOSTNAME" ] 
				then 
					echo "<td>$hostname</td>" >> $REPORT_DIR/software.html
				else 
					echo "<td><a href='/CMDB/sysinfo/$hostname-sysinfo.txt'>$hostname</td>" >> $REPORT_DIR/software.html
				fi
				echo "<td>$date</td>" >> $REPORT_DIR/software.html
				echo "<td>$os</td>" >> $REPORT_DIR/software.html
				echo "<td>$netbackup</td>" >> $REPORT_DIR/software.html
				echo "<td>$rsync</td>" >> $REPORT_DIR/software.html
				echo "<td>$uptime</td>" >> $REPORT_DIR/software.html
				echo "</tr>" >> $REPORT_DIR/software.html
			done < $REPORT_DIR/$report
				
			# Close table
			echo "</table>" >> $REPORT_DIR/software.html

			# Link to the report folder
			echo "<h2>Back to <a href='/listMatching/inventory.html'>inventory page</a></h2>" >> $REPORT_DIR/software.html

			# Close html
			echo "</body>" >> $REPORT_DIR/software.html
			echo "</html>" >> $REPORT_DIR/software.html
			;;
			
			zonelistReport.txt)
			##################################
			##### GENERATE ZONELIST.HTML #####
			##################################
			echo "<html>" > $REPORT_DIR/zonelist.html
			
			# Set the spacing between columns for zonelist.html
			echo "<head>" >> $REPORT_DIR/zonelist.html
			echo "<link rel=\"stylesheet\" href=\"../../css/report.css\"/>" >> $REPORT_DIR/zonelist.html
			echo "</head>" >> $REPORT_DIR/zonelist.html
			echo "<body>" >> $REPORT_DIR/zonelist.html

			# Title of the table
			echo "<h2>ZONELIST REPORT</h2>" >> $REPORT_DIR/zonelist.html
			echo "<p>`date '+%a %d-%b-%Y %R'`</p>" >> $REPORT_DIR/zonelist.html
			echo "<table style=\"width:300%\">" >> $REPORT_DIR/zonelist.html
			
			# Add each columns and each rows into table format (Additional columns could be added)
			while read hostname date zonelist
			do
				echo "<tr>" >> $REPORT_DIR/zonelist.html
				# Link to host sysinfo.txt file (excluding the header of host column, which is HOSTNAME)
				if [ "$hostname" == "HOSTNAME" ] 
				then 
					echo "<td>$hostname</td>" >> $REPORT_DIR/zonelist.html
				else 
					echo "<td><a href='/CMDB/sysinfo/$hostname-sysinfo.txt'>$hostname</td>" >> $REPORT_DIR/zonelist.html
				fi
				echo "<td>$date</td>" >> $REPORT_DIR/zonelist.html
				echo "<td>$zonelist</td>" >> $REPORT_DIR/zonelist.html
				echo "</tr>" >> $REPORT_DIR/zonelist.html
			done < $REPORT_DIR/$report
				
			# Close table
			echo "</table>" >> $REPORT_DIR/zonelist.html

			# Link to the report folder
			echo "<h2>Back to <a href='/listMatching/inventory.html'>inventory page</a></h2>" >> $REPORT_DIR/zonelist.html

			# Close html
			echo "</body>" >> $REPORT_DIR/zonelist.html
			echo "</html>" >> $REPORT_DIR/zonelist.html
			;;
		esac
	done

	#####################################
	##### GENERATE MASTERTABLE.HTML #####
	#####################################
	echo "<html>" > $MASTERTABLE_HTML
	
	# Set the spacing between columns for MasterTable.html
	echo "<head>" >> $MASTERTABLE_HTML
	echo "<link rel=\"stylesheet\" href=\"../css/report.css\"/>" >> $MASTERTABLE_HTML
	echo "</head>" >> $MASTERTABLE_HTML
	echo "<body>" >> $MASTERTABLE_HTML


	# Title of the table
	echo "<h2>LIST OF NODES FROM DIFFERENT SYSTEMS MANAGEMENT TOOLS</h2>" >> $MASTERTABLE_HTML
	echo "<p>`date '+%a %d-%b-%Y %R'`</p>" >> $MASTERTABLE_HTML
	echo "<table>" >> $MASTERTABLE_HTML

	# Add each columns and each rows into table format (Additional columns could be added)
	while read hostname boks controlm netbackup syscheck uptime match
	do
		echo "<tr>" >> $MASTERTABLE_HTML
		# Link to host info file only if the host is in the Masterlist and the host has a sysinfo.txt
		if [ -f "$HOST_INFO_DIR/$hostname/CMDB/$hostname-sysinfo.txt" ] 
		then
			echo "<td><a href='/CMDB/sysinfo/$hostname-sysinfo.txt'>$hostname</td>" >> $MASTERTABLE_HTML
		else
			echo "<td>$hostname</td>" >> $MASTERTABLE_HTML
		fi
		
		echo "<td>$boks</td>" >> $MASTERTABLE_HTML
		echo "<td>$controlm</td>" >> $MASTERTABLE_HTML
		echo "<td>$netbackup</td>" >> $MASTERTABLE_HTML
		echo "<td>$syscheck</td>" >> $MASTERTABLE_HTML
		echo "<td>$uptime</td>" >> $MASTERTABLE_HTML
		echo "<td>$match</td>" >> $MASTERTABLE_HTML
		echo "</tr>" >> $MASTERTABLE_HTML
	done < $MASTERTABLE
		
	# Close table
	echo "</table>" >> $MASTERTABLE_HTML

	# Link to the report folder
	echo "<h2>Back to <a href='/listMatching/listMatching.html'>list matching page</a></h2>" >> $MASTERTABLE_HTML

	# Close html
	echo "</body>" >> $MASTERTABLE_HTML
	echo "</html>" >> $MASTERTABLE_HTML
	
	
	
