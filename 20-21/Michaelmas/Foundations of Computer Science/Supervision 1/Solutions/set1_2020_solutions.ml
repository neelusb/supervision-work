(*
   FoCS 2020 : Problem Set 1 (assigned by tgg22@cam.ac.uk).
   Solution Notes. 
*) 

(* initial code *) 
let descend n = 
    let rec aux (carry, k) = 
            if k = n then n :: carry else aux(k::carry, k+1) 
    in aux ([], 1);; 

let rec change till amt =
  if amt = 0
  then [ [] ]
  else match till with
       | [] -> []
       | c::till ->
          if amt < c
	  then change till amt
          else let rec allc = function
                   | [] -> []
                   | cs :: css -> (c::cs) :: allc css
               in
                 allc (change (c::till) (amt - c)) @
                 change till amt ;; 

let partitions n = change (descend n) n;;


(* 1) List all integer partitions of n containing only odd *)

(* here is a typical solution *)

let rec odd_list l =
  match l with 
  | [] -> true
  | x::xs -> (x mod 2 = 1) && (odd_list xs);; 

let rec odd_lists = function
  | [] -> []
  | x::xs -> if odd_list x
	     then x :: odd_lists xs
	     else odd_lists xs  

let exercise1 n = odd_lists (partitions n);;

(* That's fine. It works.  But could we can we generalise? 
   The OCaml library has two functions that we could use. 

   List.filter : ('a -> bool) -> 'a list -> 'a list 
   List.for_all : ('a -> bool) -> 'a list -> bool

Let's write our own versions of these functions: 
*)
let rec filter p l =
  match l with
  | [] -> []
  | a :: rest -> if p a then a :: (filter p rest) else (filter p rest);;  

let rec for_all p l =
  match l with
  | [] -> true
  | a :: rest -> (p a) && (for_all p rest);;

(* now all we need is the is_idd function... *) 
let is_odd x = (x mod 2 = 1);;   

(* ... and then we have a very clean solution *)   

let exercise1 n = filter (for_all is_odd) (partitions n);;

(* notice how we are exploting *functional* programming here! 
filter is a function that takes a function p as an arguement. 
What does it return?  A function from lists to lists.   
In this case the function p itself is created by applying a function
to another function! 
*) 
  
(* 
2) List all integer partitions of n containing distinct integers (no duplicates). 

From the exercise1 we see that this can probably done by something like 

let exercise2 n = filter no_duplicates (partitions n);;
*)
let rec no_duplicates l =
  match l with
  | [] -> true
  | a :: rest -> (for_all (fun x -> x <> a) rest) && (no_duplicates rest) ;;

let exercise2 n = filter no_duplicates (partitions n);;

(* note the use of the anonymous function "fun x -> x <> a"  *) 


(* 
3) List all integer partitions of n containing only duplicate integers 

Hmmm, we can do this with something like 

let exercise3 n = filter all_same (partitions n);;
*) 
let rec all_same l =
  match l with
  | [] -> true
  | a :: rest -> for_all (fun x -> x = a) rest;;

let exercise3 n = filter all_same (partitions n);;


(* After you write your code, play with it.  Do you notice any
   interesting relationship between your answers from (1) and (2)?  
   Hint: count how many partitions there are. 
   Gosh, what is going on here?
 *)

(* Let's do a little experiment.  First we will 
   re-implement this function from the library
   
   List.map : ('a -> 'b) -> 'a list -> 'b list
*) 
let rec map f l =
  match l with
  | [] -> []
  | a :: rest -> (f a) :: (map f rest);;  

(* Here's the experiment. 

map (fun n -> List.length (exercise1 n)) [1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20];;
- : int list =
[1; 1; 2; 2; 3; 4; 5; 6; 8; 10; 12; 15; 18; 22; 27; 32; 38; 46; 54; 64]

# map (fun n -> List.length (exercise2 n)) [1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20];;
- : int list =
[1; 1; 2; 2; 3; 4; 5; 6; 8; 10; 12; 15; 18; 22; 27; 32; 38; 46; 54; 64]

Wow! They are the same! So what's going on? 

The first thing to do is go to The On-Line Encyclopedia of Integer Sequences
at https://oeis.org/ and enter the query: 

1, 1, 2, 2, 3, 4, 5, 6, 8, 10, 12, 15, 18, 22, 27, 32, 38, 46, 54, 64

and we see we get a famous seqence https://oeis.org/A000009.  
It turns out that in 1748 Leonhard Euler proved the number of odd partions and distinct partitions 
are always the same!

If you want to learn more about integer partitions you could start here: 
See https://en.wikipedia.org/wiki/Partition_(number_theory)#Odd_parts_and_distinct_parts

However, I think the proof there is too complicated, and it doesn't give us any idea on 
how to translate an odd partition into a distinct one, nor the other way around. 
However, there is a nice proof by Glaisher on page 2 of this http://www.personal.psu.edu/gea1/pdf/317.pdf. 
And that proof can be implemented as translations. (Huge thanks to Morgan for finding this paper!) 

So, let's use Glaisher's proof as a guide to implementing two OCaml bijections. 
Morgan send me his bijections and I have simply rewritten them a bit 
to improve readability.  Thanks again Morgan! 
 *)
  

