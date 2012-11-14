

# Module dependencies.

{readFileSync} = require 'fs'
program = require 'commander'
makeparser = require './makeparser'

# commander.js settings

program
  .version('0.0.1')
  .parse(process.argv)

# Compile files

makeparser (parser) ->
  for file in program.args
    program = readFileSync file, 'utf8'
    console.log 'Missing file #{file}' unless program?
    syntaxTree = parser.parse program
    console.log syntaxTree
