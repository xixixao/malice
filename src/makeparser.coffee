# Module dependencies.
{readFile, writeFile} = require 'fs'
metacoffee = require 'metacoffee'

metacoffee (ometa) ->
  readFile "src/parser.metacoffee", "utf-8", (err, source) ->
    if (err)
      throw err

    console.log "Compiling"
    console.log "---source---"
    console.log source
    console.log "---source---"

    compiled = ometa source

    console.log "---result---"
    console.log compiled
    console.log "---result---"

    writeFile "src/parser.js", compiled, "utf-8", ->
      parser = require './parser'

      console.log parser.parse "Hello world"
      ###

  console.log metacoffee