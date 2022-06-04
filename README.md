# expression-compiler
Compiler construction intro tutorial - build a simple expression compiler

## Lex-ing

## Parsing
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
E' -> +TE' | -TE'
T -> FT'
T' -> *FT'
F -> NUM
F -> (E)
```

3. Eliminated left-recursion and add a new start production, calculate FIRST and FOLLOW set

```
S -> E$ (* $ represents the end of the string *)
E -> TE'
E' -> +TE' | -TE'
T -> FT'
T' -> *FT'
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
T -> FT'           null             {NUM,(}         {NUM,(}          {NUM,(}
T' -> *FT'         {*}              {*}             {*}              {*}
F -> NUM           {NUM}            {NUM}           {NUM}            {NUM}
F -> (E)           {(}              {(}             {(}              {(}

Non-terminals
S                  null             null            null             {NUM,(}
E                  null             null            {NUM,(}          {NUM,(}
E'                 {+,-}            {+,-}           {+,-}            {+,-}
T                  null             {NUM,(}         {NUM,(}          {NUM,(}
T'                 {*}              {*}             {*}              {*}
F                  {NUM,(}          {NUM,(}         {NUM,(}          {NUM,(}
```

- Calculate FOLLOW set:
```
       Production       Constraints
        S -> E$          (1) {$} $\subseteq$ 
        E -> TE'         
        E' -> +TE'       
        E' -> -TE'       
        T -> FT'         
        T' -> *FT'       
        F -> NUM         
        F -> (E)          

```

## From high-level interpreter to low-level compiler
