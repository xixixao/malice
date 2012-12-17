# Unique name generator

module.exports = class Namer
  constructor: ->
    @_names = {}
    @_mangles = 0

  newTemporary: (name) ->
    origName = name
    while @_names[name]
      name = origName + Math.floor(Math.random() * 999 * Math.pow(10, Math.floor @_mangles / 500))
    @_names[name] = true
    @_mangles++
    name