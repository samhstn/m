'use strict';

const test = require('tape');
const fsPromises = require('fs').promises;

const { mArchiveFile, mgArchiveFile } = require('../../config.js');
const { MArchive, MgArchive } = require('../../lib/archive.js');

async function removeFileIfExists(file) {
  try {
    await fsPromises.unlink(file);
  } catch (_e) {}
}

test('MArchive.put :: writes to $M_ARCHIVE_DIR/m_archive.json', async (t) => {
  await removeFileIfExists(mArchiveFile);

  await MArchive.put(['hello', 'world']);

  const archive = await fsPromises.readFile(mArchiveFile);

  t.deepEqual(JSON.parse(archive), ['hello', 'world']);
  t.end();
});

test('MArchive.get :: reads from $M_ARCHIVE_DIR/m_archive.json', async (t) => {
  await fsPromises.writeFile(mArchiveFile, JSON.stringify(['hello', 'world']));

  MArchive.get((archive) => {
    t.equal(archive, 'hello world');
    t.end();
  });
});

test('MgArchive.put :: writes to $M_ARCHIVE_DIR/mg_archive.json with childProcess.exec output', async (t) => {
  await removeFileIfExists(mgArchiveFile);

  await MgArchive.put(['hello'])

  const archive = await fsPromises.readFile(mgArchiveFile);
  const actual = JSON.parse(archive);

  const expected = [
    {
      file: '.test_archive/m_archive.json',
      line: '1'
    },
    {
      file: '.test_archive/mg_archive.json',
      line: '1'
    },
    {
      file: 'file.txt',
      line: '34'
    }
  ];

  t.deepEqual(actual, expected);
  t.end();
});

test('MgArchive.get :: gets from $M_ARCHIVE_DIR/mg_archive.json', async (t) => {
  let actual, expected;
  const json = [
    {
      file: '.test_archive/m_archive.json',
      line: '1'
    },
    {
      file: '.test_archive/m_archive.json',
      line: '5'
    },
    {
      file: '.test_archive/mg_archive.json',
      line: '1'
    },
    {
      file: 'file.txt',
      line: '34'
    }
  ];

  await fsPromises.writeFile(mgArchiveFile, JSON.stringify(json));

  MgArchive.get('all', (actual) => {
    expected = '.test_archive/m_archive.json .test_archive/mg_archive.json file.txt';

    t.equal(actual, expected);

    MgArchive.get('2', (actual) => {
      expected = '.test_archive/m_archive.json +5';

      t.equal(actual, expected);

      t.end();
    });
  });
});
