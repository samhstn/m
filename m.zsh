#!/bin/zsh

function mg() {
  if [[ $1 = '-c' ]];then
    git grep --untracked $2 |
    grep -Ev '.{200}' |
    grep $2
  elif [[ $1 =~ [A-Z] ]];then
    git grep --untracked $1 |
    grep -Ev '.{200}' |
    grep $1
  else
    git grep --untracked --ignore-case $1 |
    grep -Ev '.{200}' |
    grep --ignore-case $1
  fi
}



# git grep -i --no-index --exclude-standard $1 | # grep ignoring all files in .gitignore
# egrep -v '.{200}' | # ignore lines which are longer than 200
# awk '{print NR, $0}' | # output of above command with line numbers
# grep -i $1 # highlight the original search