(* helper functions *)

(* there is a version List.flatten, but let's write our own 
   in order to learn something ... 
   flatten : 'a list list -> 'a list
*)  
let rec flatten = function
   | [] -> []
   | a::rest -> a @ flatten rest;;

let count_occurances list x =
   let rec aux count = function
      | [] -> count
      | a :: rest -> if a = x then aux (count + 1) rest else aux count rest
   in aux 0 list;;

let remove_duplicates list =
   let rec aux = function
      | [] -> []
      | [a] -> [a]	       
      | a::b::rest -> if a=b then aux (b::rest) else a :: (aux (b :: rest))
   in aux (List.sort (fun x y -> y - x) list);;

let mult a b = a * b;;

(* express a number x as the sum or powers of 2. 
For example, 
   map binary_decompose [1;2;3;4;5;6;7;8;9;10];;

should return 

  [[1]; [2]; [1; 2]; [4]; [1; 4]; [2; 4]; [1; 2; 4]; [8]; [1; 8]; [2; 8]]  
 *)
let rec binary_decompose x =
   match x, x mod 2 with
   | 0, p -> []
   | x, 1 -> 1 :: (map (mult 2) (binary_decompose (x/2)))
   | x, 0 -> map (mult 2) (binary_decompose (x/2))
   | _, _ -> [] (* this can never happen, but we want to match all cases to avoid warnings *) ;;

let odd_to_distinct_partition part =
  (* first remove duplicates from the odd partition *) 
  let part_no_duplicates = remove_duplicates part in
  (* generate a list of the form (c, i), where c is counts the occurances of i in part *) 
  let l1 = map (fun i -> (count_occurances part i, i)) part_no_duplicates in
  (* for each (c, i), translate it to (l, i), where l is the binary representation of c *)
  let l2 = map (fun (c, i) -> (binary_decompose c, i)) l1 in
  (* for each (l, i), *)
  let l3 = map (fun (l, i) -> (map (mult i) l)) l2 in
  (* we now have a list of lists where we want a list, so flatten the result *) 
     flatten l3;; 
  

let exercise2_biject n = map odd_to_distinct_partition (exercise1 n);; 

(* sanity check:

   exercise2 6;;

returns 
   
   [[6]; [5; 1]; [4; 2]; [3; 2; 1]]

   exercise2_biject 6;;

returns 

    [[5; 1]; [6]; [3; 1; 2]; [2; 4]]

Note, I have not bothered to return partitions in the same order. 
You could modify the solutions to do so. 

*) 
 
(* now for the other direction *)

(* repeat a n = [a; a; .... ;a] n times *)   
let rec repeat atom = function
   | 0 -> []
   | count -> atom :: (repeat atom (count - 1));;

(*
  We now want to decode each i in a distinct partition 
  into a sum of odd numbers. 
  If i is odd, just return [i]. 
  If i is even, then i = 2^k * j, where j is odd. 
  The return 2^k copies of j. 
  For example, 

     map decode [1;2;3;4;5;6;7;8;9;10];;

  should return 

   [[1]; [1; 1]; [3]; [1; 1; 1; 1]; [5]; [3; 3]; [7]; [1; 1; 1; 1; 1; 1; 1; 1]; [9]; [5; 5]]

*)   
let decode x =
   let rec aux pow stub =
     if stub mod 2 = 0
     then aux (2 * pow) (stub/2)
     else repeat stub pow
   in aux 1 x;;

let distinct_to_odd_partition part = flatten (map decode part);;

let exercise1_biject n = map distinct_to_odd_partition (exercise2 n);;

(* sanity check. 

   exercise1_biject 6;;

   returns 

   [[3; 3]; [5; 1]; [1; 1; 1; 1; 1; 1]; [3; 1; 1; 1]]

  exercise1 6;;

  returns 

  [[5; 1]; [3; 3]; [3; 1; 1; 1]; [1; 1; 1; 1; 1; 1]]

Again, I did not bother about order. 

) 
