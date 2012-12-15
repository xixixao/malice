{concat, join} = require './metaCoffeeUtils'
{log} = require './utils'

module.exports = optimize = (procedures, optimizers) ->

  for optimizer in optimizers
    for procedure, i in procedures
      procedures[i] = optimizer.optimize procedure

  concat procedures...

