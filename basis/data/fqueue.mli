(** Functional queue *)
type +'a t

(** [empty] is the empty queue. *)
val empty: 'a t

(** [is_empty xs] is [true] if [xs] is empty and [false] otherwise. *)
val is_empty: 'a t -> bool

(** [push x xs] is a queue with a head of [x] and a tail of [xs]. *)
val push: 'a -> 'a t -> 'a t

(** [pop xs] is a pair [x, xs'] where [x] is the last element of [xs] and [xs']
    is [xs] without [x] or @raise Failure if [xs] is empty. *)
val pop: 'a t -> 'a * 'a t

(** [pop_opt] is like {!val:pop} but it returns [None] rather than raising an
    exception. *)
val pop_opt: 'a t -> ('a * 'a t) option

(** [map f xs] is a queue whose elements are constructed by applying [f] to
    those of [xs]. *)
val map: ('a -> 'b) -> 'a t -> 'b t

(** [of_seq xs] is a queue constructed by {!val:push}ing each element of [xs] to
    the empty queue. *)
val of_seq: 'a Seq.t -> 'a t

(** [to_seq xs] is a sequence constructed as if by repeated calls to {!val:pop}. *)
val to_seq: 'a t -> 'a Seq.t