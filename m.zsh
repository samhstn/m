#!/bin/zsh

function _mr_usage() {
  cat << EOF
usage: re-runs the last m or mo command which opened an file in vim
EOF
}

function _mg_usage() {
  cat << EOF
usage: mg [-clE] <pattern> [<directory 1> <directory 2> ...]
    mg -E      regex search for <pattern>
    mg -c      case sensitive match of <pattern>
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

function _mf_usage() {
  cat << EOF
usage: mf <filename> [<directory 1> <directory 2> ...]
EOF
}

function run_m() {
  deno run --allow-env --allow-read --allow-run --allow-write $M_PATH/m.ts $@
}

function m() {
  nvim $(run_m m $@)
}

function mg() {
  if [[ $# -eq 0 ]];then
    _mg_usage
    return 1
  fi

  while getopts ":clE" opt;do
    if [[ $opt == "?" ]];then
      _mg_usage
      return 1
    fi
  done

  run_m mg $@
}

function mo() {
  if [[ $# -eq 0 ]] || ([[ $# -eq 1 ]] && [[ $1 =~ '^[0-9,]+$' ]]); then
    nvim $(run_m mo $@)
  else
    _mo_usage
    return 1
  fi
}

function mr() {
  if [[ $# -ne 0 ]];then
    _mr_usage
    return 1
  fi

  nvim $(run_m mr)
}

function mf() {
  if [[ $# -eq 0 ]];then
    _mf_usage
    return 1
  fi

  run_m mf $@
}

function ml() {
  read -r first rest <<< $(fc -lnr | head -1)

  m $rest
}
