#!/bin/bash

markdown_to_html() {
  # awk -f ${LIB_DIR}/markdown_engine/markdown_to_html.awk $1
  pandoc --from markdown --to html5 $1
}

build_code_highlight_css () {
  style=${1:-pygments}
  tmp=$(mktemp)
  echo '$highlighting-css$' > "$tmp"
  echo '`test`{.c}' | pandoc --metadata title="css highlight" --highlight-style=$style --template=$tmp
  rm -rf $tmp
}

remove_frontmatter() {
  awk '{ if(!is_inside_frontmatter && !(NR==1 && $0=="---")) { print $0 } } is_inside_frontmatter==1 && /^---$/ { is_inside_frontmatter=0 } NR==1 && /^---$/{ is_inside_frontmatter=1 } ' $1
}

get_publish_date() {
  awk -F ":" 'is_inside_frontmatter==1 && /^---$/ { is_inside_frontmatter=0 } NR==1 && /^---$/{ is_inside_frontmatter=1 } is_inside_frontmatter==1 && /^publishDate/ { print $2 }' $1
}

