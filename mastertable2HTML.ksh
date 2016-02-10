#!/bin/ksh
###########################################################################################################
# NAME: mastertable2HTML
#
# DESCRIPTION:
# This script will convert all output generated by listMatching.ksh into an html page and and move the 
# html page to a specific folder 
#
#
# INPUT: 
# Master: a list that contains all the possible hosts (Masterlist)
# MasterTable: a table that contains the Masterlist, the presence of hosts in different sources, and a 
# 'MATCH' column to show which host appears in all the sources (if applicable)
#
#
# OUTPUT:
# table.html: A html page that shows the title of the table, the date when the table is generated, and 
# the MasterTable itself with links to each host's info file (if present)
# 
# 
# ENVIRONMENT VARIABLES:
# 
#
# NOTES:
# This script needs to be in the folder containing the Masterlist and the MasterTable.
# Run as root if needed	
#
#
# EXIT CODE:
# 0 - success
# 1 - incorrect arguements
#
#
# CHANGELOG:
# Feb 8 2016 PHAT TRAN
############################################################################################################
MASTER=Master
HTML_OUTPUT_DIR=/APACHE/listMatching

echo "<html>\n" > table.html
	
# Set the spacing between columns
echo "<head>
<style type="text/css">
td
{
	padding:0 70px 0 70px;
}
</style>
</head>\n" >> table.html
echo "<body align='center'>\n" >> table.html
date >> table.html


# Title of the table
echo "\n<h3 style='font-family:Tahoma;'>List of Hosts from Different Sources</h3>\n" >> table.html
echo "<table align='center'>" >> table.html


# Add each columns and each rows into table format
while read col1 col2 col3 col4 col5 col6
do
	echo "<tr>" >> table.html
	# Link to host info file only if the it's the host is in the Masterlist
	grep "$col1" noHeader-$MASTER > /dev/null
	if [ $? -eq 0 ]
	then
		echo "<td><a href='/inv/$col1.txt'>$col1</td>" >> table.html
	else
		echo "<td>$col1</td>" >> table.html
	fi
	
	echo "<td>$col2</td>" >> table.html
	echo "<td>$col3</td>" >> table.html
	echo "<td>$col4</td>" >> table.html
	echo "<td>$col5</td>" >> table.html
	echo "<td>$col6</td>" >> table.html
	echo "</tr>" >> table.html
	echo "\n" >> table.html
done < MasterTable	
	
# Close table
echo "\n</table>\n" >> table.html

echo "<h2>Go to <a href='/listMatching/Report.txt'>Report</a></h2>" >> table.html








# Close html
echo "\n</body>\n</html>" >> table.html

mv table.html $HTML_OUTPUT_DIR
cd $HTML_OUTPUT_DIR
cat table.html