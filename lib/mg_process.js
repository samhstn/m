'use strict';

const Mg = require('./mg.js');
const childProcess = require('child_process');

/*
 * Exposes method `exec` for how to run the given shell string,
 * it simply runs `this.shellString` in bash.
 */
class MgProcess extends Mg {
  constructor(args) {
    super(args, {archive: true});
  }

  get exec() {
    return new Promise((resolve, reject) => {
      childProcess.exec(`${this.shellString}`, (error, stdout, stderr) => {
        if (error) {
          reject(stderr);
          return;
        } else {
          resolve(stdout);
          return;
        }
      });
    });
  }
}

/*
 * Exposes method `exec` for when we want to mock executing `this.shellString`.
 */
class MgProcessInternal {
  get exec() {
    return Promise.resolve(`
.test_archive/m_archive.json:1:["hello","world"]
.test_archive/mg_archive.json:1:["hello","world"]
file.txt:34:Hello world
    `);
  }
}

module.exports = { MgProcess, MgProcessInternal }
