
# Module dependencies.
fs         = require 'fs'
path       = require 'path'
{exec}     = require 'child_process'
command    = require 'commander'
clc        = require 'cli-color'
{log}      = require './utils'

# Command options
command._name = 'compile'
command
  .version('MAlice Compiler in CofeeScript and MetaCoffee, version 0.0.1')
  .usage('[options] <file ...>')
  .option('-t, --tree', 'print out the syntax tree')
  .option('-A, --threecode', 'print out the three address code')
  .option('-B, --allocation', 'print out the three address code with allocated registers')
  .option('-S, --assembly', 'print out the generated assembly code')
  .option('-O, --optim <level>', "set the level of optimization, higher include lower\n
                         <0> none\n
                         <1> constant expression evaluation\n
                         <2> unreachable code removal\n
                         <3> dead-code removal (default)", parseInt, 3)
  .option('-e, --extension <ext>', 'set an extension for the executable')
  .option('    --color', 'always output colors')

command.on '--help', ->
  console.log '  Examples:'
  console.log ''
  console.log '    $ compile example.alice -t O 0'
  console.log '    $ compile example.alice -e .exe'
  console.log ''
  console.log "  Note that the optimization level MIGHT affect the behavior of " +
                "your program, if the optimized parts would cause a runtime error."
  console.log ''

command.parse process.argv

command.extension ?= ""

# Remove colors when not outputting to CLI
require('./colorConsole')(command.color)

# Compile files
metacoffee = require './loadMetaCoffee'
optimizeWith = require './translation/optimization'
metacoffee (parser,
            semantics, constantEvalution, unreachableRemoval,
            translation, dataFlowAnalysis,
            codeGeneration) ->

  options = ['tree', 'threecode', 'allocation', 'assembly', 'run']
  lastStage = option for option in options when command[option]

  for file in command.args

    # Load file
    try
      sourceCode = fs.readFileSync file, 'utf8'
    catch e
      console.error "File '#{clc.redBright file}' couldn't be loaded!"
      continue

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
          if command.optim >= 1
            syntaxTree = constantEvalution.optimize sourceCode, syntaxTree
          if command.optim >= 2
            syntaxTree = unreachableRemoval.optimize sourceCode, syntaxTree
          if command.tree
            log syntaxTree
            continue if lastStage is 'tree'

          # Translation to three-address code
          addressCode = translation.translate sourceCode, syntaxTree
          if command.threecode
            log addressCode
            continue if lastStage is 'threecode'

          # Optimization and register allocation
          addressCode = optimizeWith addressCode, [dataFlowAnalysis], command.optim
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
                console.error "'as' error: #{error}"
                return
              build = "gcc lib/utils.c #{fileName}.o -o #{fileName}#{command.extension}"
              exec build, (error, stdout, stderr) ->
                console.log stdout
                console.error stderr
                if error
                  console.error "'gcc' error: #{error}"
                  return

