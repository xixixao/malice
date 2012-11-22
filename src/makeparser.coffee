# Module dependencies.
{readFileSync, writeFileSync} = require 'fs'
metacoffee = require 'metacoffee'

module.exports = (callback) ->

  compile = (ometa, part) ->
    console.log "Compiling #{part}"

    partSource = readFileSync "src/#{part}.metacoffee", "utf-8"

    [OMeta, OMLib, compiled] = ometa partSource

    writeFileSync "src/#{part}.js", compiled, "utf-8"

    compiledPart = require "./#{part}"
    return compiledPart OMeta, OMLib

  metacoffee (ometa) ->
    parser = compile ometa, 'parser'
    semantics = compile ometa, 'semantics'
    callback(parser, semantics)