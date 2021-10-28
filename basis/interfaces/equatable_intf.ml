(** An interface for types which have some notion of equality. *)
module type Basic = sig

  type t

  (** [equal a b] is [true] if [a] and [b] are equal and [false] otherwise.

      This function must satisfy the constraint that [a = b] implies
      [equal a b], but otherwise the meaning of equality is up to the
      implementation of this interface.
    *)
  val equal : t -> t -> bool
end

(** An interface for types which have some notion of equality. *)
module type Basic1 = sig

  type 'a t

  (** [equal a b] is [true] if [a] and [b] are equal and [false] otherwise.

      This function must satisfy the constraint that [a = b] implies
      [equal a b], but otherwise the meaning of equality is up to the
      implementation of this interface.
    *)
  val equal : 'a t -> 'a t -> bool
end


(** Infix equality operators *)
module type Infix = sig

  type t

  (** [( = )] is an alias for [equal]. *)
  val ( = ) : t -> t -> bool

  (** [( <> )] is the logical negation of [( = )]. *)
  val ( <> ) : t -> t -> bool
end


(** Infix equality operators *)
module type Infix1 = sig

  type 'a t

  (** [( = )] is an alias for [equal]. *)
  val ( = ) : 'a t -> 'a t -> bool

  (** [( <> )] is the logical negation of [( = )]. *)
  val ( <> ) : 'a t -> 'a t -> bool
end

(** An interface for types which have some notion of equality. *)
module type S = sig
  type t
  include Basic with type t := t
end

(** An interface for types which have some notion of equality. *)
module type S1 = sig
  type 'a t
  include Basic1 with type 'a t := 'a t
end

