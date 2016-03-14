#!/bin/ksh
echo "List of files" > files
for fname in $(ls !(findCommands.ksh))
do
	egrep "\\\$WHO|\\\$DATE|\\\$ECHO" $fname
	if [ $? -eq 0 ]
	then
		echo "--------"
		echo $fname
		echo $fname >> files
		echo
	fi
done
