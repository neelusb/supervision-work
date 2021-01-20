type expr =                        (* representing     *)
  | Evar of string                 (* x                *)
  | Eint of int                    (* n                *)
  | Eplus of expr * expr           (* e1 + e2          *)
  | Etimes of expr * expr          (* e1 * e2          *)
  | Elet of string * expr * expr   (* let x = e1 in e2 *)
  | Ebool of bool                  (* true/false       *)
  | Eand of expr * expr            (* e1 && e2         *)
  | Eor of expr * expr             (* e1 || e2         *)
  | Enot of expr                   (* not e            *)
  | Eequals of expr * expr         (* e1 = e2          *)
  | Eif of expr * expr * expr      (* if e1 then e2 else e3 *)

exception TypeError of string;;

exception Missing of string

let rec lookup = function
  | [], a -> raise (Missing a)
  | (x, y) :: pairs, a ->
    if a = x then y else lookup (pairs, a)

let update (l, b, y) = (b, y) :: l

type environment = (string * expr) list

let eint_to_int e = match e with Eint n -> n | _ -> raise (TypeError "Integer expected but not received.");;

let ebool_to_bool e = match e with Ebool b -> b | _ -> raise (TypeError "Boolean expected but not received.");;

let rec eval ((env, e) : environment * expr) : expr =
  match env, e with
  | env, Evar x -> lookup (env, x)
  | env, Eint n -> Eint n
  | env, Eplus (e1, e2) -> Eint (eint_to_int (eval (env, e1)) + eint_to_int(eval (env, e2)))
  | env, Etimes (e1, e2) -> Eint (eint_to_int (eval (env, e1)) * eint_to_int(eval (env, e2)))
  | env, Elet (var, e1, e2) -> eval (update (env, var, eval(env, e1)), e2)
  | env, Ebool b -> Ebool b
  | env, Eand (e1, e2) -> (match eval(env, e2) with
                          | Ebool b -> Ebool ((ebool_to_bool (eval (env, e1))) && b)
                          | _ -> raise (TypeError "Boolean expected but not received."))
  | env, Eor (e1, e2) -> (match eval(env, e2) with
                         | Ebool b -> Ebool ((ebool_to_bool (eval (env, e1))) || b)
                         | _ -> raise (TypeError "Boolean expected but not received."))
  | env, Enot e -> Ebool (not (ebool_to_bool (eval (env, e))))
  | env, Eequals (e1, e2) -> Ebool (eval (env, e1) = eval(env, e2))
  | env, Eif (e1, e2, e3) -> if ebool_to_bool (eval (env, e1)) then eval (env, e2) else eval (env, e3);;


type intruction = Ipush of expr | Iplus | Itimes | Ifind of string | Ibind of string | Iand | Ior | Inot | Iequals | Iif

type code = intruction list

type stack = expr list

type state = State of environment * code * stack

exception RuntimeError

let rec run s =
  match s with
  | State(_,                   [],                          [v]) -> v
  | State(env, (Ifind s) :: insts,                        stack) -> run (State(env, insts, (lookup(env, s)) :: stack))
  | State(env, (Ibind s) :: insts,                   v :: stack) -> run (State(update(env, s, v), insts, stack))
  | State(env, (Ipush v) :: insts,                        stack) -> run (State(env, insts, v :: stack))
  | State(env,     Iplus :: insts,              a :: b :: stack) -> run (State(env, insts, (Eint ((eint_to_int a) + (eint_to_int b))) :: stack))
  | State(env,    Itimes :: insts,              a :: b :: stack) -> run (State(env, insts, (Eint ((eint_to_int a) * (eint_to_int b))) :: stack))
  | State(env,      Iand :: insts,      a :: (Ebool b) :: stack) -> run (State(env, insts, (Ebool ((ebool_to_bool a) && b)) :: stack))
  | State(env,      Iand :: insts,                            _) -> raise (TypeError "Boolean expected but not received.")
  | State(env,       Ior :: insts,      a :: (Ebool b) :: stack) -> run (State(env, insts, (Ebool ((ebool_to_bool a) || b)) :: stack))
  | State(env,      Ior :: insts,                             _) -> raise (TypeError "Boolean expected but not received.")
  | State(env,      Inot :: insts,                   a :: stack) -> run (State(env, insts, (Ebool (not (ebool_to_bool a))) :: stack))
  | State(env,   Iequals :: insts,              a :: b :: stack) -> run (State(env, insts, (Ebool (a = b)) :: stack))
  | State(env,       Iif :: insts,         a :: b :: c :: stack) -> run (State(env, insts, (if (ebool_to_bool c) then b else a) :: stack))
  | _ -> raise RuntimeError


