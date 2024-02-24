# m

A zsh command line tool to help with using your terminal and `vim` as your ide.

```bash
# open a file for editing
$ m <filename>

# find a pattern in a project
$ mg <search pattern>

# find a file in a project
$ mf <file pattern>

# open a search result from the above 2 commands
$ mo <n>

# open the most recently viewed file
$ mr

# run m on the last command args
$ ml
```

## Requirements

[`deno`](https://deno.com/)

[`nvim`](https://neovim.io/)

[`rg`](https://github.com/BurntSushi/ripgrep)

[`fd`](https://github.com/sharkdp/fd)

## Set up

```bash
# clone the repo
git clone git@github.com:samhstn/m.git && cd m

# set up the archive
mkdir -p $HOME/.m-archive
echo '[]' > $HOME/.m-archive/mr.json
echo '[]' > $HOME/.m-archive/mo.json

# add an `M_PATH` environment var to your `.zshrc`
echo "export M_PATH=$HOME/Projects/m" >> ~/.zshrc

# add tool to your .zshrc so it runs on start up
echo "source $(pwd)/m.zsh" >> ~/.zshrc
source ~/.zshrc
```
