const reset = '\x1b[0m'
const gold = '\x1b[38;5;136m'

export const formatLine = (line: any, index: number) => {
  if (!line.match) {
    return `  ${index + 1}\t${line.file}`
  }
  let match = ''
  let lastIndex = 0
  for (const {start, end} of line.submatches) {
    match += line.match.slice(lastIndex, start)
    match += gold + line.match.slice(start, end) + reset
    lastIndex = end
  }
  match += line.match.slice(lastIndex)

  return `  ${index + 1}\t${line.file}:${match}`
}
