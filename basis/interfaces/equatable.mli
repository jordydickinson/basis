include module type of struct include Equatable_intf end

(** Create infix operators for equality. *)
module Infix (T: Basic) : Infix with type t := T.t