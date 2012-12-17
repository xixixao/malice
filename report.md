# MAlice Language Compiler - Report
Michal Srb, Harry Lachenmayer

## Introduction

In this report, we present the details of design and implementation of our MAlice compiler. We will discuss the specifics our compiler, techniques and
extensions to the basic specification. We shall start with the two decisions every compiler writer has to make.

## Design Choices

### Language of implementation and tools

Our original goal for the MAlice compiler was to create a portable, simply implemented compiler, with as few lines of code as possible and with the best possible support for error checking. We therefore chose CoffeeScript[link], a modern language which trans-compiles down to JavaScript. CoffeeScript is attractive for its natural mix of functional and object-oriented paradigms. This is a nice fit for a compiler implementation, which can be expressed entirely in functional style, but imperative programming simplifies certain algorithms as well as input/output interaction.

Prior to developing our compiler, one of us has also implemented a top-down parser generation tool which uses CoffeeScript as its underlying language. This project has been called MetaCoffee[link] and we are using it widely across our implementation. Having our own parser-generation tool has led to a mostly positive experience. We were able to extend it to support some less usual features for top-down parsers (e.g. lexical tokens simulating traditional lexer). It was also easy to get information like position of matches, which is usually tricky to set up with popular tools. One of the most powerful features MetaCoffee takes from its original is the ability to pattern-match over arbitrary data structures (`anything`), which we used to traverse the AST and three-address code in similar fashion to Haskell[link] or ML[link].

