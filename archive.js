#!/usr/bin/env node

const args = process.argv.slice(2, process.argv.length);
const { MArchive, MgArchive } = require('./lib/archive.js');

if (args[0] === 'm') {
  if (args[1] === 'write') {
    MArchive.writeJson(args.slice(2, args.length));
    return;
  } else if (args[1] === 'read' && args.length === 2) {
    MArchive.readJson();
    return;
  } else {
    throw 'unknown args passed to ./archive.js m';
  }
} else if (args[0] === 'mg') {
  if (args[1] === 'write') {
    MgArchive.writeJson(args.slice(2, args.length))
      .catch((_err) => {});
    return;
  } else if (args[1] === 'read' && args.length === 3) {
    if (args[2] === 'all') {
      MgArchive.readJson('all');
      return;
    } else {
      MgArchive.readJson(args[2]);
      return;
    }
  } else {
    throw 'unknown args passed to ./archive.js mg';
  }
} else {
  throw 'unknown first arg passed to ./archive.js';
}
