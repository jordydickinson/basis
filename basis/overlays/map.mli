include module type of struct include Stdlib.Map end
include module type of struct include Map_intf end

(** Functor building an implementation of the map structure given a totally
    ordered type. *)
module Make (T: OrderedType): S with type key = T.t