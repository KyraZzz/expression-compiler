# expression-compiler
Compiler construction intro tutorial - build a simple expression compiler

## Lex-ing

## Parsing

### LL(1)
```
E -> E + E
E -> E - E
E -> E * E
E -> NUM
E -> (E)
```
1. Ambiguous CFG, causes problems when try to go from program texts to derivation tree because of semantic ambiguity.
   - e.g., parse 17 + 3 * 4

```
E -> E + T (* T must have a higher or equal precedence as E *)
E -> E - T 
E -> T
T -> T * F (* F must have a higher or equal precedence as T *)
T -> F
F -> NUM
F -> (E)
```

2. Unique derivation tree but left-recursion

```
E -> TE'
E' -> +TE' | -TE' | ε
T -> FT'
T' -> *FT' | ε
F -> NUM
F -> (E)
```

3. Eliminated left-recursion and add a new start production, calculate FIRST and FOLLOW set

```
S -> E$ (* $ represents the end of the string *)
E -> TE'
E' -> +TE' | -TE'| ε
T -> FT'
T' -> *FT'| ε
F -> NUM
F -> (E)
```
- Calculate FIRST set:

```
Production       Iteration 1      Iteration 2      Iteration 3     Iteration 4
S -> E$            null             null            null             {NUM,(}
E -> TE'           null             null            {NUM,(}          {NUM,(}
E' -> +TE'         {+}              {+}             {+}              {+}
E' -> -TE'         {-}              {-}             {-}              {-}
E' -> ε            null             null            null             null
T -> FT'           null             {NUM,(}         {NUM,(}          {NUM,(}
T' -> *FT'         {*}              {*}             {*}              {*}
T' -> ε            null             null            null             null
F -> NUM           {NUM}            {NUM}           {NUM}            {NUM}
F -> (E)           {(}              {(}             {(}              {(}

Non-terminals
S                  null             null            null             {NUM,(}
E                  null             null            {NUM,(}          {NUM,(}
E'                 {+,-}            {+,-}           {+,-}            {+,-}
T                  null             {NUM,(}         {NUM,(}          {NUM,(}
T'                 {*}              {*}             {*}              {*}
F                  {NUM,(}          {NUM,(}         {NUM,(}          {NUM,(}

=> we get
FIRST(S) = {NUM,(}      NULLABLE(S) = False
FIRST(E) = {NUM,(}      NULLABLE(E) = False
FIRST(E') = {+,-}       NULLABLE(E') = True
FIRST(T) = {NUM,(}      NULLABLE(T) = False
FIRST(T') = {*}         NULLABLE(T') = True
FIRST(F) = {NUM,(}      NULLABLE(F) = False
```

- Calculate FOLLOW set:
```
Production       Constraints
S -> E$          {$} ⊆ FOLLOW(E), FOLLOW(S) ⊆ FOLLOW(E)
E -> TE'         FOLLOW(E) ⊆ FOLLOW(E')
E' -> +TE'       FOLLOW(E') ⊆ FOLLOW(E'), FOLLOW(E') ⊆ FOLLOW(T)
E' -> -TE'       FOLLOW(E') ⊆ FOLLOW(E'), FOLLOW(E') ⊆ FOLLOW(T)
E' -> ε
T -> FT'         FOLLOW(T) ⊆ FOLLOW(T'), FOLLOW(T) ⊆ FOLLOW(F)
T' -> *FT'       FOLLOW(T') ⊆ FOLLOW(T'), FOLLOW(T) ⊆ FOLLOW(F)
T' -> ε
F -> NUM         
F -> (E)         {)} ⊆ FOLLOW(E)

=> we get
FOLLOW(S) = {}
FOLLOW(E) = {),$}
FOLLOW(E') = {),$}
FOLLOW(T) = {),$}
FOLLOW(T') = {),$}
FOLLOW(F) = {),$}
```

4. Encode in a table or recursive-descent program
- Table: the production N -> a is in the table at (N,c) if c ∈ FIRST(a) or (NULLABLE(a) ⋀ c ∈ FOLLOW(N))

```
As a reference, the FIRST set and FOLLOW set (also the NULLABLE set):
FIRST(S) = {NUM,(}      NULLABLE(S) = False      FOLLOW(S) = {}
FIRST(E) = {NUM,(}      NULLABLE(E) = False      FOLLOW(E) = {),$}
FIRST(E') = {+,-}       NULLABLE(E') = True      FOLLOW(E') = {),$}
FIRST(T) = {NUM,(}      NULLABLE(T) = False      FOLLOW(T) = {),$}
FIRST(T') = {*}         NULLABLE(T') = True      FOLLOW(T') = {),$}
FIRST(F) = {NUM,(}      NULLABLE(F) = False      FOLLOW(F) = {),$}

The productions:
S -> E$         
E -> TE'        
E' -> +TE' 
E' -> -TE'    
E' -> ε
T -> FT'   
T' -> *FT'     
T' -> ε
F -> NUM         
F -> (E)   

Nt\t      +          -          *           NUM        (         )        $
S                                          S->E$     S->E$                         
E                                          E->TE'    E->TE'
E'      E'->+TE'   E'->-TE'                                     E'->ε   E'->ε
T                                          T->FT'    T->FT'
T'                            T'->*FT'                          T'->ε   T'->ε   
F                                          F->NUM    F->(E)

```

### SLR

1. List LR(0) items

```
Given the set of production rules
S -> E$         
E -> TE'        
E' -> +TE' 
E' -> -TE'    
E' -> ε
T -> FT'   
T' -> *FT'     
T' -> ε
F -> NUM         
F -> (E)

List all LR(0) items
(?)
```

2. Construct a DFA
3. Construct an Action & Goto table

## From high-level interpreter to low-level compiler
