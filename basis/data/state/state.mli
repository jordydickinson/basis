(** The CPS'd state monad. *)
type (+'a, !'s) t = { call: 'r. ('a -> 's -> 'r) -> 's -> 'r }

module O: State_intf.Open with type ('a, 's) t := ('a, 's) t
include State_intf.Open with type ('a, 's) t := ('a, 's) t

include Monad.S2
  with type ('a, 's) t := ('a, 's) t
  with module O := O

(** [memoize ~hash ~equal n f] is the memoized fixpoint of [f].  *)
val memoize:
  hash:('s -> int) ->
  equal:('s -> 's -> bool) ->
  int -> (('a, 's) t -> ('a, 's) t) -> ('a, 's) t