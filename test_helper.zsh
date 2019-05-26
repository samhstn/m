#!/bin/zsh

_called_with=()

function m() {
  _called_with+=($@)
}

function m_called_with() {
  for arg in $_called_with;do
    echo $arg
  done
}

function m_reset() {
  _called_with=()
}

function cyan() {
  color cyan $1
}

function red() {
  color red bold $1
}

function color() {
  local color=$1 style=$2 b=''

  shift

  case $style in
    bold|b)           b='1;'; shift ;;
    italic|i)         b='2;'; shift ;;
    underline|u)      b='4;'; shift ;;
    inverse|in)       b='7;'; shift ;;
    strikethrough|s)  b='9;'; shift ;;
  esac

  case $color in
    black|b)    echo "\033[${b}30m${@}\033[m" ;;
    red|r)      echo "\033[${b}31m${@}\033[m" ;;
    green|g)    echo "\033[${b}32m${@}\033[m" ;;
    yellow|y)   echo "\033[${b}33m${@}\033[m" ;;
    blue|bl)    echo "\033[${b}34m${@}\033[m" ;;
    magenta|m)  echo "\033[${b}35m${@}\033[m" ;;
    cyan|c)     echo "\033[${b}36m${@}\033[m" ;;
    white|w)    echo "\033[${b}37m${@}\033[m" ;;
    *)          echo "\033[${b}38;5;$(( ${color} ))m${@}\033[0;m" ;;
  esac
}
