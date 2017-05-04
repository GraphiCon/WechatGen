#!/bin/sh
echo "Generating wechat compatible html from \x1b[1m$1"
SCRIPT_PATH=$(dirname "$0")
echo "${SCRIPT_PATH}"
pandoc $1 -s --webtex -c ${SCRIPT_PATH}/simple.css -A ${SCRIPT_PATH}/footer.html -o ${1%%.*}.html
echo "Please open ${1%%.*}.html and copy all the content to wechat editor."
