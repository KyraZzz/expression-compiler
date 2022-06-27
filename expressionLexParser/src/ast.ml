(* syntax and semantics 
   e ::= 
    | i 
  
  bop ::= + | * | - | /

  i ::= <integers>
*)

type bop = 
  | Add
  | Minus
  | Mult
  | Div

type expr = 
  | Int of int
  | Binop of bop * expr * expr