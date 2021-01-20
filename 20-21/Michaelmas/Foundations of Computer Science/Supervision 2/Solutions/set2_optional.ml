(*
   FoCS 2020 : Problem Set 2 (assigned by tgg22@cam.ac.uk).
   Sulutions for optional part 

   Extend expr/eval/compile to include 
   -- booean values and operations (and, or, not, =) 
   -- conditions (if ... then ... else) 
   -- simple functions 
   -- recursive functions 

    Sorry, I didn't get around to type checing! 
*)
type binop = Band | Bor | Beq | Bplus | Bminus | Btimes 

type unary = Unot | Uneg

type var = string 		      
				       
type expr =                         (* representing     *) 
  | Evar of var                     (* x                *)
  | Ebool of bool                   (* b                *)	      
  | Eint of int                     (* n                *) 
  | Elet of var * expr * expr       (* let x = e1 in e2 *)
  | EbinOp of expr * binop * expr   (* e1 op e2         *)
  | EunaryOp of unary * expr        (* op e             *) 		       
  | Eif of expr * expr * expr       (* if e1 then e2 else e3                    *)
  | Eapply of var * expr            (* f(e),  function application              *) 			   
  | Efun of var * var * expr * expr (* let f (x) = e1 in e2                     *)
  | Erec of var * var * expr * expr (* let f (x) = e1 in e2,  recursive function*)

exception Missing of string

type environment = (string *value) list 
			   
(* values are the result of evaluating an expression *) 				   
and value =
    Vbool of bool
  | Vint of int
  | Vfunction of (value -> value)            (*function value *)
  | Vrec of (environment -> value -> value)  (* recursive function value *)		   

