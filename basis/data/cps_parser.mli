(** Deterministic parser combinators based on the CPS'd state monad. *)
type (+'a, +'e, !'i) t = (('a, 'e) result, 'i Lazy_list.t) State.t

(** Indicates that the end of input has been reached. *)
type eoi = End_of_input

include Cps_parser_intf.S
  with type ('a, 'e, 'i) t := ('a, 'e, 'i) t
  with type eoi := eoi

(** [memoize n f] is the memoized fixpoint of [f]. *)
val memoize: int -> (('a, 'e, 'i) t -> ('a, 'e, 'i) t) -> ('a, 'e, 'i) t