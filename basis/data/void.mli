(** The void type, a.k.a. the empty type. Under the Curry-Howard correspondence
    this is the false proposition. If OCaml were consistent as a logic, there
    would be no terms of this type; however, as it is not, [assert false : t]
    is one of many readily-available inhabitants. *)
type t = |

(** [unreachable x] produces whatever you like from nothing at all.  *)
val unreachable: t -> 'a