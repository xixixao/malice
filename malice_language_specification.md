# MAlice Language Specification
Michal Srb, Harry Lachenmayer


## Preface

We are basing our specification on the provided example files. The examples are syntactically valid according to our specification, and the semantics we provide will produce the same errors and results.


## Language Overview

Here we introduce key concepts of the MAlice programming language including examples which ilustrate its basic syntax. Note that MAlice syntax is strictly case-sensitive.

### Functions

MAlice is a language with single-level function definitions.

MAlice programs need to define a function named *hatta*, which is the main entry point of execution.

The body of a function, the list of statements to be executed, is enclosed between the *opened* and *closed* keywords:

    The looking-glass hatta () 
    opened
      6 said Alice.  
    closed
    
    # Outputs 6
   

### Types

MAlice is statically and strongly typed, with two types: **number** and **letter**.

- **number** is represented as a 32-bit two's complement integer.
- **letter** is represented as an 8-bit ASCII code.

### Variables

Before variables can be used, they need to be declared with a specific type. Once a variable is declared, it cannot be redeclared in the same function scope and it can only be assigned a value of that type.

To use a value stored in a variable, it needs to be initialised with an assignment. Note that incrementing/decrementing is a use of the variable's value.

Variable names consist of letters (lower or upper case) and underscores.
In this example, *x* and *y* are variables, *3* is a literal value and *number* is a type:

    The looking-glass hatta ()
    opened
      x became 3. # Semantic Error - Assignment to an undeclared variable 'x'.
      y was a number.      
      y drunk. # Semantic Error - Invalid use of a varible, 'y' wasn't initialized. 
      y became 'a'. # Semantic Error - Assignment to 'y' of value with wrong type 'letter'
      y was a number. # Semantic Error - 'y' was already declared.
    closed

Note that `# comments` are not part of MAlice syntax.

Variable values are stored on the stack (or in registers) and their relative position in memory is determined at compiletime.

### Expressions

Expressions are used to manipulate values. They are computed at runtime and result in a typed value.    

Expressions can be one of:

- literal value (number or a character)
- variable name - evaluates to the value stored in the variable at the time of evaluation
- operation

Example of simple expressions:

    x became 7.
    y became 'a'.
    z became x.

### Operations

Operations take one or two expressions as arguments and return a new value.

There is no limit to the nesting of operations.

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

These have familiar, [C](http://en.wikipedia.org/wiki/C_%28programming_language%29 "the C language")-like syntax and semantics (including precedence and associativity and the modulo behavior).

    3 ^ ~5 + 16 said Alice.

Using a value of type **letter** with these operations results in a semantic error.

    3 + 'a' said Alice. # Semantic Error - Type clash using operator '+' with 
                        # values of types 'number' and 'letter'.

### Statements

Statements in MAlice are separated by one of the statement endings (`.`, `,`, `and`, `but`, `then`) and they can be either variable declarations, assignements or a special print statement:

`someExpression said Alice`

which outputs the value of *someExpressions*.

## Formal Syntax

This the MAlice syntax specified in a PEG style (similar to [PEG.js](http://pegjs.majda.cz/documentation#grammar-syntax-and-semantics-parsing-expression-types "PEG.js syntax")).

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
    value          = number | character | name
    number         = spaces digit+
    name           = spaces letter (letter | '_')*
    character      = spaces '\'' letter '\''

Strings inside double quotes are matched using a parametrized token rule, which matches any number of spaces preceding a list of given characters
    
    token(value) ~ spaces value

We are using some predefined base rules

    digit = [0-9]
    letter = [a-zA-Z]
    spaces = [ \t\n\r]*

More on [PEG](https://github.com/PhilippeSigaud/Pegged/wiki/Peg-basics "PEG basics") and [OMeta](http://www.tinlizzie.org/ometa-js/#Things_You_Should_Know "Alex Warth's OMeta") (the parser generator we will use in our MAlice compiler, with some enhancements).