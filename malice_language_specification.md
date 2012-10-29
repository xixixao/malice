# MAlice Language Specification
Michal Srb, Harry Lachenmayer

## Overview

## Syntax

function = "The looking-glass" name "()" body

body = "opened" statements "closed"

statements = statement*

statement = (declaration | assignment | saying) statementSeparator

statementSeparator = "." | "," | "and" | "but"

declaration = name "was a" type

assignment = name ("became" expression | "drank" | "ate")

saying = expression "said Alice"

type = "number" | "letter"

name = letter (letter | '_')*

expression = or

or = xor | or '|' xor
xor = and | xor '^' and
and = additive | and '&' additive

additive = multiplicative | additive '+' multiplicative
                          | additive '-' multiplicative

multiplicative = unary | multiplicative '*' unary
                       | multiplicative '/' unary
                       | multiplicative '%' unary

unary = value | '~' value

value = number | name

