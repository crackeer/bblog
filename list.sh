#!/bin/bash

tmp_file=./list.tmp
if [ -f $tmp_file ]; then
    rm $tmp_file
fi
function print_file_title() {
    TITLE=$(grep -m 1 'title:' $1 | head -n 1 | cut -d':' -f2 | xargs)
    TIME=$(grep -m 1 'date:' $1 | head -n 1 | cut -d':' -f2 | xargs)
    if [ ! -z "$TITLE" ]; then
        echo $TIME" "$TITLE"(${1})" >> $tmp_file
    fi
}

FILES=$(find ./ -name "*.md")
for file in $FILES
do
    print_file_title $file
done
sort $tmp_file
rm $tmp_file