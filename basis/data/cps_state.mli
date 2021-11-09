(** The CPS'd state monad. *)
type (+'a, !'s) t = { cont: 'r. ('a -> 's -> 'r) -> 's -> 'r }

module O: Cps_state_intf.Open with type ('a, 's) t := ('a, 's) t
include Cps_state_intf.Open with type ('a, 's) t := ('a, 's) t

include Monad.S2
  with type ('a, 's) t := ('a, 's) t
  with module O := O