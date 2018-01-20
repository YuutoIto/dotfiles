#!/usr/bin/env zsh
set -u
source helper-chgit
local cmdname="${0:t:r}"

# functions {{{
# }}}

#Start
local rc_file="$(find_rc "${cmdname}")"

if [[ $rc_file != $HOME/.${cmdname}rc ]]; then
  print_color "[+] Load ${rc_file}" 220
fi

local mode="${1:-list}"
shift 2>/dev/null

case $mode in
  add) action_add "${@}" ;;
  pull) action_pull ;;
  only) # {{{
    : "${1:?the only option need <PATTERN>}"
    matched=$(grep "${1}" "$rc_file" | head -1)
    [[ -z $matched ]] && error "not matched: ${1}" 20

    read -k key"?$matched (Y/n)"
    [[ $key != $'\n' ]] && echo
    if [[ ! $key =~ [nN] ]]; then
      execute "$matched"
    fi
    ;; # }}}
  list) action_list ;;
  edit) action_edit ;;
  each) action_each $@ ;;
  shell) action_shell ;;
  help) # {{{
    echo "Usage: ${cmdname} [mode]"
    echo -e "\tnon-argument show list"
    echo -e "\tadd PATH or %CMD"
    echo -e "\tpull"
    echo -e "\tonly PATTERN"
    echo -e "\tlist"
    echo -e "\tedit"
    echo -e "\teach"
    echo -e "\tshell"
    echo -e "\thelp"
    ;; # }}}
  *) action_not_subcommand ;;
esac

exit 0