let rec compile (e : expr) : code =
  match e with
  | Evar x -> [Ifind x]
  | Eint n -> [Ipush (Eint n)]
  | Eplus (e1, e2) -> (compile e1) @ (compile e2) @ [Iplus]
  | Etimes (e1, e2) -> (compile e1) @ (compile e2) @ [Itimes]
  | Elet (var, e1, e2) -> (compile e1) @ ((Ibind var) :: compile e2)
  | Ebool b -> [Ipush (Ebool b)]
  | Eand (e1, e2) -> (compile e1) @ (compile e2) @ [Iand]
  | Eor (e1, e2) -> (compile e1) @ (compile e2) @ [Ior]
  | Enot e -> (compile e) @ [Inot]
  | Eequals (e1, e2) -> (compile e1) @ (compile e2) @ [Iequals]
  | Eif (e1, e2, e3) -> (compile e1) @ (compile e2) @ (compile e3) @ [Iif]


let compile_and_run e = run (State([], compile e, []))

(* Tests for boolean values and operators: *)

let example2 = Elet ("x", Eint 17, Elet ("y", Eplus (Evar "x", Eint 5), Eequals (Evar "x", Evar "y")  ));;
let example3 = Elet ("x", Eint 17, Elet ("y", Eplus (Evar "x", Eint 0), Eequals (Evar "x", Evar "y")  ));;
let example4 = Elet ("x", Eint 17, Elet ("y", Eplus (Evar "x", Eint 5), Eor (Ebool true, Eequals (Evar "x", Evar "y"))  ));;
let example5 = Elet ("x", Eint 17, Elet ("y", Eplus (Evar "x", Eint 0), Eand (Eequals (Evar "x", Evar "y"), Ebool true)  ));;
let example6 = Elet ("x", Eint 17, Elet ("y", Eplus (Evar "x", Eint 0), Enot (Eand (Eequals (Evar "x", Evar "y"), Ebool true))  ));;

[eval([], example2); eval([], example3); eval([], example4); eval([], example5); eval([], example6)];;
[compile_and_run example2; compile_and_run example3; compile_and_run example4; compile_and_run example5; compile_and_run example6];;

(* Tests for if/else: *)

let example7 = Elet ("x", Eint 17, Elet ("y", Eplus (Evar "x", Eint 5), Eif (Eequals (Evar "x", Evar "y"), Eplus (Eint 1, Eint 2), Eplus (Eint 3, Eint 4))  ));;
let example8 = Elet ("x", Eint 17, Elet ("y", Eplus (Evar "x", Eint 0), Eif (Eequals (Evar "x", Evar "y"), Eplus (Eint 1, Eint 2), Eplus (Eint 3, Eint 4))  ));;

eval([], example7);;
compile_and_run example7;;

eval([], example8);;
compile_and_run example8;;

(* Tests for TypeError: *)

let example9 = Eplus(Eint 5, Ebool true);;
let example10 = Eand(Eint 5, Ebool true);;
let example11 = Eand(Ebool false, Eint 5);;
let example12 = Eor(Ebool true, Eint 2);;


eval([], example9);;
compile_and_run example9;;

eval([], example10);;
compile_and_run example10;;

eval([], example11);;
compile_and_run example11;;

eval([], example12);;
compile_and_run example12;;
