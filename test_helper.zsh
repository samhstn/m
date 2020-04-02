#!/bin/zsh

_m_called_with=()

function m() {
  _m_called_with+=($@)
}

function m_called_with() {
  for arg in $_m_called_with;do
    echo $arg
  done
}

function m_reset() {
  _m_called_with=()
}
