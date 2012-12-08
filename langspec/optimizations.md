# Optimize

## Static

- elimination of constant expressions (e.g. 2+3 can be replaced by 5 )
- elimination of unreachable code (e.g. if-then when always false)
- elimination of statements with empty blocks (e.g. empty if-then block)

- elimination of redundant conditions ?
- elimination of redundant function calls ?

- inlining of functions ??

## Control-flow:

- loop unrolling
- optimise tail recursion
- data-flow analysis: live ranges (discussed in lectures)
- register allocation optimisations (discussed in lectures)

# Static static optimizations
expr * (2^x)
(2^x) * expr
expr / (2^x)

# Static non-static optimizations
!! expr
-- expr
~~ expr

not (not ex and ex)
(ex or not ex)

(not ex or not ex)
not (ex and ex)

# Implemented above reference
warning: static check for uninitialized variables (probably not)
