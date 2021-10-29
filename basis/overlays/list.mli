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