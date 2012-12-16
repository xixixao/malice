# Module dependencies.
metacoffee = require 'metacoffee'
parser     = require './parse/parser'
semantics  = require './semantics/semantics'
staticopt  = require './semantics/staticoptimization'
translate  = require './implementation/translation'
dataflow   = require './implementation/dataflow'
codegen    = require './assembly/codegeneration'

module.exports = (callback) ->

  # Load MetaCoffee dependencies
  metacoffee (ometa) ->
    base = ometa.OMeta
    lib  = ometa.OMLib
    parser    = parser    base, lib
    semantics = semantics base, lib
    staticopt = staticopt base, lib
    translate = translate base, lib
    codegen   = codegen   base, lib
    dataflow  = dataflow  base, lib
    callback(parser, semantics, staticopt, translate, dataflow, codegen)
