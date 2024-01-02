import { formatLine } from './utils.ts'

class Mg {
  static async run(args) {
    let regex = false
    let caseSensitive = false
    let filesOnly = false
    let sliceIndex = 0
    if (args[0].startsWith('-')) {
      sliceIndex = 1
      if (args[0].includes('E')) {
        regex = true
      }
      if (args[0].includes('c')) {
        caseSensitive = true
      }
      if (args[0].includes('l')) {
        filesOnly = true
      }
    }
    const command = new Deno.Command('rg', {
      args: [
        ...(regex ? [] : ['--fixed-strings', caseSensitive ? '--case-sensitive' : '--smart-case']),
        ...(filesOnly ? ['--files-with-matches'] : ['--json']),
        ...args.slice(sliceIndex)
      ]
    })
    const { stdout } = await command.output()
    const formattedStdout = new TextDecoder().decode(stdout).trim().split('\n').filter(l => l)
    let commandData
    if (filesOnly) {
      commandData = formattedStdout.map((file) => ({ file }))
    } else {
      commandData = 
        formattedStdout
          .map(line => JSON.parse(line))
          .filter(line => line.type === 'match')
          .map(({ data }) => {
            return {
              file: data.path.text,
              n: data.line_number,
              match: data.lines.text.replace(/\n$/, ''),
              submatches: data.submatches.map(s => ({ start: s.start, end: s.end }))
            }
          })
    }

    if (commandData.length === 0) {
      return [['No results']]
    }

    return [
      commandData.map(formatLine),
      commandData.map(line => {
        return {
          file: line.file,
          ...(
            line.n
              ? { n: line.n }
              : {}
          )
        }
      })
    ]
  }
}

export default Mg
