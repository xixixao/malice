dumper = require '../lib/jsDump'

module.exports =

  append: (xs...) ->
    xs[0] ?= []
    xs[0].push x... for x in xs[1..]
    xs[0]

  concat: (xs...) ->
    res = []
    res.push x... for x in xs
    res

  join: (xs) ->
    xs.join ''