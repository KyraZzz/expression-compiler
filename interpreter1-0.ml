(* interpreter1-0 - turn recursive functions into tail recursion with CPS,
    then DFC to transform a high-level tail recursion into a first-order function *)
(* 1. CPS *)
type expr =
	|INT of int |PLUS of expr * expr |SUBT of expr * expr |MULT of expr * expr
let rec eval_cps (expr, cnt ) =
  match expr with
  | INT a -> cnt a
  | PLUS (e1,e2) -> eval_cps(e1, fun a -> eval_cps(e2, fun b -> cnt(a + b)))
  | SUBT (e1,e2) -> eval_cps(e1, fun a -> eval_cps(e2, fun b -> cnt(a - b)))
  | MULT (e1,e2) -> eval_cps(e1, fun a -> eval_cps(e2, fun b -> cnt(a * b)))
let eval' e = eval_cps(e, fun x -> x)

(* 2. DFN *)
type funs = 
  | ID
  | OPLUS of expr * funs
  | IPLUS of int * funs
  | OSUBT of expr * funs
  | ISUBT of int * funs
  | OMULT of expr * funs
  | IMULT of int * funs
let rec eval_cps_dfn (expr, cnt) =
  match expr with
  | INT a -> apply_funs(cnt, a)
  | PLUS (e1,e2) -> eval_cps_dfn(e1, OPLUS(e2,cnt))
  | SUBT (e1,e2) -> eval_cps_dfn(e1, OSUBT(e2,cnt))
  | MULT (e1,e2) -> eval_cps_dfn(e1, OMULT(e2,cnt))
and apply_funs (funs, x) =
  match funs with
  | ID -> x
  | OPLUS (e2,cnt) -> eval_cps_dfn(e2, IPLUS(x,cnt))
  | IPLUS (a,cnt) -> apply_funs(cnt, a + x)
  | OSUBT (e2,cnt) -> eval_cps_dfn(e2, ISUBT(x,cnt))
  | ISUBT (a,cnt) -> apply_funs(cnt, a - x)
  | OMULT (e2,cnt) -> eval_cps_dfn(e2, IMULT(x,cnt))
  | IMULT (a,cnt) -> apply_funs(cnt, a * x)
let eval1 e = eval_cps_dfn(e, ID)