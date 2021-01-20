(*
   FoCS 2020 : Problem Set 3 (assigned by tgg22@cam.ac.uk).

   Here are some experiments using streams
   and "lazy binary trees"
   (that is, possibly infinite trees!).

   The file is broken up into 3 parts:

   Part 1: Streams
   Part 2: Lazy Trees
   Part 3: *optional* Fun with the Stern-Brocot tree.

   Note: "ycgh" (your-code-goes-here) is now defined as an ML function
         that always raises an exception.  You are to replace all calls
         ycgh() with your ML code that does the right thing.

*)
exception ToDo;;
let ycgh () = raise ToDo;;

(* Part 1.

   We define "streams" --- like lazy lists but they are never finite
   (no "empty list" constructor).

*)
type 'a stream = StreamCons of 'a * (unit -> 'a stream);;

(* stream_head : 'a stream -> 'a *)
let stream_head (StreamCons(x, _))  = x;;

(* stream_tail : 'a stream -> 'a stream *)
let stream_tail (StreamCons(_, xf)) = xf();;

(* stream_filter : ('a -> bool) -> 'a stream -> 'a stream
   Be careful using this!  What if nothing in stream satisfies f?
*)
let rec stream_filter f (StreamCons(x, xf)) =
  if f x
  then StreamCons(x, fun () -> stream_filter f (xf()))
  else stream_filter f (xf());;

(* stream_map : ('a -> 'b) -> 'a stream -> 'b stream *)
let rec stream_map f (StreamCons(x, xf)) = StreamCons(f x, fun() -> stream_map f (xf()));;

(* stream_interleave : 'a stream * 'a stream -> 'a stream
*)
let rec stream_interleave (StreamCons(x,xf), yq) = StreamCons(x, fun() -> stream_interleave (yq, (xf ())));;

(* stream_from : int -> int stream
*)
let rec stream_from k = StreamCons(k, fun () -> stream_from(k+1));;

(* stream_get : int * 'a stream -> 'a list
*)
let rec stream_get (n, StreamCons(x, xf)) = if n = 0 then [] else x :: stream_get (n-1, xf());;

(* Write this function:

  zip_streams : ('a * 'b -> 'c) -> 'a stream -> 'b stream -> 'c stream

  The type should tell you what it does.
*)
let rec zip_streams f (StreamCons(x,xs)) (StreamCons(y,ys)) = StreamCons(f (x, y), fun() -> zip_streams f (xs()) (ys()));;


(* The Sieve of Eratosthenes!

   sieve : int stream -> int stream

The Sieve of Erathosthenes: given an infinite sequence

  n1,n2,...,nk,...

the procedure keeps n1 and eliminates all multiples of it form the rest.
It then repeats this procdure with the result.
Thus, when this is applied to

  2,3,4,...,k,...

the procedure keeps 2 and eliminates all other even numbers, it then keeps
3 and eliminates all the multiples of 3 that had not been eliminated (that
is, the non-even multiples of 3), it then keeps 5 (as 4 has already been
eliminated) and eliminates all multiples of 5 that are not multiples of 2
and 3 (as these have already been eliminated), etc.

In this way we have a stream of all prime numbers!
The following expression

   stream_get(20, sieve(stream_from 2));

   should resturn the first 20 prime numbers:

   [2; 3; 5; 7; 11; 13; 17; 19; 23; 29; 31; 37; 41; 43; 47; 53; 59; 61; 67; 71]

*)


let rec sieve (StreamCons(h, rest)) = StreamCons(h, fun () -> sieve (stream_filter (fun x -> not (x mod h = 0)) (rest ())));;

(*
*)


(* Part 2. Fully Lazy Trees

   'a fltree : full lazy binary trees --- no leaf nodes!
*)

type 'a fltree = FLBr of 'a * (unit -> 'a fltree) * (unit -> 'a fltree);;

(* Note that it is very difficult to imagine defining
   versions of in-order or post-order traversals of lazy trees!
   However, twe might be inspired by binary trees to write
   something like the function preorder, which we will call

   flatten_fltree : 'a fltree -> 'a stream

   using stream_interleave rather than list append.

*)
let rec fltree_flatten (FLBr(x,tf1,tf2)) = StreamCons(x, fun() -> stream_interleave (fltree_flatten (tf1()), fltree_flatten (tf2())));;

(* Let's build a full lazy tree containing each positive int only once.
   OK, OK, we really need to build a new datatype of unbouned integers!
   But here we just live with the limitations of bounded (32 or 64 bit) ML ints ...

*)
let fltree_of_all_ints =
    let rec aux k = FLBr(k, (fun () -> aux((2*k)+1)), (fun() -> aux((2*k)+2)))
    in aux 0 ;;

(* Breadth-first traversal of fltrees. Write this function:

   breadth_first : a' fltree -> ('a list) stream

   where the k-th list in the sequence are all nodes at depth k.  For example,

         stream_get (5,  breadth_first fltree_of_all_ints);

   should return (I provided manual indentation) :


    [                              [0],
                                  [1, 2],
                               [3, 4, 5, 6],
                      [7, 8, 9, 10, 11, 12, 13, 14],
      [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
    ]
*)

let rec breadth_first (FLBr(a, left, right)) = StreamCons([a], fun() -> zip_streams (fun (l, r) -> l @ r) (breadth_first (left ())) (breadth_first (right ())));;


(* Part 3. OPTIONAL *)
(*
   Fun with the Stern-Brocot tree.
   We will use these trees to study the Stern-Brocot tree -- a tree
   of all positive rational numbers, where each rational only appears
   ONCE (in its most reduced form). Read the description here:
   http://en.wikipedia.org/wiki/Stern-Brocot_tree.

   For more information, see the YouTube video:
   http://www.youtube.com/watch?v=CiO8iAYC6xI
*)

let mediant (i, j) (m, n) = (i + m, j + n) ;;
let zero = (0, 1);;
let one = (1, 1) ;;
let infinity = (1, 0);;
let rational_to_float (i, j) = (float i)/.(float j);;

(* construct the stern_brocot tree!  *)
let stern_brocot =
    let rec stern_brocot_gen left mid right =
            FLBr(mid,
               (fun () -> stern_brocot_gen left (mediant left mid ) mid),
               fun () -> stern_brocot_gen mid (mediant mid right) right
              )
    in stern_brocot_gen zero one infinity ;;

(*
  The expression "stream_get(5, breadth_first stern_brocot);" evaluates to the list of list
  (with my indentation)
  [                                                                      [(1, 1)],
                                                                    [(1, 2), (2, 1)],
                                                           [(1, 3), (2, 3), (3, 2), (3, 1)],
                                     [(1, 4), (2, 5), (3, 5), (3, 4), (4, 3), (5, 3), (5, 2), (4, 1)],
      [(1, 5), (2, 7), (3, 8), (3, 7), (4, 7), (5, 8), (5, 7), (4, 5), (5, 4), (7, 5), (8, 5), (7, 4), (7, 3), (8, 3), (7, 2), (5, 1)]
  ]
*)

(* Your task: explore this tree in some interesting way, perhaps
   inspired by the YouTube video.
*)
