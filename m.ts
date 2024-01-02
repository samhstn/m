import Archive from './lib/archive.ts'
import Mg from './lib/mg.ts'
import Mf from './lib/mf.ts'
import Mo from './lib/mo.ts'

const [head, ...tail] = Deno.args
let output = '', archive = []

switch (head) {
  case 'm':
    await Archive.write('mr', tail)
    console.log(tail.join(' '))
    break
  case 'mg':
    [output, archive] = await Mg.run(tail)
    await Archive.write('mo', archive)
    console.log(output.join('\n'))
    break
  case 'mf':
    [output, archive] = await Mf.run(tail)
    await Archive.write('mo', archive)
    console.log(output.join('\n'))
    break
  case 'mo':
    archive = await Archive.read('mo');
    [output, archive] = await Mo.run(tail, archive)
    await Archive.write('mr', archive)
    console.log(output)
    break
  case 'mr':
    archive = await Archive.read('mr')
    console.log(archive.join(' '))
    break
  default:
    console.log('unknown!')
}
