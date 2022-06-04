(* initial recursive functions *)
type expr =
	|INT of int |PLUS of expr * expr |SUBT of expr * expr |MULT of expr * expr

(* eval: expr -> int *)
(* a simple recursive evaluator for expressions *)
let rec eval = function
	|INT a -> a
	|PLUS (e1, e2) -> (eval e1) + (eval e2)
	|SUBT (e1, e2) -> (eval e1) - (eval e2)
	|MULT (e1, e2) -> (eval e1) * (eval e2)