#!/usr/bin/env node

const childProcess = require('child_process');
const chalk = require('chalk');
const Mg = require('./lib/mg.js');

const args = process.argv.slice(2, process.argv.length);

const { shellString, pattern, caseSensitive } = new Mg(args);

childProcess.exec(`${shellString}`, (error, stdout, stderr) => {
  if (error) {
    process.stderr.write(stderr);
  } else {
    const regex = new RegExp(`(${pattern})`, caseSensitive ? 'i' : 'ig');

    process.stdout.write(stdout.replace(regex, chalk.magenta('$1').split('\n')));
  }
});
