(** The output signature of [Make]. *)
module type S = sig
  include Stdlib.Map.S

  val add_multi: key -> 'a -> 'a list t -> 'a list t

  val remove_multi: key -> 'a list t -> 'a list t
end