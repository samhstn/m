#!/bin/zsh

function mg_archive() {
  $M_PATH/archive.js mg $@
}

function m_archive() {
  $M_PATH/archive.js m $@
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
  if [[ $# -ne 0 ]];then
    _mr_usage
    return 1
  fi

  m $(m_archive get)
}

function _mr_usage() {
  cat << EOF
usage: re-runs the last m or mo command which opened an file in vim
EOF
}

function _mg_usage() {
  cat << EOF
usage: mg [-cnhlE] <pattern> [-v <exclude pattern>]
    mg -E      regex search for <pattern>
    mg -c      case sensitive match of <pattern>
    mg -n      supress numbers in output
    mg -h      supress files in output
    mg -l      only show files in output
EOF
}

function _mo_usage() {
  cat << EOF
usage: mo [n]
    mo opens in vim all of the last files returned from mg
    mo n (where n is an integer) opens in vim the nth mg match
         and jumps to the correct line
EOF
}

function mg() {
  if [[ $# -eq 0 ]];then
    _mg_usage
    return 0
  fi

  while getopts ":chlEn" opt;do
    if [[ $opt == "?" ]];then
      _mg_usage
      return 1
    fi
  done

  mg_archive put $@

  $M_PATH/mg.js $@
}

function mo() {
  if [[ $# -eq 0 ]];then
    m $(mg_archive get all)
  elif [[ $# -eq 1 ]] && [[ $1 =~ '^[0-9,]+$' ]];then
    m $(mg_archive get $1)
  else
    _mo_usage
    return 1
  fi
}
