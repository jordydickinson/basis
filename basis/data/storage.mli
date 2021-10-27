include module type of struct include Storage_intf end

(** [Make (T)] is a module for contiguous storage of elements of type [T.t]. *)
module Make (T: Storable_intf.Basic): S with type elt = T.t