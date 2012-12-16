errorHandle = require '../errorHandle'

# Prints and counts errors
module.exports = class ErrorPrinter
  #
  # Used for highlighting the location of an error, returns a position or undefined
  #
  #   where: Identifier with a position or position in the form [begin, end] or undefined
  #
  locate = (where) ->
    where?.position?() ? where

  #
  # Print a nicely formatted error using the error handler
  #
  #   message:           The error message to print
  #   where [optional]:  Location as per `locate`
  #   detail [optional]: Location as per `locate`
  #
  _printError: (label, message, where, detail) ->
    console.error errorHandle.format
      label: label
      input: @source
      position: locate where
      message: message
      detail: locate detail

  # Initialize errorCount to 0
  constructor: (@source) ->
    @_errorCount = 0

  # Prints a semantic error
  error: (message, where, detail) ->
    @_printError "Semantic error", message, where, detail
    @_errorCount++

  # Prints a semantic warning
  warning: (message, where, detail) ->
    @_printError "Semantic warning", message, where, detail

  hasError: ->
    @_errorCount > 0