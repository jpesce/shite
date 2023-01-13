sh_loc=$(find . -name '*.sh' | xargs wc -l | tail -1 | tr -dc '0-9')
html_loc=$(find . -name '*.html' | xargs wc -l | tail -1 | tr -dc '0-9')
md_loc=$(find . -name '*.md' | xargs wc -l | tail -1 | tr -dc '0-9')
css_loc=$(find . -name '*.css' | xargs wc -l | tail -1 | tr -dc '0-9')

echo -e "${COLOR_BRIGHT_BLACK}$(date +"%T") ${COLOR_BLUE}info${COLOR_RESET}: Lines of code: SH:${sh_loc} MD:${md_loc} HTML:${html_loc} CSS:${css_loc}"
