# MAlice Language Specification
Michal Srb, Harry Lachenmayer


## Preface

We are basing our specification on the provided example files. The examples are syntactically valid according to our specification, and the semantics we provide will produce the same errors and results.



## Syntax

This the MAlice syntax specified in a PEG style (similar to PEG.js: [pegjs.majda.cz/documentation](http://pegjs.majda.cz/documentation#grammar-syntax-and-semantics-parsing-expression-types "PEG.js syntax")).

The syntax is very permissive and does not check for natural language grammar rules (like the correct use of `.`s and `,`s). Arbitrary whitespace is allowed between terms and in many places not required (`x was anumber` is valid).

    program        = "The looking-glass hatta ()" body
    body           = "opened" statements "closed"
    statements     = statement*
    statement      = (declaration | assignment | saying) terminator
    terminator     = "too"? ("." | "," | "and" | "but" | "then")
    declaration    = variable "was a" type
    assignment     = variable ("became" expression | "drank" | "ate")
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
    value          = number | character | variable
    number         = spaces digit+
    character      = spaces '\'' letter '\''
    variable       = spaces letter (letter | '_')*    

Strings inside double quotes are matched using a parametrized token rule, which matches any number of spaces preceding a list of given characters
    
`"`string`"` ~ `spaces` string

We are using some predefined base rules

    digit = [0-9]
    letter = [a-zA-Z]
    spaces = [ \t\n\r]*

More on PEG: [https://github.com/PhilippeSigaud/Pegged/wiki/Peg-basics](https://github.com/PhilippeSigaud/Pegged/wiki/Peg-basics "PEG basics") and OMeta: [http://www.tinlizzie.org/ometa-js/#Things_You_Should_Know](http://www.tinlizzie.org/ometa-js/#Things_You_Should_Know "Alex Warth's OMeta") (the parser generator we will use, with some enhancements, in our MAlice compiler).

## Semantics

Here we present the language constructs of the MAlice programming language. Note that MAlice syntax and semantics are strictly case-sensitive.

### Program

MAlice programs consist of a list of statements. Statements can change the state of the program and produce output. They are executed in a top down order (from first statement following the `opened` keyword to the last before `closed` keyword).

### Statements

Statements can be either **variable declarations**, **assignments** or **outputting statement**:

**expression** ` said Alice`

which outputs the value of the expression.

### Types

Variables in MAlice need to have a declared type. MAlice is statically and strongly typed, with two types: **number** and **letter**.

- **number** is represented as a 32-bit two's complement integer.
- **letter** is represented as an 8-bit ASCII code.

### Variables

Before variables can be used, they need to be declared with a specific type. Once a variable is declared, it cannot be redeclared in the same function scope and it can only be assigned a value of that type.

To use a value stored in a variable, it needs to be initialised with an assignment. Note that incrementing/decrementing is a use of the variable's value.

    The looking-glass hatta ()
    opened
      x became 3. # Semantic Error - Assignment to an undeclared variable 'x'.
      y was a number.      
      y drunk. # Semantic Error - Invalid use of a varible, 'y' wasn't initialized. 
      y became 'a'. # Semantic Error - Invalid type of value in assignment, 
                    # variable 'y' is of type 'number', value is of type 'letter'
      y was a number. # Semantic Error - 'y' was already declared.
    closed

Note that `# comments` are not part of MAlice syntax.

### Expressions

Expressions are used to compute new values. They are computed at runtime and result in a typed value.

Expressions can be either **literal value** (number or a character), **variable name** which evaluates to the value stored in the variable at runtime or **operation**

### Operations

Operations take one or two **expressions** as arguments and result in a new value.

Operations defined for **number**s are, in order of precedence: *bitwise not*, *multiplication*, *division*, *modulo*, *addition*, *subtraction*, *bitwise and*, *bitwise xor*, *bitwise or*

These have familiar, [C](http://en.wikipedia.org/wiki/C_%28programming_language%29 "the C language")-like syntax and semantics (including precedence and associativity and the modulo behavior). All the binary operations are left-associative and modulo returns negative reminder when divisor is negative.

Using a value of type **letter** with these operations results in a semantic error.

    3 + 'a' said Alice. # Semantic Error - Type clash using operator '+' with 
                        # values of types 'number' and 'letter'.


## Implementation details

There is no limit to the nesting of operations.

Variable values are stored in registers (or in registers) and their relative position in memory is determined at compiletime.