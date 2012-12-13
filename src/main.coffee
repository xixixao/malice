# Module dependencies.
fs         = require 'fs'
{exec}     = require 'child_process'
command    = require 'commander'
clc        = require 'cli-color'
{log}      = require './utils'

# Remove colors when not outputting to CLI
require './colorConsole'

# Command options
command
  .version('MAlice Compiler in CofeeScript and MetaCoffee, version 0.0.1')
  .usage('[options] <file ...>')
  .option('-t, --tree', 'print out the syntax tree')
  .option('-S, --assembly', 'print out the generated assembly code')
  .parse(process.argv)

logAll = (error, stdout, stderr) ->
  console.log stdout
  console.error stderr
  if error
    console.error "error: #{error}"

# Compile files
metacoffee = require './loadMetaCoffee'
metacoffee (parser, semantics, staticoptimization, translation, codeGeneration, code3) ->
  for file in command.args
    try
      sourceCode = fs.readFileSync file, 'utf8'
    catch e
      console.error "File '#{file}' couldn't be loaded!"
    if sourceCode?
      console.error "\nCompiling file '#{clc.greenBright file}'\n"
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
          return
        code = codeGeneration.generateCode syntaxTree
        if command.assembly
          console.log code
          console.log "\n"
          return
        fs.writeFileSync 'out.s', code
        exec 'as out.s -o out.o', logAll
        exec 'gcc out.o -o out', logAll
      else
        console.error syntaxTree
