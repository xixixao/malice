# Module dependencies.

fs         = require 'fs'
program    = require 'commander'
makeparser = require './makeparser'
dumper     = require './jsDump'
clc        = require 'cli-color'
require './colorConsole'
dump = (data) -> console.log dumper.parse data

# commander.js settings

program
  .version('MAlice Compiler in CofeeScript and MetaCoffee, version 0.0.1')
  .usage('[options] <file ...>')
  .option('-t, --tree', 'print out syntax tree')
  .parse(process.argv)

# Compile files

makeparser (parser, semantics) ->
  for file in program.args
    try
      sourceCode = fs.readFileSync file, 'utf8'
    catch e
      console.error "File '#{file}' couldn't be loaded!"
    if sourceCode?
      console.log "\nCompiling file '#{clc.greenBright file}'\n\n"
      syntaxTree = parser.parse sourceCode
      if typeof syntaxTree isnt "string"
        if program.tree
          dump syntaxTree
          console.log "\n"
        semantics.analyze sourceCode, syntaxTree
      else
        console.error syntaxTree

