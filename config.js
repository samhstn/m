'use strict';

const path = require('path');
const NODE_ENV = process.env.NODE_ENV;

const MgProcesses = require('./lib/mg_process.js');

const archiveDir =
  NODE_ENV === 'test' ? 
  path.resolve(__dirname, '.test_archive') :
  path.resolve(__dirname, '.archive');

const MgProcess =
  NODE_ENV === 'test' ?
  MgProcesses.MgProcessInternal :
  MgProcesses.MgProcess

const config = {
  archiveDir: archiveDir,
  mArchiveFile: path.join(archiveDir, 'm_archive.json'),
  mgArchiveFile: path.join(archiveDir, 'mg_archive.json'),
  MgProcess: MgProcess
}

module.exports = config;
