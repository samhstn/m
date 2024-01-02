const fullFile = (f) => `${Deno.env.get('HOME')}/.m-archive/${f}.json`

class Archive {
  static async write(archive, contents) {
    if (!['mr', 'mo'].includes(archive)) {
      throw `unknown archive: ${archive}`
    }
    if (contents) {
      await Deno.writeTextFile(fullFile(archive), JSON.stringify(contents))
    }
  }

  static async read(archive) {
    if (!['mr', 'mo'].includes(archive)) {
      throw `unknown archive: ${archive}`
    }
    const contentsStr = await Deno.readTextFile(fullFile(archive))
    return JSON.parse(contentsStr)
  }
}

export default Archive
