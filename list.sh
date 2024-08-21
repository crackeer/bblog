#!/bin/bash

function print_file_title() {
    TITLE=$(grep -m 1 'title:' $1 | head -n 1 | cut -d':' -f2 | xargs)
    if [ ! -z "$TITLE" ]; then
        echo $TITLE"(${1})"
    fi
}

FILES=$(find ./ -name "*.md")
for file in $FILES
do
    print_file_title $file
done