#!/bin/zsh

function mg_usage() {
  cat << EOF
usage: mg [-cnhl] <pattern> [-v <exclude pattern>]
    mg -c      case sensitive match of <pattern>
    mg -n      supress numbers in output
    mg -h      supress files in output
    mg -l      only show files in output
EOF
}

function mg_formatted() {
  ARGS=()

  case_sensitive="false"
  suppress_files="false"
  no_numbers="false"

  ARGS+=(--untracked) # include untracked in git grep command
  ARGS+=(--color) # color the output in the terminal

  while getopts ":nchlv:" opt;do
    case ${opt} in
      n ) no_numbers="true";;
      c ) case_sensitive="true";;
      h ) ARGS+=(-h);;
      l ) ARGS+=(-l);;
      v ) echo "v $OPTARG";;
      \? ) mg_usage;return 1;;
    esac
  done

  shift $(($OPTIND -1))

  if [[ $1 =~ [A-Z] ]];then
    case_sensitive="true"
  fi

  if [[ $case_sensitive = "false" ]];then
    ARGS+=(--ignore-case)
  fi

  ARGS+=(-E -e $1 --and --not -e '.{200}')

  if [[ $no_numbers = "true" ]];then
    git grep $ARGS | cat
  else
    git grep $ARGS | cat -n
  fi
}

function mg() {
  if [[ $# -eq 0 ]];then
    mg_usage
    return 0
  fi

  # if we receive the first argument as many opts prepended by one dash
  # then we format them as individual opts each prepended by a dash
  # this allows for easy parsing and consistency in mg_formatted

  while getopts ":n::c::h::l::" opt;do
    if [ $opt = \? ];then
      mg_usage
      return 1
    fi

    if [ $OPTIND -eq 2 ];then
      ARGS=()

      for f in $(grep -o . <<< $(echo $1 | sed 's/-//g'));do
        ARGS+=(-$f)
      done

      for a in ${@:2};do
        ARGS+=($a)
      done
    fi
  done

  if [ $OPTIND -eq 2 ];then
    mg_formatted $ARGS
  else
    mg_formatted $@
  fi
}
