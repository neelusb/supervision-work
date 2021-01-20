
(* fun with lazy sequences ... *) 

exception Error;;

type 'a seq = Nil | Cons of 'a * (unit -> 'a seq);;

let head = function Nil -> raise Error | (Cons (x, _)) -> x;;

let tail = function Nil -> raise Error | (Cons (_, xf)) -> xf ();;

let rec get n s =
    match n, s with
    | 0, _ -> []
    | n, Nil -> []
    | n, Cons (x, xf) -> x :: get (n-1) (xf ());;

let rec interleave xq yq =
    match xq with
    | Nil -> yq
    | Cons (x, xf) -> Cons (x, fun () -> interleave yq (xf ()));;

let rec filterq p = function
    | Nil -> Nil
    | Cons (x, xf) ->
       if p x
       then Cons (x, fun () -> filterq p (xf ()))
       else filterq p (xf ());;
  

let rec iterates f x = Cons (x, fun () -> iterates f (f x));; 

let rec from k = Cons (k, fun () -> from (k+1));; 			     

let rec mapq f = function
  | Nil -> Nil
  | Cons (x, xf) -> Cons (f x, fun () -> mapq f (xf ()));;				   

(********************************************************

       SOME PROBLEMS INVOLVING LAZY SEQUENCES 

 *********************************************************)

(* Let's make an infinte "grid" of the form 

   (0, 0) (0, 1) (0, 2) ... 
   (1, 1) (1, 1) (1, 2) ... 
   (2, 1) (2, 1) (2, 2) ... 
   ... ... 

   grid : (int * int) seq seq
*) 
let grid = mapq (fun x -> mapq (fun y -> (x, y)) (from 0)) (from 0);;

(* 
List.map (get 5) (get 5 grid);;

returns: 

[[(0, 0); (0, 1); (0, 2); (0, 3); (0, 4)];
 [(1, 0); (1, 1); (1, 2); (1, 3); (1, 4)];
 [(2, 0); (2, 1); (2, 2); (2, 3); (2, 4)];
 [(3, 0); (3, 1); (3, 2); (3, 3); (3, 4)];
 [(4, 0); (4, 1); (4, 2); (4, 3); (4, 4)]]

*) 

(* tgg22: I goofed this one up in supervision. Sorry. Corrected here. 

Exercise 9.2
Consider the list function concat, which concatenates a list of lists to form a single list. Can it be
generalised to concatenate a sequence of sequences? What can go wrong?

let rec concat = function
| [] -> []
| l::ls -> l @ concat ls
concat : 'a list list -> 'a list = <fun>
*) 

(* We know we can't write append, but we could use interleave 

  val concat : 'a seq seq -> 'a seq 
*)
let rec concat = function
  | Nil                     -> Nil
  | Cons (Nil, yf)          -> concat (yf ())
  | Cons (Cons (x, xf), yf) -> Cons (x, fun () -> interleave (xf ()) (concat (yf ())));; 

(* from 2015-p01-q02
Write a function diag that takes a lazy list of lazy lists,

    [ [z11, z12, z13, . . .],
      [z21, z22, z23, . . .], 
      [z31, z32, z33, . . .], . . . ]

and returns the diagonal, namely the lazy list [z11, z22, z33, . . .]. 
 *)
let rec diag ss =
  match ss with
  | Cons(Cons(x, _), fs) -> Cons(x, fun () -> diag (mapq tail (fs ())))
  | _ -> Nil;; 

(*
get 20 (diag grid);;

returns 

[(0, 0); (1, 1); (2, 2); (3, 3); (4, 4); (5, 5); (6, 6); (7, 7); (8, 8);
 (9, 9); (10, 10); (11, 11); (12, 12); (13, 13); (14, 14); (15, 15);
 (16, 16); (17, 17); (18, 18); (19, 19)]
*)


(* from 2015-p01-q02

given [x1, x2, ...] [y1, y2, ...] 

and a function f x y, 

poduce the lazy list of all f xi yk. 

Think of it this way: 

      y1   y2   ... yk ... 
 x1
 x2 
...
 xi             f xi yk 
...
*) 

let rec product f sx sy =
  match sx, sy with
  | Cons(x, fx), Cons(y, fy) -> Cons(f x y, fun () -> interleave (mapq (f x) (fy ()))(product f (fx ()) sy))
  | _, _ -> Nil ;;

(* problem : give (x, y) give me the n such that (x, y) is the nth element of this list! *)   
let all_pairs = product (fun x -> fun y -> (x, y))  (from 0) (from 0);;

(*

get 20 all_pairs; 

returns 

[(0, 0); (0, 1); (1, 0); (0, 2); (1, 1); (0, 3); (2, 0); (0, 4); (1, 2);
 (0, 5); (2, 1); (0, 6); (1, 3); (0, 7); (3, 0); (0, 8); (1, 4); (0, 9);
 (2, 2); (0, 10)]

An interesting order! 
 *) 

(* or  how about returning a lazy lists of lazy lists? *)

let rec product' f sx sy =
  match sx, sy with
  | Cons(x, fx), Cons(_,_) -> Cons(mapq (f x) sy, fun () -> product' f (fx ()) sy)
  | _, _ -> Nil ;;

let all_pairs' = product' (fun x -> fun y -> (x, y))  (from 0) (from 0);;    

(*
get 20 all_pairs'; 
returns

[Cons ((0, 0), <fun>); Cons ((1, 0), <fun>); Cons ((2, 0), <fun>);
 Cons ((3, 0), <fun>); Cons ((4, 0), <fun>); Cons ((5, 0), <fun>);
 Cons ((6, 0), <fun>); Cons ((7, 0), <fun>); Cons ((8, 0), <fun>);
 Cons ((9, 0), <fun>); Cons ((10, 0), <fun>); Cons ((11, 0), <fun>);
 Cons ((12, 0), <fun>); Cons ((13, 0), <fun>); Cons ((14, 0), <fun>);
 Cons ((15, 0), <fun>); Cons ((16, 0), <fun>); Cons ((17, 0), <fun>);
 Cons ((18, 0), <fun>); Cons ((19, 0), <fun>)]

List.map (get 5) (get 5 all_pairs');;

[[(0, 0); (0, 1); (0, 2); (0, 3); (0, 4)];
 [(1, 0); (1, 1); (1, 2); (1, 3); (1, 4)];
 [(2, 0); (2, 1); (2, 2); (2, 3); (2, 4)];
 [(3, 0); (3, 1); (3, 2); (3, 3); (3, 4)];
 [(4, 0); (4, 1); (4, 2); (4, 3); (4, 4)]]
 

 *)   

(* so this can be done more simply ....look familiar? *) 
let product'' f xq yq = mapq (fun x -> mapq (f x) yq) xq;;

let new_grid = product'' (fun x -> fun y -> (x, y))  (from 0) (from 0);;  


  
  
 (* Exercise 9.5
Code the lazy list whose elements are all ordinary lists of zeroes and ones, namely []; [0]; [1];
[0; 0]; [0; 1]; [1; 0]; [1; 1]; [0; 0; 0];
  *) 

let rec binaryLists bl =
  Cons (bl, fun () -> interleave (binaryLists (0::bl)) (binaryLists (1::bl)));;

(* 
get 20 (binaryLists []);;

returns 

[[]; [0]; [1]; [0; 0]; [0; 1]; [1; 0]; [1; 1]; [0; 0; 0]; [0; 0; 1];
 [0; 1; 0]; [0; 1; 1]; [1; 0; 0]; [1; 0; 1]; [1; 1; 0]; [1; 1; 1];
 [0; 0; 0; 0]; [0; 0; 0; 1]; [0; 0; 1; 0]; [0; 0; 1; 1]; [0; 1; 0; 0]]

*)   

(*Exercise 9.6
(Continuing the previous exercise.) A palindrome is a list that equals its own reverse. Code the
lazy list whose elements are all palindromes of 0s and 1s, namely []; [0]; [1]; [0; 0]; [0;
0; 0]; [0; 1; 0]; [1; 1]; [1; 0; 1]; [1; 1; 1]; [0; 0; 0; 0];, . . . . You may take the
reversal function List.rev as given.  
 *)

let rec palify = function
  | Nil -> Nil
  | Cons(l, xs) ->
     let r = List.rev l in
     Cons(l @ r,
	  fun () -> Cons(l @ [0] @ r,
			 fun () -> Cons(l @ [1] @ r,
					fun () -> palify (xs ()))));;

let palindromes = palify (binaryLists []);;
(*
9.9.3 Exercise 9.3
Code a function to make change using lazy lists, delivering the sequence of all possible ways
of making change. Using sequences allows us to compute solutions one at a time when there
exists an astronomical number. Represent lists of coins using ordinary lists. (Hint: to benefit from
laziness you may need to pass around the sequence of alternative solutions as a function of type
unit -> (int list) seq.)
 *)

(* One solutions involves this helper function. 
    mapapp : ('a -> 'b) -> 'a seq -> (unit -> 'b seq) -> 'b seq 

       mapapp f sx fy 
  
   is the same as "mapq f sx" when is infinite. 
   Otherwise, sx is finite, say x1, x2, ... xk. 
   Then we get  (f x), (f x2) .. (f xk), (fy ())
*)

let rec mapapp f xs yf =
  match xs with
  | Nil -> yf ()
  | Cons (x, xf) ->
      Cons (f x, fun () -> mapapp f (xf ()) yf);; 

let rec change till amt =
  if amt = 0
  then Cons ([], fun () -> Nil)
  else
    match till with
    | [] -> Nil
    | c::till ->
        if amt < c 
        then change till amt
        else mapapp (List.cons c) (change (c::till) (amt - c))
                    (fun () -> change till amt);; 
  
  
