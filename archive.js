#!/usr/bin/env node

const args = process.argv.slice(2, process.argv.length);
const { MArchive, MgArchive } = require('./lib/archive.js');

if (args[0] === 'm') {
  if (args[1] === 'put') {
    MArchive.put(args.slice(2, args.length));
    return;
  } else if (args[1] === 'get' && args.length === 2) {
    MArchive.get();
    return;
  } else {
    throw 'unknown args passed to ./archive.js m';
  }
} else if (args[0] === 'mg') {
  if (args[1] === 'put') {
    MgArchive.put(args.slice(2, args.length));
    return;
  } else if (args[1] === 'get' && args.length === 3) {
    if (args[2] === 'all') {
      MgArchive.get('all');
      return;
    } else {
      MgArchive.get(args[2]);
      return;
    }
  } else {
    throw 'unknown args passed to ./archive.js mg';
  }
} else {
  throw 'unknown first arg passed to ./archive.js';
}
