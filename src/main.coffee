

# Module dependencies.

{readFile} = require 'fs'
program = require 'commander'
makeparser = require './makeparser'

# Setting commander

program
  .version('0.0.1')
  .parse(process.argv)

# Print out file contents

for file in program.args
  readFile file, 'utf8', (err, data) ->
    if (err)
      throw err
    makeparser (parser) ->
      syntaxTree = parser.parse data
      console.log syntaxTree
