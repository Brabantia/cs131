#!/bin/bash

# Determine number of lines in source file
lCount=$(cat $1 | wc -l)
# Store number of lines for train folder
trainCount=$((lcount / 10 * 8))
# Store number of lines for test folder
testCount=$((lcount - trainCount))
# Standardize delimiter
header=$(head -n 1 $1)
# check for the presence of a space, semicolon, pipe, tab, or colon
delim=','
echo delim is $delim
delim=$(echo $header | grep -q ';' && echo ';')
echo delim is $delim
delim=$(echo $header | grep -q '|' && echo '|')
echo delim is $delim
delim=$(echo $header | grep -q '\t' && echo '\t')
echo delim is $delim
#delim=$(echo $header | grep -q ':' && echo '\:')
#echo delim is $delim
# replace delims if not a comma
if [ "$delim" != "," ]; then
   sed -i "s/$(echo $delim)/,/g" $1
fi
# Iterate over each line
for line in $1;
do
   # Insert header into both data files
   if [ $lCount -gt $((trainCount + testCount)) ] ; then
      echo $line > ./train/data.csv
      echo $line > ./test/data.csv
      ((lcount--));
   # Insert lines into training data file
   elif [ $lCount -gt $testCount ] ; then
      echo $line >> ./train/data.csv
      ((lcount--));
   #Insert lines into testing data file
   else echo $line >> ./test/data.csv
      ((lcount--));
   fi
done
