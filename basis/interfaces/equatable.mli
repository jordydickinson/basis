include module type of struct include Equatable_intf end

(** Implement the basic interface using a comparable interface. *)
module Basic (T: Comparable.Basic) : Basic with type t := T.t

(** Create infix operators for equality. *)
module Infix (T: Basic) : Infix with type t := T.t