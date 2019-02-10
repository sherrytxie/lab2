(*
                              CS51 Lab 2
                     Basic Functional Programming
                             Spring 2019
 *)
(* Objective:

This lab is intended to introduce you to staples of functional
programming in OCaml, including:

    lists and tuples
    higher-order functional programming
 *)

(*======================================================================
Part 1: Types and type inference beyond atomic types

Exercise 1: What are appropriate types to replace the ??? in the
expressions below? Test your solution by uncommenting the examples
(removing the (* and *) at start and end) and verifying that no typing
error is generated.
......................................................................*)

let exercise1a : float * string =
  (0.1, "hi") ;;

let exercise1b : string list =
  let add_to_hello_list x = ["Hello"; x]
  in add_to_hello_list "World!";;

let exercise1c : int * float -> int  =
  fun (x, y) -> x + int_of_float y ;;

let exercise1d : int list -> bool  =
  fun lst ->
    match lst with
    | [] -> false
    | hd :: _ -> hd < hd + 1 ;;

let exercise1e : bool -> bool list =
  fun x -> if x then [x] else [] ;;

(*======================================================================
Part 2: First-order functional programming with lists

We'll start with some "finger exercises" defining simple functions
before moving on to more complex problems. As a reminder, here's the
definition for the length function of type int list -> int:

let rec length (lst : int list) : int =
  match lst with
  | [] -> 0
  | head :: tail -> 1 + length tail ;;

........................................................................
Exercise 2: In lab 1, we defined a function that could square its input.
Now, define a function square_all that squares all of the
elements of an integer list. We've provided a bit of template code,
supplying the first line of the function definition but the body of
the skeleton code just fails by forcing an error using the built-in
failwith function. Edit the code to implement square_all
properly.

Test out your implementation of square_all by modifying the template
code below to define exercise2 to be the square_all function applied
to the list containing the elements 3, 4, and 5? You'll want to
replace the "[]" with the correct functional call.

Thorough testing is important in all your work, and we hope to impart
this view to you in CS51. Testing will help you find bugs, avoid
mistakes, and teach you the value of short, clear functions. In the
file lab2_tests.ml, we’ve put some prewritten tests for square_all
using the testing method of Section 6.5 in the book. Spend some time
understanding how the testing function works and why these tests are
comprehensive. You may want to add some tests for other functions in
the lab to get some practice with automated unit testing.
......................................................................*)

let exercise1d : int list -> bool  =
  fun lst ->
    match lst with
    | [] -> false
    | hd :: _ -> hd < hd + 1 ;;

let square_all : int list -> int list =
  List.map (fun x -> x * x) ;;

let exercise2 = square_all [-2; 4];;

