(** An interface for types whose inhabitants can be ordered. *)
module type Basic = sig
  type t

  (** [compare a b] is [0] when [a] and [b] are equal, a negative integer when
      [a] is less than [b], and a positive integer when [a] is greater than
      [b].
    *)
  val compare : t -> t -> int
end

(** A basic interface for comparable containers. *)
module type BasicContainer = sig
  type 'a t

  (** [compare compare_elt xs ys] compares [xs] and [ys], using [compare_elt] to
      compare each element of [xs] and [ys]. If [Stdlib.compare xs ys = i] and
      for any two [x], [y] we have [Stdlib.compare x y = i] implies
      [compare_elt x y = i], then [compare compare_elt xs ys] must also equal
      [i]. *)
  val compare: ('a -> 'a -> int) -> 'a t -> 'a t -> int
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

(** An interface for comparable containers. *)
module type Container = sig
  type 'a t
  include BasicContainer with type 'a t := 'a t
  module MakeComparable (T: Basic): S with type t = T.t t
end