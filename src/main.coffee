
# Module dependencies.
fs         = require 'fs'
path       = require 'path'
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
  .option('-B, --allocation', 'print out the three address code with allocated registers')
  .option('-S, --assembly', 'print out the generated assembly code')
  .option('-r, --run', 'print out a bash exec list for all files')
  .parse(process.argv)

# Compile files
metacoffee = require './loadMetaCoffee'
optimizeWith = require './implementation/optimization'
metacoffee (parser, semantics, staticOptimization, translation, dataFlowAnalysis, codeGeneration) ->

  options = ['tree', 'threecode', 'allocation', 'assembly', 'run']
  lastStage = option for option in options when command[option]

  for file in command.args

    # Load file
    try
      sourceCode = fs.readFileSync file, 'utf8'
    catch e
      console.error "File '#{file}' couldn't be loaded!"

    # Parse file
    if sourceCode?
      console.error "\nCompiling file '#{clc.greenBright file}'\n"
      syntaxTree = parser.parse sourceCode
      if typeof syntaxTree is "string"
        console.error syntaxTree
        continue
      else

        # Semantic analysis
        syntaxTree = semantics.analyze sourceCode, syntaxTree
        if not syntaxTree?
          continue
        else
          syntaxTree = staticOptimization.optimize sourceCode, syntaxTree
          if command.tree
            log syntaxTree
            continue if lastStage is 'tree'

          # Translation to three-address code
          addressCode = translation.translate sourceCode, syntaxTree
          if command.threecode
            log addressCode
            continue if lastStage is 'threecode'

          # Optimization and register allocation
          addressCode = optimizeWith addressCode, [dataFlowAnalysis]
          if command.allocation
            log addressCode
            continue if lastStage is 'allocation'

          # Assembly generation
          assemblyCode = codeGeneration.generateCode addressCode
          if command.assembly
            console.log assemblyCode
            continue if lastStage is 'assembly'
          fileName = file.replace new RegExp("#{path.extname file}$"), ''
          fileName = "out"
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