The downside of using our own tool was mainly its level of polish. Especially at the beginning of the development, we had to fix some bugs in it. MetaCoffee also doesn't provide all the debugging options we would have liked to have (errors in its whitespace-significant syntax might turn out quite cryptic). This was in big part due to CoffeeScript's terrible error messages. Both of these technologies might evolve from these pitfalls over time (there is a new CoffeeScript compiler[link] which we haven't used).

We use Node.js[link] to run our compiler on all major OSs. We have used only a few 3rd party Node packages, mainly for CLI support.

### Target language

Originally, we considered LLVM intermediate-representation as our output language. This would be a perfect fit for our overall strategy, as LLVM would take care of portability and optimization for us.

At this point, our focus changed as we found out that we had to do at least some of register-level optimizations to fulfill the specification. After learning this, we decided to use Intel x86-64 assembly as our target language. We had prior experience with the Intel syntactical version of the assembly and we felt that making optimizations on top of LLVM would feel redundant. From a practical point of view, LLVM would be a much better choice thanks to its portability, but we felt we would benefit from dealing directly with a low-level representation. It might have also been the case that some more specialized implementation details, like implementing non-escaping closures (nested functions[http://en.wikipedia.org/wiki/Nested_function]), would be constrained by LLVM's higher-levelness (this was a strong argument against JVM bitcode as well).

Our familiarity with the instruction set did not turn out to provide much advantage. In the end, thanks to the scarcity of information on calling conventions and lack of resources on topics such as division, booleans and very much anything else we could have probably chosen LLVM IR or some other target language as well (and these might have simplified some features we had issues implementing). 

### Architecture

We designed our compiler to be separated into each phase of compilation. These phases process our data structures in a sequential fashion. Due to heavy use of pattern-matching, we based our AST and three-address code representations on simple data structures (arrays), possibly wrapped by a thin layer of getter-setter classes. This has the advantage of clear seperation of function, as we didn't have to bundle data and functionality together (as we probably would have to using tools for and languages like Java). This is a much more functional approach to processing data.

Each phase is specified by the type of data it operates on and produces:

- **parsing** takes user input and produces the syntax tree of the program
- **semantics** takes the AST, verifies it's semantics, ammend's it with additional typing and scoping information and performs simple optimization
- **translation** translates the typed AST into three-address code, performs advanced optimizations and register allocation
- **code generation** translates the three-address code with fixed registers into target assembly

Each of our data-structures is general enough to be reused for other source or target languages. Hence we could for example provide different code-generator to output 32-bit Intel assembly, ARM assembly, etc.

## The product

### Features

Originally, we were planning on including a parser with error recovery and better error messages. We even wrote a working prototype for MAlice from Milestone I specification, but in the end we shifted our focus to optimizations.

We took great care to provide well-formatted semantic error messages. The location information we got automatically from MetaCoffee was very useful in this. We are also performing constants evaluation inside expressions. This was greatly simplified by the expressive power of JavaScript with its *eval* function and by the similarity between MAlice and JavaScript expressions (even though this could have been easily done by hand). Evaluating constant expressions and having the information about whether particular statement or block return enabled us to perform removal of unreachable code inside conditionals, loops and following returning code. These are done during the semantics phase on the AST, before translation (some compilers behave similarly, e.g. gcc[link]). We included a warning message for loops with constant conditions leading to infinite repetition.

During the translation phase, after generating three-address code with temporary variable names, we perform complex data-flow analysis, including control-flow analysis and liveness analysis to determine an optimal register allocation. This is the most advanced part of our compiler, with full-blown algorithm including coalescing of move instructions and heuristics for spilling (these are each marked as Advanced Project in Appel[1]). We also implemented one of the data-flow analyses for dead-code elimination with refined liveness analysis, which give us a least fixed point for the results (see page 401 of Appel). We describe the whole algorithm in the extension section of this report.

The compiler is bundled with a fairly complex command-line interface, which lets us set the level of optimization, the type of output and at what stage the compiler should stop its work. We also made sure to visualize well the data structures we were working with, as reading them would be essential for debugging our code. Type `compile --help` to see the list of options.

### Implementation

There are couple specifics to our implementation of the MAlice language. Firstly, we used C libraries to read and write output. Our implementation of reading is very primitive and should be extended with a buffer to read arbitrarily large text. We have also used *malloc* to allocate textual input and arrays. We would use *free* to clean up memory when the program exited the declaring scope for dynamically allocated values, as current version of MAlice does not allow them to escape it. If this was not the case, we would have to provide a garbage collector.

One of the most interesting features of MAlice is its nested function declarations. We didn't want to use static links for implementing them, because we have used this technique for our C project extension (a TeaScript compiler) last year. We therefore looked at lambda lifting[link], as it was quoted as another technique (though with virtually no references). We discovered that lambda lifting makes most sense when applied to strictly functional programming languages. The technique consists of passing in escaping variables as arguments to the function. Since MAlice includes non-escaping closures (functions can change values inside variables from outer scopes), this was not ideal, as we would have to return the values when exiting the called function.

We have therefore gone with a solution combining the two traditional approaches. We push the escaping variables onto stack (unlike 64bit C calling convention, and like its 32 bit version, we pass parameters by pushing them onto the stack) and reference them as local variables / arguments inside the inner function. If the updated value is needed after the call, the caller pops it back to a register. This has the advantage of not having to lookup the variables in long chain of static links, but increases the cost of each call. The full analysis of these different solutions is beyond the scope of this project.

### Fulfilling requirements

Our parser successfully parses all MALice language features. The only difficulties we encountered were related to the fact that the reference compiler uses traditional lexer, which results in some unexpected constrains ('a' is not a valid variable name), which we had to force onto a much better (in our opinion) top-down parser. In a future this could be easily remedied by removing the keyword constraint from our *token* rule. This is also where using MetaCoffee meant the most sense and we would happily choose this path again.

Our semantic analyzer again performs as expected, providing nicely formatted error and warning messages. Going from implementing front-end to implementing the back-end of our compiler, we only had to add return values, the amended AST nodes, to our semantic actions. This was a good sign for our design. We designed our type checking to minimize code repetition, and therefore adding new types and language constructs would be trivial. We could have abstracted more our type system, by providing general sorts of types instead of the built-in numbers, letters etc., but as we didn't plan on extending the compiler in this way, this wasn't our priority.

We have gone well over the requirements in terms of optimization and this turned out to be a major pitfall. The main problem was that we didn't have a separate way of generating code when our complex register allocation wasn't working, and so to identify an error, we had to search across all of our modules. We did better with static optimizations (before translation), were we can easily switch them on and off with command parameters. This seems partially inherent, but we could have done a better job in making parts of the algorithm optional and had we had more time, we would have come up with dummy versions of each part (for example a naive graph coloring).

Overall, time management was our biggest issue, as following our original goals we produced the front-end to our compiler very quickly (also thanks to our parser generator tool), but taking on a complex register allocation algorithm resulted in much greater time needed to write the back-end. We would have really liked to have been able to follow are original goal, leaving low-level optimizations to LLVM and focusing possibly on extending the MAlice language and runtime (as this seems to us more applicable to real-life situations).

### Performance

We didn't allocate enough time to testing the performance of our compiler. Not all of our code is also most optimal, especially during register allocation we are doing a lot of iteration and array lookup (this could be improved using sets). Our choice of tools is obviously not tailored towards high-performing solutions, we would use a more low level language like C or C++ if this was an issue. The given examples compiled practically instantaneously.

## Beyond the Specification

Here we are going to describe our extension to the basic specification of the compiler and how we would further improve it. 

### Register allocation

### Dead-code elimination
After performing the initial build phase of register allocation including liveness analysis, we check for nodes in the control-flow graph which define values not used afterwards. These are *dead* and we can mark them for removal. We could just remove them and repeat the whole build process, but we went with a more efficient solution. We had to improve the control-flow analysis by not only marking each used variable, but also where the use is actually located in the graph. This way, we are able to remove the occurrences of the now *dead* uses from the graph and repeat only the liveness analysis (as described in lectures). We do this until there are no more removable nodes.










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