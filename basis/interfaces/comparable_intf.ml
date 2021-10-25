(** An interface for types whose inhabitants can be ordered. *)
module type Basic = sig
  type t

  (** [compare a b] is [0] when [a] and [b] are equal, a negative integer when
      [a] is less than [b], and a positive integer when [a] is greater than
      [b].
    *)
  val compare : t -> t -> int
end

(** An interface for comparison operators. *)
module type Infix = sig
  type t

  (** [a < b] is [true] if [a] is less than [b] and [false] otherwise. *)
  val ( < ) : t -> t -> bool

  (** [a <= b] is [true] if [a] is less than or equal to [b] and [false] otherwise. *)
  val ( <= ) : t -> t -> bool

  (** [a > b] is the logical negation of [a <= b]. *)
  val ( > ) : t -> t -> bool

  (** [a >= b] is the logical negation of [a < b]. *)
  val ( >= ) : t -> t -> bool
end

(** An interface for comparable types. *)
module type S = sig
  type t
  include Basic with type t := t
  module Set: Set.S with type elt = t
  module Map: Map.S with type key = t
end