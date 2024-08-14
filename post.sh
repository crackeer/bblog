#!/bin/bash

CATEGORY=$1
SLUG=$(date +%Y-%m-%d-%H-%M-%S)
DATE=$(date +%Y-%m-%d)
mkdir -p ./content/post/$CATEGORY/$SLUG

YAML="---\ntitle: YourTitle\ndate: ${DATE}\nslug: ${SLUG}\ncategories:\n  - ${CATEGORY}\ntags:\n  - xxx\n---\n"

echo -ne $YAML > ./content/post/$CATEGORY/$SLUG/index.md

echo "File created: ./content/post/$CATEGORY/$SLUG/index.md"
code ./content/post ./content/post/$CATEGORY/$SLUG/index.md
