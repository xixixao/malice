# Statements

## Variable declaration and assignment

Variables need to be declared before they can be used. The statement for variable declarations is:

    name "was a" type ["of" value].

(An initial value can be specified by using the "of" keyword.)

To assign a value to a (previously declared) variable, the following statement can be used:

    name "became" value.

## Functions

There are two different types of functions, "looking-glass" and "room".

A looking-glass is a void function, it has no specified return type.

    "The looking-glass" name "(" args ")"
    opened
      statements
    closed

A room is a function which always returns a value. All paths in the function must return a value, otherwise an error will be thrown.

    "The room" name "(" args ") contained a" return type
    opened
      statements
    closed

A value is returned from a room with the following statement:

    "Alice found" value.

## Looping

Loops are defined as follows:

    "eventually (" expression ") because"
      statements
    "enough times"

This will execute the loop body until the expression becomes true. Note that this is the opposite behaviour to a C-style "while" loop.

## Conditionals

Conditionals have "perhaps", "or maybe" and "or" branches, which correspond respectively to the "if", "else if" and "else" branches in conventional programming languages. The "or maybe" and "or" branches are optional. There can be several "or maybe" branches, but only one "perhaps" or "or" branch, respectively.

    "perhaps (" expression ") so"
      statements
    "or maybe (" expression ") so"
      statements
    "or"
      statements
    "because Alice was unsure which."

## Input/Output

The following two statement print the given value to the standard output. They are functionally equivalent.

    value "spoke"
    value "said Alice"

The following statement reads a value from the standard input:

    "what was" value "?"

# Arrays

Arrays in MAlice have a fixed size. The declaration syntax for arrays is different to simple values, as the size and type of elements needs to be specified.

    name "had" size type.

To access the i'th element of an array

name's i piece
