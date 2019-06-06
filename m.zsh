#!/bin/zsh

function m() {
  mvim -v $@
}

function _m_mg_usage() {
  cat << EOF
usage: mg [-cnhl] <pattern> [-v <exclude pattern>]
    mg -c      case sensitive match of <pattern>
    mg -n      supress numbers in output
    mg -h      supress files in output
    mg -l      only show files in output
EOF
}

function _m_mo_usage() {
  cat << EOF
usage: mo [n]
    mo opens in vim all of the last files returned from mg
    mo n (where n is an integer) opens in vim the nth mg match
EOF
}

# takes a first argument of a string matching the pattern:
# mg [-cnhl] <pattern> [-v <exclude_pattern>]
# and a second argument of characters as flags
# and returns the first command with flags set
# we keep the output altering flags: -cvl
# we change the output styling flags: -nh
function ensure_flags() {
  local first arg1 rest flags

  read -r first arg1 rest <<< $1

  if [[ $arg1 =~ ^[^-] ]];then
    echo "-$2 $arg1${rest:+ $rest}"
  else
    eval 'flags=${arg1//[nh'$2']/}$2'

    echo "$flags $rest"
  fi
}

function mg_formatted() {
  ARGS=()
  EXCLUDE_PATTERN=()

  case_sensitive="false"
  suppress_files="false"
  no_numbers="false"
  no_color="false"
  directory=""

  ARGS+=(--untracked) # include untracked in git grep command

  while getopts ":nchlC" opt;do
    case ${opt} in
      n ) no_numbers="true";;
      c ) case_sensitive="true";;
      h ) ARGS+=(-h);;
      l ) ARGS+=(-l);;
      C ) no_color="true";; # only used internally by mo
      \? ) _m_mg_usage;return 1;;
    esac
  done

  shift $(($OPTIND -1))

  PATTERN=$1

  shift

  if [[ $1 != "" ]] && ! [[ $1 =~ ^- ]];then
    directory=$1
    shift
  fi

  while getopts ":v:" opt;do
    case ${opt} in
      v ) EXCLUDE_PATTERN+=($OPTARG);;
      \? ) _m_mg_usage;return 1;;
    esac
  done

  if [[ $PATTERN =~ [A-Z] ]];then
    case_sensitive="true"
  fi

  if [[ $no_color = "false" ]];then
    ARGS+=(--color)
  fi

  if [[ $case_sensitive = "false" ]];then
    ARGS+=(--ignore-case)
  fi

  ARGS+=(-E -e $PATTERN --and --not -e '.{200}')

  for exclude_pattern in $EXCLUDE_PATTERN;do
    ARGS+=(--and --not -e $exclude_pattern)
  done

  if [[ $directory != "" ]];then
    ARGS+=(-- $directory)
  fi

  if [[ $no_numbers = "true" ]];then
    git grep $ARGS | cat
  else
    git grep $ARGS | cat -n
  fi
}

function mg() {
  if [[ $# -eq 0 ]];then
    _m_mg_usage
    return 0
  fi

  # if we receive the first argument as many opts prepended by one dash
  # then we format them as individual opts each prepended by a dash
  # this allows for easy parsing and consistency in mg_formatted
  while getopts ":n::c::h::l::" opt;do
    if [ $opt = \? ];then
      _m_mg_usage
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
  if [ "$M_TEST" = "true" ] && [[ ! -z $M_HISTORY_TEST ]];then
    h=$M_HISTORY_TEST
  else
    h=$(fc -lnr)
  fi

  if ! echo $h | grep -Eq '^mg ';then
    echo "cannot find recently run mg command"
    return 1
  fi

  last_mg_command=$(echo $h | grep -m 1 -E '^mg ')

  # if no args, then open all files from mg
  if [[ $# -eq 0 ]];then
    m $(mg $(ensure_flags $last_mg_command 'nl'))
  elif [[ $# -eq 1 ]] && [[ $1 =~ '^[0-9]+$' ]];then
    m \
      $(
        mg $(ensure_flags $last_mg_command 'nC') |
        sed 's/:.*$//' |
        sed -n "$1"p
      )
  else
    _m_mo_usage
    return 1
  fi
}
