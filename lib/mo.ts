class Mo {
  static run(args, archive) {
    if (args[0]) {
      const n = parseInt(args[0])
      const res = archive[n - 1]
      if (!res) {
        throw 'No results'
      }
      let strs
      if (res.n === undefined) {
        strs = [res.file]
      } else {
        strs = [`+${res.n}`, res.file]
      }
      return [strs.join(' '), strs]
    } else {
      const files = [...new Set(archive.map(({ file }) => file))]
      return [files.join(' '), files]
    }
  }
}

export default Mo
