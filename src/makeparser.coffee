# Module dependencies.
{readFile, writeFile} = require 'fs'
metacoffee = require 'metacoffee'

module.exports = (callback) ->
  metacoffee (ometa) ->
    readFile "src/parser.metacoffee", "utf-8", (err, source) ->
      if (err)
        throw err
      
      debug = false
      if debug
        console.log "Compiling parser"
        console.log "---source---"
        console.log source
        console.log "---source---"

      [OMeta, OMLib, compiled] = ometa source

      if debug
        console.log "---result---"
        console.log compiled
        console.log "---result---"

      writeFile "src/parser.js", compiled, "utf-8", ->
        parser = require './parser'
        parser = parser OMeta, OMLib

        callback(parser)