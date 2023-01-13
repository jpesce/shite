#!/bin/bash

markdown_to_html() {
  pandoc --from markdown --to html5 $1
}

markdown_get_metadata_field() {
  awk -F ":" "is_inside_frontmatter==1 && /^---$/ { is_inside_frontmatter=0 } NR==1 && /^---$/{ is_inside_frontmatter=1 } is_inside_frontmatter==1 && /^${1}/ { print \$2 }" $2
}

markdown_get_first_heading() {
  awk -F '#' '/^# / { if(!is_inside_frontmatter && !(NR==1 && $0=="---")) { print $2; exit; } } is_inside_frontmatter==1 && /^---$/ { is_inside_frontmatter=0 } NR==1 && /^---$/{ is_inside_frontmatter=1 } ' $1
}

# Get CSS file from a pygments theme in pandoc
build_code_highlight_css () {
  style=${1:-pygments}
  tmp=$(mktemp)
  echo '$highlighting-css$' > "$tmp"
  echo '`test`{.c}' | pandoc --highlight-style=$style --template=$tmp 2> /dev/null
  rm -rf $tmp
}
