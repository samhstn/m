#!/usr/bin/env node

const args = process.argv.slice(2, process.argv.length);
const { MArchive, MgArchive } = require('./lib/archive.js');

if (args[0] === 'm') {
  if (args[1] === 'put') {
    MArchive.put(args.slice(2, args.length));
    return;
  }

  if (args[1] === 'get' && args.length === 2) {
    MArchive.get();
    return;
  }

  throw 'unknown args passed to ./archive.js m';
}

if (args[0] === 'mg') {
  if (args[1] === 'put') {
    MgArchive.put(args.slice(2, args.length));
    return;
  }

  if (args[1] === 'get' && args.length === 3) {
    if (args[2] === 'all') {
      MgArchive.get('all');
    } else {
      MgArchive.get(args[2]);
    }
    return;
  }

  throw 'unknown args passed to ./archive.js mg';
}

throw 'unknown first arg passed to ./archive.js';
