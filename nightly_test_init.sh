#!/bin/bash

REPO_FILE='repo.info'
LOG_CSV_FILE='change.csv'
LOG_HTML_FILE='change.html'

# Create LOG_CSV_FILE and enter headers
if [ ! -f $LOG_CSV_FILE ]; then
  printf "date," > $LOG_CSV_FILE
  cat $REPO_FILE | awk -F ' *\\| *' '{printf "%s,", $1}' >> $LOG_CSV_FILE
  sed -i 's/,$/\n/' $LOG_CSV_FILE
fi

# Enter today's date (first column in LOG_CSV_FILE)
printf "$(date -u "+%x-%X")," >> $LOG_CSV_FILE

# Check if repo hash has changed
# If yes: 1) write 'changed' in LOG_CSV_FILE; 2) update REPO_FILE hash
# If no: write 'unchanged' in LOG_CSV_FILE
while IFS="|" read repo url cur_hash
do
  new_hash=$(git ls-remote ${url} HEAD | awk '{print $1}')

  if [ ${cur_hash} != ${new_hash} ]; then
    #printf "changed (from $(echo ${cur_hash} | cut -c 1-7) to $(echo ${new_hash} | cut -c 1-7))," >> $LOG_CSV_FILE
    printf "changed ($(echo ${cur_hash} | cut -c 1-7) => $(echo ${new_hash} | cut -c 1-7))," >> $LOG_CSV_FILE
    #sed
  else
    printf "unchanged ($(echo ${cur_hash} | cut -c 1-7))," >> $LOG_CSV_FILE 

  fi
done < ${REPO_FILE}
sed -i 's/,$/\n/' $LOG_CSV_FILE

# Convert LOG_CSV_FILE to LOG_HTML_FILE

