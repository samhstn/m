#!/bin/zsh

function thing() {
  while getopts ":h" opt; do
    case ${opt} in
      h )
        echo "h"
        ;;
      \? ) echo "Usage: cmd [-h] [-t]";;
    esac

    echo $@
  done
}

echo "-------"
thing -h asdf

echo "-------"
thing asdf

echo "-------"
thing -a
