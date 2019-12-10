'use strict';

const test = require('tape');
const Mg = require('../../lib/mg.js');

test('Mg :: single word', (t) => {
  t.equal(new Mg(['pattern']).shellString, "git grep --untracked --ignore-case 'pattern' | cat -n");
  t.end();
});

test('Mg :: smartcase', (t) => {
  t.equal(new Mg(['Pattern']).shellString, "git grep --untracked 'Pattern' | cat -n");
  t.end();
});

test('Mg :: -c case sensitive', (t) => {
  t.equal(new Mg(['-c', 'pattern']).shellString, "git grep --untracked 'pattern' | cat -n");
  t.end();
});

test('Mg :: -h suppress files', (t) => {
  t.equal(new Mg(['-h', 'pattern']).shellString, "git grep --untracked -h --ignore-case 'pattern' | cat -n");
  t.end();
});

test('Mg :: -hc case suppress and suppress files', (t) => {
  t.equal(new Mg(['-hc', 'pattern']).shellString, "git grep --untracked -h 'pattern' | cat -n");
  t.end();
});

test('Mg :: -l only file names', (t) => {
  t.equal(new Mg(['-l', 'pattern']).shellString, "git grep --untracked -l --ignore-case 'pattern' | cat -n");
  t.end();
});

test('Mg :: -v exclude_pattern', (t) => {
  t.equal(new Mg(['pattern', '-v', 'exclude_pattern']).shellString, "git grep --untracked --ignore-case 'pattern' | grep -Ev exclude_pattern | cat -n")
  t.equal(new Mg(['-c', 'pattern', '-v', 'exclude_pattern']).shellString, "git grep --untracked 'pattern' | grep -Ev exclude_pattern | cat -n")
  t.equal(new Mg(['-c', 'pattern', '-v', 'one', 'two']).shellString, "git grep --untracked 'pattern' | grep -Ev (one|two) | cat -n")
  t.end();
});

test('Mg :: -E works with regex', (t) => {
  t.equal(new Mg(['-E', 'pattern']).shellString, "git grep --untracked -E --ignore-case 'pattern' | cat -n");
  t.end()
});

test('Mg :: works with multiple words', (t) => {
  t.equal(new Mg(['one two three']).shellString, "git grep --untracked --ignore-case 'one two three' | cat -n");
  t.end();
});

test('Mg :: handles directories', (t) => {
  t.equal(new Mg(['pattern', 'dir1/dir2']).shellString, "git grep --untracked --ignore-case 'pattern' -- dir1/dir2 | cat -n");
  t.equal(new Mg(['-c', 'pattern', 'dir1/dir2']).shellString, "git grep --untracked 'pattern' -- dir1/dir2 | cat -n");
  t.equal(new Mg(['pattern', 'dir1/dir2', '-v', 'exclude_pattern']).shellString, "git grep --untracked --ignore-case 'pattern' -- dir1/dir2 | grep -Ev exclude_pattern | cat -n");
  t.equal(new Mg(['-c', 'pattern', 'dir1/dir2', '-v', 'exclude_pattern']).shellString, "git grep --untracked 'pattern' -- dir1/dir2 | grep -Ev exclude_pattern | cat -n");
  t.end();
});

test('Mg :: without numbers', (t) => {
  t.equal(new Mg(['-n', 'pattern']).shellString, "git grep --untracked --ignore-case 'pattern'");
  t.end();
});

test('Mg :: with {archive: true}', (t) => {
  t.equal(new Mg(['pattern'], {archive: true}).shellString, "git grep --untracked --ignore-case -n 'pattern'");
  t.end();
});
