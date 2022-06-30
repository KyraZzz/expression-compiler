(* syntax and semantics 
   e ::= 
      x 
    | i 
    | b 
    | e1 op e2 
    | if e1 then e2 else e3
    | let x = e1 in e2
    
    | skip
    | e1; e2
    | while e1 do e2

    | fn x => e
    | e1 [e2]
    | let rec x = (fn y => e1) in e2
  
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
  | Skip (* e ::= skip *)
  | Seq of expr * expr (* e ::= e1; e2 *)
  | While of expr * expr (* e ::=  while e1 do e2 *)
  | Func of string * expr (* e ::= fn x => e *)
  | App of expr * expr (* e ::= e1 e2 *)
  | LetRec of string * expr * expr (* e ::= let rec x = (fn y => e1) in e2 *)