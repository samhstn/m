'use strict';

const Mg = require('./mg.js');
const childProcess = require('child_process');

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
        }

        resolve(stdout);
      });
    });
  }
}

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
