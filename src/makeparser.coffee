# Module dependencies.
metacoffee = require 'metacoffee'
parser     = require './parser'
semantics  = require './semantics'

module.exports = (callback) ->

  # Load MetaCoffee dependencies
  metacoffee (ometa) ->
    parser = parser ometa.OMeta, ometa.OMLib
    semantics = semantics ometa.OMeta, ometa.OMLib
    callback(parser, semantics)