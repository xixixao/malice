{concat, join} = require './../metaCoffeeUtils'
{log} = require './../utils'

module.exports = optimize = (procedures, optimizers, level) ->

  namer = procedures.namer
  for optimizer in optimizers
    for procedure, i in procedures
      procedures[i] = optimizer.optimize procedure, namer, level

  concat procedures...

