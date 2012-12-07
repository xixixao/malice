# Module dependencies.
fs         = require 'fs'
program    = require 'commander'
clc        = require 'cli-color'
{log}      = require './utils'

# Remove colors when not outputting to CLI
require './colorConsole'

# Command options
program
  .version('MAlice Compiler in CofeeScript and MetaCoffee, version 0.0.1')
  .usage('[options] <file ...>')
  .option('-t, --tree', 'print out syntax tree')
  .parse(process.argv)

# Compile files
metacoffee = require './loadMetaCoffee'
metacoffee (parser, semantics) ->
  for file in program.args
    try
      sourceCode = fs.readFileSync file, 'utf8'
    catch e
      console.error "File '#{file}' couldn't be loaded!"
    if sourceCode?
      console.log "\nCompiling file '#{clc.greenBright file}'\n"
      syntaxTree = parser.parse sourceCode
      if typeof syntaxTree isnt "string"
        syntaxTree = semantics.analyze sourceCode, syntaxTree
        if program.tree
          log syntaxTree
          console.log "\n"
      else
        console.error syntaxTree