(*......................................................................
Exercise 3: Define a recursive function that sums an integer
list. (What's a sensible return value for the empty list?)
......................................................................*)

let rec sum (lst : int list) : int =
  match lst with
  |[] -> 0
  | hd :: [] -> hd
  | hd :: nk :: tl -> sum (hd + nk :: tl);;

let exercise3 = sum [1;2;3;5];;
(*......................................................................
Exercise 4: Define a recursive function that returns the maximum
element in a non-empty integer list. Don't worry what happens on an empty
list. You may be warned by the compiler that "this pattern-matching is
not exhaustive." You may ignore this warning for this lab.
......................................................................*)

let rec max_list (lst : int list) : int =
  match lst with
  |[] -> 0
  | hd :: [] -> hd
  | hd :: nt :: tl -> if nt > hd then max_list (nt :: tl)
    else max_list(hd :: tl);;

let exercise4 = max_list [-1;2;3;-5];;

(*......................................................................
Exercise 5: Define a function zip, that takes two int lists and
returns a list of pairs of ints, one from each of the two argument
lists. Your function can assume the input lists will be the same
length.  You can ignore what happens in the case the input list
lengths do not match. You may be warned by the compiler that "this
pattern-matching is not exhaustive." You may ignore this warning for
this lab.

For example, zip [1; 2; 3] [4; 5; 6] should evaluate to
[(1, 4); (2, 5); (3, 6)].

To think about: Why wouldn't it be possible, in cases of mismatched
length lists, to just pad the shorter list with, say, false values, so
that, zip [1] [2; 3; 4] = [(1, 2); (false, 3); (false, 4)]?
......................................................................*)

let rec zip (x : int list) (y : int list) : (int * int) list =
  match x with
  | hdx :: tlx -> (match y with
    |hdy :: tly -> (hdx, hdy) :: zip tlx tly)
  | [] -> [];;

let exercise5 = zip [1; 2; 3] [4; 5; 6];;

(*......................................................................
Exercise 6: Recall from Chapter 7 the definition of the function prods
(duplicated below).

Using sum, prods, and zip, define a function dotprod that
takes the dot product of two integer lists (that is, the sum of the
products of corresponding elements of the lists). For example, you
should have:

# dotprod [1; 2; 3] [0; 1; 2] ;;
- : int = 8
# dotprod [1; 2] [5; 10] ;;
- : int = 25

Even without looking at the code for the functions, carefully looking
at the type signatures for zip, prods, and sum should give a good idea
of how you might combine these functions to implement dotproduct.

If you've got the right idea, your implementation should be literally
a single line of code. If it isn't, try it again, getting into the
functional programming zen mindset.
......................................................................*)

let rec prods (lst : (int * int) list) : int list =
  match lst with
  | [] -> []
  | (x, y) :: tail -> (x * y) :: (prods tail) ;;

let dotprod (a : int list) (b : int list) : int =
  sum (prods (zip a b));;

let exercise6 = dotprod [1; 2] [5; 10] ;;

(*======================================================================
Part 3: High-order functional programming with map, filter, and fold

In these exercises, you should use the built-in functions map, filter,
and fold_left and fold_right provided in the OCaml List module to
implement these simple functions.

IMPORTANT NOTE 1: When you make use of these functions, you'll either
need to prefix them with the module name, for example, List.map or
List.fold_left, or you'll need to open the module with the line

    open List ;;

You can place that line at the top of this file if you'd like.

IMPORTANT NOTE 2: In these labs, and in the problem sets as well, we'll
often supply some skeleton code that looks like this:

    let somefunction (arg1 : type) (arg2 : type) : returntype =
      failwith "somefunction not implemented"

We provide this to give you an idea of the function's intended name,
its arguments and their types, and the return type. But there's no
need to slavishly follow that particular way of implementing code to
those specifications. In particular, you may want to modify the first
line to introduce, say, a rec keyword (if your function is to be
recursive):

    let rec somefunction (arg1 : type) (arg2 : type) : returntype =
      ...your further code here...

Or you might want to define the function using anonymous function
syntax. (If you haven't seen this yet, come back to this comment later
when you have.)

    let somefunction =
      fun (arg1 : type) (arg2 : type) : returntype ->
        ...your further code here...

This will be especially pertinent in this section, where functions can
be built just by applying other higher order functions directly,
without specifying the arguments explicitly, for example, in this
implementation of the double function, which doubles each element of a
list:

    let double : int list -> int list =
      map (( * ) 2) ;;

END IMPORTANT NOTES

........................................................................
Exercise 7: Reimplement sum using fold_left, naming it sum_ho (for
"higher order").
......................................................................*)

open List ;;

let sum_ho (lst : int list) : int =
  List.fold_left (+) 0 lst;;

let exercise7 = sum_ho [1;2;3];;
(*......................................................................
Exercise 8: Reimplement prods using map.
......................................................................*)

let prods_ho (lst : (int * int) list) : int list =
  List.map (fun(a,b) -> (a*b)) lst;;

let exercise8 = prods_ho [(1, 4); (2, 5); (3, 6)];;

(*......................................................................
Exercise 9: The OCaml List module provides -- in addition to the map,
fold_left, and fold_right higher-order functions -- several other
useful higher-order list manipulation functions. For instance, map2 is
like map, but takes two lists instead of one along with a function of
two arguments and applies the function to corresponding elements of
the two lists to form the result list. (You can read about it at
https://caml.inria.fr/pub/docs/manual-ocaml/libref/List.html.) Use
map2 to reimplement zip.
......................................................................*)

let zip_ho (x : int list) (y : int list) : (int * int) list =
  List.map2 (fun a b -> (a,b)) x y;;

let exercise9 = zip_ho [1; 2; 3] [4; 5; 6];;

(*......................................................................
Exercise 10: Define a function evens, using these higher-order
functional programming techniques, that returns a list of all of the
even numbers in its argument list.
......................................................................*)

let evens : int list -> int list =
  List.filter (fun a -> a mod 2 = 0);;

let exercise10 = evens [1;2;3;4;5;6];;
