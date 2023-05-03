#!/bin/bash

# Determine number of lines in source file
lCount=$(cat $1 | wc -l)
# Store number of lines for train folder
trainCount=$((lCount / 10 * 8))
# Store number of lines for test folder
testCount=$((lCount - trainCount -1))
# Grab header to check for delimiter
header=$(head -n 1 $1)
# check for the presence of a semicolon, backslash, tab, or colon
if [ $(echo $header | grep ';' | wc -l) -ge 1 ] ; then
   delim=';'
elif [ $(echo $header | grep '\\' | wc -l) -ge 1 ] ; then
   delim='\'
elif [ $(echo $header | grep '\t' | wc -l) -ge 1 ] ; then
   delim='	'
elif [ $(echo $header | grep ':' | wc -l) -ge 1 ] ; then
   delim=':'
else
   delim=','
fi
# Read each line of file fed through standard input
while read line;
do
   # Insert header into both output data files, also erasing previous contents if the files existed
   if [ $lCount -gt $((trainCount + testCount)) ] ; then
      echo $line > ./train/data.csv
      echo $line > ./test/data.csv
      ((lCount--));
   # Insert 80% of the data into training data file
   elif [ $lCount -gt $testCount ] ; then
      echo $line >> ./train/data.csv
      ((lCount--));
   # Insert remaining 20% of data into testing data file
   else echo $line >> ./test/data.csv
      ((lCount--));
   fi
done <$1

# replace delims if not a comma, but only in newly generated files. Preserving the source data file as is to ensure data integrity for future applications'
if [ "$delim" != "," ]; then
   sed -i "s/$delim/,/g" ./train/data.csv
   sed -i "s/$delim/,/g" ./test/data.csv
fi
