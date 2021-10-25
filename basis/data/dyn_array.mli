type !'a t

val create : int -> 'a -> 'a t

val create_float : int -> float t

val create_char : int -> char t

val length : 'a t -> int

val to_array : 'a t -> 'a array

val to_floatarray : float t -> floatarray

val to_bytes : char t -> bytes

val ensure_capacity : 'a t -> int -> unit

val compact : 'a t -> unit

val set : 'a t -> int -> 'a -> unit

val get : 'a t -> int -> 'a

val push : 'a t -> 'a -> unit

val pop : 'a t -> 'a

val pop_opt : 'a t -> 'a option

val fill : 'a t -> int -> int -> 'a -> unit

val blit : 'a t -> int -> 'a t -> int -> int -> unit

val iteri : (int -> 'a -> unit) -> 'a t -> unit

val iter : ('a -> unit) -> 'a t -> unit

val mapi_into : (int -> 'a -> 'b) -> 'a t -> 'b t -> unit

val map_into : ('a -> 'b) -> 'a t -> 'b t -> unit

val mapi_inplace : (int -> 'a -> 'a) -> 'a t -> unit

val map_inplace : ('a -> 'a) -> 'a t -> unit

val init : int -> 'a -> (int -> 'a) -> 'a t

val init_float : int -> (int -> float) -> float t

val init_char : int -> (int -> char) -> char t

val mapi : 'b -> (int -> 'a -> 'b) -> 'a t -> 'b t

val map : 'b -> ('a -> 'b) -> 'a t -> 'b t

val mapi_float : (int -> 'a -> float) -> 'a t -> float t

val map_float : ('a -> float) -> 'a t -> float t

val mapi_char : (int -> 'a -> char) -> 'a t -> char t

val map_char : ('a -> char) -> 'a t -> char t

val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b t -> 'a

val fold_right : ('a -> 'b -> 'b) -> 'a t -> 'b -> 'b

val iteri2 : (int -> 'a -> 'b -> unit) -> 'a t -> 'b t -> unit

val iter2 : ('a -> 'b -> unit) -> 'a t -> 'b t -> unit

val mapi2 : 'c -> (int -> 'a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t

val map2 : 'c -> ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t

val for_alli : (int -> 'a -> bool) -> 'a t -> bool

val for_all : ('a -> bool) -> 'a t -> bool

val existsi : (int -> 'a -> bool) -> 'a t -> bool

val exists : ('a -> bool) -> 'a t -> bool

val for_alli2 : (int -> 'a -> 'b -> bool) -> 'a t -> 'b t -> bool

val for_all2 : ('a -> 'b -> bool) -> 'a t -> 'b t -> bool

val existsi2 : (int -> 'a -> 'b -> bool) -> 'a t -> 'b t -> bool

val exists2 : ('a -> 'b -> bool) -> 'a t -> 'b t -> bool

val mem : 'a -> 'a t -> bool

val memq : 'a -> 'a t -> bool

val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool

val compare : ('a -> 'a -> int) -> 'a t -> 'a t -> int