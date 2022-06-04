(* from a high-level stack machine to a compiler + a stack machine *)
type expr =
	|INT of int |PLUS of expr * expr |SUBT of expr * expr |MULT of expr * expr
type directive = 
  | E of expr
  | DO_PLUS
  | DO_SUBT
  | DO_MULT

let step = function
  | (E(INT v) :: ds, vs) -> (ds, v :: vs)
  | (E(PLUS(e1, e2)) :: ds, vs) -> ((E e1) :: (E e2) :: DO_PLUS :: ds, vs)
  | (E(SUBT(e1, e2)) :: ds, vs) -> ((E e1) :: (E e2) :: DO_SUBT :: ds, vs)
  | (E(MULT(e1, e2)) :: ds, vs) -> ((E e1) :: (E e2) :: DO_MULT :: ds, vs)
  | (DO_PLUS :: ds, v2 :: v1 :: vs) -> (ds, (v1 + v2) :: vs)
  | (DO_SUBT :: ds, v2 :: v1 :: vs) -> (ds, (v1 - v2) :: vs)
  | (DO_MULT :: ds, v2 :: v1 :: vs) -> (ds, (v1 * v2) :: vs)
  | _ -> failwith "step: run time error."

let rec driver = function
  | ([], [v]) -> v
  | state -> driver (step state)

let eval e = driver ([E(e)], [])

type instr = 
  | IPUSH of int
  | IPLUS
  | ISUBT
  | IMULT

let rec compile = function
  | INT a -> [IPUSH (a)]
  | PLUS (e1,e2) -> (compile e1) @ (compile e2) @ [IPLUS]
  | SUBT (e1, e2) -> (compile e1) @ (compile e2) @ [ISUBT]
  | MULT (e1, e2) -> (compile e1) @ (compile e2) @ [IMULT]

let step2 = function
  |(IPUSH v :: is, vs) -> (is, v :: vs)
  |(IPLUS :: is, v2 :: v1 :: vs) -> (is, (v1 + v2) :: vs)
  |(ISUBT :: is, v2 :: v1 :: vs) -> (is, (v1 - v2) :: vs)
  |(IMULT :: is, v2 :: v1 :: vs) -> (is, (v1 * v2) :: vs)
  |_ -> failwith "step2: run time error."

let rec driver2 = function
  | ([], [v]) -> ([], v)
  | state -> driver2 (step2 state)