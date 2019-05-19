#!/bin/zsh

function mg() {
  ARGS=(--untracked --color)

  case $1 in
    -i) case_sensitive=false
    -c) case_sensitive=true;shift;;
  esac

  if [[ $1 = '-c' ]];then
    ARGS+=(-E -e $2 --and --not -e '.{200}')
  elif [[ $1 =~ [A-Z] ]];then
    ARGS+=(-E -e $1 --and --not -e '.{200}')
  else
    ARGS+=(--ignore-case -E -e $1 --and --not -e '.{200}')
  fi

  git grep $ARGS | cat
}



# git grep -i --no-index --exclude-standard $1 | # grep ignoring all files in .gitignore
# egrep -v '.{200}' | # ignore lines which are longer than 200
# awk '{print NR, $0}' | # output of above command with line numbers
# grep -i $1 # highlight the original search
