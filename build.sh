#!/bin/bash

# Force user to run script from the base directory to avoid relative path issues
if [[ $BASH_SOURCE = */* ]]; then cd -- "${BASH_SOURCE%/*}/"; fi
if [[ ! -e build.sh ]]; then echo "cd into the script directory before running"; exit 1; fi

# Exit on error
set -e

# Globals
SOURCE_DIR="./source"
TEMPLATES_DIR="${SOURCE_DIR}/templates"
TARGET_DIR="./output"

LIB_DIR="./lib"
TMP_DIR="./tmp"

# Libraries
source ${LIB_DIR}/shell_colors.sh
source ${LIB_DIR}/markdown_engine.sh
source ${LIB_DIR}/template_engine.sh

# Run with -w to watch changes
# Requires browser-sync and fswatch
while getopts "w" opt; do
  case ${opt} in
    w)
      ./build.sh
      (trap 'kill 0' SIGINT; browser-sync --no-ui --no-notify --server --watch ${TARGET_DIR} ${TARGET_DIR} & fswatch --latency 0.1 --one-per-batch -0 ${SOURCE_DIR} ${LIB_DIR} *.sh | xargs -0 -n1 -I{} ./build.sh)
      ;;
  esac
done

# Clean
echo -e "${COLOR_BRIGHT_BLACK}$(date +"%T") ${COLOR_BLUE}info${COLOR_RESET}: Cleaning…"
rm -rf ${TARGET_DIR}
rm -rf ${TMP_DIR}
mkdir -p ${TARGET_DIR}
mkdir -p ${TMP_DIR}

# Get stats
source build_stats.sh

# Build
# Copy style and images
cp -r ${SOURCE_DIR}/images ${TARGET_DIR}/images
cp -r ${SOURCE_DIR}/style ${TARGET_DIR}/style

# Build Notes
echo -e "${COLOR_BRIGHT_BLACK}$(date +"%T") ${COLOR_BLUE}info${COLOR_RESET}: Building notes…"
source build_notes.sh

# Clean
rm -rf ${TMP_DIR}
echo -e "${COLOR_BRIGHT_BLACK}$(date +"%T") ${COLOR_BLUE}info${COLOR_RESET}: Done"