let rec lookup (env, x) =
  match env with 
  | []      -> raise (Missing x)
  | (x', y) :: rest ->
     if x' = x
     then match y with
          (* recursive functions need to know about themselves *)	    
	  | Vrec g -> Vfunction (g env)  
          | _ -> y 				
     else lookup (rest, x)		   
    

let update (l, b, y) = (b, y) :: l
	      
			
exception RuntimeError

(* eval binary operator on two values *) 	    
let eval_bop (bop, v1, v2) =
    match bop, v1, v2 with 		  
    | Band,   Vbool b1, Vbool b2 -> Vbool(b1 && b2)
    | Bor,    Vbool b1, Vbool b2 -> Vbool(b1 || b2)				    
    | Bplus,  Vint n1,  Vint n2  -> Vint(n1 + n2)
    | Bminus, Vint n1,  Vint n2  -> Vint(n1 - n2)					
    | Btimes, Vint n1,  Vint n2  -> Vint(n1 * n2) 				    				    
    | Beq,    Vint n1,  Vint n2  -> Vbool(n1 = n2)
    | Beq,    Vbool b1, Vbool b2 -> Vbool(b1 = b2) 				    				    				       
    | _,_,_ -> raise RuntimeError 						        
				    
(* eval : environment * expr -> value  *) 				   
let rec eval ((env, e) : environment * expr) : value  =
  match e with
  | Evar s          -> lookup(env, s)
  | Eint n          -> Vint n
  | Ebool b          -> Vbool b 			    
  | Elet(s, e1, e2) ->  eval(update (env, s, eval(env, e1)), e2)
  (* let's implement a short-circuit "and" and "or" *) 			    
  | EbinOp(e1, Band, e2) -> 
     (match eval(env, e1) with
      | Vbool true -> eval(env, e2)
      | Vbool _  -> Vbool false 
      | _ -> raise RuntimeError) 						        
  | EbinOp(e1, Bor, e2) ->
     (match eval(env, e1) with
      | Vbool false -> eval(env, e2)
      | Vbool _  -> Vbool true
      | _ -> raise RuntimeError) 						        
  | EbinOp(e1, bop, e2) -> eval_bop (bop, eval(env, e1), eval(env, e2)) 
  | EunaryOp (Unot, e) ->
     (match eval(env, e) with
      | Vbool true -> Vbool(false)
      | Vbool false -> Vbool(true)			   
      | _ -> raise RuntimeError) 						   
  | EunaryOp (Uneg, e) ->
     (match eval(env, e) with
      | Vint n -> Vint(-1 * n)
      | _ -> raise RuntimeError) 						   
  | Eif(e1, e2, e3) ->
     (match eval(env, e1) with
      | Vbool true -> eval(env, e2)
      | Vbool false -> eval(env, e3) 			  
      | _ -> raise RuntimeError)
  | Eapply(f, e) ->
     (match lookup(env, f) with
      | Vfunction g -> g (eval(env, e))
      | _ -> raise RuntimeError)
  (* interesting! *)
  | Efun (f, x, e1, e2) -> eval(update(env, f, Vfunction (fun y -> eval(update(env, x, y), e1))), e2)
  (* very interesting! *)	 
  | Erec (f, x, e1, e2) -> eval(update(env, f, Vrec (fun e -> fun y -> eval(update(e, x, y), e1))), e2)


let test1 = EbinOp(Eint 2, Bplus, Eint 2)
let test2 = EbinOp(Eint 2, Bminus, Eint 2)	    
let test3 = EbinOp(Eint 2, Beq, Eint 2)
let test4 = EbinOp(Eint 2, Beq, Eint 3)
let test5 = Elet("x", Eint 2, EbinOp(Eint 7, Bminus, Evar "x"))
let test6 = Eif(Ebool true, Eint 0, Eint 3)
let test7 = Eif(Ebool false, Eint 0, Eint 3)
let test8 = Efun("f", "x", EbinOp(Eint 7, Bminus, Evar "x"), Eapply ("f", Eint 3))


(* the fibonacci function!

List.map (fun x -> eval([], fib x)) [1;2;3;4;5;6;7;8;9;10];;

results in 

[Vint 1; Vint 1; Vint 2; Vint 3; Vint 5; Vint 8; Vint 13; Vint 21; Vint 34; Vint 55]
*)
		  
let fib n =
  Erec("fib", "x",
       Eif(EbinOp(Evar "x", Beq, Eint 1), Eint 1,
	   Eif(EbinOp(Evar "x", Beq, Eint 2), Eint 1,
		EbinOp(Eapply("fib", EbinOp(Evar "x", Bminus, Eint 1)), Bplus, Eapply("fib", EbinOp(Evar "x", Bminus, Eint 2))))),
       Eapply("fib", Eint n))

	    

(* Now we implement a low-level stack machine with an instruction set *) 	    

      
type instruction =
  | IpushStack of machine_value
  | IpushEnv of var 
  | IpopEnv 
  | Iplus
  | Iminus      
  | Itimes
  | Ieq
  | Inot
  | Ineg      
  | Ifind of string
  | Ibind of string
  | Itest of code * code
  | Iapply

and machine_value =
     Mint of int
   | Mbool of bool
   | Mfunction of code  

and code = instruction list
		       
type stack = machine_value list

type machine_environment = (string * machine_value) list			   
				
type state = State of machine_environment * code * stack
	    
let rec mlookup (env, x) =
  match env with 
  | []      -> raise (Missing x)
  | (x', y) :: rest ->
     if x' = x
     then y 
     else mlookup (rest, x)		   

	    
(* run : state -> value *) 
let rec run s =
  match s with
  | State(_,   [],                                      [v]) -> v
  | State(env, Ifind s :: insts,                      stack) -> run (State(env, insts, (mlookup(env, s)) :: stack))
  | State(env, IpushEnv s :: insts,              v :: stack) -> run (State((s, v) :: env, insts, stack))
  | State(_ :: env, IpopEnv :: insts,                 stack) -> run (State(env, insts, stack))  	    
  | State(env, IpushStack v :: insts,                 stack) -> run (State(env, insts, v :: stack))
  | State(env, Iplus :: insts,    Mint a :: Mint b :: stack) -> run (State(env, insts, Mint(a + b) :: stack))
  | State(env, Iminus :: insts,   Mint a :: Mint b :: stack) -> run (State(env, insts, Mint(b - a) :: stack))	 
  | State(env, Itimes :: insts,   Mint a :: Mint b :: stack) -> run (State(env, insts, Mint(a * b) :: stack))
  | State(env, Ieq :: insts,      Mint a :: Mint b :: stack) -> run (State(env, insts, Mbool(a = b) :: stack)) 	  
  | State(env, Ineg :: insts,               Mint a :: stack) -> run (State(env, insts, Mint(-1 * a) :: stack))
  | State(env, Inot :: insts,              Mbool b :: stack) -> run (State(env, insts, Mbool(not b) :: stack))
  | State(env, Ieq :: insts,    Mbool a :: Mbool b :: stack) -> run (State(env, insts, Mbool(a = b) :: stack))
  | State(env, Ieq :: insts,    Mint  a :: Mint  b :: stack) -> run (State(env, insts, Mbool(a = b) :: stack))	  	    
  | State(env, Itest(c, _) :: insts,  (Mbool true) :: stack) -> run (State(env, c @ insts, stack))
  | State(env, Itest(_, c) :: insts, (Mbool false) :: stack) -> run (State(env, c @ insts, stack))
  | State(env, Iapply :: insts, v :: (Mfunction c) :: stack) -> run (State(env, c @ insts, v :: stack))
  | _ -> raise RuntimeError 						       


(*
   running (compile e) in the machine above should leave the value of e on top of the stack. 
 *) 	       
let rec compile (e : expr) : code =
  match e with
  | Evar s                 -> [Ifind s] 
  | Eint n                 -> [IpushStack (Mint n)]
  | Ebool b                -> [IpushStack (Mbool b)]
  | EbinOp(e1, Band, e2)   -> compile (Eif(e1, e2, Ebool false))
  | EbinOp(e1, Bor, e2)    -> compile (Eif(e1, Ebool true, e2))				    
  | EbinOp(e1, Beq, e2)    -> (compile e1) @ (compile e2) @ [Ieq]
  | EbinOp(e1, Bplus, e2)  -> (compile e1) @ (compile e2) @ [Iplus]
  | EbinOp(e1, Bminus, e2) -> (compile e1) @ (compile e2) @ [Iminus]
  | EbinOp(e1, Btimes, e2) -> (compile e1) @ (compile e2) @ [Itimes]
  | EunaryOp(Unot, e)      -> (compile e)  @ [Inot]							       
  | EunaryOp(Uneg, e)      -> (compile e)  @ [Ineg]
  | Elet(s, e1, e2)        -> (compile e1) @ [IpushEnv s] @ (compile e2) @ [IpopEnv]
  | Eif(e1, e2, e3)        -> (compile e1) @ [Itest(compile e2, compile e3)]
  | Eapply(f, e)           -> Ifind f :: (compile e) @ [Iapply]
  | Efun(f, x, e1, e2)     -> (IpushStack (Mfunction ((IpushEnv x) :: (compile e1) @ [IpopEnv]))) :: (IpushEnv f) :: (compile e2) @ [IpopEnv]
  | Erec(f, x, e1, e2)     -> (IpushStack (Mfunction ((IpushEnv x) :: (compile e1) @ [IpopEnv]))) :: (IpushEnv f) :: (compile e2) @ [IpopEnv]

let compile_and_run e = run (State([], compile e, []))


(* the fibonacci function again!

List.map (fun x -> compile_and_run(fib x)) [1;2;3;4;5;6;7;8;9;10];;

results in 

[Mint 1; Mint 1; Mint 2; Mint 3; Mint 5; Mint 8; Mint 13; Mint 21; Mint 34; Mint 55]
*)

			    
