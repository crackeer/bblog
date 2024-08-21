#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage: $0 <category> <title>"
    exit
fi
CATEGORY=$1
TITLE=$2
SLUG=$(date +%Y-%m-%d-%H-%M-%S)
DATE=$(date +%Y-%m-%d)
mkdir -p ./content/post/$CATEGORY/$SLUG

YAML=$(cat content.template)
cp content.template ./content/post/$CATEGORY/$SLUG/index.md

sed -i 's/SLUG/'${SLUG}'/g' ./content/post/$CATEGORY/$SLUG/index.md
sed -i 's/DATE/'${DATE}'/g' ./content/post/$CATEGORY/$SLUG/index.md
sed -i 's/CATEGORY/'${CATEGORY}'/g' ./content/post/$CATEGORY/$SLUG/index.md
sed -i 's/TITLE/'${TITLE}'/g' ./content/post/$CATEGORY/$SLUG/index.md


echo "File created: ./content/post/$CATEGORY/$SLUG/index.md"
code . ./content/post/$CATEGORY/$SLUG/index.md
