include module type of struct include Hashable_intf end

(** Implement the hashable interface. *)
module Make (T: Basic) : S with type t := T.t

(** Implement the weak hashable interface. *)
module MakeWeak (T: Basic) : WeakS with type t := T.t

module MakeSeeded (T: SeededBasic) : SeededS with type t := T.t