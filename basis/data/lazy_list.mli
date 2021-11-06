type +'a node =
| Nil
| Cons of 'a * 'a t

and +'a t = 'a node Lazy.t

(** [nil] is the empty list. *)
val nil : 'a t

(** [cons x xs] is a list with a head of [x] and a tail of [xs]. *)
val cons : 'a -> 'a t -> 'a t

(** [lcons x xs] is a list with a head of [Lazy.force x] and a tail of [xs], but
    it does not force the suspension [x] until the head of [lcons x xs] is
    forced. *)
val lcons : 'a Lazy.t -> 'a t -> 'a t

(** [singleton x] is [cons x nil]. *)
val singleton : 'a -> 'a t

(** [lsingleton x] is [lcons x nil]. *)
val lsingleton : 'a Lazy.t -> 'a t

(** [is_nil xs] is [true] if [xs] is {!val:nil} and [false] otherwise. This
    function forces the head of the list. *)
val is_nil : 'a t -> bool

(** [hd xs] is the head of [xs] or @raise Failure if [xs] is empty. *)
val hd : 'a t -> 'a

(** [hd_opt] is like {!val:hd} but it returns [None] rather than raising an
    exception. *)
val hd_opt : 'a t -> 'a option

(** [tl xs] is the tail of [xs] or @raise Failure if [xs] is empty. *)
val tl : 'a t -> 'a t

(** [tl_opt] is like {!val:tl} but it returns [None] rather than raising an
    exception. *)
val tl_opt : 'a t -> 'a t option

(** [at i xs] is the [i]th element of [xs]. This function forces the first [i]
    elements of [xs].

    @raise Not_found if [xs] does not have at least [i] elements
  *)
val at : int -> 'a t -> 'a

(** [at_opt] is like {!val:at} but it returns [None] rather than raising an 
    exception. *)
val at_opt : int -> 'a t -> 'a option

(** [nth xs i] is [at i xs]. *)
val nth : 'a t -> int -> 'a

(** [nth_opt xs i] is [at_opt i xs]. *)
val nth_opt : 'a t -> int -> 'a option

(** [fold_left f init xs] is [f (... (f (f init x1) x2) ...) xn] where [x1],
    [x2], ..., [xn] denote consecutive elements of [xs]. This function is eager
    and tail-recursive. *)
val fold_left : ('acc -> 'a -> 'acc) -> 'acc -> 'a t -> 'acc

(** [fold_right f xs init] is [f x1 (f x2 (... (f xn init) ...))] where [x1],
    [x2], ..., [xn] denote consecutive elements of [xs]. This function is eager
    and not tail-recursive. *)
val fold_right : ('a -> 'acc -> 'acc) -> 'a t -> 'acc -> 'acc

(** [length xs] is the number of elements in [xs]. This function is eager, and
    will force the entire list. *)
val length : 'a t -> int

(** [iter f xs] is [f x1; f x2; ...; f xn] where [x1], [x2], ..., [xn] denote
    consecutive elements of [xs]. This function is eager and tail-recursive. *)
val iter : ('a -> unit) -> 'a t -> unit

(** [iteri] is like {!val:iter}, but the function is also given the index of
    each element. *)
val iteri : (int -> 'a -> unit) -> 'a t -> unit

(** [map f xs] is [cons (f x1) (cons (f x2) (... (cons (f xn) nil)))]. This
    function is lazy. *)
val map : ('a -> 'b) -> 'a t -> 'b t

(** [mapi] is like {!val:map} but the function is also provided the index of the
    element of the list. *)
val mapi : (int -> 'a -> 'b) -> 'a t -> 'b t

(** [map_val f xs] is like [map f xs], but if [xs] was constructed only from
    immediate values (e.g., using only {!val:cons} and {!val:nil}), then it is
    evaluated eagerly. If [xs] was only partially constructed using immediate
    values, then this function is only partially eager. *)
val map_val : ('a -> 'b) -> 'a t -> 'b t

(** [mapi_val] is like {!val:map_val} but the function is also provided with the
    index of each element in the list. *)
val mapi_val : (int -> 'a -> 'b) -> 'a t -> 'b t

(** [append xs ys] is a list containing all the elements of [xs] and then all
    the elements of [ys]. This function is lazy. *)
val append : 'a t -> 'a t -> 'a t

(** [append_val] is like {!val:append}, but it is possibly-eager in the same way
    as {!val:map_val}. *)
val append_val : 'a t -> 'a t -> 'a t

(** [concat xss] is equivalent to [List.fold_left append nil xss]. *)
val concat: 'a t list -> 'a t

(** [flatten xss] is equivalent to [fold_left append nil xss], but it is lazy. *)
val flatten: 'a t t -> 'a t

(** [filter pred xs] is [xs] without any element [x] for which [pred x] is
    [false]. This function is lazy. *)
val filter : ('a -> bool) -> 'a t -> 'a t

(** [combine xs ys] is [cons (x1, y1) (cons (x2, y2) (... (cons (xn, yn) nil)))]
    or @raise Invalid_arg if [xs] and [ys] are of unequal lengths. *)
val combine : 'a t -> 'b t -> ('a * 'b) t

(** [cartprod xs ys] is the cartesian product of [xs] and [ys]. *)
val cartprod: 'a t -> 'b t -> ('a * 'b) t

(** [of_seq xs] is a lazy list comprised of the elements of the sequence [xs].
    This function is lazy. *)
val of_seq : 'a Seq.t -> 'a t

(** [to_seq xs] is a sequence comprised of the elements of the lazy list [xs]. *)
val to_seq : 'a t -> 'a Seq.t