module T = struct
  include Stdlib.Result

  let return = ok

  let bind f x = bind x f
end

include T
include Monad.Make2 (T)

(* [Stdlib] has the arguments here in the wrong order, but to keep the peace we
   repeat the sins of our predecessors. *)
let bind x f = bind f x