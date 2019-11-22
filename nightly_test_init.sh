#!/bin/bash
LOGFILE='apps.txt'

while IFS="|" read repo url cur_hash
do
  new_hash=$(git ls-remote ${url} HEAD | awk '{print $1}')
  if [ ${cur_hash} != ${new_hash} ]; then
    echo "*******************************************************"
    echo "[${repo}] repo has changed since last commit."
    echo "current hash:${cur_hash}"
    echo "new hash:    ${new_hash}"
    # align the above two hash lines for easier comparison
    echo -e "A new regression test will be conducted.\n"
    # need to append (update) apps.txt with the new hash
    # including date may also be helpful
  fi
done < ${LOGFILE}
