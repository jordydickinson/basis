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