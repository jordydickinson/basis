type 'a t := 'a Stdlib.Lazy.t

(** [map f x] is equivalent to [lazy (f @@ force x)]. *)
val map : ('a -> 'b) -> 'a t -> 'b t

(** [map_val f x] is like [map f x], but in the case that [x] was constructed
    with {!val:Stdlib.Lazy.from_val}, it is equivalent to
    [from_val (f @@ force_val x)]. *)
val map_val : ('a -> 'b) -> 'a t -> 'b t

include module type of struct include Stdlib.Lazy end