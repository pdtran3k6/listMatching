#!/usr/bin/ksh

MASTER_TABLE_DIR=/u1/tranp 

cd $MASTER_TABLE_DIR
rm table.html
echo "<html>\n" >> table.html
	
#Set the spacing between columns
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
echo "\n<h3>List of Hosts from Different Sources</h3>\n" >> table.html
echo "<table align='center'>" >> table.html


#Add each columns and each rows into table format
while read col1 col2 col3 col4 col5
do
	echo "<tr>" >> table.html
	echo "<td><a href='/Apache/inv/$col1.txt'>$col1</td>" >> table.html
	echo "<td>$col2</td>" >> table.html
	echo "<td>$col3</td>" >> table.html
	echo "<td>$col4</td>" >> table.html
	echo "<td>$col5</td>" >> table.html
	echo "</tr>" >> table.html
	echo "\n" >> table.html
done < MasterTable	
	
#Close table and html
print "\n</table>\n</body>\n</html>" >> table.html

cat table.html
