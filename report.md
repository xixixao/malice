# MAlice Milestone 3
Michal Srb, Harry Lachenmayer

We chose to use Intel x86-64 assembly as output language for the code
generation stage. We had initially looked at using LLVM as output platform,
but as we could not rely on any of the optimizations that LLVM provides, we
decided that outputting Intel assembly would be a better choice. In addition,
we had previous experience writing Intel assembly code from our first year
Architecture and C courses.

The code generation stage is contained in the src/codegeneration.metacoffee
file. It performs pattern matching on the 3-address code structure generated
by the translation and register allocation stages. Every node in the input
structure is translated into a series of assembly instructions.
