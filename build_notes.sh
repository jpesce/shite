#!/bin/bash

NOTES_SOURCE_DIR=${SOURCE_DIR}/notes
NOTES_TARGET_DIR=${TARGET_DIR} # Put notes directly on /
NOTES_URL=${NOTES_TARGET_DIR#"${TARGET_DIR}"}

# Prepare
mkdir -p ${NOTES_TARGET_DIR}

# Sort notes by publishDate
notes=$(ls ${NOTES_SOURCE_DIR}/)
notes_and_publish_date=()
for note in ${notes}; do
  note_date=$(markdown_get_metadata_field "publishDate" ${NOTES_SOURCE_DIR}/${note})
  notes_and_publish_date+=(${note_date},${note})
done
sorted_notes_and_publish_date=$(echo "${notes_and_publish_date[@]}" | tr " " "\n" | sort -r)
notes=$(echo "${sorted_notes_and_publish_date}" | awk -F "," "//{print \$2}")

# Build notes
for note in ${notes}; do
  filename=${note%.*}
  source=${NOTES_SOURCE_DIR}/${note}
  target=${NOTES_TARGET_DIR}/${filename}/index.html
  title=$(markdown_get_first_heading ${source})

  mkdir -p ${NOTES_TARGET_DIR}/${filename}

  # Build current note
  markdown_to_html $source > ${target}
  injected_prose=$(template_inject_file ${target} ${TEMPLATES_DIR}/prose.html "<!--content-->")
  echo "${injected_prose}" > ${target}

  injected_main=$(template_inject_file ${target} ${TEMPLATES_DIR}/main.html "<!--content-->")
  echo "${injected_main}" > ${target}

  injected_title=$(template_inject_string "${title}" ${target} "<!--title-->")
  echo "${injected_title}" > ${target}
done

notes_index_list="<ul class='notes-index__list'>"
for note in ${notes}; do
  filename=${note%.*}
  source=${NOTES_SOURCE_DIR}/${note}
  title=$(markdown_get_first_heading ${source})
  publish_date=$(markdown_get_metadata_field "publishDate" ${source})

  # Add current note to index list
  notes_index_list+="
    <li class='grid-12 notes-index__note'>
      <div class='grid-column-3'>${publish_date}</div>
      <div class='grid-column-3'><a href='${NOTES_URL}/${filename}'><h2>${title}</h2></a></div>
    </li>
  "
done
notes_index_list+="</ul>"

# Build the index
target=${TARGET_DIR}/index.html
tmp_file="${TMP_DIR}/index"

echo "${notes_index_list}" > ${tmp_file}
injected_main=$(template_inject_file ${tmp_file} ${TEMPLATES_DIR}/main.html "<!--content-->")
echo "${injected_main}" > ${target}

injected_title=$(template_inject_string "pesce.cc" ${target} "<!--title-->")
echo "${injected_title}" > ${target}
