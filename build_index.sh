#!/bin/bash

tmp_file=/tmp/tmp
source=${SOURCE_DIR}/index.html
target=${TARGET_DIR}/index.html

# Get 5 post (remove about page)
# posts=$(ls -tU ${POST_SOURCE_DIR}/ | sort -r | grep -v "about" | head -n5)
# list="<ul>"
# for post in $posts; do
#   filename=${post%.*}
#   extension=${post##*.}

#   list+="<li><a href=\"post/${filename}/index.html\">Post</a></li>"
# done
# list+="</ul>"
# echo ${list} > ${tmp_file}

template_inject ${SOURCE_DIR}/index.html ${TEMPLATES_DIR}/main.html "<!--content-->" > ${target}
