# MAlice Language Compiler - Report
Michal Srb, Harry Lachenmayer

## Introduction

In this report, we present the details of design and implemention of our MAlice compiler. We will present the specifics our compiler, techniques and
extensions to the basic specification. We shall start with the two decisions every compiler writer has to make.

### Language of implementation

Our original goal for the MAlice compiler was to create a portable, simply implemented compiler, with as few lines of code as possible and with the best possible support for error checking. We therefore chose CoffeeScript[link], a modern language which trans-compiles down to JavaScript. CoffeeScript is attractive for its natural mix of functional and object-oriented paradigms, which is nice fit for a compiler implementation, which can be expressed entirely in functional style, but imperative programming simplifies certain algorithms as well as input/output interaction.

Prior to developing our compiler, one of us has also implemented a top-down parser generation tool which uses CoffeeScript as its underlying language. This project has been called MetaCoffee[link] and we are using it widely across our implementation. Having our own parser-generation tool has led to a mostly positive experience. We were able to extend it to support some less usual features for top-down parsers (e.g. lexical tokens simulating traditional lexer). It was also easy to get information like position of matches, which is usually tricky to set up with popular tools. One of the most powerful features MetaCoffee takes from its original is the ability to pattern-match over arbitrary data structures (i.e. `anything`), which we used to traverse the AST and three-address code in similar fashion to Haskell[link] or ML[link].

We use Node.js[link] to run our compiler on all major OSs. We have used only a few 3rd party Node packages, mainly for CLI support.

### Target language

Originally, we considered LLVM intermediate-representation as our output language. This would be a perfect fit for our overall strategy, as LLVM would take care of portability and optimization for us.

At this point, our focus changed as we found out that we had to do at least some of register-level optimizations to fulfill the specification. After learning this, we decided to use Intel x86-64 assembly as our target language. We had prior experience with the Intel syntactical version of the assembly and we felt that making optimizations on top of LLVM would feel redundant. From a practical point of view, LLVM would be a much better choice thanks to its portability, but we felt we would benefit from dealing directly with a low-level representation. It might have also been the case that some more specialized implementation details, like implementing non-escaping closures (nested functions[http://en.wikipedia.org/wiki/Nested_function]), would be constrained.





We had initially considered using LLVM as output platform,
but as we could not rely on any of the optimizations that LLVM provides, we
decided that outputting Intel assembly would be a better choice. In addition,
we had previous experience writing Intel assembly code from our first year
Architecture and C courses.

The code generation stage is contained in the src/codegeneration.metacoffee
file. It performs pattern matching on the 3-address code structure generated
by the translation and register allocation stages. Every node in the input
structure is translated into a series of assembly instructions.

# Setbacks and pitfalls
not the best debugging from MetaCoffee

Because CoffeeScript is an imperative language, even in respect to defining functions, it is usually much easier to put top level code at the bottom of a source file. This is undesirable, as we much prefer top-down code which actually read top down. Working around this requires good care and in some instances it might complicate the code too much to keep the flow in reverse order.