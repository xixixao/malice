# Module dependencies.
fs         = require 'fs'
command    = require 'commander'
clc        = require 'cli-color'
{log}      = require './utils'

# Remove colors when not outputting to CLI
require './colorConsole'

# Command options
command
  .version('MAlice Compiler in CofeeScript and MetaCoffee, version 0.0.1')
  .usage('[options] <file ...>')
  .option('-t, --tree', 'print out syntax tree')
  .parse(process.argv)

# Compile files
metacoffee = require './loadMetaCoffee'
metacoffee (parser, semantics, staticoptimization, translation, codeGeneration, code3) ->
  for file in command.args
    try
      sourceCode = fs.readFileSync file, 'utf8'
    catch e
      console.error "File '#{file}' couldn't be loaded!"
    if sourceCode?
      console.log "\nCompiling file '#{clc.greenBright file}'\n"
      syntaxTree = parser.parse sourceCode
      if typeof syntaxTree isnt "string"
        syntaxTree = semantics.analyze sourceCode, syntaxTree
        #syntaxTree = staticoptimization.optimize sourceCode, syntaxTree
        syntaxTree = translation.translate sourceCode, syntaxTree
        if command.tree
          log syntaxTree
          console.log "\n"
        syntaxTree = code3.optimize syntaxTree
        if command.tree
          log syntaxTree
          console.log "\n"
      else
        console.error syntaxTree
