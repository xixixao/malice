This assignment is no longer used at Imperial, so I decided to publish our solution. It's a compiler for made up language called MAlice (see langspec/malice_milestone2_spec.md), which compiles given plaintext source code into x86 assembly. I wish we were allowed to compile down to LLVM, but this would prevent us to handroll some of the assembly optimizations (think register allocation).

This is an example of how [MetaCoffee](https://github.com/xixixao/meta-coffee/) and/or [CoffeeScript](http://coffeescript.org) can be used to write a full-blown down-to-assembly compiler.

# MAlice Milestone 2

## Overview

Main file is                           `src/main.coffee`,
parser (includes lexing) is defined in `src/parser.metacoffee`,
semantic analyser is defined in        `src/semantics.metacoffee`.

We are using the top-down parser generator tool called MetaCoffee
(https://github.com/xixixao/meta-coffee/ - I am still working on full
documentation) similar to PEG.js (https://github.com/dmajda/pegjs) for both
parsing of the input MAlice code and traversing the AST.

## File Structure

    Makefile
      - Invoke build by running `make`
    compile
      - Launch script, executes src/main.js with Node.js
    src/
      main.coffee
        - Main entry point of the compiler / CLI
      parser.metacoffee
        - Grammar definitions and AST generation
      semantics.metacoffee
        - Semantic analysis / error checking
      loadMetaCoffee.coffee
        - Initializes parser and semantics with MetaCoffee base
      colorConsole.coffee
        - Removes colors from console output if redirected
      errorprinter.coffee
        - Pretty printer for compile-time errors
    lib/
    node_modules/
    bin/
      - stores JavaScript files built by make

