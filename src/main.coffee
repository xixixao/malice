# Module dependencies.
fs         = require 'fs'
command    = require 'commander'
clc        = require 'cli-color'
{log}      = require './utils'

# Remove colors when not outputting to CLI
require './colorConsole'

# Command options
command
  .version('MAlice Compiler in CoffeeScript and MetaCoffee, version 0.0.1')
  .usage('[options] <file ...>')
  .option('-t, --tree', 'print out syntax tree')
  .option('-S, --assembly', 'print out the generated assembly code')
  .parse(process.argv)

# Compile files
metacoffee = require './loadMetaCoffee'
metacoffee (parser, semantics, staticoptimization, translation, codeGeneration) ->
  for file in command.args
    try
      sourceCode = fs.readFileSync file, 'utf8'
    catch e
      console.error "File '#{file}' couldn't be loaded!"
    if sourceCode?
      unless command.tree or command.assembly
        console.log "\nCompiling file '#{clc.greenBright file}'\n"
      syntaxTree = parser.parse sourceCode
      if typeof syntaxTree isnt "string"
        syntaxTree = semantics.analyze sourceCode, syntaxTree
        #syntaxTree = staticoptimization.optimize sourceCode, syntaxTree
        #if command.tree
        #  log syntaxTree
        #  console.log "\n"
        syntaxTree = translation.translate sourceCode, syntaxTree
        if command.tree
          log syntaxTree
          console.log "\n"
        code = codeGeneration.generateCode syntaxTree
        if command.assembly
          console.log code
          console.log "\n"
      else
        console.error syntaxTree
