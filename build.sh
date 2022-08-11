#!/bin/bash

# force script to run from the script's base directory to avoid relative path
# issues
if [[ $BASH_SOURCE = */* ]]; then cd -- "${BASH_SOURCE%/*}/"; fi
if [[ ! -e build.sh ]]; then echo "Please cd into the script directory before running"; exit 1; fi

# globals
SOURCE_DIR="./src"
TEMPLATES_DIR="${SOURCE_DIR}/templates"
TARGET_DIR="./dist"
LIB_DIR="./lib"
TMP_DIR="./tmp"

# libraries
source ${LIB_DIR}/shell_colors.sh
source ${LIB_DIR}/markdown_engine.sh
source ${LIB_DIR}/template_engine.sh

# clean
mkdir -p ${TARGET_DIR}
mkdir -p ${TMP_DIR}

# build
echo -e "${COLOR_BRIGHT_BLACK}$(date +"%T") ${COLOR_BLUE}info${COLOR_RESET}: Building images…"
source build_images.sh
echo -e "${COLOR_BRIGHT_BLACK}$(date +"%T") ${COLOR_BLUE}info${COLOR_RESET}: Done building images"

echo -e "${COLOR_BRIGHT_BLACK}$(date +"%T") ${COLOR_BLUE}info${COLOR_RESET}: Building style…"
source build_style.sh
echo -e "${COLOR_BRIGHT_BLACK}$(date +"%T") ${COLOR_BLUE}info${COLOR_RESET}: Done building style"

# echo -e "${COLOR_BRIGHT_BLACK}$(date +"%T") ${COLOR_BLUE}info${COLOR_RESET}: Building index…"
# source build_index.sh
# echo -e "${COLOR_BRIGHT_BLACK}$(date +"%T") ${COLOR_BLUE}info${COLOR_RESET}: Done building index"

echo -e "${COLOR_BRIGHT_BLACK}$(date +"%T") ${COLOR_BLUE}info${COLOR_RESET}: Building notes…"
source build_notes.sh
echo -e "${COLOR_BRIGHT_BLACK}$(date +"%T") ${COLOR_BLUE}info${COLOR_RESET}: Done building notes"

# clean
rm -rf ${TMP_DIR}
