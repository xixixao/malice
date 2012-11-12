# Module dependencies.

fs = require 'fs'
program = require 'commander'


program
  .version('0.0.1')
  .parse(process.argv)

filename = program.args[0]

fs.readFile filename, 'utf8', (err, data) ->
  if (err)
    throw err
  console.log data
