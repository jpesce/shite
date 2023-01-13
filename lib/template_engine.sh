#!/bin/bash

# Replace a string in the template for the contents of a file
# The string must be in a line by its own
template_inject_file() {
  file=$1
  template=$2
  old_string=$3

  sed -e "/${old_string}/{ r ${file}" -e "d" -e "}" ${template}
}

template_inject_string() {
  # TODO: escape new_string
  new_string=$1
  template=$2
  old_string=$3

  sed -e "s/${old_string}/${new_string}/g" ${template}
}
