(* Let's investigate imperative features in OCaml : references and exceptions *)

let r = ref 10;;
(* this gives 
   val r : int ref = {contents = 10}
 *)
let x = !r;;   
(* this gives 
   val x : int = 10
 *)
let u = r := !r + 1;;
(* this gives 
   val u : unit = () 
 *)

r;;
(* this gives 
   val r : int ref = {contents = 11}
 *)

(* what is really going on here?  what is this {contents = 11}? 

Answer : OCaml has record types.  And fields in records can 
be declared as "mutable". 

First, a record with immutable fields. 
*)   
type int_pair = {first : int; second : int};;
let p = {first = 17; second = 99};;
(* this gives 
val p : int_pair = {first = 17; second = 99}
 *)
p.first;;
(* this gives
- : int = 17	
 *) 
p.second;;
(* this gives
- : int = 99	
 *) 

(* now let's define a mutable version *)  
type int_pair_mutable = {mutable first : int; mutable second : int};;
val p : int_pair_mutable = {first = 17; second = 99};; 

p.first <- 55;;
(* this gives     
- : unit = ()
 *)
p.first ;;  
(* this gives     
- : int = 55
 *)
p;;
(* this gives 
int_pair_mutable = {first = 55; second = 99}
*)

(* note that I can use the same kind of access and update 
   syntax on ref values *)
r.contents;;
(* this gives
- : int = 11
 *)
r.contents <- 17;;  
(* this gives 
- : unit = ()
*)
r;;
(* this gives
int ref = {contents = 17}  

In other words, ref values are nothing but a special built-in 
mutable record with a single field called "contents". These 
values are associated with some syntactic sugar

   (:=) : 'a ref -> 'a -> unit
     (!) : 'a ref -> 'a 

Let's define our own "smart" ref values that contain time-stamps 
using Sys.time() : float. 
*) 
type 'a smart_ref = {mutable value : 'a; mutable updated : float; created : float};;

let smart_ref v = let t = Sys.time () in {value = v; updated = t; created = t};;
(*
val smart_ref : 'a -> 'a smart_ref = <fun>
*)   
let update r v = (r.value <- v); r.updated <- Sys.time ();;  
(*
val update : 'a smart_ref -> 'a -> unit = <fun>
 *) 
(* we can even define new infix notation that acts like := for our smart refs *)
let (<=) r v = update r v;;
(*
val ( <= ) : 'a smart_ref -> 'a -> unit = <fun>
 *)  
let sm = smart_ref 17;;
(*  
val sm : int smart_ref = {value = 17; updated = 0.050897; created = 0.050897}  
*)
sm <= 22;;
(*
- : unit = ()
 *)
 sm;;
(*
- : int smart_ref = {value = 22; updated = 0.0521629999999999941; created = 0.050897}    
 *)
(* our own version of ! *)
let (!!) r = r.value;;   
(*
val ( !! ) : 'a smart_ref -> 'a = <fun>
 *) 
!! sm;;
(*    
- : int = 22
 *)

(* Let's  use reference cells to perform "tail recursion elimination" by 
hand on this code : 

let rec fold_left f accu l =
  match l with
    [] -> accu
  | a::l -> fold_left f (f accu a) l

 *) 
let fold_left_imp f accu l =
     let raccu = ref accu in
     let rl = ref l in 
     while !rl <> [] do
         raccu := f !raccu (List.hd !rl);
	 rl        := List.tl !rl 
     done;
     !raccu;;
(*
   val fold_left_imp : ('a -> 'b -> 'a) -> 'a -> 'b list -> 'a = <fun>
 *)

(* let's solve my "next puzzle" *)
let next =
  let x = ref (-1)
  in let g () = (x := !x + 1); !x
     in g ;;
(*
val next : unit -> int = <fun>
 *)
next ();;
(*
- : int = 0
 *) 
next ();;
(* 
- : int = 1
*)
next ();;
(*    
- : int = 2
 *)

(* Now, let's look at some strange interactions between polymorphism 
   and mutable values.   These two OCaml features interact in strange ways
   in order to keep the type system safe. 
*)  
let fr = ref (fun a -> a);;
(*
val fr : ('_a -> '_a) ref = {contents = <fun>}

Note the types of the form '_a.  
 *) 
!fr 17;;
(*
- : int = 17
 *) 
!fr;;
(*     
- : int -> int = <fun>

Wow, that application changed the type of the stored function! 
That is, types of the form '_a will be set to their first use, and 
cannot change after that. 
 *) 

(* Let's talk about exceptions *)   
List.hd [];;
(*
Exception: Failure "hd".
*)     
(* How would we write hd if OCaml didn't have exceptions? 
    In the Hakell style! 
*)
let safe_hd l = match l with [] -> None | a :: _ -> Some a;;
(*
val safe_hd : 'a list -> 'a option = <fun>

Notice that the type List.hd : : 'a list -> 'a is hiding 
something from you: the fact that it can raise an exception, 
while safe_hd's type give you more info. 
However, using safe_hd may require more case checking and 
complicate code.   Haskell programmers solve this problem 
with "monadic programming" 
https://en.wikipedia.org/wiki/Monad_(functional_programming)
 *)

(* look at the type of raise *)  
raise;;
(* 
- : exn -> 'a = <fun>   

It can return *any* type.  This makes sense since it never returns 
and so will never be caught fibbing! 
*)
let strange a = raise (Failure "hello")   + raise (Failure "world");;
(*
val strange : 'a -> int = <fun>
 *)
