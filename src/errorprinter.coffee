clc = require('cli-color');

formatOmetaError =  (label, interpreter, position) ->
  format label: label, input: interpreter.input.lst, position: position

format = (data) ->
  {label, input, position, message} = data
  output = clc.redBright label
  if position?
    if position.length? # is an Array
      [position, length] = position
      length -= position
      [position, length] = stripWhiteBegin input, position, length
    computed = handle input, position
    [inputLine, arrow] = bottomErrorArrow computed, length ? 1
    output += " on line #{computed.lineNumber + 1}"
  output += clc.redBright ":\n"
  if position?
    output += "  #{inputLine}\n"
    output += "  #{clc.redBright arrow}\n"
  if message?
    output += "  #{message}\n"
  return output + "\n"

stripWhiteBegin = (input, pos, length) ->
  while input[pos].match /^\s/
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
  lines = input.split('\n')
  currentPosition = position + 1
  for line, i in lines
    if currentPosition > line.length + 1
      currentPosition -= line.length + 1
    else
      break

  position: currentPosition
  lineNumber: i
  line: line

bottomErrorArrow = (handledError, length) ->
  pos = handledError.position
  line = handledError.line
  lineLimit = 80
  offset = Math.max 0, pos - lineLimit
  [line[offset..offset + lineLimit], positionAt "^", pos - offset, length]

module.exports =
  formatOmetaError: formatOmetaError
  format: format