#!/bin/bash
MAX_FILE_SIZE_IN_MB=1

git status
exec < /dev/tty
read -p "Are you sure you want to commit these changes ?(y/N): " CONFIRM
CONFIRM=$(echo $CONFIRM | tr a-z A-Z | xargs )
[ "$CONFIRM" != "Y" ] && echo "Aborting the commit" && exit 2

ADDED_FILES=$(git status -s | grep "^[AM]" | cut -c4-)

for FILE in $ADDED_FILES;do
    #echo checking file size of $FILE
    FILE_SIZE_IN_MB=$(echo $(wc -c $FILE | xargs | cut -d" " -f1)/1000000 | bc)
    if [ $FILE_SIZE_IN_MB -ge $MAX_FILE_SIZE_IN_MB ];then
        echo
        echo "[ERROR]: File size too large, cannot commit ${FILE} (${FILE_SIZE_IN_MB} MB)"
        exit 1
    fi
done
