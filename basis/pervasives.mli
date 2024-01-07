type void = Void.t

(** [unreachable] is an alias for {!val:Void.unreachable}. *)
val unreachable: void -> 'a

(** [phys_same] is like {!val:(==)} but it can compare terms of unequal type.
  This is mostly useful when optimizing code to avoid superfluous memory
  allocations, since it allows you to check equality without producing a type
  constraint. *)
val phys_same: 'a -> 'b -> bool

(* [hash_combine h1 h2] is the combination of hashes [h1] and [h2]. *)
val hash_combine: int -> int -> int