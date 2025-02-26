#!/bin/bash

if [ $# -lt 3 ]; then
    echo "Usage: $0 <category> <slug> <title>"
    exit
fi
CATEGORY=$1
SLUG=$2
TITLE=$3
DATE=$(date +%Y-%m-%d)
mkdir -p ./content/post/$CATEGORY/$SLUG

YAML=$(cat content.template)
cp content.template ./content/post/$CATEGORY/$SLUG/index.md

if [ "$(uname)" = "Darwin" ]; then
    sed -i '' 's/SLUG/'${SLUG}'/g' ./content/post/$CATEGORY/$SLUG/index.md
    sed -i '' 's/DATE/'${DATE}'/g' ./content/post/$CATEGORY/$SLUG/index.md
    sed -i '' 's/CATEGORY/'${CATEGORY}'/g' ./content/post/$CATEGORY/$SLUG/index.md
    sed -i '' 's/TITLE/'${TITLE}'/g' ./content/post/$CATEGORY/$SLUG/index.md
else
    sed -i 's/SLUG/'${SLUG}'/g' ./content/post/$CATEGORY/$SLUG/index.md
    sed -i 's/DATE/'${DATE}'/g' ./content/post/$CATEGORY/$SLUG/index.md
    sed -i 's/CATEGORY/'${CATEGORY}'/g' ./content/post/$CATEGORY/$SLUG/index.md
    sed -i 's/TITLE/'${TITLE}'/g' ./content/post/$CATEGORY/$SLUG/index.md
fi


echo "File created: ./content/post/$CATEGORY/$SLUG/index.md"
code -r ./content/post/$CATEGORY/$SLUG/index.md
