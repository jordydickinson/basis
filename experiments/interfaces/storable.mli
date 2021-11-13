include module type of struct include Storable_intf end

(** Implement the storable interface. *)
module Make (T: Basic): S with type t := T.t