(** Utilities which defy categorization. *)

(** [phys_same] is like {!val:(==)} but it can compare terms of unequal type.
    This is mostly useful when optimizing code to avoid superfluous memory
    allocations, since it allows you to check equality without producing a type
    constraint. *)
val phys_same: 'a -> 'b -> bool