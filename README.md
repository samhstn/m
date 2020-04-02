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

We will also need to add the environment variable:

```zsh
export M_PATH=$HOME/proj/m
```

To keep up to date, we should clone the repo and add a symlink to our plugin path:

```bash
# clone the repo
git clone git@github.com:samhstn/m.git && cd m

# create the plugin directory
md ~/.oh-my-zsh/plugins/m

# add the symlink
ln -s $(pwd)/m.zsh $HOME/.oh-my-zsh/plugins/m/m.plugin.zsh
```

# Running the tests locally

Ensure you have [`zunit`](https://github.com/zunit-zsh/zunit) installed.

Run the `zsh` tests:

```bash
zunit
```

Install our `node` dependencies:

```bash
npm install
```

Run the `node` tests:

```bash
npm test
```

For development, if you have [`nodemon`](https://github.com/remy/nodemon) installed, a nice tdd setup

is to develop in one terminal window and watch the tests in another window by running the command:

```bash
# watch zunit tests
nodemon -w tests/zunit -w m.zsh -e zunit,zsh -x 'zunit'

# watch node tests
nodemon -x 'npm test'

# watch all tests
nodemon -e zunit,zsh,js -x 'zunit && npm test'
```
