# Module dependencies.
metacoffee = require 'metacoffee'
parser     = require './parser'
semantics  = require './semantics'
staticopt  = require './staticoptimization'
translate  = require './translation'

module.exports = (callback) ->

  # Load MetaCoffee dependencies
  metacoffee (ometa) ->
    parser = parser ometa.OMeta, ometa.OMLib
    semantics = semantics ometa.OMeta, ometa.OMLib
    staticopt = staticopt ometa.OMeta, ometa.OMLib
    translate = translate ometa.OMeta, ometa.OMLib
    callback(parser, semantics, staticopt, translate)