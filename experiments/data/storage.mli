include module type of struct include Storage_intf end

(** [MakeBasic (T)] is a module for contiguous storage of elements of type [T.t]
    without any convenient fluff. *)
module MakeBasic (T: Storable_intf.Basic): Basic with type elt = T.t

(** [OfBasic (T)] is [T] extended with convenient fluff. *)
module OfBasic (T: Basic): S with type elt = T.elt and type t = T.t

(** [Make (T)] is a module for contiguous storage of elements of type [T.t]. *)
module Make (T: Storable_intf.Basic): S with type elt = T.t