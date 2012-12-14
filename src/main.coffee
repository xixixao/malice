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
  .option('-A, --threecode', 'print out the three address code')
  .option('-A2, --allocation', 'print out the three address code with allocated registers')
  .option('-S, --assembly', 'print out the generated assembly code')
  .option('-r, --run', 'print out a bash exec list for all files')
  .parse(process.argv)

# Compile files
metacoffee = require './loadMetaCoffee'
metacoffee (parser, semantics, staticoptimization, translation, codeGeneration, addressCodeOptimization) ->
  allCompiled = true
  for file in command.args

    # Load file
    try
      sourceCode = fs.readFileSync file, 'utf8'
    catch e
      console.error "File '#{file}' couldn't be loaded!"
      allCompiled = false

    # Parse file
    if sourceCode?
      console.error "\nCompiling file '#{clc.greenBright file}'\n"
      syntaxTree = parser.parse sourceCode
      if typeof syntaxTree is "string"
        console.error syntaxTree
        allCompiled = false
      else

        # Semantic analysis
        syntaxTree = semantics.analyze sourceCode, syntaxTree
        if not syntaxTree?
          allCompiled = false
        else
          if command.tree
            log syntaxTree
          #syntaxTree = staticoptimization.optimize sourceCode, syntaxTree

          # Translation to three-address code
          addressCode = translation.translate sourceCode, syntaxTree
          if command.threecode
            log addressCode
            continue

          # Optimization and register allocation
          addressCode = addressCodeOptimization.optimize addressCode
          if command.threecode
            log addressCode
            continue

          # Assembly generation
          assemblyCode = codeGeneration.generateCode addressCode
          if command.assembly
            console.log assemblyCode
            continue
          fileName = file.replace /([^.])\.[^\.]+$/, '$1'
          do (fileName) ->
            fs.writeFileSync "#{fileName}.s", assemblyCode
            exec "as #{fileName}.s -o #{fileName}.o", (error, stdout, stderr) ->
              console.log stdout
              console.error stderr
              if error
                console.error "as error: #{error}"
                return
              exec "gcc lib/utils.c #{fileName}.o -o #{fileName}", (error, stdout, stderr) ->
                console.log stdout
                console.error stderr
                if error
                  console.error "gcc error: #{error}"
                  return

          # Exec list generation
          if command.run
            exec "echo 'exec #{fileName}' >> exec-list"

