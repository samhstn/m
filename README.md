# m

A zsh command line utility when using your terminal and `vim` as your ide.

To be used along side the alias:

```bash
alias m='mvim -v'
```

We have the following commands:

### mg

A command similar to the `grep -R <pattern> .` command

```bash
# case insensitive search of `pattern`
mg pattern

# when capitilized performs a case sensitive search of `String`
mg Pattern

# the -c flag will always be case sensitive
mg -c pattern

# the -i flag will always be case insensitive
mg -i pattern

# the -n flag will surpress numbers
mg -n pattern

# the -f flag will surpress file names
mg -f pattern

# the -l flag will return only files
mg -l pattern

# it can accept the following combinations (in any order)
mg -cn pattern
mg -cf pattern
mg -cl pattern
mg -in pattern
mg -if pattern
mg -il pattern

# to pass in a file or directory add it as an additional argument
# this also accepts all of the above flags
mg pattern ./path/to/dir
```

### mo

A command to open in `vim` the output of the `mg` command.

Will reference the most recently run `mg` command.

```bash
# mo n
# where n is a reference to the number corresponding to an `mg` output
mo 1
```

### mr

A command for jumping back to the last run `m` or `mo` command.

```bash
# simply run it with no arguments
mr
```

# Getting started

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
