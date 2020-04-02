#!/usr/bin/env node

const childProcess = require('child_process');
const chalk = require('chalk');
const Mg = require('./lib/mg.js');

const args = process.argv.slice(2, process.argv.length);

const { shellString, pattern, caseSensitive } = new Mg(args);

// taken from https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions#Using_Special_Characters
const escapeRegExp = (string) => {
  // $& means the whole matched string
  return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

childProcess.exec(`${shellString}`, (error, stdout, stderr) => {
  if (error) {
    process.stderr.write(stderr);
  } else if (stdout === '') {
    process.stdout.write('No results 😥\n')
  } else {
    const safePattern = escapeRegExp(pattern);
    const regex = new RegExp(`(${safePattern})`, caseSensitive ? 'i' : 'ig');

    process.stdout.write(stdout.replace(regex, chalk.magenta('$1').split('\n')));
  }
});
