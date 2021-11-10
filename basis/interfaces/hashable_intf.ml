(** A basic interface for hashable types. *)
module type Basic = sig
  type t

  include Equatable_intf.Basic with type t := t

  (** [hash a] is an integer hash of [a]'s value.

      This function must satisfy the following constraint: if [equal a b] is
      [true], then [hash a = hash b] is also [true].
   *)
  val hash : t -> int
end

(** An interface for hashable types. *)
module type S = sig
  type t
  include Basic with type t := t
  module Table: Hashtbl.S with type key = t
end

(** An interface for hashable types with weak sets and tables. *)
module type WeakS = sig
  type t
  include Basic with type t := t
  module WeakHashset: Weak.S with type data = t
  module WeakTable: Ephemeron.S with type key = t
end

(** A basic interface for seeded hashable types. *)
module type SeededBasic = sig
  type t

  include Equatable_intf.Basic with type t := t

  (** [seeded_hash seed a] is an integer hash of [a]'s value, using [seed] to
      seed the hash function. This hash function should be reasonably secure
      for most applications where a secure hash is preferred over a fast hash.

      This function must satisfy the following constraint: if [equal a b] is
      [true], then [hash seed a = hash seed b] is also [true].
    *)
  val seeded_hash: int -> t -> int
end

(** An interface for seeded hashable types. *)
module type SeededS = sig
  type t
  include SeededBasic with type t := t
  module SeededTable: Hashtbl.SeededS with type key = t
end