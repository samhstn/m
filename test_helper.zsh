#!/bin/zsh

_called_with=""

function m() {
  _called_with=$1
}

function m_called_with() {
  echo $_called_with
}
