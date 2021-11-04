include module type of struct include Comparable_intf end

(** Create infix comparison operators. *)
module Infix (T: Basic): Infix with type t := T.t

(** Implement the comparable interface. *)
module Make (T: Basic): S with type t := T.t

(** Implement the comparable container interface. *)
module MakeContainer (T: BasicContainer): Container with type 'a t = 'a T.t