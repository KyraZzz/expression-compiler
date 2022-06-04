(* interpreter1-1 turn continuations into a list that canbe used as a stack, obtain a stack machine *)
type expr =
	|INT of int |PLUS of expr * expr |SUBT of expr * expr |MULT of expr * expr

type funsList = 
| OPLUS of expr
| IPLUS of int
| OSUBT of expr 
| ISUBT of int
| OMULT of expr
| IMULT of int
let rec eval_cps_dfn_list (expr, cnt) =
  match expr with
  | INT a -> apply_funs(cnt, a)
  | PLUS (e1,e2) -> eval_cps_dfn_list(e1, OPLUS(e2)::cnt)
  | SUBT (e1,e2) -> eval_cps_dfn_list(e1, OSUBT(e2)::cnt)
  | MULT (e1,e2) -> eval_cps_dfn_list(e1, OMULT(e2)::cnt)
and apply_funs (funs, x) =
  match funs with
  | [] -> x
  | OPLUS (e2)::cnt -> eval_cps_dfn_list(e2, IPLUS(x)::cnt)
  | IPLUS (a)::cnt -> apply_funs(cnt, a + x)
  | OSUBT (e2)::cnt -> eval_cps_dfn_list(e2, ISUBT(x)::cnt)
  | ISUBT (a)::cnt -> apply_funs(cnt, a - x)
  | OMULT (e2)::cnt -> eval_cps_dfn_list(e2, IMULT(x)::cnt)
  | IMULT (a)::cnt -> apply_funs(cnt, a * x)
let eval1' e = eval_cps_dfn_list (e, []) 

(* combine the two mutually recursive function into a state machine *)
type flag = 
  | F_INT of int
  | F_EXP of expr
let step = function
  | (F_EXP (INT a), cnt) -> (F_INT a, cnt)
  | (F_EXP (PLUS (e1, e2)), cnt) -> (F_EXP e1, OPLUS(e2)::cnt)
  | (F_EXP (SUBT (e1, e2)), cnt) -> (F_EXP e1, OSUBT(e2)::cnt)
  | (F_EXP (MULT (e1, e2)), cnt) -> (F_EXP e1, OMULT(e2)::cnt)
  | (F_INT x, OPLUS(e2)::cnt) -> (F_EXP e2, IPLUS(x)::cnt)
  | (F_INT x, OSUBT(e2)::cnt) -> (F_EXP e2, ISUBT(x)::cnt)
  | (F_INT x, OMULT(e2)::cnt) -> (F_EXP e2, IMULT(x)::cnt)
  | (F_INT x, IPLUS(a)::cnt) -> (F_INT (a + x), cnt)
  | (F_INT x, ISUBT(a)::cnt) -> (F_INT (a - x), cnt)
  | (F_INT x, IMULT(a)::cnt) -> (F_INT (a * x), cnt)
  | (F_INT x, []) -> (F_INT x, [])
let rec driver = function
  | (x, []) -> x
  | state -> driver (step state)
let eval e = driver(e,[])