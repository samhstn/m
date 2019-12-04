'use strict';

class Mg {
  constructor(args, ops = {archive: false}) {
    this._getPattern = this._getPattern.bind(this);
    this._haveFlags = this._haveFlags.bind(this);
    this._flagChars = this._flagChars.bind(this);
    this._caseSensitive = this._caseSensitive.bind(this);
    this._excludePattern = this._excludePattern.bind(this);
    this._directory = this._directory.bind(this)

    this.pattern = this._getPattern(args);
    this.caseSensitive = this._caseSensitive(args);
    this.flagChars = this._flagChars(args);
    this.excludePattern = this._excludePattern(args);
    this.directory = this._directory(args);
    this.archive = ops.archive;
  }
  _getPattern(args) {
    return this._haveFlags(args) ? args[1] : args[0];
  }
  _haveFlags(args) {
    return args[0].startsWith('-');
  }
  _flagChars(args) {
    if (this._haveFlags(args)) {
      return args[0].split('-')[1].split('');
    }
  }
  _caseSensitive(args) {
    const { _haveFlags, _flagChars, pattern } = this;
    const hasCFlag = _haveFlags(args) && _flagChars(args).includes('c');

    return hasCFlag || pattern !== pattern.toLowerCase();
  }
  _excludePattern(args) {
    if (args.includes('-v')) {
      const vArgs = args.slice(args.indexOf('-v') + 1, args.length);

      return vArgs.length === 1 ?  vArgs[0] : `(${vArgs.join('|')})`;
    }
  }
  _directory(args) {
    if (this._haveFlags(args)) {
      if (args.length === 3 || args[3] === '-v') {
        return args[2];
      }
    } else {
      if (args.length === 2 || args[2] === '-v') {
        return args[1];
      }
    }
  }
  get shellString() {
    const { pattern, flagChars, caseSensitive, directory, excludePattern, archive } = this;
    const flags = ['--untracked'];

    if (flagChars) {
      flagChars.forEach((flagChar) => {
        if (['h', 'l', 'E'].includes(flagChar)) {
          flags.push(`-${flagChar}`);
        }
      });
    }

    if (!caseSensitive) {
      flags.push('--ignore-case');
    }

    if (archive) {
      flags.push('-n');
    }

    const dirString = directory ? ` -- ${directory}` : '';
    const excludePatternString = excludePattern ? ` | grep -Ev ${excludePattern}` : '';
    const withNumbersString = archive || (flagChars && flagChars.includes('n')) ? '' : ' | cat -n';

    return `git grep ${flags.join(' ')} ${pattern}${dirString}${excludePatternString}${withNumbersString}`;
  }
}

module.exports = Mg;
