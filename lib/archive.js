'use strict';

const fsPromises = require('fs').promises;

const NODE_ENV = process.env.NODE_ENV;
const { mArchiveFile, mgArchiveFile, MgProcess } = require('../config.js');

class MArchive {
  static put(args) {
    return fsPromises.writeFile(mArchiveFile, JSON.stringify(args));
  }

  static async get(logFunc = console.log) {
    const archive = await fsPromises.readFile(mArchiveFile);

    logFunc(JSON.parse(archive).join(' '));
  }
}

class MgArchive {
  static stringify(archive) {
    return JSON.stringify(archive.trim().split('\n').map((line) => {
      return { file: line.split(':')[0], line: line.split(':')[1] };
    }));
  }

  static put(args) {
    return new Promise(async (resolve, reject) => {
      try {
        const archive = await new MgProcess(args).exec;

        await fsPromises.writeFile(mgArchiveFile, this.stringify(archive))

        resolve();
      } catch (err) {
        reject(err);
      }
    });
  }

  static async get(getString, logFunc = console.log) {
    const fileString = await fsPromises.readFile(mgArchiveFile);
    const fileJson = JSON.parse(fileString);

    if (getString === 'all') {
      logFunc(
        fileJson
        .map((line) => line.file)
        .filter((file, i, a) => a.indexOf(file) === i)
        .join(' ')
      );

      return;
    } else if (readString.match(/^\d+$/)) {
      const n = parseInt(readString) - 1;

      if (!fileJson[n]) {
        throw 'Unknown number in mg archive';
      }

      logFunc([fileJson[n].file, `+${fileJson[n].line}`].join(' '));
    }
  }
}

module.exports = { MArchive, MgArchive }
