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

function mo_usage() {
  cat << EOF
usage: mo [n]
    mo opens in vim all of the last files returned from mg
    mo n (where n is an integer) opens in vim the nth mg match
EOF
}

function mg_formatted() {
  ARGS=()
  EXCLUDE_PATTERN=()

  case_sensitive="false"
  suppress_files="false"
  no_numbers="false"

  ARGS+=(--untracked) # include untracked in git grep command
  ARGS+=(--color) # color the output in the terminal

  while getopts ":nchl" opt;do
    case ${opt} in
      n ) no_numbers="true";;
      c ) case_sensitive="true";;
      h ) ARGS+=(-h);;
      l ) ARGS+=(-l);;
      \? ) mg_usage;return 1;;
    esac
  done

  shift $(($OPTIND -1))

  PATTERN=$1

  shift

  while getopts ":v:" opt;do
    case ${opt} in
      v ) EXCLUDE_PATTERN+=($OPTARG);;
      \? ) mg_usage;return 1;;
    esac
  done

  if [[ $PATTERN =~ [A-Z] ]];then
    case_sensitive="true"
  fi

  if [[ $case_sensitive = "false" ]];then
    ARGS+=(--ignore-case)
  fi

  ARGS+=(-E -e $PATTERN --and --not -e '.{200}')

  for exclude_pattern in $EXCLUDE_PATTERN;do
    ARGS+=(--and --not -e $exclude_pattern)
  done

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

function mo() {
  # this if statement is needed for testing
  # as fc doesn't work in zunit
  if [[ -z $M_HISTORY_TEST ]];then
    h=$(fc -lnr)
  else
    h=$M_HISTORY_TEST
  fi

  if ! [[ "$h" =~ "^mg " ]];then
    echo "cannot find recently run mg command"
    return 1
  fi

  last_mg_command=$(echo $h | grep -m 1 -E '^mg ')

  # if no args, then open all files from mg
  if [[ $# -eq 0 ]];then
    cmd=$(
      echo $last_mg_command |
      # if there are no flags, we want to set -nl as flags
      sed '/^mg [^\-]/s/^mg \(\.*\)/mg -nl \1/' |
      # if there are flags, we want to append them with -nl
      sed 's/^mg -\([a-z]*\)\(\.*\)/mg -\1nl\2/'
    )

    m $(eval $cmd)
  elif [[ $# -eq 1 ]] && [[ $1 =~ '^[0-9]+$' ]];then
    cmd=$(
      echo $last_mg_command
    )
  else
    mo_usage
    return 1
  fi
}
