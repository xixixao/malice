clcTrim    = require 'cli-color/lib/trim'
tty        = require 'tty'

# Removes coloring when the output is redirected

module.exports = (alwaysColor) ->
  unless alwaysColor
    builtinError = console.error
    console.error = (input...) ->
      if tty.isatty process.stderr.fd
        builtinError input...
      else
        builtinError clcTrim input...

    builtinLog = console.log
    console.log = (input...) ->
      if tty.isatty process.stdout.fd
        builtinLog input...
      else
        builtinLog clcTrim input...