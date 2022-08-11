#!/bin/bash

# Replace a section of a template for the contents of a file
# template_inject [content file] [template file] [string to be replaced]
template_inject() {
  content_file=$1
  template=$2
  string_to_be_replaced=$3

  sed -e "/${string_to_be_replaced}/{ r ${content_file}" -e "d" -e "}" ${template}
}
