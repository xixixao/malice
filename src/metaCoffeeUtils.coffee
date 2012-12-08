dumper = require '../lib/jsDump'

module.exports =

  concat: (xs...) ->
    xs[0] ?= []
    xs[0].push x... for x in xs[1..]
    xs[0]

  join: (xs) ->
    xs.join ''