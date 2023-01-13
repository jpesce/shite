#!/bin/sh

PAGES_SOURCE_DIR=${SOURCE_DIR}/other
PAGES_TARGET_DIR=${TARGET_DIR} # Put pages directly on /
PAGES_URL=${PAGES_TARGET_DIR#"${TARGET_DIR}"}

# Prepare
mkdir -p ${PAGES_TARGET_DIR}

pages=$(ls ${PAGES_SOURCE_DIR}/)
for page in ${pages}; do
  filename=${page%.*}
  source=${PAGES_SOURCE_DIR}/${page}
  target=${PAGES_TARGET_DIR}/${filename}/index.html
  title=$(markdown_get_first_heading ${source})

  mkdir -p ${PAGES_TARGET_DIR}/${filename}

  # Build current page
  markdown_to_html $source > ${target}
  echo "$(template_inject_file ${target} ${TEMPLATES_DIR}/prose.html "<!--content-->")" > ${target}
  echo "$(template_inject_file ${target} ${TEMPLATES_DIR}/main.html "<!--content-->")" > ${target}
  echo "$(template_inject_string "${title}" ${target} "<!--title-->")" > ${target}
done
