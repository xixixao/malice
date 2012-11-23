clcTrim    = require 'cli-color/lib/trim'
tty        = require 'tty'

builtinError = console.error
console.error = (message) ->
  if tty.isatty process.stderr.fd
    builtinError message
  else
    builtinError clcTrim message

builtinLog = console.log
console.log = (message) ->
  if tty.isatty process.stdout.fd
    builtinLog message
  else
    builtinLog clcTrim message