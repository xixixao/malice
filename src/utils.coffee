dumper     = require '../lib/jsDump'
clc        = require 'cli-color'

colorize = (js) ->
  js = js.replace /(\[\w+? ?\w+?\])/g, clc.red '$1' # <[Function]> or <[object]> etc.
  js = js.replace /'((\\'|.)*?)'/g, clc.green '$1' # <'some text'>
  js = js.replace /"((\\"|.)*?)"/g, clc.green '$1' # <"some text">
  js = js.replace /(true|false|undefined|null)/g, clc.yellow '$1' # keywords

module.exports =
  log: (xs...) ->
    console.log (xs.map (x) -> colorize dumper.parse x).join ","
