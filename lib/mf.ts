class Mf {
  static async run(args) {
    const command = new Deno.Command('fd', { args })
    const { stdout } = await command.output()
    const formattedStdout = new TextDecoder().decode(stdout).trim().split('\n').filter(l => l)
    if (formattedStdout.length === 0) {
      return [['No results']]
    }
    return [
      formattedStdout.map((line, index) => `  ${index + 1}\t${line}`),
      formattedStdout
    ]
  }
}

export default Mf
