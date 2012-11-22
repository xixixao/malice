# Module dependencies.
fs = require 'fs'
metacoffee = require 'metacoffee'

module.exports = (callback) ->

  compile = (ometa, part) ->
    sourceStats = fs.statSync "src/#{part}.metacoffee"
    compiledStats = fs.statSync "src/#{part}.js"
    if (new Date sourceStats.mtime) > (new Date compiledStats.mtime)
      console.log "Compiling #{part}"
      partSource = fs.readFileSync "src/#{part}.metacoffee", "utf-8"
      compiled = ometa.compileSource partSource
      fs.writeFileSync "src/#{part}.js", compiled, "utf-8"
    compiledPart = require "./#{part}"
    return compiledPart ometa.OMeta, ometa.OMLib

  metacoffee (ometa) ->
    parser = compile ometa, 'parser'
    semantics = compile ometa, 'semantics'
    callback(parser, semantics)