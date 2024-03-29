include Comparable.Container
include module type of struct include Stdlib.List end

(** [is_empty xs] is [true] if [xs = []] and [false] otherwise. *)
val is_empty: 'a t -> bool

(** [head xs] is a list containing all but the last element of [xs] or @raise
    Failure if [xs] is empty. *)
val head: 'a t -> 'a t

(** [head_opt] is like {!val:head} but it returns [None] rather than raising
    an exception. *)
val head_opt: 'a t -> 'a t option

(** [last xs] is the last element of [xs] or @raise Failure if [xs] is empty. *)
val last: 'a t -> 'a

(** [last_opt] is like {!val:last} but it returns [None] rather than raising
    an exception. *)
val last_opt: 'a t -> 'a option

(** [fold_left2_rem] is like {!val:fold_left2} but rather than raising an
    exception it folds as much as it can and returns a remainder when the lists
    are of unequal length. *)
val fold_left2_rem: ('acc -> 'a -> 'b -> 'acc) -> 'acc -> 'a t -> 'b t -> 'acc * ('a t, 'b t) Either.t option

(** [combine_rem xs ys] transforms a pair of lists into a list of pairs similar
    to {!val:combine}, but when [xs] and [ys] have differing lengths, the
    longest possible combined list is returned along with the remainder of
    whichever of the two was longer. *)
val combine_rem: 'a t -> 'b t -> ('a * 'b) t * ('a t, 'b t) Either.t option

(** [takedrop n xs] is a pair of lists [ys, zs] where [ys] is comprised of the
    first [n] elements of [xs], and [zs] of the remainder.

    @raise Invalid_arg if [n] is negative
    @raise Failure if [xs] has fewer than [n] elements
  *)
val takedrop: int -> 'a t -> 'a t * 'a t

(** [take n xs] is [fst @@ takedrop n xs]. *)
val take: int -> 'a t -> 'a t

(** [drop n xs] is [snd @@ takedrop n xs]. *)
val drop: int -> 'a t -> 'a t

(** [fold_left_while] is like {!val:fold_left}, but the provided function also
    indicates whether it wants the fold to continue. In addition to the
    accumulated value, the remainder of the list which was not traversed is
    returned as well. *)
val fold_left_while: ('acc -> 'a -> 'acc * bool) -> 'acc -> 'a t -> 'acc * 'a t

(** [takedrop_while f xs] is a pair of lists [ys, zs] where [ys] is comprised of
    the longest prefix of [xs] whose elements satisfy [f], and [zs] is comprised
    of the remainder. *)
val takedrop_while: ('a -> bool) -> 'a t -> 'a t * 'a t

(** [take_while f xs] is [fst @@ takedrop_while f xs]. *)
val take_while: ('a -> bool) -> 'a t -> 'a t

(** [drop_while f xs] is [snd @@ takedrop_while f xs]. *)
val drop_while: ('a -> bool) -> 'a t -> 'a t

(** [uniq equal_elt xs] is [xs] with consecutive duplicates removed, using
    [equal_elt] to test equality. Note that non-consecutive duplicates are not
    removed. *)
val uniq: ('a -> 'a -> bool) -> 'a t -> 'a t

(** [map_uniq equal_elt f xs] combines {!val:map} with {!val:uniq}, first
    applying [f] and then testing for equality. *)
val map_uniq: ('b -> 'b -> bool) -> ('a -> 'b) -> 'a t -> 'b t

(** [group_by_int group xs] is a mapping from integers to groups of elements of
    [xs] where the list of elements at key [i] is comprised of all [x] in [xs]
    such that [group x = i]. *)
val group_by_int: ('a -> int) -> 'a t -> 'a t Int.Map.t

(** [swap_hd i xs] is [xs] with its head and [i]th element swapped. For example,
    [swap_hd 2 [1; 2; 3; 4]] is [3; 2; 1; 4].
    
    @raise Failure if [xs] does not contain an [i]th element. *)
val swap_hd: int -> 'a t -> 'a t

(** [insert i x xs] is [xs] with [x] at index [i] and all elements [y] in [xs]
    at index [j > i] at indices [j + 1]. For example, [insert 2 'a' ['b'; 'c';
    'd'; 'e']] is [['b'; 'c'; 'a'; 'd'; 'e']]. *)
val insert: int -> 'a -> 'a t -> 'a t

val transpose: 'a t t -> 'a t t

(** [hash hash_elt xs] computes a hash for [xs] using [hash_elt] to hash
    individual elements. *)
val hash: ('a -> int) -> 'a t -> int