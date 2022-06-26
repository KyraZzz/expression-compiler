(* syntax and semantics 
   e ::= 
      x 
    | i 
    | b 
    | e1 op e2 
    | if e1 then e2 else e3
    | let x = e1 in e2
  
  bop ::= + | * | <=

  x ::= <identifiers>

  i ::= <integers>

  b ::= true | false
*)

type bop = 
  | Add
  | Mult
  | Leq

type expr = 
  | Var of string
  | Int of int
  | Bool of bool
  | Binop of bop * expr * expr
  | Let of string * expr * expr
  | If of expr * expr * expr