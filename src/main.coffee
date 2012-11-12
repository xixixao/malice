

# Module dependencies.

{readFile} = require 'fs'
program = require 'commander'
makeparser = require './makeparser'

# Setting commander

program
  .version('0.0.1')
  .parse(process.argv)

# Getting the file name

filename = program.args[0]

# Print out file contents

readFile filename, 'utf8', (err, data) ->
  if (err)
    throw err
  makeparser (parser) ->
    syntaxTree = parser.parse data
    console.log syntaxTree