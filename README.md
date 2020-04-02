[![Build Status](https://travis-ci.org/samhstn/m.svg?branch=master)](https://travis-ci.org/samhstn/m)

# m

A zsh command line utility when using your terminal and `vim` as your ide.

```bash
# to open any file
m <filename>

# to recursively grep search through all files in a directory
mg <pattern>

# to open a specific file from an `mg` output
mo [<number>]

# to open the last argument of the last command
ml

# to rerun the last run `m <filename>`, `mo [<number>]` or `ml`
mr
```

# Installation

To set this up as a `zsh` plugin, simply run the following command:

```zsh
md ~/.oh-my-zsh/plugins/m
curl -sSL https://raw.githubusercontent.com/samhstn/m/master/m.zsh > ~/.oh-my-zsh/plugins/m/m.plugin.zsh
```

and edit your `plugins` in your `~/.zshrc`:

```zsh
plugins=(
  ...
  m
)
```

# Running the tests locally

Ensure you have [`zunit`](https://github.com/zunit-zsh/zunit) installed.

Then run the tests:

```bash
zunit
```

For development, if you have [`nodemon`](https://github.com/remy/nodemon) installed, a nice tdd setup

is to develop in one terminal window and watch the tests in another window by running the command:

```bash
nodemon -w tests -w m.zsh -e zunit,zsh -x 'zunit'
```
