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
# 1 - incorrect arguements
# 
#
# CHANGELOG:
# Feb 18 2016 PHAT TRAN
############################################################################################################

NO_HEADER_MASTER=/opt/fundserv/syscheck/webcontent/listMatching/totals/noHeader-Master
MASTERTABLE_HTML=/opt/fundserv/syscheck/webcontent/listMatching/MasterTable.html
MASTERTABLE=/opt/fundserv/syscheck/webcontent/listMatching/table/MasterTable

echo "<html>\n" > $MASTERTABLE_HTML
	
# Set the spacing between columns
echo "<head>
<style type="text/css">
td
{
	padding:0 70px 0 70px;
}
</style>
</head>\n" >> $MASTERTABLE_HTML
echo "<body align='center'>\n" >> $MASTERTABLE_HTML

# Date when the $MASTERTABLE_HTML was generated
date >> $MASTERTABLE_HTML

# Title of the table
echo "\n<h3 style='font-family:Tahoma;'>List of Nodes from Different Tool</h3>\n" >> $MASTERTABLE_HTML
echo "<table align='center'>" >> $MASTERTABLE_HTML

# Add each columns and each rows into table format (Additional columns could be added)
while read col1 col2 col3 col4 col5 col6 col7
do
	echo "<tr>" >> $MASTERTABLE_HTML
	# Link to host info file only if the it's the host is in the Masterlist
	grep "$col1" $NO_HEADER_MASTER > /dev/null
	if [ $? -eq 0 ]
	then
		echo "<td><a href='/CMDB/sysinfo/`echo $col1 | sed 's/+/ /g'`-sysinfo.txt'>$col1</td>" >> $MASTERTABLE_HTML
	else
		echo "<td>$col1</td>" >> $MASTERTABLE_HTML
	fi
	
	echo "<td>$col2</td>" >> $MASTERTABLE_HTML
	echo "<td>$col3</td>" >> $MASTERTABLE_HTML
	echo "<td>$col4</td>" >> $MASTERTABLE_HTML
	echo "<td>$col5</td>" >> $MASTERTABLE_HTML
	echo "<td>$col6</td>" >> $MASTERTABLE_HTML
	echo "<td>$col7</td>" >> $MASTERTABLE_HTML
	echo "</tr>" >> $MASTERTABLE_HTML
	echo "\n" >> $MASTERTABLE_HTML
done < $MASTERTABLE
	
# Close table
echo "\n</table>\n" >> $MASTERTABLE_HTML

# Link to the report folder
echo "<h2>Go to <a href='/listMatching/reports'>Report</a></h2>" >> $MASTERTABLE_HTML

# Close html
echo "\n</body>\n</html>" >> $MASTERTABLE_HTML
