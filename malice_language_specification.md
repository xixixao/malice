# MAlice Language Specification
Michal Srb, Harry Lachenmayer

## Overview

We are basing our specification on the provided example files. The examples are syntactically valid according to our specification, and the semantics we provide will produce the same errors and results.

## Language Overview


### Functions

MAlice is a language with single-level function definitions.

MAlice programs need to define a function named "hatta", which is the main entry point of execution.

### Types

MAlice is statically typed, currently with two types: "number" and "letter".

number is a 32-bit two's complement integer.
letter is an 8-bit ASCII code.

### Operations

Operations defined for numbers are:
  - addition
  - subtraction
  - multiplication
  - division
  - modulo
  - bitwise not
  - bitwise or
  - bitwise and
  - bitwise xor
These have familiar, C-like syntax.

Using a value of type "letter" with these operations results in a semantic error.

### Variables

Before variables can be used, they need to be declared with a specific type.

Once a variable is declared, it can not be redeclared in the same function scope. Doing so will result in a semantic error.

To use a variable, it needs to be initialised with an assignment. Otherwise a semantic error is produced. Note that incrementing/decrementing is a use of a variable.

## Syntax

function = "The looking-glass" name "()" body

body = "opened" statements "closed"

statements = statement*

statement = (declaration | assignment | saying) statementSeparator

statementSeparator = "too"? ("." | "," | "and" | "but" | "then")

declaration = name "was a" type

assignment = name ("became" expression | "drank" | "ate")

saying = expression "said Alice"

type = "number" | "letter"

expression = or

or = or "|" xor | xor
xor = xor "^" and | and
and = and "&" additive | additive

additive =  additive "+" multiplicative
         | additive "-" multiplicative
         | multiplicative

multiplicative = multiplicative "*" unary
               | multiplicative "/" unary
               | multiplicative "%" unary
               | unary

unary = "~" value | value

value = number | name | char

number = spaces digit+

name = letter (letter | '_')*

char = spaces '\'' letter '\''

// We are using these base rules

digit = [0-9]
letter = [a-zA-Z]
spaces = [ \t\n\r]*
