clc = require('cli-color');

# Formats syntactic and semantic errors, given the original source and
# error locations.

formatOmetaError =  (label, interpreter, position, message) ->
  format 
    label: label
    input: interpreter.input.lst
    position: position
    message: message

format = (data) ->
  {label, input, position, message, detail} = data
  output = clc.redBright label
  if position?
    computed = handle input, position
    [inputLine, arrow] = bottomErrorArrow '^', computed, computed.length
    output += " on line #{computed.lineNumber + 1}"
  output += clc.redBright ":\n"
  if position?
    output += "  #{inputLine}\n"
    output += "  #{clc.redBright arrow}\n"
  if message?
    output += "#{message}"
  if detail?
    computed = handle input, detail
    [inputLine, arrow] = bottomErrorArrow '-', computed, computed.length
    output += " on line #{computed.lineNumber + 1}" + clc.redBright ":\n"
    output += "  #{inputLine}\n"
    output += "  #{clc.blue arrow}\n"
  else
    output += "\n"
  return output + "\n"


stripWhiteBegin = (input, pos, length) ->
  while input[pos].match /\s/
    pos++
    length--
  [pos, length]

positionAt = (string, n, length) ->
  result = ""
  for i in [1...n] by 1
    result += " "
  result += string for i in [0...length]
  result

# +1 for the erased newline character
handle = (input, position) ->
  if Array.isArray position
    [position, length] = position
    length -= position
    [position, length] = stripWhiteBegin input, position, length
  lines = input.split('\n')
  currentPosition = position + 1
  for line, i in lines
    if currentPosition > line.length + 1
      currentPosition -= line.length + 1
    else
      break

  position: currentPosition
  length: length ? 1
  lineNumber: i
  line: line

bottomErrorArrow = (pointer, handledError, length) ->
  pos = handledError.position
  line = handledError.line
  lineLimit = 80
  offset = Math.max 0, pos - lineLimit
  arrow = positionAt pointer, pos - offset, Math.min length, line.length - 1
  [line[offset..offset + lineLimit], arrow]

module.exports =
  formatOmetaError: formatOmetaError
  format: format