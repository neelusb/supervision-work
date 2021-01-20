(*
   FoCS 2020 : Problem Set 2 (assigned by tgg22@cam.ac.uk).
*)


(* The type expr represents abstract syntax trees in our
   little language of expressions.
*)
type expr =                        (* representing     *)
  | Evar of string                 (* x                *)
  | Eint of int                    (* n                *)
  | Eplus of expr * expr           (* e1 + e2          *)
  | Etimes of expr * expr          (* e1 * e2          *)
  | Elet of string * expr * expr   (* let x = e1 in e2 *)


(* For example, the an experssion like

   let x = 17
   in let y = x + 21
      in x * (y + 99)

   is represented as
*)
let example1 = Elet("x", Eint 17, Elet("y", Eplus(Evar "x", Eint 21), Etimes (Evar "x", Eplus(Evar "y", Eint 19))))

(* we now implement an evaluation function for expressions.
   First, we need a way of associating variables with values.
*)
exception Missing of string

let rec lookup = function
  | [], a -> raise (Missing a)
  | (x, y) :: pairs, a ->
    if a = x then y else lookup (pairs, a)

let update (l, b, y) = (b, y) :: l

type environment = (string * int) list

(* Now, write  the function

   eval : environment * expr -> int

   Given the expression example1 above, eval([], example1) should return 969.
*)
let rec eval ((env, e) : environment * expr) : int =
  match env, e with
  | env, Evar x -> lookup (env, x)
  | env, Eint n -> n
  | env, Eplus (e1, e2) -> eval (env, e1) + eval (env, e2)
  | env, Etimes (e1, e2) -> eval (env, e1) * eval (env, e2)
  | env, Elet(var, e1, e2) -> eval (update (env, var, eval(env, e1)), e2);;

(* Now we implement a low-level stack machine with an instruction set *)

type intruction = Ipush of int | IpopEnv | Iplus | Itimes | Ifind of string | Ibind of string

type code = intruction list

type stack = int list

type state = State of environment * code * stack

exception RuntimeError

(* run : state -> int

   The idea is this. If we start with an initial state with c of type code

   State([], c, [])

   then "run (State([], c, []))" should perform each intruction in c and eventually reach a state
   of the form State(_, [], [v]), where v is the result of running the code c.

*)
let rec run s =
  match s with
  | State(_,                   [],             [v]) -> v
  | State(env, (Ifind s) :: insts,           stack) -> run (State(env, insts, (lookup(env, s)) :: stack))
  | State(env, (Ibind s) :: insts,      v :: stack) -> run (State(update(env, s, v), insts, stack))
  | State(env, (Ipush v) :: insts,           stack) -> run (State(env, insts, v :: stack))
  | State(_ :: env, IpopEnv :: insts,        stack) -> run (State(env, insts, stack))							   
  | State(env,     Iplus :: insts, a :: b :: stack) -> run (State(env, insts, (a + b) :: stack))
  | State(env,    Itimes :: insts, a :: b :: stack) -> run (State(env, insts, (a * b) :: stack))
  | _ -> raise RuntimeError


(* Write the function

   compile : expr -> code

   that translates an expression into code that when run will return the
   same value as eval.

   The basic idea is this: "compile e" generates code that when run will leave the
   value of e on top of the stack.

   For example, "compile example1" should return the code

    [Ipush 17;
     Ibind "x";
     Ifind "x";
     Ipush 21;
     Iplus;
     Ibind "y";
     Ifind "x";
     Ifind "y";
     Ipush 19;
     Iplus;
     Itimes]

   If this is unclear, then here is a hint:
   https://en.wikipedia.org/wiki/Reverse_Polish_notation
*)
let rec compile (e : expr) : code =
  match e with
  | Evar x             -> [Ifind x]
  | Eint n             -> [Ipush n]
  | Eplus (e1, e2)     -> (compile e1) @ (compile e2) @ [Iplus]
  | Etimes (e1, e2)    -> (compile e1) @ (compile e2) @ [Itimes]
  | Elet (var, e1, e2) -> (compile e1) @ [Ibind var]  @ (compile e2) @ [IpopEnv];;

(* "compile_and_run example1" should return 969 *)
let compile_and_run e = run (State([], compile e, []))


(* evaluates to val test : int list = [4; 16; 256] *) 			    
let test = List.map compile_and_run
     [
       Eplus(Eint 2, Eint 2);
       Etimes(Eint 2, Eint 8);
       Elet("x", Etimes(Eint 2, Eint 8), Etimes(Evar "x", Evar "x"))
     ]
     
let test1 = Elet("x", Eint 2, Eplus(Eint 7, Evar "x"))
(* test2 should not work since the second x is out-of-scope *) 		
let test2 = Eplus(test1, Evar "x")

