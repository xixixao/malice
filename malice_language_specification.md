# MAlice Language Specification
Michal Srb, Harry Lachenmayer

## Overview

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
