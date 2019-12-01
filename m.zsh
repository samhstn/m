#!/bin/zsh

function mg_archive() {
  ./archive.js mg $@
}

function m_archive() {
  ./archive.js m $@
}

function m() {
  m_archive put $@

  # to allow for opening files pasted from
  # output of git diff of the form a/filname.ext
  if [[ $1 =~ ^(a|b)/ ]];then
    mvim -v $(echo $1 | sed -E 's/^(a|b)\///')
  else
    mvim -v $@
  fi
}

function ml() {
  # this if statement is needed for testing
  # as fc doesn't work in zunit
  if [[ ! -z $M_HISTORY_TEST ]];then
    h=$M_HISTORY_TEST
  else
    h=$(fc -lnr)
  fi

  read -r first rest <<< $(echo $h | head -1)

  m $rest
}

function mr() {
  # TODO: add usage when arguments provided
  # if [[ $# -ne 0 ]];then
  #   _m_mr_usage
  #   return 0
  # fi

  m $(m_archive get)
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
         and jumps to the correct line
EOF
}

# takes a first argument of an array of args passed to mg
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

function mg_args() {
  ARGS=()
  EXCLUDE_PATTERN=()

  no_color="false"
  show_lines="false"
  case_sensitive="false"
  suppress_files="false"
  regex="false"
  directory=""

  # we always want to include untracked in our git grep command
  ARGS+=(--untracked)

  while getopts ":chlECLn" opt;do
    case ${opt} in
      c ) case_sensitive="true";;
      E ) regex="true";;
      h ) ARGS+=(-h);;
      l ) ARGS+=(-l);;
      C ) no_color="true";; # only used internally by mo
      L ) show_lines="true";; # only used internally by mo
      n ) ;;
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

  if [[ $PATTERN =~ [A-Z] ]];then
    case_sensitive="true"
  fi

  if [[ $case_sensitive = "false" ]];then
    ARGS+=(--ignore-case)
  fi

  if [[ $no_color = "true" ]];then
    ARGS+=(--no-color)
  fi

  if [[ $show_lines = "true" ]];then
    ARGS+=(-n)
  fi

  if [[ $regex = "true" ]];then
    ARGS+=(-E)
  fi

  ARGS+=($PATTERN)

  if [[ $directory != "" ]];then
    ARGS+=(-- $directory)
  fi

  echo $ARGS
}

function mg_excludes() {
  append="false"
  EXCLUDES=()

  for arg in $@;do
    if [[ $append = "true" ]];then
      EXCLUDES+=$arg
    fi

    if [[ $arg == "-v" ]];then
      append="true"
    fi
  done

  str=""
  if [ "${#EXCLUDES[@]}" -gt 1 ];then
    str="($str"
    for exc in $EXCLUDES;do
      str="$str$exc|"
    done
    str=$(echo $str | sed 's/\|$//')
    str="$str)"
  else
    str="${EXCLUDES[1]}"
  fi

  echo $str
}

# wrapper around git-grep which records each run to be used
# in conjuction with mo command.
function mg() {
  excludes="false"

  if [[ $# -eq 0 ]];then
    _m_mg_usage
    return 0
  fi

  while getopts ":n::E::c::h::l::C::L::v:" opt;do
    # if we receive $1 as many opts prepended by one dash
    # then we format them as individual opts each prepended by a dash
    # this allows for easy parsing and consistency in mg_formatted
    if [ $OPTIND -eq 2 ];then
      ARGS=()

      for f in $(grep -o . <<< $(echo $1 | sed 's/-//g'));do
        ARGS+=(-$f)
      done

      for a in ${@:2};do
        ARGS+=($a)
      done
    fi

    case ${opt} in
      v ) excludes="true";;
      \? ) _m_mg_usage;return 1;;
    esac
  done

  # see above for this if condition
  if [ $OPTIND -eq 2 ];then
    # mg_archive $(git grep $(mg_args $(ensure_flags $ARGS)) | grep -Ev $(mg_excludes $@))

    # See: https://stackoverflow.com/a/15394738/4699289
    # for how to check if list contains some string
    # if -n flag, then suppress numbers in output
    if [[ " ${ARGS[@]} " =~ " ${-n} " ]];then
      if [[ excludes = "true" ]];then
        git grep $(mg_args $ARGS) | grep -Ev $(mg_excludes $@)
      else
        git grep $(mg_args $ARGS)
      fi
    else
      if [[ excludes = "true" ]];then
        git grep $(mg_args $ARGS) | grep -Ev $(mg_excludes $@) | cat -n
      else
        git grep $(mg_args $ARGS) | cat -n
      fi
    fi
  else
    # mg_archive $(git grep $(mg_args $(ensure_flags $ARGS 'nCL')) | grep -Ev $(mg_excludes $@))

    if [[ excludes = "true" ]];then
      git grep $(mg_args $@) | grep -Ev $(mg_excludes $@)
    else
      git grep $(mg_args $@)
    fi
  fi
}

function mo() {
  if [[ $# -eq 0 ]];then
    m $(mg_archive get all)
  elif [[ $# -eq 1 ]] && [[ $1 =~ '^[0-9]+$' ]];then
    m $(mg_archive get $1)
  else
    _m_mo_usage
    return 1
  fi
}
