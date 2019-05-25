#!/bin/zsh

function usage() {
  cat << EOF
usage: mg [-cnhl] <pattern> [-v <exclude pattern>]
    mg -c      case sensitive match of <pattern>
    mg -n      supress numbers in output
    mg -h      supress files in output
    mg -l      only show files in output
EOF
} 

function mg() {
  if [[ $# -eq 0 ]];then
    usage
    exit 0
  fi

  declare -a ARGS
  declare case_sensitive="false"
  declare suppress_files="false"
  declare no_numbers="false"

  ARGS+=(--untracked) # include untracked in git grep command
  ARGS+=(--color) # color the output in the terminal

  while getopts ":c:h:l:n:" opt; do
    case ${opt} in
      c ) case_sensitive="true";shift;;
      n ) no_numbers="true";shift;;
      h ) ARGS+=(-h);shift;;
      l ) ARGS+=(-l);shift;;
      \? ) usage 1>&2;exit 1;;
    esac
  done

  if [[ $1 =~ [A-Z] ]] || [[ $case_sensitive = "true" ]];then
    ARGS+=(-E -e $1 --and --not -e '.{200}')
  else
    ARGS+=(--ignore-case -E -e $1 --and --not -e '.{200}')
  fi

  if [[ $no_numbers = "true" ]];then
    git grep $ARGS | cat
  else
    git grep $ARGS | cat -n
  fi
}
