import { assertEquals } from 'https://deno.land/std@0.210.0/assert/mod.ts'
import { formatLine } from '../lib/utils.ts'

Deno.test('formatLine', () => {
  const input = [
    {
      file: "m.zsh",
      n: 23,
      match: "    mo opens in vim all of the last files returned from mg",
      submatches: [ { start: 28, end: 30 } ]
    },
    {
      file: "m.zsh",
      n: 24,
      match: "    mo n (where n is an integer) opens in vim the nth mg match",
      submatches: [ { start: 11, end: 13 }, { start: 47, end: 49 } ]
    }
  ]
  const expected = [
    '  1\tm.zsh:    mo opens in vim all of t\x1b[38;5;136mhe\x1b[0m last files returned from mg',
    '  2\tm.zsh:    mo n (w\x1b[38;5;136mhe\x1b[0mre n is an integer) opens in vim t\x1b[38;5;136mhe\x1b[0m nth mg match',
  ]
  assertEquals(input.map(formatLine), expected)
});
