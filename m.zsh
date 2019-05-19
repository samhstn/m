#!/bin/zsh

function mg() {
  ARGS=(--untracked --color)
  case_sensitive=''

  case $1 in
    -c) case_sensitive=true;shift;;
  esac

  if [[ $1 =~ [A-Z] ]] || [[ $case_sensitive = true ]];then
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
