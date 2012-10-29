# MAlice Language Specification
Michal Srb, Harry Lachenmayer


## Preface

We are basing our specification on the provided example files. The examples are syntactically valid according to our specification, and the semantics we provide will produce the same errors and results.


## Language Semantics

Here we introduce key concepts of the MAlice language including examples.

### Functions

MAlice is a language with single-level function definitions.

MAlice programs need to define a function named "hatta", which is the main entry point of execution.

    The looking-glass hatta () 
    opened
      6 said Alice.  
    closed
    
    # Outputs 6
   

### Types

MAlice is statically typed, with two types: **number** and **letter**.

- **number** is represented as a 32-bit two's complement integer.
- **letter** is represented as an 8-bit ASCII code.

### Operations

Operations take one or two arguments (either literal values or variable names) and return a new value.

Operations defined for **number**s are:

  - addition
  - subtraction
  - multiplication
  - division
  - modulo
  - bitwise not
  - bitwise or
  - bitwise and
  - bitwise xor

These have familiar, C-like syntax and semantics (including precedence and associativity).

    3 ^ ~5 + 16 said Alice.

Using a value of type **letter** with these operations results in a semantic error.

    3 + 'a' said Alice. # Semantic Error - Type clash using operator '+' with 
                        # values of types 'number' and 'letter'.

### Variables

Before variables can be used, they need to be declared with a specific type.

Once a variable is declared, it can not be redeclared in the same function scope.

To use a variable, it needs to be initialised with an assignment. Note that incrementing/decrementing is a use of a variable.

    The looking-glass hatta ()
    opened
      x became 3. # Semantic Error - Assignment to an undeclared variable 'x'.
      y was a number.
      y drunk. # Semantic Error - Invalid use of a varible, 'y' wasn't initialized. 
      y was a number. # Semantic Error - 'y' was already declared.
    closed


## Syntax

This the MAlice syntax specified in a PEG style.

The syntax is very permissive and does not check for natural language grammar rules (like the correct use of `.`s and `,`s). Arbitrary whitespace is allowed between terms and in many places not required (`x was anumber` is valid).

    function       = "The looking-glass" name "()" body
    body           = "opened" statements "closed"
    statements     = statement*
    statement      = (declaration | assignment | saying) terminator
    terminator     = "too"? ("." | "," | "and" | "but" | "then")
    declaration    = name "was a" type
    assignment     = name ("became" expression | "drank" | "ate")
    saying         = expression "said Alice"
    type           = "number" 
                   | "letter"
    expression     = or
    or             = or "|" xor
                   | xor
    xor            = xor "^" and 
                   | and
    and            = and "&" additive 
                   | additive
    additive       = additive "+" multiplicative
                   | additive "-" multiplicative
                   | multiplicative
    multiplicative = multiplicative "*" unary
                   | multiplicative "/" unary
                   | multiplicative "%" unary
                   | unary
    unary          = "~" value
                   | value
    value          = number | char | name
    number         = spaces digit+
    name           = spaces letter (letter | '_')*
    char           = spaces '\'' letter '\''

Strings inside double quotes are matched using the parametrized token rule
    
    token :value = spaces value

We are using some predefined base rules

    digit = [0-9]
    letter = [a-zA-Z]
    spaces = [ \t\n\r]*
