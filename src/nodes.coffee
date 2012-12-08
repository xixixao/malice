class ObjectifiedArray
  constructor: ->
    node =  Array.apply (new Array), arguments
    return node

  @wrap = (node, methods) ->
    for name, index of methods
      do (index) ->
        node[name] = (value) ->
          if value?
            @[index] = value
            this
          else
            @[index]
    node

  @with: (methods) ->
    superClass = this
    class extends superClass
      constructor: ->
        return superClass.wrap super, methods


# Node is [node, position, ...]
Node = ObjectifiedArray.with position: 1

# Executes is [node, position, returns, ...]
Executes = Node.with doesReturn: 2

# Value is [node, position, type, ...]
Value = Node.with type:2

# Reference is [node, position, type, name, ...]
Reference = Value.with name:3

# FunctionNode is [node, position, type, name, returnType, args, ...]
FunctionNode = Reference.with returnType: 4, args: 5

# Types
# -----

# Type is [node, position, ...]
class Type extends Node
  constructor: ->
    node = Node.wrap super, label: 2
    node.isDynamic = true
    node.equals = Type::equals
    node.equalsAny = Type::equalsAny
    return node
  equals: (t) ->
    @label() is t.label() or t.isError
  equalsAny: (ts) ->
    ts.some (t) ->
      @equals t
    , this

# SimpleType is [node, position, label, ...]
class SimpleType extends Type
  constructor: (values...)->
    values.unshift 'Type'
    node = Node.wrap super(values...), toString: 2
    return node

class FunctionType extends Type
  constructor: ->
    node = super 'FunctionType', undefined, "function"
    node.isDynamic = no
    return node

# ArrayType is [node, position, itemType, ...]
class ArrayType extends Type
  constructor: (values...) ->
    values.unshift 'ArrayType'
    node = Node.wrap super(values...), itemType: 2
    node.isArray = yes
    node.isDynamic = no
    node.equals = ArrayType::equals
    node.toString = -> "spider #{@itemType()}"
    return node
  equals: (t) ->
    t.isArray and @itemType().equals t.itemType()

class ErrorType extends Type
  constructor: ->
    @isError = yes
    @isDynamic = yes
  equals: (t) ->
    yes
  toString: ->
    "error"

types =
  number: new SimpleType undefined, "number"
  letter: new SimpleType undefined, "letter"
  sentence: new SimpleType undefined, "sentence"
  boolean: new SimpleType undefined, "boolean"
  function: new FunctionType
  void: new SimpleType undefined, "void"
  error: new ErrorType

module.exports = {Node, Executes, Value, Reference, FunctionNode, SimpleType, FunctionType, ArrayType, ErrorType, types}