#!/bin/bash

NOTE_SOURCE_DIR=${SOURCE_DIR}/notes
NOTE_TARGET_DIR=${TARGET_DIR}/
NOTE_URL=${NOTE_TARGET_DIR#"${NOTE_TARGET_DIR}"}

# prepare
mkdir -p ${NOTE_TARGET_DIR}

# build
notes_index_list="<ul class='notes-index__list'>"
notes=$(ls -tU ${NOTE_SOURCE_DIR}/ | sort -r)
for note in $notes; do
  filename=${note%.*}
  extension=${note##*.}

  source=${NOTE_SOURCE_DIR}/${filename}.${extension}
  target=${NOTE_TARGET_DIR}/${filename}/index.html
  tmp_markdown="/tmp/${filename}.md"
  tmp_file="/tmp/${filename}"

  case $extension in
    "md")
      mkdir -p ${NOTE_TARGET_DIR}/${filename}

      # build current note
      remove_frontmatter $source | markdown_to_html > ${tmp_markdown}
      template_inject ${tmp_markdown} ${TEMPLATES_DIR}/fieldnote.html "<!--fieldnote-->" > ${tmp_file}
      template_inject ${tmp_file} ${TEMPLATES_DIR}/main.html "<!--content-->" > $target

      # add note to index list
      if [ ! ${filename} == "about" ]; then
        notes_index_list+="
          <li class='grid-12 notes-index__note'>
            <div class='grid-column-3'><a href='${NOTE_URL}/${filename}'>${filename}</a></div>
            <div class='grid-column-6 prose'>$(cat ${tmp_markdown})</div>
          </li>
        "
      fi

      rm ${tmp_file} ${tmp_markdown}
      ;;
    *)
      echo -e "${COLOR_BRIGHT_BLACK}$(date +'%T') ${COLOR_YELLOW}warning${COLOR_RESET}: ${source}: Don't know how to build note extension ${extension}. Skipping…"
  esac
done

# build notes index
target=${NOTE_TARGET_DIR}/index.html
tmp_file="/tmp/index"

notes_index_list+="</ul>"
echo ${notes_index_list} > ${tmp_file}

template_inject ${tmp_file} ${TEMPLATES_DIR}/main.html "<!--content-->" > $target
