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

(** [unpop] is like {!val:push}, but the element is appended to the tail of the
    queue instead. *)
val unpop: 'a -> 'a t -> 'a t

(** [map f xs] is a queue whose elements are constructed by applying [f] to
    those of [xs]. *)
val map: ('a -> 'b) -> 'a t -> 'b t

(** [of_seq xs] is a queue constructed by {!val:push}ing each element of [xs] to
    the empty queue. *)
val of_seq: 'a Seq.t -> 'a t

(** [to_seq xs] is a sequence constructed as if by repeated calls to {!val:pop}. *)
val to_seq: 'a t -> 'a Seq.t

(** [to_list xs] is equivalent to [List.of_seq @@ to_seq xs], but avoids the
    spurious allocation of the sequence. *)
val to_list: 'a t -> 'a list

(** [of_list xs] is equivalent to [of_seq @@ List.to_seq xs], but it runs in
    constant time. *)
val of_list: 'a list -> 'a t

(** [rev xs] is a queue with all the elements of [xs] in reverse order. *)
val rev: 'a t -> 'a t

(** [append xs ys] is a queue with all the elements of [xs] and then all the
    elements of [ys]. *)
val append: 'a t -> 'a t -> 'a t